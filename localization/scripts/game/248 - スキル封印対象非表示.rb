#==============================================================================
# ■ RGSS3 スキル封印対象非表示 Ver1.00 by 星潟
#------------------------------------------------------------------------------
# 特徴:スキル封印によって封印されたスキルは
# スキルウィンドウに表示しないようにします。
#==============================================================================
module SkillSealInvisible
  
  #非表示タイプを指定。
  #0の時、非戦闘時のみ非表示
  #1の時、戦闘時のみ非表示
  #それ以外の時、常時非表示
  
  Type = 1
  
  #--------------------------------------------------------------------------
  # スキル封印非表示判定
  #--------------------------------------------------------------------------
  def self.check
    case Type
    when 0;!$game_party.in_battle
    when 1;$game_party.in_battle
    else  ;true
    end
  end
end
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # スキル封印配列を取得
  #--------------------------------------------------------------------------
  def skill_seal_array_for_skill_seal_invisible
    features_set(FEATURE_SKILL_SEAL)
  end
end
class Window_SkillList < Window_Selectable
  #--------------------------------------------------------------------------
  # スキルリストの作成
  #--------------------------------------------------------------------------
  alias make_item_list_skill_seal_invisible make_item_list
  def make_item_list
    if SkillSealInvisible.check && @actor
      @skill_seal_invisible = @actor.skill_seal_array_for_skill_seal_invisible
    end
    make_item_list_skill_seal_invisible
    @skill_seal_invisible = nil
  end
  #--------------------------------------------------------------------------
  # スキルをリストに含めるかどうか
  #--------------------------------------------------------------------------
  alias include_skill_seal_invisible? include?
  def include?(item)
    include_skill_seal_invisible?(item) && 
    ((@skill_seal_invisible && item) ? !@skill_seal_invisible.include?(item.id) : true)
  end
end