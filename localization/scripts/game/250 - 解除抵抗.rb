#==============================================================================
# ■ RGSS3 解除抵抗 Ver1.00 by 星潟
#------------------------------------------------------------------------------
# 使用効果によるステートの解除・強化の解除・弱体の解除に対し
# 有効度を設定できるようになり、解除に抵抗できるようになります。
# これらの有効度設定には、特定のステート有効度を用います。
# もしも該当する抵抗用ステートが無効の場合、有効度0と同じ扱いとなります。
# 
# ※注意 強化を弱体で打ち消したり、弱体を強化で打ち消す場合については
#        このスクリプトによる解除抵抗の範疇外となります。
#==============================================================================
# ステートに設定。
#------------------------------------------------------------------------------
# <解除抵抗ステートID:20>
# 
# このステートが使用効果「ステートの解除」によって解除判定が行われる時
# ステートID20が無効の時は解除が行われません。
# 無効でない場合、ステートID20の有効度を持って解除判定が行われます。
#==============================================================================
# アイテム/スキルに設定。
#------------------------------------------------------------------------------
# <解除抵抗無視:100>
# 
# このアイテム/スキルは100％の確率で解除抵抗を無視します。
#------------------------------------------------------------------------------
# <解除抵抗無視:a.luk-b.luk>
# 
# このアイテム/スキルは使用者の運－対象の運の確率で解除抵抗を無視します。
#==============================================================================
module AntiDispel
  
  #解除抵抗無視設定用キーワードを指定。
  
  W1 = "解除抵抗無視"
  
  #解除抵抗設定用キーワードを指定。
  
  W2 = "解除抵抗ステートID"
  
  #最大HP～運の順に強化の解除抵抗判定に使用するステートIDを指定。
  #0の場合は解除抵抗を行わない。
  
  B = [0,0,0,0,0,0,0,0]
  
  #最大HP～運の順に弱体の解除抵抗判定に使用するステートIDを指定。
  #0の場合は解除抵抗を行わない。
  
  D = [0,0,0,0,0,0,0,0]
  
  #味方からの解除の場合、解除抵抗を無効とするかを判定。
  
  F = true
  
  #解除抵抗に通常のステート付与等のように運による補正を行う。
  
  L = false
  
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # 使用効果［ステート解除］
  #--------------------------------------------------------------------------
  alias item_effect_remove_state_anti_dispel item_effect_remove_state
  def item_effect_remove_state(user,item,effect)
    return if anti_dispel_state_check(user,item,$data_states[effect.data_id].anti_dispel_sid)
    item_effect_remove_state_anti_dispel(user,item,effect)
  end
  #--------------------------------------------------------------------------
  # 使用効果［能力強化の解除］
  #--------------------------------------------------------------------------
  alias item_effect_remove_buff_anti_dispel item_effect_remove_buff
  def item_effect_remove_buff(user, item, effect)
    return if anti_dispel_state_check(user,item,AntiDispel::B[effect.data_id])
    item_effect_remove_buff_anti_dispel(user, item, effect)
  end
  #--------------------------------------------------------------------------
  # 使用効果［能力弱体の解除］
  #--------------------------------------------------------------------------
  alias item_effect_remove_debuff_anti_dispel item_effect_remove_debuff
  def item_effect_remove_debuff(user, item, effect)
    return if anti_dispel_state_check(user,item,AntiDispel::D[effect.data_id])
    item_effect_remove_debuff_anti_dispel(user, item, effect)
  end
  #--------------------------------------------------------------------------
  # 解除抵抗判定
  #--------------------------------------------------------------------------
  def anti_dispel_state_check(a,i,s)
    return false unless $data_states[s]
    return false if AntiDispel::F && !opposite?(a)
    b = self
    v = $game_variables
    return false if eval(i.anti_dispel_canceler) > rand(100)
    return true if state_resist?(s)
    !(100 * state_rate(s) * (AntiDispel::L ? luk_effect_rate(a) : 1) > rand(100))
  end
end
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # 解除抵抗無視
  #--------------------------------------------------------------------------
  def anti_dispel_canceler
    @anti_dispel_canceler ||= /<#{AntiDispel::W1}[:：](\S+)>/ =~ note ? $1.to_s : "0"
  end
end
class RPG::State < RPG::BaseItem
  #--------------------------------------------------------------------------
  # 解除抵抗
  #--------------------------------------------------------------------------
  def anti_dispel_sid
    @anti_dispel_sid ||= /<#{AntiDispel::W2}[:：](\d+)>/ =~ note ? $1.to_i : 0
  end
end