#==============================================================================
# ■ RGSS3 8方向移動スクリプト Ver2.02 by 星潟
#------------------------------------------------------------------------------
# プレイヤーキャラクターの8方向移動を可能にします。
# その他、プレイヤーの移動に関する一部機能について設定できます。
# 基本的に機能拡張依頼や競合対応は受け付けておりません。ご了承ください。
# 
# 仕様:Game_Followerの移動速度はGame_Playerと同期します
#==============================================================================
# Ver1.01 不要な記述一点を削除。
#         スイッチ切り替えによるダッシュ禁止機能を追加。
# Ver2.00 処理の簡略化。
#         斜め移動判定をデフォの緩い物と厳格化した物とで選択可能に。
# Ver2.01 ダッシュ時の速度増加機能による表示ずれ修正。
#         これにより、これまでと変数に応じた速度増加値が変更されています。
# Ver2.02 斜め移動時の接触イベントに対し、接触を優先するか移動を優先するかを
#         決められるようになりました。
#==============================================================================
module MOVE_CONTROL
  
  #この番号のスイッチがONの時、8方向移動を禁止し、4方向移動のみにします。
  #無効にする場合は0を指定して下さい。
  
  FOUR_MOVE_SWITCH = 0
  
  #この番号のスイッチがONの時、プレイヤーキャラクターの操作を禁止します。
  #無効にする場合は0を指定して下さい。
  
  MOVE_SEAL_SWITCH = 0
  
  #斜め移動判定を厳密に判定するか否かを指定します。
  #trueで2ルート分の判定を両方クリアすれば移動可。
  #(左上の場合、左→上＆上→左)
  #falseで2ルート分の判定をどちらかクリアすれば移動可。
  #(左上の場合、左→上or上→左)
  
  DIAG_CHANGE = true
  
  #斜め移動しようとした方向に同一の接触イベントが存在する場合
  #移動よりも接触を優先するかを指定します。
  #基本、DIAG_CHANGEがtrueの場合でなければ意味がありません。
  #trueで接触、falseで移動を優先します。
  #trueの方が動作は重くなりますが、ゲーム上の挙動としては安定しやすいです。
  
  DIAG_TOUCH  = true
  
  #この番号のスイッチがONの時、ダッシュ判定が逆転します。
  #（平常時がダッシュ、ダッシュキーを押している状態で通常歩行となります）
  #無効にする場合は0を指定して下さい。
  
  DASH_REV = 0
  
  #この番号のスイッチがONの時、ダッシュが使用できなくなります。
  #無効にする場合は0を指定して下さい。
  #（スイッチを切り替える事で、同一マップで
  #  ダッシュのできる場所とそうでない場所を分けることが出来ます）
  
  DASH_SEAL = 0
  
  #この番号の変数が0より大きい時、ダッシュ時の速度が更に増加します。
  #無効にする場合は0を指定して下さい。
  
  DASH_PLUS = 0
  
end

class Game_CharacterBase
  #--------------------------------------------------------------------------
  # 1 フレームあたりの移動距離を計算
  #--------------------------------------------------------------------------
  alias distance_per_frame_change distance_per_frame
  def distance_per_frame
    r = distance_per_frame_change
    r += dash_add_speed if dash?
    r
  end
  #--------------------------------------------------------------------------
  # 斜めの通行可能判定
  #--------------------------------------------------------------------------
  alias diagonal_passable_change? diagonal_passable?
  def diagonal_passable?(x, y, horz, vert)
    unless MOVE_CONTROL::DIAG_CHANGE
      diagonal_passable_change?(x, y, horz, vert)
    else
      x2 = $game_map.round_x_with_direction(x, horz)
      y2 = $game_map.round_y_with_direction(y, vert)
      (passable?(x, y, vert) && passable?(x, y2, horz)) &&
      (passable?(x, y, horz) && passable?(x2, y, vert))
    end
  end
  #--------------------------------------------------------------------------
  # ダッシュ時追加速度
  #--------------------------------------------------------------------------
  def dash_add_speed
    $game_variables[MOVE_CONTROL::DASH_PLUS].to_f / 32
  end
end

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # ダッシュ状態判定
  #--------------------------------------------------------------------------
  alias dash_rev? dash?
  def dash?
    return false if $game_switches[MOVE_CONTROL::DASH_SEAL]
    if $game_switches[MOVE_CONTROL::DASH_REV]
      return false if @move_route_forcing
      return false if $game_map.disable_dash?
      return false if vehicle
      return false if Input.press?(:A)
      return true
    else
      dash_rev?
    end
  end
  #--------------------------------------------------------------------------
  # 方向ボタン入力による移動処理
  #--------------------------------------------------------------------------
  alias move_by_input_8direction move_by_input
  def move_by_input
    return if $game_switches[MOVE_CONTROL::MOVE_SEAL_SWITCH]
    if $game_switches[MOVE_CONTROL::FOUR_MOVE_SWITCH]
      move_by_input_8direction
      return
    end
    return if !movable? || $game_map.interpreter.running?
    d = Input.dir8
    dia_flag = d % 2 == 1
    if dia_flag
      array = []
      case Input.dir8
      when 1
        move_diagonal(4, 2)
        unless @move_succeed
          case @direction
          when 4;array = [2,4]
          when 2;array = [4,2]
          end
        end
      when 3
        move_diagonal(6, 2)
        unless @move_succeed
          case @direction
          when 6;array = [2,6]
          when 2;array = [6,2]
          end
        end
      when 7
        move_diagonal(4, 8)
        unless @move_succeed
          case @direction
          when 4;array = [8,4]
          when 8;array = [4,8]
          end
        end
      when 9
        move_diagonal(6, 8)
        unless @move_succeed
          case @direction
          when 6;array = [8,6]
          when 8;array = [6,8]
          end
        end
      end
      if !array.empty? && MOVE_CONTROL::DIAG_TOUCH && !$game_map.any_event_starting?
        array.each {|d|
        x2 = $game_map.round_x_with_direction(@x, d)
        y2 = $game_map.round_y_with_direction(@y, d)
        check_event_trigger_touch(x2, y2)
        if $game_map.any_event_starting?
          set_direction(d)
          return
        end}
      end
      array.each {|i| move_straight(i);break if @move_succeed}
      d = Input.dir4
      set_direction(d) if d > 0 && !moving?
    else
      move_by_input_8direction
    end
  end
end
class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # 1 フレームあたりの移動距離を計算 プレイヤーと同期
  #--------------------------------------------------------------------------
  def distance_per_frame
    $game_player.distance_per_frame
  end
end