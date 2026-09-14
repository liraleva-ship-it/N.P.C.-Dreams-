#==============================================================================
# ■ RGSS3 踏み止まり特徴 Ver1.04 by 星潟
#------------------------------------------------------------------------------
# HP0となるダメージを受けても戦闘不能にならず
# HP1で耐える特徴を設定できるようになります。
# ただし、ダメージを与えるアイテム・スキルを受けた時のみ発動し
# ステート付与による戦闘不能や
# イベントコマンドのHP増減による戦闘不能には反応しません。
# また、ダメージ＋戦闘不能効果を持つ攻撃を受けてダメージ部分で戦闘不能になり
# 戦闘不能効果の部分も発動した場合、踏み止まりは表示されません。
# （戦闘中1回のみ発動する設定の場合、消費された扱いになります）
# 
# 確率以外に、特殊な条件を指定する事も出来ます。（若干設定難易度高め）
# この条件は1特徴につき、行を分ける事で複数設定出来ますが
# 条件が多くなればなるほど、処理に時間がかかりますのでご注意下さい。
#==============================================================================
# 特徴を有する項目のメモ欄に記述。
#==============================================================================
# <踏み止まり:100>
# 
# 100％の確率で踏み止まりが発生します。
#------------------------------------------------------------------------------
# <踏み止まり:50>
# 
# 50％の確率で踏み止まりが発生します。
#==============================================================================
# <踏み止まり条件:self.hp_rate==1>
# 
# HPが全回復している状態でのみ、踏み止まりが発生します。
#------------------------------------------------------------------------------
# <踏み止まり条件:self.tp==100>
# 
# TPが100の場合のみ、踏み止まりが発生します。
#------------------------------------------------------------------------------
# <踏み止まり条件:self.state?(27)>
# 
# ステート27が付与されている場合のみ、踏み止まりが発生します。
#------------------------------------------------------------------------------
# <踏み止まり条件:$game_switches[25]>
# 
# スイッチID25がONの場合のみ、踏み止まりが発生します。
#------------------------------------------------------------------------------
# <踏み止まり条件:$game_variables[50]>5>
# 
# 変数ID50の値が5より大きい場合のみ、踏み止まりが発生します。
#==============================================================================
# 踏み止まり効果が設定された装備品・ステートのメモ欄に記述。
#------------------------------------------------------------------------------
# <踏み止まり破損:50>
# 
# この装備品・ステートに設定された踏み止まり効果が発動した時
# 50％の確率で装備品なら破損（消滅）し、ステートなら解除される。
#------------------------------------------------------------------------------
# <踏み止まり破損:100>
# 
# この装備品・ステートに設定された踏み止まり効果が発動した時
# 100％の確率で装備品なら破損（消滅）し、ステートなら解除される。
#------------------------------------------------------------------------------
# <踏み止まり破損:50-self.luk/25>
# 
# この装備品・ステートに設定された踏み止まり効果が発動した時
# 50－運÷25の確率で装備品なら破損（消滅）し、ステートなら解除される。
#==============================================================================
# アイテム・スキルのメモ欄に記述。
#------------------------------------------------------------------------------
# <踏み止まり無効:50>
# 
# このアイテム・スキルによって相手を戦闘不能にした場合
# 相手の踏み止まりを発生させない。
#==============================================================================
module EndureHP1Once
  
  #踏み止まり設定用キーワードを指定。
  
  W1 = "踏み止まり"
  
  #確率以外の踏み止まり条件キーワードを指定。
  
  W2 = "踏み止まり条件"
  
  #踏み止まり無効設定用キーワードを指定。
  
  W3 = "踏み止まり無効"
  
  #踏み止まり破損設定用キーワードを指定。
  
  W4 = "踏み止まり破損"
  
  #発動時メッセージを指定。
  #（%sの部分に発動したバトラーの名前が入る）
  
  T1 = "%sは踏み止まった！"
  
  #装備破損メッセージを指定。
  #（%sの部分に発動したバトラーの名前が入る）
  
  T2 = "%sは砕け散った！"
  
  #戦闘中、踏み止まり発動回数を1バトラー1回に限定するか？
  
  O = true
  
  #発動時SEを指定。
  #不要な場合はSE名前を""にする。
  
  SE1 = ["Skill1",80,100]
  
  #装備破損時SEを指定。
  #不要な場合はSE名前を""にする。
  
  SE2 = ["Crash",80,100]
  
  #発動時アニメーションを指定。
  #不要な場合は0にする。
  
  A = 0
  
end
class Game_Interpreter
  #--------------------------------------------------------------------------
  # 踏み止まり使用済みフラグ消去
  #--------------------------------------------------------------------------
  def endure_hp1_once(id,type)
    (id > 0 ? $game_actors[id] : $game_troop.members[id]).endure_hp1_once_switch(type)
  end
end
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # 無効化されているステートの判定
  #--------------------------------------------------------------------------
  alias state_resist_endure_hp1? state_resist?
  def state_resist?(state_id)
    return true if state_id == death_state_id && @endure_hp1
    state_resist_endure_hp1?(state_id)
  end
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # 踏み止まり使用済みフラグ消去
  #--------------------------------------------------------------------------
  def endure_hp1_once_switch(type)
    @endure_hp1_used = type
  end
  #--------------------------------------------------------------------------
  # 戦闘終了処理
  #--------------------------------------------------------------------------
  alias on_battle_end_endure_hp1 on_battle_end
  def on_battle_end
    endure_hp1_once_switch(false)
    on_battle_end_endure_hp1
  end
  #--------------------------------------------------------------------------
  # 踏み止まり発動確率
  #--------------------------------------------------------------------------
  def endure_hp1_rate
    feature_objects.inject(0) {|r,f| r += f.endure_hp1c.any?{|a| !eval(a)} ? 0 : eval(f.endure_hp1)}
  end
  #--------------------------------------------------------------------------
  # スキル／アイテムの効果適用
  #--------------------------------------------------------------------------
  alias item_apply_endure_hp1 item_apply
  def item_apply(user, item)
    @anti_endure_hp1 = item.anti_endure_hp1
    item_apply_endure_hp1(user, item)
    @anti_endure_hp1 = nil
  end
  #--------------------------------------------------------------------------
  # ダメージの処理
  #--------------------------------------------------------------------------
  alias execute_damage_endure_hp1 execute_damage
  def execute_damage(user)
    @endure_hp1 = check_endure_hp1(@result.hp_damage)
    execute_damage_endure_hp1(user)
    return if !(@endure_hp1 && self.hp <= 0)
    self.hp = 1
    @endure_hp1_used = true if EndureHP1Once::O
    @result.endure_hp1 = @endure_hp1
    @endure_hp1 = nil
  end
  #--------------------------------------------------------------------------
  # ダメージの処理
  #--------------------------------------------------------------------------
  def check_endure_hp1(damage)
    return false if @anti_endure_hp1
    return false if self.hp > damage
    return false if @endure_hp1_used
    return false if !$game_party.in_battle
    feature_objects.each {|f|
    if f.endure_hp1c.empty? ? true : f.endure_hp1c.all? {|c| eval(c)}
      return f if eval(f.endure_hp1) > rand(100)
    end}
    return nil
  end
  #--------------------------------------------------------------------------
  # 破損率確率の計算
  #--------------------------------------------------------------------------
  def endure_hp1_break_rate(f)
    eval(f.endure_hp1_break_rate)
  end
end
class Game_ActionResult
  attr_accessor :endure_hp1
  #--------------------------------------------------------------------------
  # ダメージ値のクリア
  #--------------------------------------------------------------------------
  alias clear_damage_values_endure_hp1 clear_damage_values
  def clear_damage_values
    clear_damage_values_endure_hp1
    @endure_hp1 = nil
  end
end
class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # HP ダメージ表示
  #--------------------------------------------------------------------------
  alias display_hp_damage_endure_hp1 display_hp_damage
  def display_hp_damage(target, item)
    display_hp_damage_endure_hp1(target, item)
    execute_endure_hp1(target, item) if target.result.endure_hp1 && !target.dead?
  end
  #--------------------------------------------------------------------------
  # 踏み止まりエフェクト
  #--------------------------------------------------------------------------
  def execute_endure_hp1(target, item)
    a = EndureHP1Once::A
    if a != 0
      target.animation_id = a
      SceneManager.scene.wait_for_animation if $game_party.in_battle
    end
    s = EndureHP1Once::SE1
    RPG::SE.new(s[0],s[1],s[2]).play if !s[0].empty?
    add_text(sprintf(EndureHP1Once::T1,target.name))
    wait
    display_endure_hp1_break(target)
  end
  #--------------------------------------------------------------------------
  # 自動蘇生破損の表示
  #--------------------------------------------------------------------------
  def display_endure_hp1_break(target)
    feature = target.result.endure_hp1
    return unless feature
    return unless target.endure_hp1_break_rate(feature) > rand(100)
    last_line_number = line_number
    if feature.is_a?(RPG::EquipItem)
      return unless target.equips.include?(feature)
      wait
      target.discard_equip(feature)
      SceneManager.scene.refresh_status if $game_party.in_battle
      array = EndureHP1Once::SE2
      RPG::SE.new(array[0],array[1],array[2]).play
      add_text(sprintf(EndureHP1Once::T2,feature.name)) unless EndureHP1Once::T2.empty?
      wait
      back_to(last_line_number)
    elsif feature.is_a?(RPG::State)
      return unless target.state?(feature.id)
      wait
      target.remove_state(feature.id)
      SceneManager.scene.refresh_status if $game_party.in_battle
      add_text(target.name + feature.message4) unless feature.message4.empty?
      wait
      back_to(last_line_number)
    end
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 踏み止まり特徴
  #--------------------------------------------------------------------------
  def endure_hp1
    @endure_hp1 ||= /<#{EndureHP1Once::W1}[:：](\S+)>/ =~ note ? $1.to_s : "0"
  end
  #--------------------------------------------------------------------------
  # 踏み止まり条件
  #--------------------------------------------------------------------------
  def endure_hp1c
    @endure_hp1c ||= endure_hp1c_make
  end
  #--------------------------------------------------------------------------
  # 踏み止まり条件作成
  #--------------------------------------------------------------------------
  def endure_hp1c_make
    a = []
    note.each_line {|l| a.push($1.to_s) if /<#{EndureHP1Once::W2}[:：](\S+)>/ =~ l}
    a
  end
  #--------------------------------------------------------------------------
  # 踏み止まり時破損確率
  #--------------------------------------------------------------------------
  def endure_hp1_break_rate
    @endure_hp1_break ||= /<#{EndureHP1Once::W4}[：:](\S+)>/ =~ note ? $1.to_s : "0"
  end
end
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # 踏み止まり無効
  #--------------------------------------------------------------------------
  def anti_endure_hp1
    (@anti_endure_hp1 ||= /<#{EndureHP1Once::W3}>/ =~ note ? 1 : 0) == 1
  end
end