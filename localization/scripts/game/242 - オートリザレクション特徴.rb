#==============================================================================
# ■ RGSS3 オートリザレクション特徴 Ver2.04 by 星潟
#------------------------------------------------------------------------------
# 戦闘不能に陥った際、一定確率で自動回復する特徴を作成します。
# 著しくゲームバランスを損ねる場合がありますので、ご利用は計画的に。
# なお、イベントコマンドのHP増減やステート付与による戦闘不能では
# 動作しないようにしています。
#
# また、自動蘇生効果発動時に破損する装備品や
# 解除するステートを作成することもできます。
# （特に素材を導入していない限りは、戦闘不能時にステートは自動消滅します。
#   戦闘不能時にステートが解除されないような素材を導入されている場合のみ
#   解除するステート設定は有効です）
#==============================================================================
# ★自動蘇生特徴設定例（アクター・装備品・ステート・エネミー用）
#------------------------------------------------------------------------------
# <自動蘇生:500,42,25>
#
# 戦闘不能になった際、アニメーションID42を再生しつつ
# 25％の確率でHP500の状態で蘇生します。
#------------------------------------------------------------------------------
# <自動蘇生:self.mhp*3/4,0>
#
# 戦闘不能になった際、アニメーションは表示せず
# 100％の確率でHPが最大HPの75％の状態で蘇生します。
#==============================================================================
# ★自動蘇生破損特徴設定例（装備品・ステート用）
#------------------------------------------------------------------------------
# <自動蘇生破損:75>
#
# この装備・ステートで自動蘇生が発動した際
# 75％の確率で破壊/解除されます。
#------------------------------------------------------------------------------
# <自動蘇生破損:$game_variables[1]>
#
# この装備・ステートで自動蘇生が発動した際
# 変数1の値分の確率で破壊/解除されます。
#==============================================================================
# ★自動蘇生無効設定例（アイテム・スキル用）
#------------------------------------------------------------------------------
# <自動蘇生無効>
#
# このアイテム・スキルで自動蘇生の条件を満たした場合は
# 自動蘇生の効果は発動しない。
#==============================================================================
# Ver1.01
# 自動蘇生を特徴化。
# Ver2.00
# 注釈を全面的に追加。
# キャッシュ化による軽量化を実施。
# HP回復量・発動確率にスクリプトによる計算を行えるように変更。
# 装備・ステートに対し、自動蘇生発動時に破壊/解除される確率を
# 指定できるように機能を拡張。
# Ver2.01
# アイテム・スキルで戦闘不能ステートが付与された場合と
# 反撃で戦闘不能になった場合にも自動蘇生対象となるように修正。
# また、受けても自動蘇生させないアイテム・スキルが作成可能に。
# Ver2.03
# アイテム・スキルで戦闘不能ステートが付与された場合については
# 自動蘇生が発生しないようにする設定項目を追加しました。
# Ver2.04
# 戦闘中の行動であるならばなるべく対応するようにする設定を追加。
# (鳥小屋.txt様のターン消費無しスキルを想定)
#==============================================================================
module A_Resurrection
  
  #死亡時自動蘇生の設定用キーワードを指定。
  
  WORD1    = "自動蘇生"
  
  #死亡時自動蘇生が発動した際の破壊/解除率設定用キーワードを指定。
  
  WORD2    = "自動蘇生破損"
  
  #自動蘇生無効スキル・アイテム設定用キーワードを指定。
  #（イベント戦用）
  
  WORD3    = "自動蘇生無効"
  
  #ステート付与効果によって戦闘不能ステートが付与された場合は発動せず
  #HPが0になることで戦闘不能になった場合のみ有効にするかを指定。
  #true  …… HPが0になったことによる戦闘不能のみ
  #false …… 戦闘不能ステート付与についても有効
  
  HP0_ONLY = false
  
  #自動回復させる場合にHP回復量を表示するか否かを指定。
  #true …… 表示する false …… 表示しない
  
  RE_HPDIS = true
  
  #スリップダメージによる戦闘不能でも自動回復するか否かを指定。
  #true …… する false …… しない
  
  SLIP_REC = true
  
  #戦闘中の行動によるものであればなるべく適用するようにするかを指定。
  #鳥小屋.txt様のターン消費無しスキルのスクリプトを導入されている場合は
  #trueを推奨。
  
  ACTFORCE = false
  
  #死亡時自動蘇生時に装備品が破壊された場合のキーワードを指定。
  
  TEXT = "%sは砕け散った！"
  
  #装備品が破壊された場合のSEを指定。
  #指定順は[SE名,音量,ピッチ]。
  
  SE       = ["Crash",80,100]
  
end
class Game_ActionResult
  attr_accessor :a_resurrection
  #--------------------------------------------------------------------------
  # ダメージ値のクリア
  #--------------------------------------------------------------------------
  alias clear_damage_values_a_resurrection clear_damage_values
  def clear_damage_values
    
    #本来の処理を実行。
    
    clear_damage_values_a_resurrection
    
    #自動蘇生データを初期化する。
    
    a_resurrection_clear
  end
  #--------------------------------------------------------------------------
  # 自動蘇生データを初期化
  #--------------------------------------------------------------------------
  def a_resurrection_clear
    @a_resurrection = [0,0]
  end
end
module BattleManager
  #--------------------------------------------------------------------------
  # 蘇生可能タイミングかどうかを判定。
  #--------------------------------------------------------------------------
  def self.resurrection
    
    #ターン中、もしくはターン終了時はtrue、そうでない場合はfalse
    
    @phase == :turn or @phase == :turn_end or (A_Resurrection::ACTFORCE ? $game_party.a_resurrection : false)
    
  end
end
class Game_Party < Game_Unit
  attr_accessor :a_resurrection
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ステート付与
  #--------------------------------------------------------------------------
  alias add_state_a_resurrection add_state
  def add_state(state_id)
    
    #ステートIDが死亡ステートであり
    #蘇生可能なタイミングであり
    #なおかつまだ死亡していない場合は分岐。
    
    if state_id == death_state_id && (A_Resurrection::HP0_ONLY ? self.hp == 0 : true) && BattleManager.resurrection && !state?(death_state_id)
      
      #自動蘇生データを取得。
      
      data = a_resurrection_check
      
      #本来の処理を実行。
      
      add_state_a_resurrection(state_id)
      
      #自動蘇生データのHP回復量が0以上の場合は行動結果に反映。
      
      @result.a_resurrection = data if data[0] > 0
      
    else
      
      #本来の処理を実行。
      
      add_state_a_resurrection(state_id)
      
    end
  end
  #--------------------------------------------------------------------------
  # 自動蘇生データ生成
  #--------------------------------------------------------------------------
  def a_resurrection_check
    
    #既に戦闘不能状態の場合はデフォルトの配列を返す。
    
    return [0,0] if self.state?(death_state_id)
    
    #特徴別に判定。
    
    feature_objects.each {|f| a1 = f.a_resurrection
    
    #特徴の自動蘇生データの配列から発動率を計算する。
    
    a1.each {|a2| next unless eval(a2[2]) > rand(100)
    
    #HP回復量を計算。
    
    data = eval(a2[0]).to_i
    
    #HP回復量が0以上の場合のみ続行。
    
    next unless data > 0
    
    #HP回復量、アニメーションID、特徴データを返す。
    
    return [data, a2[1],f]}}
    
    #デフォルトの配列を返す。
    
    [0,0]
    
  end
  #--------------------------------------------------------------------------
  # 自動蘇生データ
  #--------------------------------------------------------------------------
  def a_resurrection
    
    #自動蘇生データを返す。
    
    @result.a_resurrection
    
  end
  #--------------------------------------------------------------------------
  # ターン終了
  #--------------------------------------------------------------------------
  alias regenerate_hp_a_resurrection regenerate_hp
  def regenerate_hp
    
    #スリップダメージによる死亡からの自動蘇生を行う場合
    #自動蘇生データを取得し、そうでない場合はデフォルトの配列を返す。
    
    @result.a_resurrection = A_Resurrection::SLIP_REC ? a_resurrection_check : [0,0]
    
    #本来の処理を実行。
    
    regenerate_hp_a_resurrection
    
    #本来の処理を行った上でHPが0でないか死亡していない場合は
    #デフォルトの配列を返す。
    
    @result.a_resurrection = [0,0] if self.hp != 0 or !state?(death_state_id)
    
  end
  #--------------------------------------------------------------------------
  # 破損率確率の計算
  #--------------------------------------------------------------------------
  def a_r_break_rate(f)
    eval(f.a_r_break_rate)
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # スキル／アイテムの効果を適用
  #--------------------------------------------------------------------------
  alias apply_item_effects_a_resurrection apply_item_effects
  def apply_item_effects(target, item)
    
    #本来の処理を実行。
    
    $game_party.a_resurrection = true if A_Resurrection::ACTFORCE
    
    apply_item_effects_a_resurrection(target, item)
    
    $game_party.a_resurrection = nil if A_Resurrection::ACTFORCE
    
    #自動蘇生を実行。
    
    execute_a_resurrection(target,item)
    
  end
  #--------------------------------------------------------------------------
  # 反撃の発動
  #--------------------------------------------------------------------------
  alias invoke_counter_attack_a_resurrection invoke_counter_attack
  def invoke_counter_attack(target, item)
    
    #本来の処理を実行。
    
    $game_party.a_resurrection = true if A_Resurrection::ACTFORCE
    
    invoke_counter_attack_a_resurrection(target, item)
    
    $game_party.a_resurrection = nil if A_Resurrection::ACTFORCE
    
    #自動蘇生を実行。
    
    execute_a_resurrection(@subject,item)
    
  end
  #--------------------------------------------------------------------------
  # 自動蘇生の発動
  #--------------------------------------------------------------------------
  def execute_a_resurrection(target,item = nil)
    
    #自動蘇生データを取得。
    
    data = target.a_resurrection
    
    #自動蘇生禁止スキルの場合は処理を中断。
    
    return if item && item.anti_a_resurrection
    
    #HP回復量が0より大きい場合は処理を続行。
    
    return if data[0] <= 0 or !target.state?(target.death_state_id)
    
    #ログウィンドウをクリア。
    
    @log_window.clear
    
    #指定したアニメーションを再生。ID0の場合は再生しない。
    
    show_animation([target], data[1]) if data[1] > 0
    
    #対象のHPを回復。
    
    target.hp = data[0]
    
    #ステータスウィンドウの更新。
    
    refresh_status
    
    #自動蘇生を表示。
    
    @log_window.display_a_resurrection(target)
    
    #自動蘇生による破損の表示。
    
    @log_window.display_a_r_break(target, data[2])
    
  end
  #--------------------------------------------------------------------------
  # ターン終了
  #--------------------------------------------------------------------------
  alias turn_end_a_resurrection turn_end
  def turn_end
    
    #スリップダメージによる死亡からの蘇生フラグを取得。
    
    @te_a_resurrection = A_Resurrection::SLIP_REC
    
    #本来の処理を実行。
    
    turn_end_a_resurrection
    
    #スリップダメージによる死亡からの蘇生フラグを消去。
    
    @te_a_resurrection = nil
    
  end
  #--------------------------------------------------------------------------
  # イベント処理
  #--------------------------------------------------------------------------
  alias process_event_te_a_resurrection process_event
  def process_event
    
    #スリップダメージによる死亡からの蘇生フラグが有効な場合
    #ここで蘇生処理を実行する。
    
    te_a_resurrection_execute if @te_a_resurrection
    process_event_te_a_resurrection
  end
  #--------------------------------------------------------------------------
  # イベント前にスリップダメージによる自動蘇生演出
  #--------------------------------------------------------------------------
  def te_a_resurrection_execute
    
    #全ての戦闘メンバー別に処理。
    
    all_battle_members.each do |battler|
      
      #自動蘇生のデータを取得。
      
      data = battler.result.a_resurrection
      
      #自動蘇生のHP回復量が0より大きい場合
      
      if data[0] > 0
        
        #ログウィンドウをクリア。
        
        @log_window.clear
        
        #指定したアニメーションを再生。ID0の場合は再生しない。
        
        show_animation([battler], data[1]) if data[1] > 0
        
        #対象のHPを回復。
        
        battler.hp = data[0]
        
        #ステータスウィンドウの更新。
        
        refresh_status
        
        #自動蘇生の表示。
        
        @log_window.display_a_resurrection(battler)
        
        #ログウィンドウのクリア。
        
        @log_window.wait_and_clear
        
        #自動蘇生による破損の表示。
        
        @log_window.display_a_r_break(battler,data[2])
        
      end
    end
  end
end
class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # 自動蘇生時のHP回復表示
  #--------------------------------------------------------------------------
  def a_resurrection_hp_recovery(target)
    
    #回復ではなくダメージである場合や
    #回復量を表示しない設定である場合は処理しない。
    
    return unless target.result.hp_damage > 0 or A_Resurrection::RE_HPDIS
    
    #回復SEを実行。
    
    Sound.play_recovery
    
    #回復メッセージを表示。
    
    add_text(target.result.hp_damage_text)
    
    #ウェイトを実行。
    
    wait
    
  end
  #--------------------------------------------------------------------------
  # 自動蘇生の表示
  #--------------------------------------------------------------------------
  def display_a_resurrection(target)
    
    #結果を書き換える。
    
    target.result.used = true
    target.result.critical = false
    target.result.success = true
    target.result.hp_damage = -target.result.a_resurrection[0]
    
    #死亡ステートデータを取得。
    
    state = $data_states[target.death_state_id]
    
    #最終行を取得。
    
    last_line_number = line_number
    
    #自動蘇生時のHP回復表示。
    
    a_resurrection_hp_recovery(target)
    
    #戦闘不能ステート解除メッセージを表示。
    
    add_text(target.name + state.message4) unless state.message4.empty?
    
    #ウェイトを実行。
    
    wait if line_number > last_line_number
    
    #行を戻す。
    
    back_to(last_line_number)
    
  end
  #--------------------------------------------------------------------------
  # 自動蘇生破損の表示
  #--------------------------------------------------------------------------
  def display_a_r_break(target, feature)
    
    #該当する特徴の破損判定を実行。
    
    return unless target.a_r_break_rate(feature) > rand(100)
    
    #最終行を取得。
    
    last_line_number = line_number
    
    #特徴が装備品である場合
    
    if feature.is_a?(RPG::EquipItem)
      
      #なんらかの原因で既に装備解除されている状況を考え
      #装備品別に自動蘇生に用いた装備品を装備しているか否かを判定。
      
      return unless target.equips.include?(feature)
      
      #ウェイトを実行。
      
      wait
      
      #該当する装備を破棄。
      
      target.discard_equip(feature)
      SceneManager.scene.refresh_status if $game_party.in_battle
      
      #SEの配列を用意。
      
      array = A_Resurrection::SE
      
      #SEを演奏。
      
      RPG::SE.new(array[0],array[1],array[2]).play
      
      #設定に応じてメッセージを表示。
      
      add_text(sprintf(A_Resurrection::TEXT,feature.name)) unless A_Resurrection::TEXT.empty?
      
      #ウェイトを実行。
      
      wait
      
      #行を戻す。
      
      back_to(last_line_number)
      
    #対象がステートである場合
      
    elsif feature.is_a?(RPG::State)
      
      #そのステートが付与されていない場合は飛ばす。
      
      return unless target.state?(feature.id)
      
      #ウェイトを実行。
      
      wait
      
      #該当するステートを解除。
      
      target.remove_state(feature.id)
      SceneManager.scene.refresh_status if $game_party.in_battle
      
      #ステート解除メッセージを表示。
      
      add_text(target.name + feature.message4) unless feature.message4.empty?
      
      #ウェイトを実行。
      
      wait
      
      #行を戻す。
      
      back_to(last_line_number)
      
    end
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 自動蘇生データ
  #--------------------------------------------------------------------------
  def a_resurrection
    
    #キャッシュが存在する場合はキャッシュを返す。
    
    @a_resurrection ||= create_a_resurrection
    
  end
  def create_a_resurrection
    
    #配列を作成。
    
    r = []
    
    #メモ欄からデータを取得する。
    
    note.each_line {|l|
    
    #正常なデータを取得できた場合はそのデータを分解する。
    
    if /<#{A_Resurrection::WORD1}[：:](\S+)>/ =~ l
    
      a = $1.to_s.split(/\s*,\s*/)
      
      #要素数が決定的に足りない場合は飛ばす。
      
      next if a.size < 2
      
      #要素が1足りない場合は確率の省略とみなし、文字列の100を代入。
      
      a.push("100") if a.size < 3
      
      #アニメーションIDは整数とする。
      
      a[1] = a[1].to_i
      
      #配列にデータを追加。
      
      r.push(a)
    
    end
    
    }
    
    #データを返す。
    
    r
    
  end
  #--------------------------------------------------------------------------
  # 自動蘇生時破損確率
  #--------------------------------------------------------------------------
  def a_r_break_rate
    
    #キャッシュが存在する場合はキャッシュを返す。
    
    @a_r_break ||= /<#{A_Resurrection::WORD2}[：:](\S+)>/ =~ note ? $1.to_s : "0"
    
  end
end
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # 自動蘇生禁止アイテム
  #--------------------------------------------------------------------------
  def anti_a_resurrection
    (@anti_a_resurrection ||= /<#{A_Resurrection::WORD3}>/ =~ note ? 1 : 0) == 1
  end
end