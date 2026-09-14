#==============================================================================
# ■ RGSS3 エネミー同時行動配列内存在禁止 Ver1.01 by 星潟
#------------------------------------------------------------------------------
# 戦闘時、同一の敵が複数回行動時に複数回使われないスキルを実装します。
#==============================================================================
# スキルのメモ欄に指定
#------------------------------------------------------------------------------
# <エネミー同時行動配列内存在禁止>
# 
# このスキルは敵の複数回行動時、一度に複数回使われなくなります。
#==============================================================================
module SameActionsSeal
  
  #エネミー同時行動配列内存在禁止の設定用キーワードを指定。
  
  Word = "エネミー同時行動配列内存在禁止"
  
end
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # 戦闘行動の作成
  #--------------------------------------------------------------------------
  alias make_actions_same_actions_seal make_actions
  def make_actions
    @same_actions_valid_action_list = []
    make_actions_same_actions_seal
    @same_actions_valid_action_list = nil
    @same_actions_seal_action_list = nil
    @same_actions_seal_rating_zero = nil
  end
  #--------------------------------------------------------------------------
  # 現在の状況で戦闘行動が有効か否かを判定
  #--------------------------------------------------------------------------
  alias action_valid_same_actions_seal? action_valid?
  def action_valid?(action)
    r = action_valid_same_actions_seal?(action)
    @same_actions_valid_action_list.push(action) if @same_actions_valid_action_list && r
    r
  end
  #--------------------------------------------------------------------------
  # 戦闘行動をランダムに選択
  #--------------------------------------------------------------------------
  alias select_enemy_action_same_actions_seal select_enemy_action
  def select_enemy_action(action_list, rating_zero)
    if @same_actions_valid_action_list
      r = select_enemy_action_same_actions_seal(
      @same_actions_seal_action_list ? @same_actions_seal_action_list : action_list,
      @same_actions_seal_rating_zero ? @same_actions_seal_rating_zero : rating_zero)
      if r
        sid = r.skill_id
        s = $data_skills[sid]
        if s.same_actions_seal
          @same_actions_valid_action_list.reject! {|action| action.skill_id == sid}
          new_action_list = @same_actions_valid_action_list.clone
          new_rating_max = new_action_list.collect {|a| a.rating }.max
          new_rating_max = 0 unless new_rating_max
          new_rating_zero = new_rating_max - 3
          new_action_list.reject! {|a| a.rating <= new_rating_zero }
          @same_actions_seal_action_list = new_action_list
          @same_actions_seal_rating_zero = new_rating_zero
        end
      end
      r
    else
      select_enemy_action_same_actions_seal(action_list, rating_zero)
    end
  end
end
class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  # エネミー同時行動配列内存在禁止
  #--------------------------------------------------------------------------
  def same_actions_seal
    (@same_actions_seal ||= /<#{SameActionsSeal::Word}>/ =~ note ? 1 : 0) == 1
  end
end