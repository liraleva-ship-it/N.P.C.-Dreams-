#==============================================================================
# ■ RGSS3 戦闘前保存BGM/BGS変更 Ver1.00 by 星潟
#------------------------------------------------------------------------------
# 戦闘開始前に保存されたBGMやBGSを別の物に差し換えます。
#==============================================================================
# イベントコマンドのスクリプトで使用
#------------------------------------------------------------------------------
# change_saved_map_bgm("Dungeon1",80,100)
# 
# 戦闘開始前に保存されたBGMを
# BGM名「Dungeon1」、音量80、ピッチ100のBGMに差し換えます。
#------------------------------------------------------------------------------
# change_saved_map_bgm("Dungeon1",80,100,1200000)
# 
# 戦闘開始前に保存されたBGMを
# BGM名「Dungeon1」、音量80、ピッチ100のBGMに差し換え
# 1200000の位置から演奏します。
# (演奏位置指定はストリーム再生が可能なOGG形式のファイルでないと意味がありません)
#------------------------------------------------------------------------------
# change_saved_map_bgs("Darkness",60,50)
# 
# 戦闘開始前に保存されたBGMを
# BGS名「Darkness」、音量60、ピッチ50のBGSに差し換えます。
#------------------------------------------------------------------------------
# change_saved_map_bgs("Darkness",60,50,2400000)
# 
# 戦闘開始前に保存されたBGMを
# BGS名「Darkness」、音量60、ピッチ50のBGSに差し換え
# 2400000の位置から演奏します。
# (演奏位置指定はストリーム再生が可能なOGG形式のファイルでないと意味がありません)
#==============================================================================
module BattleManager
  def self.change_saved_map_bgm(name,volume,pitch,pos = 0)
    bgm = RPG::BGM.new(name,volume,pitch)
    bgm.pos = pos
    @map_bgm = bgm
  end
  def self.change_saved_map_bgs(name,volume,pitch,pos = 0)
    bgs = RPG::BGS.new(name,volume,pitch)
    bgs.pos = pos
    @map_bgs = bgs
  end
end
class Game_Interpreter
  def change_saved_map_bgm(name,volume,pitch,pos = 0)
    BattleManager.change_saved_map_bgm(name,volume,pitch,pos)
  end
  def change_saved_map_bgs(name,volume,pitch,pos = 0)
    BattleManager.change_saved_map_bgs(name,volume,pitch,pos)
  end
end