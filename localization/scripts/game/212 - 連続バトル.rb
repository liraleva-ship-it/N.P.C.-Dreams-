#~ #==============================================================================
#~ # ★ RGSS3_連続バトル Ver1.0
#~ #==============================================================================
#~ =begin

#~ 作者：tomoaky
#~ webサイト：ひきも記は閉鎖しました。 (http://hikimoki.sakura.ne.jp/)

#~ バトル勝利時に別のトループとのバトルを開始します。

#~ 同じトループを指定した場合、無限ループになってしまうため、
#~ バトルイベントなどで抜け道を用意する必要があります。

#~ 敵グループの名前に <loop 1> という文字列が含まれていれば
#~ バトル勝利時に敵グループ１番とのバトルが開始されます。

#~ 2015/09/25  Ver1.0
#~ 公開

#~ =end

#~ #==============================================================================
#~ # ■ BattleManager
#~ #==============================================================================
#~ module BattleManager
#~   #--------------------------------------------------------------------------
#~   # ● 勝利の処理【再定義】
#~   #--------------------------------------------------------------------------
#~   def self.process_victory
#~     if /<roop\s*(\d+)>/i =~ $game_troop.troop.name
#~       display_exp
#~       gain_gold
#~       gain_drop_items
#~       gain_exp
#~       $game_troop.setup_loop($1.to_i)
#~       $game_troop.enemy_names.each do |name|
#~         $game_message.add(sprintf(Vocab::Emerge, name))
#~       end
#~       wait_for_message
#~       return false
#~     else
#~       play_battle_end_me
#~       replay_bgm_and_bgs
#~       $game_message.add(sprintf(Vocab::Victory, $game_party.name))
#~       display_exp
#~       gain_gold
#~       gain_drop_items
#~       gain_exp
#~       SceneManager.return
#~       battle_end(0)
#~       return true
#~     end
#~   end
#~ end

#~ #==============================================================================
#~ # ■ Game_Troop
#~ #==============================================================================
#~ class Game_Troop
#~   #--------------------------------------------------------------------------
#~   # ○ 連続バトルのセットアップ
#~   #--------------------------------------------------------------------------
#~   def setup_loop(troop_id)
#~     @event_flags.clear
#~     @turn_count = 0
#~     @troop_id = troop_id
#~     @enemies = []
#~     troop.members.each do |member|
#~       next unless $data_enemies[member.enemy_id]
#~       enemy = Game_Enemy.new(@enemies.size, member.enemy_id)
#~       enemy.hide if member.hidden
#~       enemy.screen_x = member.x
#~       enemy.screen_y = member.y
#~       enemy.sprite_effect_type = :appear
#~       @enemies.push(enemy)
#~     end
#~     make_unique_names
#~     SceneManager.scene.setup_loop
#~   end
#~ end

#~ #==============================================================================
#~ # ■ Spriteset_Battle
#~ #==============================================================================
#~ class Spriteset_Battle
#~   #--------------------------------------------------------------------------
#~   # ○ 連続バトル開始時のスプライトリセット
#~   #--------------------------------------------------------------------------
#~   def setup_loop
#~     dispose_enemies
#~     create_enemies
#~   end
#~ end

#~ #==============================================================================
#~ # ■ Scene_Battle
#~ #==============================================================================
#~ class Scene_Battle
#~   #--------------------------------------------------------------------------
#~   # ○ 連続バトルのセットアップ
#~   #--------------------------------------------------------------------------
#~   def setup_loop
#~     @spriteset.setup_loop
#~   end
#~ end
