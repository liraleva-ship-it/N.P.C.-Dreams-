#==============================================================================
# ■ RGSS3 戦闘終了後自動フェードアウト Ver1.00　by 星潟
#------------------------------------------------------------------------------
# 指定スイッチがONの時、戦闘終了後に
# フェードアウト状態でマップに戻るようにします。
# 戦闘前後でマップの状態が変わっている演出を行いたい場合に
# フェードアウト中に諸々の演出を済ませておくことで
# 自然な演出が可能になるかもしれません。
#==============================================================================
module BattleEndMapFadeOut
  
  #戦闘終了後自動フェードアウトを有効にするスイッチIDを指定
  
  SID = 332
  
  #戦闘終了後自動フェードアウトが行われた際
  #逐一対応するスイッチIDをOFFにするか？
  #trueでOFFにする
  #falseでそのまま
  
  OFF = true
  
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # 終了処理
  #--------------------------------------------------------------------------
  alias terminate_battle_end_map_fadeout terminate
  def terminate
    terminate_battle_end_map_fadeout
    sid = BattleEndMapFadeOut::SID
    if $game_switches[sid]
      $game_map.screen.quick_fadeout_for_battle_end
      $game_switches[sid] = false if BattleEndMapFadeOut::OFF
    end
  end
end
class Game_Screen
  #--------------------------------------------------------------------------
  # 戦闘終了後フェードアウト
  #--------------------------------------------------------------------------
  def quick_fadeout_for_battle_end
    @brightness = 0
    @fadeout_duration = 0
    @fadein_duration = 0
  end
end