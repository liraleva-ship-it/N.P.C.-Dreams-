#==============================================================================
#  ■移動用画面 for RGSS3 Ver1.06-β-fix
#　□作成者 kure
#
#　呼び出し方法 　SceneManager.call(Scene_ShortMove)
#
#==============================================================================

module KURE
  module ShortMove
    #初期設定(変更しないこと)  
    MOVE_LIST = []
    EXPLAN = []
    PLAYER_ICON = []
    CALL_COMMON = []
    ICONLIST = []
  
    
    #移動先設定(以下の設定は項目が対応している為注意)---------------------------
    #MOVE_LIST[0]、EXPLAN[0]、PLAYER_ICON[0]、CALL_COMMON[0]は対応しています。
    
      #表示名、移動先設定
      #MOVE_LIST[0～] = [[表示名,表示するスイッチ,選択可スイッチ,消去スイッチ] ,[マップID, x座標, y座標, 向き(2468)]]
      MOVE_LIST[0] = [["Gwirionedd Orphanage"  ,0,103,102],[2,10,8,2]]
      MOVE_LIST[1] = [["Gwirionedd Orphanage"  ,0,125,124],[2,10,8,2]]
      MOVE_LIST[2] = [["Gwirionedd Orphanage"  ,0,165,164],[2,10,8,2]]
      MOVE_LIST[3] = [["Stellar Rift"  ,0,151,150],[207,19,12,2]]
      MOVE_LIST[4] = [["Hollow Village"  ,0,105,104],[3,40,6,2]]
      MOVE_LIST[5] = [["Plagued Forest"  ,0,107,106],[14,21,66,2]]
      MOVE_LIST[6] = [["Church of the Sword"  ,0,109,108],[22,25,35,2]]
      MOVE_LIST[7] = [["Blight Grove"  ,0,111,110],[29,41,47,2]]
      MOVE_LIST[8] = [["Blighted Swarm"  ,0,113,112],[40,16,27,2]]
      MOVE_LIST[9] = [["Melf's Garden"  ,0,115,114],[132,35,95,2]]
      MOVE_LIST[10] = [["Plague's Heart"  ,0,117,116],[74,5,31,2]]
      MOVE_LIST[11] = [["Blue Frontier"  ,0,119,118],[82,28,58,2]]
      MOVE_LIST[12] = [["Rotting Valley"  ,0,121,120],[89,53,71,2]]
      MOVE_LIST[13] = [["Hal Riad"  ,0,123,122],[95,33,74,2]]
      MOVE_LIST[14] = [["House of Favor"  ,0,127,126],[110,36,80,2]]
      MOVE_LIST[15] = [["Abyssal Sanctum"  ,0,129,128],[114,34,47,2]]
      MOVE_LIST[16] = [["Miracle Cave"  ,0,131,130],[122,54,56,2]]
      MOVE_LIST[17] = [["Sea of Corpses"  ,0,133,132],[128,36,67,2]]
      MOVE_LIST[18] = [["Martyrdom Cemetery"  ,0,135,134],[149,50,47,2]]
      MOVE_LIST[19] = [["Hunting Prison"  ,0,137,136],[158,56,31,2]]
      MOVE_LIST[20] = [["Grand Cathedral"  ,0,139,138],[165,21,17,2]]
      MOVE_LIST[21] = [["Umbral Basin"  ,0,141,140],[174,22,31,2]]
      MOVE_LIST[22] = [["Obetion's Scar"  ,0,143,142],[174,22,31,2]]
      MOVE_LIST[23] = [["Obetion's Scar"  ,0,167,166],[174,22,31,2]]
      MOVE_LIST[24] = [["【第１層・ヘルファ魔獣域】"  ,0,153,152],[82,28,58,2]]
      MOVE_LIST[25] = [["【第２層・象られた楽園】"  ,0,155,154],[82,28,58,2]]
      MOVE_LIST[26] = [["【第３層・赫醒の夜】"  ,0,157,156],[82,28,58,2]]
      MOVE_LIST[27] = [["【第４層・破滅の残夢】"  ,0,159,158],[82,28,58,2]]
      MOVE_LIST[28] = [["【第５層・星海】"  ,0,161,160],[82,28,58,2]]
      MOVE_LIST[29] = [["【象層・冒涜の回帰】"  ,0,163,162],[82,28,58,2]]
      
      #説明文の設定
      #EXPLAN[0～] = [説明1行目,説明2行目]
      EXPLAN[0] = ["The orphanage once run by the Eye of Truth, Gwirionedd."  ,"Though deserted and in ruin, truth still yet resides."  ]
      EXPLAN[1] = ["Where light is lost, darkness exists. As above, so below."  ,"Light is salvation for those who drown in dark."  ]
      EXPLAN[2] = ["　"]
      EXPLAN[3] = ["A world wavering between dreams free and lost alike."  ,"Abandoned dreams becomes stars, lighting up this world."  ]
      EXPLAN[4] = ["A restless village beneath the Sky of Pale Eternity."  ,"Clear skies at dawn's end, yet still no peace in sight."  ]
      EXPLAN[5] = ["A forest shimmering between the Blue Plague and Pale Eternity."  ,"The forest indicates that the plague is rapidly approaching."  ]
      EXPLAN[6] = ["A church for the believers of the sword."  ,"Though but a desolate land, loyalty still yet remains."  ]
      EXPLAN[7] = ["A foul forest tainted with poison. Should an ordinary step in," ,"they will start liquefying, feeding this ever-growing green." ]
      EXPLAN[8] = ["A dark and vast swamp sitting under the Sky of Blue Plague."  ,"Restless insects consume all who try to enter the swamp."  ]
      EXPLAN[9] = ["An eternal garden, forever sunny, forever unspoiled."  ,"Everyone in the garden waits for the dear girl's return."  ]
      EXPLAN[10] = ["Heart of plague, where it all begun."  ,"In this rotting land dwells a powerful being spreading agony."  ]
      EXPLAN[11] = ["A desolate wetland; a withered marsh; poison amix."  ,"Boundary between the skies of Crimson Wrath and Abyssal Dream."  ]
      EXPLAN[12] = ["A rocky desert located in the outskirts of the grand city."  ,"Failed and abandoned souls are left or find their way here."  ]
      EXPLAN[13] = ["A paradise built by the Maruoris for those who receive favor."  ,"In hope's pursuit, all are led into the deep Abyssal Dream."  ]
      EXPLAN[14] = ["The mansion standing at the innermost part of Hal Riad."  ,"Here people receive favor, thence reborn as beings beyond."  ]
      EXPLAN[15] = ["Place where the Maruoris started his research."  ,"Never giving up, he believed his dreams would save everyone."  ]
      EXPLAN[16] = ["A crystal cave, birthed by the Corruption created by Maruoris."  ,"Remnants of the miracles can still be found here."  ]
      EXPLAN[17] = ["The sea of blood. A maverick under the Sky of Crimson Wrath."  ,"The sea's thirst never quells, despite the many lives it claims."  ]
      EXPLAN[18] = ["Where the Sword of Dreams fell, fighting beside his followers."  ,"All feelings besides Wrath have long since faded."  ]
      EXPLAN[19] = ["A maze prison stretching deep beneath the world."  ,"Those who fall have their names never spoken again."  ]
      EXPLAN[20] = ["An empty cathedral under the Crimson Sky, abandoned by all."  ,"Once a place of reverence, the cathedral now stands empty."  ]
      EXPLAN[21] = ["The source of all Crimson Wrath flooding the world."  ,"Wrath will never vanish until it consumes the entire world."  ]
      EXPLAN[22] = ["All will come to an end."  ]
      EXPLAN[23] = ["　"]
      EXPLAN[24] = ["The edge of Obetion, the land of Helfa."  ,"Even after everything, people will never yield their lives."  ]
      EXPLAN[25] = ["An eternal garden. All for the miracle daughter."  ,"She led everyone to this false Eden owing to her ignorance."  ]
      EXPLAN[26] = ["The turning point marking the start of chaos in Obetion."  ,"Only the deepest stars of dreams remember that night."  ]
      EXPLAN[27] = ["The lingering scent of destruction in the fallen country."  ,"Though seldom, people indeed wished for the future of this land."  ]
      EXPLAN[28] = ["The unfathomable depths of oblivion, the end of dreams."  ,"The waters of stars at wanders end."  ]
      EXPLAN[29] = ["The return of time with no reward; a path little more than frivolous charade."  ,"The messenger will likely continue despite the vanity of it all."  ]
      
      #プレーヤーのアイコン(選択肢対応アイコン)
      #PLAYER_ICON[0～] = [アイコンタイプ,アイコンX,アイコンY]
      #アイコンタイプ
      # 0 → 隊列先頭のキャラクター 
      # PLAYER_ICON[0] = [0, x, y]
      #
      # 1 → 四角形
      # PLAYER_ICON[0] = [1, x, y, [size,red,green,blue]]
      #
      # 2 → 画像ファイル(Pictureフォルダに入れること)
      # PLAYER_ICON[0] = [2, x, y, filename]
      #
      
      PLAYER_ICON[0] = [2, 10, 10, "孤児院"]
      PLAYER_ICON[1] = [2, 10, 10, "孤児院・最後"]
      PLAYER_ICON[2] = [2, 10, 10, "孤児院・最後"]
      PLAYER_ICON[3] = [2, 10, 10, "星見の狭間"]
      PLAYER_ICON[4] = [2, 10, 10, "荒れ野の村"]
      PLAYER_ICON[5] = [2, 10, 10, "混疫冥域"]
      PLAYER_ICON[6] = [2, 10, 10, "剣の教会"]
      PLAYER_ICON[7] = [2, 10, 10, "疫碧の森"]
      PLAYER_ICON[8] = [2, 10, 10, "疫蟲輪唱地帯"]
      PLAYER_ICON[9] = [2, 10, 10, "メルフの箱庭"]
      PLAYER_ICON[10] = [2, 10, 10, "最奥域"]
      PLAYER_ICON[11] = [2, 10, 10, "疫碧の辺境"]
      PLAYER_ICON[12] = [2, 10, 10, "澱みの渓谷"]
      PLAYER_ICON[13] = [2, 10, 10, "ハル・レアード"]
      PLAYER_ICON[14] = [2, 10, 10, "寵愛の宮殿"]
      PLAYER_ICON[15] = [2, 10, 10, "暗き聖域"]
      PLAYER_ICON[16] = [2, 10, 10, "奇跡の洞穴"]
      PLAYER_ICON[17] = [2, 10, 10, "屍海"]
      PLAYER_ICON[18] = [2, 10, 10, "殉教墓地"]
      PLAYER_ICON[19] = [2, 10, 10, "狩猟牢"]
      PLAYER_ICON[20] = [2, 10, 10, "大聖堂"]
      PLAYER_ICON[21] = [2, 10, 10, "黒塗られた地底湖"]
      PLAYER_ICON[22] = [2, 10, 10, "オベイシオンの疵痕"]
      PLAYER_ICON[23] = [2, 10, 10, "オベイシオンの疵痕"]
      PLAYER_ICON[24] = [2, 10, 10, "さんぷる"]
      PLAYER_ICON[25] = [2, 10, 10, "さんぷる"]
      PLAYER_ICON[26] = [2, 10, 10, "さんぷる"]
      PLAYER_ICON[27] = [2, 10, 10, "さんぷる"]
      PLAYER_ICON[28] = [2, 10, 10, "さんぷる"]
      PLAYER_ICON[29] = [2, 10, 10, "さんぷる"]
      
      #移動と同時に呼び出すコモンイベントのID
      #CALL_COMMON[0～] = [ID配列]
      CALL_COMMON[0] = [8]
      CALL_COMMON[1] = [8]
      CALL_COMMON[2] = [8]
      CALL_COMMON[3] = [29]
      CALL_COMMON[4] = [9]
      CALL_COMMON[5] = [7]
      CALL_COMMON[6] = [7]
      CALL_COMMON[7] = [7]
      CALL_COMMON[8] = [7]
      CALL_COMMON[9] = [7]
      CALL_COMMON[10] = [7]
      CALL_COMMON[11] = [7]
      CALL_COMMON[12] = [7]
      CALL_COMMON[13] = [7]
      CALL_COMMON[14] = [21]
      CALL_COMMON[15] = [7]
      CALL_COMMON[16] = [7]
      CALL_COMMON[17] = [7]
      CALL_COMMON[18] = [7]
      CALL_COMMON[19] = [7]
      CALL_COMMON[20] = [7]
      CALL_COMMON[21] = [7]
      CALL_COMMON[22] = [7]
      CALL_COMMON[23] = [7]
      CALL_COMMON[24] = [7]
      CALL_COMMON[25] = [7]
      CALL_COMMON[26] = [7]
      CALL_COMMON[27] = [7]
      CALL_COMMON[28] = [7]
      CALL_COMMON[29] = [7]

    #マップ上に表示するアイコンの設定-------------------------------------------
      #ICONLIST[0～] = [アイコンタイプ,アイコンX,アイコンY,表示スイッチ,消去スイッチ,各種設定]
      #必要な数に応じて項目を追加してください
      #アイコンタイプによる設定の違い
      # 0 → アクターを描画します
      # ICONLIST[0] = [0, x, y, switch_id, switch_id, actor_id]
      #　
      # 1 → 四角形
      # ICONLIST[1] = [1, x, y, switch_id, switch_id, [size,red,green,blue]]
      #
      # 2 → 画像ファイル(Pictureフォルダに入れること)
      # ICONLIST[1] = [2, x, y, switch_id, switch_id, filename]
      #
      
#~       ICONLIST[0] = [1,115,200,0,0,[9,255,0,0]]
#~       ICONLIST[1] = [1,115,180,0,0,[9,255,0,0]]
#~       ICONLIST[2] = [1,75,60,1,0,[9,255,0,0]]
#~       ICONLIST[3] = [1,206,116,1,0,[9,255,0,0]]
#~       ICONLIST[4] = [1,243,107,1,0,[9,255,0,0]]
#~       ICONLIST[5] = [1,275,165,1,0,[9,255,0,0]]
#~       ICONLIST[6] = [1,302,131,1,0,[9,255,0,0]]
#~       ICONLIST[7] = [1,290,187,0,0,[9,255,0,0]]
    
    #MAPDATA
    #png形式の画像データを「Picture」フォルダに入れること(380×296)
    MAPDATA = "tizu"
 
  end
end

#==============================================================================
# ■ Scene_ShortMove
#------------------------------------------------------------------------------
# 　キャラクターメイキングの処理を行うクラスです。
#==============================================================================
class Scene_ShortMove < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_command_window
    create_map_window
    create_icon_window
    create_info_window
    create_popup_window
    
    set_window_task
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_command_window
    #キャラクター選択ウィンドウを作成
    @command_window = Window_k_ShortMove_Command.new(0, 0)
    @command_window.height = Graphics.height
    @command_window.activate
    #呼び出しのハンドラをセット
    @command_window.set_handler(:ok,method(:select_command))
    @command_window.set_handler(:cancel,method(:on_cancel))
  end
  #--------------------------------------------------------------------------
  # ● アイコンウィンドウの作成
  #--------------------------------------------------------------------------
  def create_icon_window    
    x = @command_window.width
    y = 0
    ww = Graphics.width - x
    wh = Graphics.height - 24 * 4
    @icon_window = Window_k_ShortMove_Icon.new(x,y,ww,wh)
    @icon_window.z += 10
    @icon_window.opacity = 0
    @icon_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● マップウィンドウの作成
  #--------------------------------------------------------------------------
  def create_map_window    
    x = @command_window.width
    y = 0
    ww = Graphics.width - x
    wh = Graphics.height - 24 * 4
    @map_window = Window_k_ShortMove_Map.new(x,y,ww,wh)
    @map_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● インフォメーションウィンドウの作成
  #--------------------------------------------------------------------------
  def create_info_window
    x = @command_window.width
    y = @map_window.height
    ww = Graphics.width - x
    wh = Graphics.height - y
    @info_window = Window_k_ShortMove_Info.new(x,y,ww,wh)
  end
  #--------------------------------------------------------------------------
  # ● ポップアップウィンドウの作成
  #--------------------------------------------------------------------------
  def create_popup_window
    wx = (Graphics.width - 180)/2
    wy = (Graphics.height - 180)/2
    @popup_window = Window_k_ShortMove_Pop.new(wx, wy)
    @popup_window.unselect
    @popup_window.deactivate
    @popup_window.z  += 10
    @popup_window.hide 
    #ハンドラのセット
    @popup_window.set_handler(:cancel,   method(:pop_cancel))
    @popup_window.set_handler(:ok,   method(:pop_ok)) 
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウのセッティング処理
  #--------------------------------------------------------------------------
  def set_window_task
    @command_window.info_window = @info_window
    @command_window.map_window = @map_window
    @command_window.icon_window = @icon_window
    @command_window.select(0)
    
    @info_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウ[決定]
  #--------------------------------------------------------------------------
  def select_command
    pop_open
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウ[キャンセル]
  #--------------------------------------------------------------------------
  def on_cancel
    Cache.clear
    SceneManager.return
  end 
  #--------------------------------------------------------------------------
  # ● ポップアップウィンドウ[決定]
  #--------------------------------------------------------------------------
  def pop_ok
    case @popup_window.current_ext
    when 1
      #画像キャッシュをクリアしておく
      Cache.clear
      
      move_point = @command_window.current_ext
      map_id = move_point[0][1][0]
      x = move_point[0][1][1]
      y = move_point[0][1][2]
      dir = move_point[0][1][3]
      
      fadeout_all(300)
      
      $game_player.reserve_transfer(map_id, x, y, dir)
      
#~       if map_id != 110
#~     $game_system.end_signal
#~   else
#~     $game_system.start_signal
#~   end

      if map_id == 74
        $game_system.sunshine_type = 2
      $game_system.sunshine_position = 2
    else 
      $game_system.sunshine_type = 0
    end
    if map_id != 40
    $game_map.screen.change_weather(:none, 0, 0)
  else
    $game_map.screen.change_weather(:ancient_light, 3, 0)
  end

  if map_id == 69
     $game_player.transparent = true
     Audio.bgs_play("Audio/BGS/Wind", 80, 100)
     RPG::BGS.fade(2000)
   end

   
      $game_switches[991] = false # かしこしっ！！
      $game_switches[992] = false
      $game_switches[993] = false
      $game_switches[231] = false
      $game_timer.stop
      


      $game_player.perform_transfer
      SceneManager.call(Scene_Map)
      $game_temp.recall_map_name = 1
      $game_map.autoplay

      call_common(move_point[1])
        if map_id == 2
    if $game_variables[50] >= 11
      tn = Tone.new(-15, -30, 80)
        $game_map.screen.start_tone_change(tn, 1)
      end
    if $game_variables[51] >= 4
      tn = Tone.new(35, 10, 120)
        $game_map.screen.start_tone_change(tn, 1)
      end

      if map_id != 110
    $game_system.signal_display = false
  else
    $game_system.signal_display = true
  end

#~     if map_id == 71
#~       tn = Tone.new(0, 0, 0)
#~         $game_map.screen.start_tone_change(tn, 1)
#~       end
  end
      
    when 2
      pop_close
    end
  end
  #--------------------------------------------------------------------------
  # ● ポップアップウィンドウ[キャンセル]
  #--------------------------------------------------------------------------
  def pop_cancel
    pop_close
  end
  #--------------------------------------------------------------------------
  # ● コモンイベント呼び出し[キャンセル]
  #--------------------------------------------------------------------------
  def call_common(list)
    event = KURE::ShortMove::CALL_COMMON[list]
    event.each do |id|
      $game_temp.reserve_common_event(id)
    end
  end
  #--------------------------------------------------------------------------
  # ● ポップアップウィンドウ[開く]
  #--------------------------------------------------------------------------
  def pop_open
    @popup_window.show
    @popup_window.select(1)
    @popup_window.activate
    @command_window.deactivate
  end
  #--------------------------------------------------------------------------
  # ● ポップアップウィンドウ[閉じる]
  #--------------------------------------------------------------------------
  def pop_close
    @popup_window.hide
    @popup_window.unselect
    @popup_window.deactivate
    @command_window.activate
  end
end


#==============================================================================
# ■ Window_k_ShortMove_Command
#==============================================================================
class Window_k_ShortMove_Command < Window_Command
  attr_accessor :info_window
  attr_accessor :map_window
  attr_accessor :icon_window
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return 140
  end
  #--------------------------------------------------------------------------
  # ● カーソル位置の設定
  #--------------------------------------------------------------------------
  def index=(index)
    @index = index
    update_cursor
    call_update_help
    
    @info_window.select = current_ext if @info_window
    @map_window.select = current_ext if @map_window
    @icon_window.select = current_ext if @icon_window
  end
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  def make_command_list
    master = KURE::ShortMove::MOVE_LIST
    for i in 0..master.size - 1
      if visible?(master[i])
        add_command(master[i][0][0], :ok, selectable?(master[i]), [master[i],i])
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 表示の可否
  #--------------------------------------------------------------------------
  def visible?(list)
    return false if list[0][3] != 0 && $game_switches[list[0][3]]
    if list[0][3] == 0
      return true if list[0][1] == 0
      return true if $game_switches[list[0][1]] 
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 選択の可否
  #--------------------------------------------------------------------------
  def selectable?(list)
    return true if list[0][2] == 0
    return true if $game_switches[list[0][2]]
    return false
  end
end

#==============================================================================
# ■ Window_k_ShortMove_Map
#==============================================================================
class Window_k_ShortMove_Map < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #-------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @select = nil
  end
  #--------------------------------------------------------------------------
  # ● 選択中のMAPデータを更新
  #--------------------------------------------------------------------------
  def select=(select)
    return if @select == select
    @select = select
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    
    bitmap = Cache.picture(KURE::ShortMove::MAPDATA)
    #描画
    self.contents.blt(0, 0, bitmap, bitmap.rect)
  end
end

#==============================================================================
# ■ Window_k_ShortMove_Icon
#==============================================================================
class Window_k_ShortMove_Icon < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #-------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @select = nil
  end
  #--------------------------------------------------------------------------
  # ● 選択中のMAPデータを更新
  #--------------------------------------------------------------------------
  def select=(select)
    return if @select == select[1]
    @select = select[1]
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return unless @select
    
    draw_list = KURE::ShortMove::ICONLIST
    
    draw_list.each do |list|
      next if list == [] 
      #描画判定
      if list[3] != 0
        next unless $game_switches[list[3]]
      end
      
      if list[4] != 0
        next if $game_switches[list[4]]
      end
      
      #アイコンタイプ
      case list[0]
      #アクター描画
      when 0
        actor = $game_actors[list[5]]
        next unless actor
    
        x = list[1]
        y = list[2]
        draw_character(actor.character_name, actor.character_index , x, y)
      #四角形描画  
      when 1
        size = 7 ; size2 = 3
        red = 0 ; green = 0 ; blue = 0
        if list[5] 
          if list[5][0]
            size = list[5][0]
            size2 = (list[5][0] / 2).truncate
          end
          if list[5][1] && list[5][2] && list[5][3]
            red = list[5][1]
            green = list[5][2]
            blue = list[5][3]
          end
        end
        
        rect = Rect.new(list[1] - size2,list[2] - size2,size,size)
        color = Color.new(red, green, blue) 
        contents.fill_rect(rect, color)
      #画像描画
      when 2
        next unless list[5]
        bitmap = Cache.picture(list[5])
        self.contents.blt(list[1], list[2], bitmap, bitmap.rect) 
      end
      
    end
    
    player = KURE::ShortMove::PLAYER_ICON[@select]
    case player[0]
    #アクター描画
    when 0
      actor = $game_party.battle_members[0]
      return unless actor
    
      x = player[1]
      y = player[2]
      draw_character(actor.character_name, actor.character_index , x, y)
    #四角形
    when 1
        size = 7 ; size2 = 3
        red = 0 ; green = 0 ; blue = 0
        if player[3] 
          if player[3][0]
            size = player[3][0]
            size2 = (player[3][0] / 2).truncate
          end
          if player[3][1] && player[3][2] && player[3][3]
            red = player[3][1]
            green = player[3][2]
            blue = player[3][3]
          end
        end
        
        rect = Rect.new(player[1] - size2,player[2] - size2,size,size)
        color = Color.new(red, green, blue) 
        contents.fill_rect(rect, color)
    #画像描画
    when 2
      return unless player[3]
      bitmap = Cache.picture(player[3])
      self.contents.blt(player[1], player[2], bitmap, bitmap.rect) 
      
    end
    
  end
end

#==============================================================================
# ■ Window_k_ShortMove_Info
#==============================================================================
class Window_k_ShortMove_Info < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #-------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @select = nil
  end
  #--------------------------------------------------------------------------
  # ● 選択中のMAPデータを更新
  #--------------------------------------------------------------------------
  def select=(select)
    return if @select == select[1]
    @select = select[1]
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    return unless @select
    contents.clear
    
    title = KURE::ShortMove::MOVE_LIST[@select][0][0]
    explan = KURE::ShortMove::EXPLAN[@select]
    
    draw_text(0, 0, contents_width, line_height, title)
    
    return unless explan
      draw_text(0, line_height * 1, contents_width, line_height, explan[0]) if explan[0]
      draw_text(0, line_height * 2, contents_width, line_height, explan[1]) if explan[1]
    end
end


#==============================================================================
# ■ Window_k_ShortMove_Pop
#==============================================================================
class Window_k_ShortMove_Pop < Window_Command
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return 180
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ高さの取得
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(visible_line_number)
  end
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  def make_command_list
    add_command("Travel", :ok, true, 1)
    add_command("Cancel", :ok, true, 2)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    clear_command_list
    make_command_list
    create_contents
    self.height = window_height
    select(0)
    super
  end
end

#==============================================================================
# ■ Game_Temp
#==============================================================================
class Game_Temp
  attr_accessor :recall_map_name             # 場所移動時のフェードタイプ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_before_shotmove_initialize initialize
  def initialize
    k_before_shotmove_initialize
    @recall_map_name = 0
  end
end

#==============================================================================
# ■ Scene_Map
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_before_shotmove_start start
  def start
    k_before_shotmove_start
    recall_map_name_window
  end
  #--------------------------------------------------------------------------
  # ● マップ名表示処理(追加定義)
  #--------------------------------------------------------------------------
  def recall_map_name_window
    if $game_temp.recall_map_name == 1
      @map_name_window.open
      $game_temp.recall_map_name = 0
    end
  end
end