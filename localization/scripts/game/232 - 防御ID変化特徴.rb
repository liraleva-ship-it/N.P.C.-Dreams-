#==============================================================================
# ■ RGSS3 防御ID変化特徴 Ver1.01 by 星潟
#------------------------------------------------------------------------------
# 本来はスキルID2番に指定されている防御のスキルIDを
# 変更する特徴を作成する事が可能になります。
# 
# これにより、防御時にHPを回復する盾等の演出が容易になります。
#==============================================================================
# 特徴を有する項目のメモ欄に設定
#------------------------------------------------------------------------------
# <防御スキルID:5>
# 
# 防御スキルIDとして5を登録します。
#==============================================================================
# スキルのメモ欄に設定
#------------------------------------------------------------------------------
# <防御スキル優先度:10>
# 
# このスキルの防御スキルとしての優先度は10となります。
# 最も高い優先度の防御スキルが採用されます。
#==============================================================================
module AnotherGuardSkillID
  
  #防御スキル指定用キーワードを指定。
  
  Word1 = "防御スキルID"
  
  #防御スキル優先度指定用キーワードを指定。
  
  Word2 = "防御スキル優先度"
  
end
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # 防御スキルID取得
  #--------------------------------------------------------------------------
  alias guard_skill_id_another_id guard_skill_id
  def guard_skill_id
    a = feature_objects.inject([]) {|r,f| r += [f.another_guard_skill_id]}
    a.delete(0)
    return guard_skill_id_another_id if a.empty?
    a.uniq.max_by {|s| $data_skills[s].ags_priority}
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # コマンド［防御］
  #--------------------------------------------------------------------------
  alias command_guard_another_id command_guard
  def command_guard
    s = $data_skills[BattleManager.actor.guard_skill_id]
    return command_guard_another_id if !s.need_selection?
    BattleManager.actor.input.set_guard
    if s.for_opponent?;select_enemy_selection
    elsif s.for_friend?;select_actor_selection
    else;next_command
    end
  end
  #--------------------------------------------------------------------------
  # アクター［キャンセル］
  #--------------------------------------------------------------------------
  alias on_actor_cancel_guard_another_id on_actor_cancel
  def on_actor_cancel
    on_actor_cancel_guard_another_id
    @actor_command_window.activate if @actor_command_window.current_symbol == :guard
  end
  #--------------------------------------------------------------------------
  # 敵キャラ［キャンセル］
  #--------------------------------------------------------------------------
  alias on_enemy_cancel_guard_another_id on_enemy_cancel
  def on_enemy_cancel
    on_enemy_cancel_guard_another_id
    @actor_command_window.activate if @actor_command_window.current_symbol == :guard
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 防御スキルID取得
  #--------------------------------------------------------------------------
  def another_guard_skill_id
    @another_guard_skill_id ||= /<#{AnotherGuardSkillID::Word1}[:：](\d+)>/ =~ note ? $1.to_i : 0
  end
end
class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  # 防御スキル優先度取得
  #--------------------------------------------------------------------------
  def ags_priority
    @ags_priority ||= /<#{AnotherGuardSkillID::Word2}[:：](\d+)>/ =~ note ? $1.to_i : 0
  end
end