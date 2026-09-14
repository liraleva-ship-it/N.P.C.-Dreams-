#  ■ RGSS3 フィールドステートアイテム・スキル・イベント Ver1.02 by 星潟
#------------------------------------------------------------------------------
# 戦闘中、敵味方全員が影響を受けるフィールドステートを付与する
# アイテム・スキル・イベントの作成を可能にします。
# なお、フィールドステートは1つしか存在できず
# 新たに付与された場合、前に付与されたものは解除されます。
#==============================================================================
# アイテム・スキルのメモ欄に指定
#------------------------------------------------------------------------------
# <フィールドステート:10>
# 
# このアイテム・スキル使用時、フィールドステートとしてステートID10が付与される。
#------------------------------------------------------------------------------
# <フィールドステート:10,50>
# 
# このアイテム・スキル使用時、50％の確率でフィールドステートとして
# ステートID10が付与される。
#------------------------------------------------------------------------------
# <フィールドステート:0>
# 
# このアイテム・スキル使用時、フィールドステートが解除される。
#------------------------------------------------------------------------------
# <フィールドステート:0,50>
# 
# このアイテム・スキル使用時、50％の確率でフィールドステートが解除される。
#==============================================================================
# イベントコマンドのスクリプトで指定
# イベントコマンドで付与・消去した場合、ログウィンドウには表示されない
#------------------------------------------------------------------------------
# add_field_state(20,5)
# 
# フィールドステートとしてステートID20が付与される。
# このフィールドステートは5ターン持続する。
# ただし、上書きできないフィールドステートが付与されていた場合は無効。
#------------------------------------------------------------------------------
# add_field_state(20,5,true)
# 
# フィールドステートとしてステートID20が付与される。
# このフィールドステートは5ターン持続する。
# 上書きできないフィールドステートが付与されていた場合でも上書きする。
#------------------------------------------------------------------------------
# remove_field_state
# 
# フィールドステートを消去する。
# ただし、消去できないフィールドステートが付与されていた場合は無効。
#------------------------------------------------------------------------------
# remove_field_state(true)
# 
# フィールドステートを消去する。
# 消去できないフィールドステートが付与されていた場合でも消去する。
#==============================================================================
# イベントコマンドの条件分岐のスクリプトで指定
#------------------------------------------------------------------------------
# field_state_id == 0
# 
# 現在付与されているフィールドステートが存在しないなら条件を満たす。
#------------------------------------------------------------------------------
# field_state_id == 1
# 
# 現在付与されているフィールドステートIDが1なら条件を満たす。
#------------------------------------------------------------------------------
# field_state_id != 2
# 
# 現在付与されているフィールドステートIDが2でないなら条件を満たす。
#------------------------------------------------------------------------------
# field_state_turn == 3
# 
# 現在付与されているフィールドステートの残りターン数が3なら条件を満たす。
#------------------------------------------------------------------------------
# field_state_turn != 4
# 
# 現在付与されているフィールドステートの残りターン数が4でないなら条件を満たす。
#==============================================================================
# イベントコマンドの変数の操作のスクリプトで指定
#------------------------------------------------------------------------------
# field_state_id
# 
# 現在付与されているフィールドステートIDを取得する。
# 付与されていない場合は0になる。
#------------------------------------------------------------------------------
# field_state_turn
# 
# 現在付与されているフィールドステートの残りターン数を取得する。
# 付与されていない場合は0になる。
#==============================================================================
# 各種特徴を有する項目に関する補足
#------------------------------------------------------------------------------
# ステート無効の特徴で該当するフィールドステートが対象となっている場合
# そのフィールドステートを無効化する。
# なお、ステート有効度の特徴はフィールドステートが有効か否かには影響しない。
#==============================================================================
# ステートに関して
#------------------------------------------------------------------------------
# アイコンが設定してある場合は
# フィールドステートウィンドウにフィールドステートの名前と共に表示される。
# 設定されていなければ名前が表示される。
#------------------------------------------------------------------------------
# 「味方がこの状態になったときのメッセージ」は
# スキル・アイテムのメモ欄でフィールドステートを設定していて
# スキル・アイテムの使用によってそのフィールドステートが付与された際に表示される。
# 空欄の場合、表示されない。
#------------------------------------------------------------------------------
# 「敵がこの状態になったときのメッセージ」は
# 「味方がこの状態になったときのメッセージ」に続いて表示される。
# 空欄の場合、表示されない。
#------------------------------------------------------------------------------
# 「この状態が継続しているときのメッセージ」は
# ターン終了時のフィールドステートの残りターン数を更新した際
# まだフィールドステートが維持されている場合に表示される。
#------------------------------------------------------------------------------
# 「この状態が解除されたときのメッセージ」は
# ターン終了時のフィールドステートの残りターン数を更新した際
# フィールドステートの効果が消えた場合に表示される。
#------------------------------------------------------------------------------
# 「戦闘終了時に解除」は
# チェックが入っていないと新たにフィールドステートを付与することで上書きできる。
# チェックが入っていると上書きできないフィールドステートとして扱われる。
#------------------------------------------------------------------------------
# 「行動制約によって解除」は
# チェックが入っていないとフィールド消去が有効になる。
# チェックが入っているとフィールド消去が無効になる。
#------------------------------------------------------------------------------
# 「自動解除のタイミング」は
# なしの場合は残りターン数の更新がされず
# なし以外の場合は残りターン数の更新がされる。
#------------------------------------------------------------------------------
# 「継続ターン数」は
# デフォルトと同じような処理だが、独立した処理となるので
# ターン数を変動するようなスクリプトは基本的に効果がない。
#==============================================================================
module FieldState
  
  #空のハッシュを作成
  
  W = {}
  
  #フィールドステート設定
  
  Word = "フィールドステート"
  
  #フィールドステートの残りターン数表示用フォーマット
  #例."%2d"
  #2桁の数維持を想定して数字を描写
  #例."%2dターン"
  #2桁の数維持を想定してターン数の数字とターンという文字列を描写
  
  TurnFormat = "%2d"
  
  #ログにフィールド効果について表示するかを指定
  #trueで表示
  #falseで非表示
  
  LogTextAdd = false
  
  #フィールド効果が消滅する場合の表示文字列を指定
  
  NoExistFormat = "消去する効果がない！"
  
  #フィールド効果が消滅する場合の表示文字列を指定
  
  EraseFormat = "場の効果をかき消した！"
  
  #フィールド効果の上書きを失敗した場合の表示文字列を指定
  
  OverwriteFailure = "%sは上書きできない！"
  
  #フィールド効果の消滅に失敗した場合の表示文字列を指定
  
  EraseFailure = "%sは消去できない！"
  
  #ターン終了時の残りターン更新タイミングを指定
  #trueの場合は全員のターン更新処理前
  #falseの場合は全員のターン更新処理後
  
  UpdateTiming = false
  
  #フィールド効果が付与・解除された時にパーティメンバー全員と敵グループ全員、
  #フィールド効果が付与された状態で戦闘を終了した時
  #パーティメンバー全員のリフレッシュ処理を行うか否かを指定
  #trueで行う
  #falseで行わない
  
  #最大HPや最大MPなどを増減させるフィールドステートが存在する場合は
  #trueにすることをお勧めしますが、スクリプトの構成によっては
  #falseのままでも問題がない場合もあります。
  
  BattlerRefresh = true
  
  #フィールドステートウィンドウの幅を指定
  
  Width = 640
  
  #フィールドステートウィンドウのX座標を指定
  
  X     = 0
  
  #フィールドステートウィンドウのY座標を指定
  
  Y     = 0
  
  #フィールドステートウィンドウのZ座標を指定
  #通常はviewport1(エネミーや背景)が0
  #viewport2(ピクチャやタイマー)が50
  #viewport3(フェードアウト・イン)が100
  
  Z     = 50
  
  #フィールドステートウィンドウのウィンドウタイプを指定
  #0で通常
  #1でグラデーション
  #2で透明
  
  WindowType = 1
  
  #ウィンドウタイプが1の場合のみ使用
  #グラデーション色を指定する。
  #Color1が薄い方の色
  #Color2が濃い方の色
  
  Color1 = [0,0,0,0]
  
  Color2 = [0,0,0,160]
  
  #ウィンドウ内の両端から文字描写を狭める幅を指定
  #ウィンドウタイプが1の場合は薄い部分の色
  
  ExtraSpace = 24
  
  #ウィンドウタイプが1か2の場合
  #非表示状態から表示状態、もしくは表示状態から非表示状態に移る際の
  #不透明度の増減値を設定
  
  Speed = 16
  
  #フィールドステートウィンドウの可視タイミングを指定
  #共通してフィールドステートが存在しなければ表示されない。
  #0なら常時
  #1ならコマンド選択中である場合
  #2なら特定ウィンドウがアクティブ(選択中)である場合
  
  Visible = 1
  
  #Visibleが2の時にフィールドステートウィンドウの
  #表示フラグとなるウィンドウを指定
  #trueの場合はフラグとなる。falseの場合は関係がなくなる。
  
  #パーティコマンドウィンドウ
  
  W["@party_command_window"] = true
  
  #アクターコマンドウィンドウ
  
  W["@actor_command_window"] = true
  
  #スキルウィンドウ
  
  W["@skill_window"] = false
  
  #アイテムウィンドウ
  
  W["@item_window"] = false
  
  #アクター選択ウィンドウ
  
  W["@actor_window"] = false
  
  #エネミー選択ウィンドウ
  
  W["@enemy_window"] = false
  
end
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # フィールドステート
  #--------------------------------------------------------------------------
  def field_state
    @field_state ||= create_field_state
  end
  #--------------------------------------------------------------------------
  # フィールドステートデータ作成
  #--------------------------------------------------------------------------
  def create_field_state
    if /<#{FieldState::Word}[:：](\S+)>/ =~ note
      a = $1.to_s.split(/\s*,\s*/).inject([]) {|r,i| r.push(i)}
      a[0] = a[0].to_i
      a[1] = "100" if !a[1]
      a
    else
      []
    end
  end
end
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # フィールドステート
  #--------------------------------------------------------------------------
  def field_state
    return [] unless $game_party
    a = $game_party.field_state
    return [$data_states[a[0]]] if a && !(@state_resist_set_for_field_state && @state_resist_set_for_field_state.include?(a[0]))
    []
  end
  #--------------------------------------------------------------------------
  # 制約の取得
  #--------------------------------------------------------------------------
  alias restriction_field_state restriction
  def restriction
    @in_restriction_field_state = true
    r = restriction_field_state
    remove_instance_variable(:@in_restriction_field_state)
    r
  end
  #--------------------------------------------------------------------------
  # 現在のステートをオブジェクトの配列で取得
  #--------------------------------------------------------------------------
  alias states_field_state states
  def states
    r = states_field_state
    r += field_state if @in_restriction_field_state
    r
  end
  #--------------------------------------------------------------------------
  # リフレッシュ
  #--------------------------------------------------------------------------
  alias refresh_field_state refresh
  def refresh
    @state_resist_set_for_field_state = nil
    refresh_field_state
  end
  #--------------------------------------------------------------------------
  # 無効化するステートの配列を取得
  #--------------------------------------------------------------------------
  alias state_resist_set_field_state state_resist_set
  def state_resist_set
    r = state_resist_set_field_state
    @state_resist_set_for_field_state ||= r
    r
  end
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # フィールドステート変動
  #--------------------------------------------------------------------------
  def change_field_state(item)
    return unless $game_party.in_battle
    f = item.field_state
    return if f.empty?
    a = self
    return unless eval(f[1]) > rand(100)
    s = $data_states[f[0]]
    fs = $game_party.field_state
    if s
      return -1 if fs && $data_states[fs[0]].remove_at_battle_end
      t = 1 + s.max_turns - s.min_turns
      t = 0 if t < 0
      r = s.min_turns + rand(t)
      $game_party.add_field_state(f[0],r)
      f[0]
    else
      if fs
        return -2 if $data_states[fs[0]].remove_by_restriction
      else
        return -3
      end
      return -2 if (fs ? $data_states[fs[0]].remove_by_restriction : true)
      $game_party.remove_field_state
      0
    end
  end
end
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # 特徴データ
  #--------------------------------------------------------------------------
  alias feature_objects_field_state feature_objects
  def feature_objects
    r = feature_objects_field_state
    r += field_state if !@in_restriction_field_state
    r
  end
end
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # 特徴データ
  #--------------------------------------------------------------------------
  alias feature_objects_field_state feature_objects
  def feature_objects
    r = feature_objects_field_state
    r += field_state if !@in_restriction_field_state
    r
  end
end
class Game_Party < Game_Unit
  attr_accessor :field_state
  #--------------------------------------------------------------------------
  # フィールドステート更新
  #--------------------------------------------------------------------------
  def update_field_state
    if @field_state && $data_states[@field_state[0]].auto_removal_timing != 0
      @field_state[1] -= 1
      remove_field_state(true) if @field_state[1] == 0
    end
  end
  #--------------------------------------------------------------------------
  # フィールドステートIDの取得
  #--------------------------------------------------------------------------
  def field_state_id
    @field_state ? @field_state[0] : 0
  end
  #--------------------------------------------------------------------------
  # フィールドステートの残りターンの取得
  #--------------------------------------------------------------------------
  def field_state_turn
    @field_state ? @field_state[1] : 0
  end
  #--------------------------------------------------------------------------
  # フィールドステートの付与
  #--------------------------------------------------------------------------
  def add_field_state(state_id,turn = 0,forcing = false)
    return if !$game_party.in_battle or @field_state && !forcing && $data_states[@field_state[0]].remove_at_battle_end
    @field_state = [state_id,turn]
    ($game_party.all_members + $game_troop.members).each {|m| m.refresh} if FieldState::BattlerRefresh
  end
  #--------------------------------------------------------------------------
  # フィールドステートの消去
  #--------------------------------------------------------------------------
  def remove_field_state(forcing = false)
    return if !$game_party.in_battle or @field_state && !forcing && $data_states[@field_state[0]].remove_by_restriction
    @field_state = nil
    ($game_party.all_members + $game_troop.members).each {|m| m.refresh} if FieldState::BattlerRefresh
  end
end
class Game_Interpreter
  #--------------------------------------------------------------------------
  # フィールドステートIDの取得
  #--------------------------------------------------------------------------
  def field_state_id
    $game_party.field_state_id
  end
  #--------------------------------------------------------------------------
  # フィールドステートIDの残りターンの取得
  #--------------------------------------------------------------------------
  def field_state_turn
    $game_party.field_state_turn
  end
  #--------------------------------------------------------------------------
  # フィールドステートIDの付与
  #--------------------------------------------------------------------------
  def add_field_state(state_id,turn = 0,forcing = false)
    $game_party.add_field_state(state_id,turn,forcing)
  end
  #--------------------------------------------------------------------------
  # フィールドステートIDの消去
  #--------------------------------------------------------------------------
  def remove_field_state(forcing = false)
    $game_party.remove_field_state(forcing)
  end
end
class Window_FieldState < Window_Base
  attr_accessor :windows
  #--------------------------------------------------------------------------
  # 初期化
  #--------------------------------------------------------------------------
  def initialize(windows)
    @parent_windows = windows
    super(FieldState::X,FieldState::Y,FieldState::Width,line_height + standard_padding * 2)
    self.opacity = 0 if FieldState::WindowType != 0
    self.z = FieldState::Z
    if FieldState::WindowType == 0
      self.openness = 0
    else
      self.contents_opacity = 0
    end
    @last_field_state = nil
    refresh
  end
  #--------------------------------------------------------------------------
  # 更新
  #--------------------------------------------------------------------------
  def update
    super
    refresh if @last_field_state != $game_party.field_state
    if @last_field_state && visible_flag
      if FieldState::WindowType == 0
        open
      else
        self.contents_opacity += FieldState::Speed if self.contents_opacity < 255
      end
    else
      if FieldState::WindowType == 0
        close
      else
        self.contents_opacity -= FieldState::Speed if self.contents_opacity > 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # 可視フラグ
  #--------------------------------------------------------------------------
  def visible_flag
    case FieldState::Visible
    when 0;true
    when 1;BattleManager.input_check_for_field_state
    else  ;@parent_windows.any? {|w| w.active}
    end
  end
  #--------------------------------------------------------------------------
  # リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    a = $game_party.field_state
    @last_field_state = a ? a.clone : nil
    return unless a
    s = $data_states[a[0]]
    r = contents.rect
    e = FieldState::ExtraSpace
    if FieldState::WindowType == 1
      c1 = FieldState::Color1
      c2 = FieldState::Color2
      color1 = Color.new(c1[0],c1[1],c1[2],c1[3])
      color2 = Color.new(c2[0],c2[1],c2[2],c2[3])
      contents.fill_rect(e,0,r.width - e * 2,r.height,color2)
      if e > 0
        contents.gradient_fill_rect(0,0,e,r.height,color1,color2)
        contents.gradient_fill_rect(r.width - e,0,e,r.height,color2,color1)
      end
    end
    if e > 0
      r.x += e
      r.width -= e * 2
    end
    i = s.icon_index
    if i > 0
      draw_icon(s.icon_index,r.x,0)
      r.x += 24
      r.width -= 24
    end
    draw_text(r,s.name)
    draw_text(r,sprintf(FieldState::TurnFormat,a[1]),2) if s.auto_removal_timing != 0
  end
end
class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # フィールドステート変動の表示
  #--------------------------------------------------------------------------
  def display_changed_field_state(state_id1,state_id2 = nil)
    return unless FieldState::LogTextAdd
    return unless state_id1
    text = (
    case state_id1
    when -4;$data_states[state_id2].message3.empty? ? "" : $data_states[state_id2].message3
    when -3;sprintf(FieldState::NoExistFormat)
    when -2;sprintf(FieldState::EraseFailure,$data_states[$game_party.field_state_id].name)
    when -1;sprintf(FieldState::OverwriteFailure,$data_states[$game_party.field_state_id].name)
    else
      if state_id1 == 0
        state_id2 ? $data_states[state_id2].message4 : FieldState::EraseFormat
      else
        $data_states[state_id1].message1
      end
    end)
    if !text.empty?
      add_text(text)
      if state_id1 > 0
        t = $data_states[state_id1].message2
        unless t.empty?
          wait
          wait_for_effect
          add_text(t)
        end
      end
      wait
      wait_for_effect
    end
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # 全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_all_windows_field_state create_all_windows
  def create_all_windows
    create_all_windows_field_state
    create_field_state_window
  end
  #--------------------------------------------------------------------------
  # フィールドステートウィンドウの作成
  #--------------------------------------------------------------------------
  def create_field_state_window
    a = []
    FieldState::W.each {|k,v| a.push(eval(k)) if v} if FieldState::Visible == 2
    @field_state_window = Window_FieldState.new(a)
  end
  #--------------------------------------------------------------------------
  # スキル／アイテムの使用
  #--------------------------------------------------------------------------
  alias use_item_field_state use_item
  def use_item
    user = @subject
    item = user.current_action.item
    use_item_field_state
    @log_window.display_changed_field_state(user.change_field_state(item))
  end
  #--------------------------------------------------------------------------
  # フィールドステートの更新
  #--------------------------------------------------------------------------
  def update_field_state
    last = $game_party.field_state_id
    $game_party.update_field_state
    now = $game_party.field_state_id
    if last != now
      @log_window.display_changed_field_state(0,last)
    elsif now > 0
      @log_window.display_changed_field_state(-4,last)
    end
  end
end
class << BattleManager
  #--------------------------------------------------------------------------
  # コマンド入力開始
  #--------------------------------------------------------------------------
  def input_check_for_field_state
    @phase == :input
  end
  #--------------------------------------------------------------------------
  # 戦闘終了処理
  #--------------------------------------------------------------------------
  alias battle_end_field_state battle_end
  def battle_end(result)
    if $game_party.field_state
      $game_party.field_state = nil
      $game_party.all_members.each {|m| m.refresh} if FieldState::BattlerRefresh
    end
    battle_end_field_state(result)
  end
end
if FieldState::UpdateTiming
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ターン終了
  #--------------------------------------------------------------------------
  alias turn_end_field_state turn_end
  def turn_end
    update_field_state
    turn_end_field_state
  end
end
else
class << BattleManager
  #--------------------------------------------------------------------------
  # ターン終了
  #--------------------------------------------------------------------------
  alias turn_end_field_state turn_end
  def turn_end
    turn_end_field_state
    SceneManager.scene.update_field_state if $game_party.in_battle
  end
end
end