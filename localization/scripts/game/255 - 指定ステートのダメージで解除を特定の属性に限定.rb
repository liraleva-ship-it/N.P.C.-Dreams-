#==============================================================================
# ■ RGSS3 指定ステートのダメージで解除を特定の属性に限定 Ver1.01　by 星潟
#------------------------------------------------------------------------------
# ステートの「ダメージで解除」の判定に対し、有効に設定されていても
# このスクリプトの設定を行っている場合は
# 指定した属性を持つアイテム・スキルでなければ
# ダメージを受けた際に解除判定が発生しなくなります。
# 
# 元々無効に設定されている場合は効果がありません。
#==============================================================================
# ステートのメモ欄に指定します。
#------------------------------------------------------------------------------
# <ダメージ解除属性限定:3>
# 
# この場合、このステートはアイテム・スキルによるダメージを受けた際に
# 属性修正値の判定中で属性ID3の判定処理を含んでいる場合のみ
# ダメージによるステート解除が発生する。
#------------------------------------------------------------------------------
# <ダメージ解除属性限定:3,4>
# 
# この場合、このステートはアイテム・スキルによるダメージを受けた際に
# 属性修正値の判定中で属性ID3もしくは4の判定処理を含んでいる場合のみ
# ダメージによるステート解除が発生する。
#------------------------------------------------------------------------------
# <ダメージ解除属性限定:3,4,5>
# 
# この場合、このステートはアイテム・スキルによるダメージを受けた際に
# 属性修正値の判定中で属性ID3、4、5の何れかの判定処理を含んでいる場合のみ
# ダメージによるステート解除が発生する。
#==============================================================================

module StateRemoveByElementDamage
  
  #設定用キーワードを指定
  
  Word = "ダメージ解除属性限定"
  
end
class Game_Temp
  attr_accessor :srbed_ids
end
class Game_ActionResult
  attr_accessor :srbed_ids
  #--------------------------------------------------------------------------
  # クリア
  #--------------------------------------------------------------------------
  alias clear_srbed_ids clear
  def clear
    clear_srbed_ids
    @srbed_ids = nil
  end
end
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # 属性有効度の取得
  #--------------------------------------------------------------------------
  alias element_rate_srbed_ids element_rate
  def element_rate(element_id)
    @result.srbed_ids.push(element_id) if @srbed_ids_flag
    element_rate_srbed_ids(element_id)
  end
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # スキル／アイテムの属性修正値を取得
  #--------------------------------------------------------------------------
  alias item_element_rate_srbed_ids item_element_rate
  def item_element_rate(user, item)
    @result.srbed_ids = []
    @srbed_ids_flag = true
    r = item_element_rate_srbed_ids(user, item)
    @srbed_ids_flag = nil
    r
  end
  #--------------------------------------------------------------------------
  # ダメージによるステート解除
  #--------------------------------------------------------------------------
  alias remove_states_by_damage_of_element_damage remove_states_by_damage
  def remove_states_by_damage
    $game_temp.srbed_ids = @result.srbed_ids if @result.srbed_ids
    remove_states_by_damage_of_element_damage
    $game_temp.srbed_ids = nil
  end
end
class RPG::State < RPG::BaseItem
  #--------------------------------------------------------------------------
  # ダメージによるステート解除フラグ
  #--------------------------------------------------------------------------
  unless method_defined?(:remove_by_damage_of_element_damage1)
  alias remove_by_damage_of_element_damage1 remove_by_damage
  def remove_by_damage
    r = remove_by_damage_of_element_damage1
    return false unless r
    if $game_temp.srbed_ids
      a = remove_by_damage_of_element_damage2
      return false if !a.empty? && !$game_temp.srbed_ids.any? {|i| a.include?(i)}
    end
    r
  end
  end
  #--------------------------------------------------------------------------
  # ダメージ解除属性限定の配列を取得
  #--------------------------------------------------------------------------
  def remove_by_damage_of_element_damage2
    @remove_by_damage_of_element_damage2 ||= create_remove_by_damage_of_element_damage2
  end
  #--------------------------------------------------------------------------
  # ダメージ解除属性限定の配列を作成
  #--------------------------------------------------------------------------
  def create_remove_by_damage_of_element_damage2
    (/<#{StateRemoveByElementDamage::Word}[:：](\S+)>/ =~ note ? $1.to_s : "").split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)}
  end
end