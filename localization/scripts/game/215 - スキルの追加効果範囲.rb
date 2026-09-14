module DataManager
  def self.data_ssscope  
    $data_skills[187].ex_scope = 2
    $data_skills[209].ex_scope = 2
    $data_skills[236].ex_scope = 2
  end  
  
#~ 使い方：https://cyclone.siitake-alacarte.com/rgss/ex-scope/ex-scope.html
end  

class Game_Action

  #--------------------------------------------------------------------------
  # ● ターゲットの配列作成
  #--------------------------------------------------------------------------
  alias takorree44make_targets make_targets
  def make_targets
    if item.ex_scope > 0
      make_targets_ex
    else  
      takorree44make_targets
    end  
    
  end  
  
  def make_targets_ex
    targets_for_opponents_ex
  end  
  
  def ex_scope
    item.is_a?(RPG::Skill) && $data_skills_scope[item.id] || item.is_a?(RPG::Item) && $data_items_scope[item.id]
  end  
  
  #--------------------------------------------------------------------------
  # ● 敵に対するターゲット
  #--------------------------------------------------------------------------
  def targets_for_opponents_ex
    exscope = item.ex_scope#item.is_a?(RPG::Skill) ? $data_skills_scope[item.id] : $data_items_scope[item.id]
    num = 1 + (attack? ? subject.atk_times_add.to_i : 0)
    if exscope == 2
      if @target_index < 0
        ([opponents_unit.random_target]  + [subject] ) * num
      else
        ([opponents_unit.smooth_target(@target_index)]  + [subject] ) * num
      end      
      
    elsif exscope == 3
      Array.new(item.ex_scope_attack_count) { opponents_unit.random_target }+ [subject] 
    elsif exscope == 4
      opponents_unit.alive_members + [subject]   
    elsif exscope == 12
      if @target_index < 0
        ([opponents_unit.random_target]  + friends_unit.alive_members ) * num
      else
        ([opponents_unit.smooth_target(@target_index)]  + friends_unit.alive_members ) * num
      end       
    elsif exscope == 13
      Array.new(item.ex_scope_attack_count) { opponents_unit.random_target }+ friends_unit.alive_members
    elsif exscope == 14
      opponents_unit.alive_members + friends_unit.alive_members      
    elsif exscope == 20
      Array.new(item.ex_scope_attack_count) {random_opponents_and_friends}
      
    elsif exscope == 1
      Array.new(item.ex_scope_attack_count) { opponents_unit.random_target } 
      
    end
  end  
  
  def random_opponents_and_friends
    if rand(100) < item.ex_scope_value
      opponents_unit.random_target
    else
      friends_unit.random_target
    end  
  end  


end
  
class RPG::UsableItem < RPG::BaseItem
  def ex_scope
    @ex_scope || 0
  end  
  
  def ex_scope=(val)
    @ex_scope = val 
    
  end  

  def ex_scope_attack_count
    @ex_scope_attack_count || 1
  end  
  
  def ex_scope_attack_count=(val)
    @ex_scope_attack_count = val 
    
  end   
  
  def ex_scope_value
    @ex_scope_value || 0
  end  
  
  def ex_scope_value=(val)
    @ex_scope_value = val 
    
  end  
  
end  