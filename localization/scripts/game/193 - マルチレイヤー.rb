#==============================================================================
# ■ マルチレイヤーシステム (VX Ace用)
#------------------------------------------------------------------------------
# 制作者     : CanariAlternate
# サイト名   : カルトの鳥篭
# サイトURL  : http://canarialt.blog.fc2.com
#------------------------------------------------------------------------------
# ■ 概要 : 多層のマップを表現可能にする。
#
# ■ 必須 : 「画面座標を整数値に補正」
#
# ■ 位置 : 「フィールド並行戦闘」より下
#------------------------------------------------------------------------------
# 更新履歴 : 2012/12/07 Ver1.00 スクリプトを作成した。
#            2012/12/18 Ver1.01 ラスタスクロールするピクチャーの管理・生成の方法を変更した。
#            2012/12/25 Ver1.02 ラスタスクロールするピクチャーのバグを修正した。
#            2012/12/30 Ver1.03 戦闘テストでエラーになるバグを修正した。
#            2013/01/06 Ver1.04 RGSSが停止するバグの原因と思われる部分を修正した。
#            2013/01/08 Ver1.05 基準にするイベントを指定するイテレータの仕様を変更した。
#            2013/01/09 Ver1.06 乗り物のいるマップ以外でエラーが発生するバグを修正した。
#            2013/01/11 Ver1.07 前景スプライトを改良した。
#            2013/02/19 Ver1.08 共通処理スクリプトの廃止による変更を施した。
#            2013/03/28 Ver1.09 乗り物を配置していない状態で起動するとエラーになるバグを修正した。
#            2013/04/08 Ver1.10 タイルセットの変更と指定位置の情報取得のバグを修正した。
#            2013/05/19 Ver1.11 スプライトの分割に関するバグを修正した。
#            2013/09/26 Ver1.12 temp_execute() メソッドに後処理の記述を追加した。
#            2014/06/08 Ver1.13 場所移動後は最下層を基準にイベントを実行するように修正した。
#            2015/05/04 Ver1.14 戦闘背景の自動選択が正しく動作しなくなっていた問題を修正した。
#==============================================================================

=begin
  ■□■参考にしたスクリプト■□■
  開発初期における基礎的な仕様・機能の決定にLibのツクールページ様が制作したマップレイヤーシステムを参考にさせてもらいました。
  Libのツクールページ http://cwoweb2.bai.ne.jp/lib_rpg_tkool/
  
  ■□■仕様・設定に関する内容の箇条書き□■□
  レイヤー番号は整数で重複しなければ何番でも可。あえて飛び番にしておけば後でレイヤーを追加するのが楽かもしれない。
  レイヤー番号の一番小さいマップが最下層になり、最下層のエンカウント、BGM、戦闘背景などの設定が適用される。
  飛行船は搭乗すると一番上のレイヤーに移動し着陸する時は空属性を設定したタイル以外で最も上のレイヤーに着陸する。
  ジャンプも飛行船の着陸と同様に空属性を設定したタイル以外で最も上のレイヤーに着地する。場合によっては不自然なので着地場所の階層を手動で設定するメソッドを一応は用意してある。
  レイヤー番号がマイナスのレイヤーには飛行船は着陸できない。マイナスの番号のレイヤーしかないマップでは永遠に着陸できなくなるので注意。
  レイヤー数の制限はなし。スペックの許すならば何層にでも出来る。ただし、マップ製作の労力も比例して増大する。
  マップのサイズは合わせる必要がある。マップIDの取得は基本的には最下層のIDを取得する。
  タイルセットの変更は実行したイベントのレイヤーを変更する。
  タイルIDやイベントIDの取得は実行したイベントのレイヤーから取得する。
  タイル「上」「下」はレイヤー移動に使用する。
  ※「上」「下」のタイルの場所に並列・自動起動以外のイベントを置いても無駄なので注意。イベントはレイヤー移動先に配置する。
  タイル「浅」「深」は浅瀬・海の役割をする。タイル「浅」「深」の移動設定は"[☆]通行に影響しない"を推奨する。
  タイル「草」は通行４方向の設定用に16枚ある。水に浸かっている表現などに使用を想定している。
  タイル「上」「下」「浅」「深」「草」はタイルイベントで配置しても上記の効果は無い。
  タイル「橋」「低」「高」「壁」は特に意味の無いタイルである。サンプルではマップ製作の視覚的な補助に使用した。
  以上のタイル「上」「下」「浅」「深」「草」「橋」「低」「高」「壁」は画像を消去するタイルとして設定することを推奨する。
  テストプレイ時のみマップが当スクリプトの規格に適合してるか簡単なチェックを行い問題を確認すれば表示する。
  
  ■□■スクリプトを操作する為のメソッドの目次＆簡単な説明■□■
  manual_jump(引数)       # 移動ルートの設定でジャンプ先の階層を手動で設定してジャンプを実行するメソッドです。
  animation_current_floor_ON  # アニメーションを再生するレイヤーは対象のいるレイヤーにする。
  animation_current_floor_OFF # アニメーションを再生するレイヤーは最上層のレイヤーにする(初期状態)。
  get_foreground_sprite(引数) # レイヤーに表示するスプライトの設定クラスを取得する。
  change_layer(引数)          # イベントIDで指定したイベントのレイヤーを変更する。
  current_layer(引数)         # イベントIDで指定したイベントのレイヤー番号を取得する。
  absolute_event_id(引数)     # 他のレイヤーのイベントを操作する為に必要な絶対イベントIDを取得する。
=end

$imported ||= {}
$imported[:CanariAlternate_Multilayer] = true

#==============================================================================
# ■ Calt
#------------------------------------------------------------------------------
# 　CanariAlternateが制作したスクリプト用のモジュールです。
#==============================================================================
module Calt
  #----------------------------------------------------------------------------
  # 1. マップ名の認識方法(仕様メモ:$1 == マップ名, $2 == レイヤー識別番号, $4 == ピクチャー名)
  MULTILAYER_MAP_NAME = /(.+)\<LAY(\-?\d+)\>(\[(.+)\])?$/i
  #
  # 2. 上昇用のタイルのID(0 ～ 1023)
  LAYER_UP_TILE   = nil
  #
  # 2. 下降用のタイルのID(0 ～ 1023)
  LAYER_DOWN_TILE = nil
  #
  # 3. 小型船通行可にするタイルID
  BOAT_PASSABLE_TILE_ID = []#[1020]
  #
  # 3. 大型船通行可にするタイルID
  SHIP_PASSABLE_TILE_ID = []#[1020, 1021]
  #
  # 4. 空の扱いにするタイルID
  #    飛行船は離陸すると最上層のレイヤーに移動する。着陸するときは空以外のタイルで最も階層の高いレイヤーに着陸する。
  #    ジャンプの階層移動にも使用する。飛行船同様に空以外のタイルで最も階層の高いレイヤーに着地する。
  AIR_TILE_ID = []#[1544]
  #
  # 5. 水没を表現するタイルID
  SUBMERGENCE_TILE_ID = []#[
#    1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007,
#    1008, 1009, 1010, 1011,
#    1016, 1017, 1018, 1019, 1020, 1021            ]
  #
  # 6. 画像を消去する上層タイルのID(1024以上のIDは無視)
  BITMAP_CLEAR_TILE = []#[
#    1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007,
#    1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015,
#    1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023]
  #
  # 7. タイルIDを取得する際に 0 に変換(通常キャラより下に表示する通行に影響しないタイル用)
  NOT_EXIST_TILE_ID = []#[
#~      976,  977,  978,  979,  980,  981,  982,  983,
#~      984,  985,  986,  987,        989,  990,  991,
#~      992,  993,  994,  995,        997,  998,  999,

#~                             1012, 1013, 1014, 1015
#~                                                   ]
  #----------------------------------------------------------------------------
  BOAT_PASSABLE_TILE_ID_HASH = Hash.new
  BOAT_PASSABLE_TILE_ID.each { |tile_id| BOAT_PASSABLE_TILE_ID_HASH[tile_id] = true }
  SHIP_PASSABLE_TILE_ID_HASH = Hash.new
  SHIP_PASSABLE_TILE_ID.each { |tile_id| SHIP_PASSABLE_TILE_ID_HASH[tile_id] = true }
  AIR_TILE_ID_HASH = Hash.new
  AIR_TILE_ID.each { |tile_id| AIR_TILE_ID_HASH[tile_id] = true }
  SUBMERGENCE_TILE_ID_HASH = Hash.new
  SUBMERGENCE_TILE_ID.each { |tile_id| SUBMERGENCE_TILE_ID_HASH[tile_id] = true }
  NOT_EXIST_TILE_TABLE = Table.new(8192)  # 特定のタイルIDを 0 に変換するテーブルの生成
  NOT_EXIST_TILE_TABLE.xsize.times { |id| NOT_EXIST_TILE_TABLE[id] = id }
  NOT_EXIST_TILE_ID.each { |id| NOT_EXIST_TILE_TABLE[id] = 0 }
  #----------------------------------------------------------------------------
end

#==============================================================================
# ■ Sprite_Manager
#------------------------------------------------------------------------------
# 　スプライトの設定値を記憶する為のクラスです。
#==============================================================================
class Sprite_Manager
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :bitmap_name                    # 表示するピクチャー名(String)
  attr_accessor :visible                        # スプライトの可視状態
  attr_accessor :x                              # スプライトの X 座標
  attr_accessor :y                              # スプライトの Y 座標
  attr_accessor :z                              # スプライトの Z 座標
  attr_accessor :ox                             # スプライトの転送元原点の X 座標
  attr_accessor :oy                             # スプライトの転送元原点の Y 座標
  attr_accessor :zoom_x                         # スプライトの X 方向拡大率
  attr_accessor :zoom_y                         # スプライトの Y 方向拡大率
  attr_accessor :angle                          # スプライトの回転角度
  attr_accessor :wave_amp                       # 波形描画のための振幅
  attr_accessor :wave_length                    # 波形描画のための周期
  attr_accessor :wave_speed                     # 波形描画のための速度
  attr_accessor :wave_phase                     # 波形描画のための位相
  attr_accessor :mirror                         # スプライトの左右反転フラグ
  attr_accessor :bush_depth                     # スプライトの茂みの深さ
  attr_accessor :bush_opacity                   # スプライトの茂みの不透明度
  attr_accessor :opacity                        # スプライトの不透明度
  attr_accessor :blend_type                     # スプライトの合成方法
  attr_accessor :color                          # スプライトにブレンドする色
  attr_accessor :tone                           # スプライトの色調
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(bitmap_name)
    @last_bitmap = nil                          # 最後に更新した時のピクチャー名
    @bitmap_name = bitmap_name
    # 以下の初期値は規定の範囲内で自由に変更可
    @visible      = true
    @x            = -10
    @y            = 0
    @z            = 500
    @ox           = 0
    @oy           = 0
    @zoom_x       = 1.0
    @zoom_y       = 1.0
    @angle        = 0
    @wave_amp     = 3
    @wave_length  = 10
    @wave_speed   = 45
    @wave_phase   = 0
    @mirror       = false
    @bush_depth   = 0
    @bush_opacity = 128
    @opacity      = 160
    @blend_type   = 0
    @color        = Color.new(0, 0, 0, 0)
    @tone         = Tone.new(0, 0, 0, 0)
  end
  #--------------------------------------------------------------------------
  # ● スプライトを生成するか判定
  #--------------------------------------------------------------------------
  def create_sprite?
    return !@last_bitmap && @bitmap_name
  end
  #--------------------------------------------------------------------------
  # ● スプライトを解放するか判定
  #--------------------------------------------------------------------------
  def dispose_sprite?
    return @last_bitmap && !@bitmap_name
  end
  #--------------------------------------------------------------------------
  # ● ビットマップを変更するか判定
  #--------------------------------------------------------------------------
  def bitmap_change?
    return @last_bitmap != @bitmap_name && @bitmap_name
  end
  #--------------------------------------------------------------------------
  # ● スプライトを更新するか判定
  #--------------------------------------------------------------------------
  def update_sprite?
    return @bitmap_name
  end
  #--------------------------------------------------------------------------
  # ● スプライトの更新
  #--------------------------------------------------------------------------
  def update(sprite)
    @last_bitmap = @bitmap_name
    return unless update_sprite?
    sprite.visible = @visible
    sprite.x = @x
    sprite.y = @y
    sprite.z = @z
    sprite.ox = @ox
    sprite.oy = @oy
    sprite.zoom_x = @zoom_x
    sprite.zoom_y = @zoom_y
    sprite.angle = @angle
    sprite.wave_amp    = @wave_amp
    sprite.wave_length = @wave_length
    sprite.wave_speed  = @wave_speed
    sprite.wave_phase  = @wave_phase
    sprite.mirror = @mirror
    sprite.bush_depth   = @bush_depth
    sprite.bush_opacity = @bush_opacity
    sprite.opacity = @opacity
    sprite.blend_type = @blend_type
    sprite.color = @color
    sprite.tone = @tone
    sprite.update
    @wave_phase = sprite.wave_phase
  end
end

#==============================================================================
# ■ Game_Temp
#------------------------------------------------------------------------------
# 　セーブデータに含まれない、一時的なデータを扱うクラスです。このクラスのイン
# スタンスは $game_temp で参照されます。
#==============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :map_group_list                 # マップの所属するグループのIDのハッシュ
  attr_reader   :map_index_list                 # グループに所属するマップのレイヤー番号をインデックスに変換するハッシュのハッシュ
  attr_reader   :map_layer_list                 # グループに所属するマップのIDの配列(階層順)のハッシュ
  attr_reader   :map_foreground                 # マップの前景スプライトのピクチャー名のハッシュ
  attr_accessor :multi_viewport_accessor        # 各ビューポートへの参照
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化 [追加]
  #--------------------------------------------------------------------------
  alias initialize_Multilayer initialize
  def initialize
    initialize_Multilayer
    create_map_group_list
  end
  #--------------------------------------------------------------------------
  # ● マップのグループを生成 [新規]
  #--------------------------------------------------------------------------
  def create_map_group_list
    $data_mapinfos = load_data("Data/MapInfos.rvdata2") if $BTEST # 戦闘テストの場合
    
    @map_group_list = Hash.new  # map_id    => group_id
    @layer_numbers  = Hash.new  # map_id    => layer_number
    @map_foreground = Hash.new  # map_id    => foreground_sprite_picture_name
    @map_layer_list = Hash.new  # group_id  => group_list
    @map_index_list = Hash.new  # group_id　 => links_list
    @map_names_list = Hash.new  # code_name => group_id

    # 集団リストを生成
    $data_mapinfos.each do |map_id, map_info|
      map_name = map_info.name
      if map_name =~ Calt::MULTILAYER_MAP_NAME
        code_name = $1
        if group_id = @map_names_list[code_name]
          @map_group_list[map_id] = group_id
        else
          @map_names_list[code_name] = @map_group_list[map_id] = @map_group_list.size
        end
      else
        @map_group_list[map_id] = @map_group_list.size
      end
      @layer_numbers[map_id]  = $2.to_i
      @map_foreground[map_id] = $4
    end

    # 階層リストを生成
    @map_group_list.each do |map_id, group_id|
      if layer_list = @map_layer_list[group_id]
        layer_list.push map_id
      else
        @map_layer_list[group_id] = [map_id]
      end
    end
    @map_layer_list.each_value do |layer_list|
      layer_list.sort! {|a, b| @layer_numbers[a] <=> @layer_numbers[b] }
    end

    # 変換リストを生成
    @map_layer_list.each do |group_id, layer_list|
      links_list = Hash.new
      layer_list.each_index do |index|
        map_id = layer_list[index]
        layer_number = @layer_numbers[map_id]
        links_list[layer_number] = index
      end
      @map_index_list[group_id] = links_list
    end
  end
  #--------------------------------------------------------------------------
  # ● 階層を取得 [新規]
  #--------------------------------------------------------------------------
  def map_id_to_z(map_id)
    return 0 if map_id == 0 # 存在しないマップIDの場合
    group_id = @map_group_list[map_id]
    layer_list = @map_layer_list[group_id]
    return layer_list.index(map_id)
  end
  #--------------------------------------------------------------------------
  # ● 最下層のマップIDを取得 [新規]
  #--------------------------------------------------------------------------
  def map_id_to_base_map_id(map_id)
    return 0 if map_id == 0 # 存在しないマップIDの場合
    group_id = @map_group_list[map_id]
    return @map_layer_list[group_id][0]
  end
end

#==============================================================================
# ■ Game_Map
#------------------------------------------------------------------------------
# 　マップを扱うクラスです。スクロールや通行可能判定などの機能を持っています。
# このクラスのインスタンスは $game_map で参照されます。
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :layer_index                # レイヤー番号をindexに変換するハッシュ
  attr_reader   :event_id_transformation    # イベントIDの変換に使用する配列
  attr_reader   :map_group_id               # マップのグループのID
  attr_reader   :multi_map_data             # マルチレイヤーのマップデータの配列
  attr_reader   :multi_tileset              # マルチレイヤーのタイルセットの配列
  attr_reader   :foreground_sprites         # 前景ピクチャーの配列
  attr_accessor :animation_current_floor    # アニメーションをキャラクターの現在地のレイヤーで再生
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化 [追加]
  #--------------------------------------------------------------------------
  alias initialize_Multilayer initialize
  def initialize
    initialize_Multilayer
    @map_group_id = -1  # マップの識別に使用する番号
    @animation_current_floor = false
  end
  #--------------------------------------------------------------------------
  # ● 基準にするイベントを指定してブロックを実行 [新規]
  #--------------------------------------------------------------------------
  def temp_execute(event)
    temp = @updating_event
    @updating_event = event
    begin
      result = yield  # ブロックを実行
    ensure
      @updating_event = temp  # 後処理を忘れずに
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 更新しているイベントの記憶をリセット [新規]
  #--------------------------------------------------------------------------
  def reset_updating_event
    @updating_event = $game_player
  end
  #--------------------------------------------------------------------------
  # ● 省略された場合の階層を取得 [新規]
  #--------------------------------------------------------------------------
  def floor_omit
    @updating_event ||= reset_updating_event
    return @updating_event.current_floor
  end
  #--------------------------------------------------------------------------
  # ● イベントの更新 [◆再定義]
  #--------------------------------------------------------------------------
  def update_events
    @events.each_value do |event|
      @updating_event = event # 更新するイベントを記憶
      event.update
    end
    reset_updating_event
    @common_events.each {|event| event.update }
  end
  #--------------------------------------------------------------------------
  # ● 乗り物の更新 [◆再定義]
  #--------------------------------------------------------------------------
  def update_vehicles
    @vehicles.each do |vehicle|
      @updating_event = vehicle # 更新するイベントを記憶
      vehicle.update
    end
    reset_updating_event
  end
  #--------------------------------------------------------------------------
  # ● レイヤー数の取得 [新規]
  #--------------------------------------------------------------------------
  def layer_size
    return @multi_map_data.size
  end
  #--------------------------------------------------------------------------
  # ● マップデータのセット [新規]
  #--------------------------------------------------------------------------
  def create_multi_map_data(map_id)
    @map_group_id   = $game_temp.map_group_list[map_id]
    group_list      = $game_temp.map_layer_list[@map_group_id]
    @map_id         = group_list[0]                             # 最下層を現在のマップIDにする
    @layer_index    = $game_temp.map_index_list[@map_group_id]  #　レイヤー番号⇒インデックスの変換を行うハッシュ
    @multi_map_data = Array.new                                 # 複数のマップデータを格納する為の配列
    group_list.each {|map_id| @multi_map_data.push load_data(sprintf("Data/Map%03d.rvdata2", map_id)) }
  end
  #--------------------------------------------------------------------------
  # ● マップデータが規格に適合してるか判定 [新規]
  #--------------------------------------------------------------------------
  def standard_check
    map_width  = @multi_map_data[0].width
    map_height = @multi_map_data[0].height
    for i in 1 ... @multi_map_data.size
      next if map_width == @multi_map_data[i].width && map_height == @multi_map_data[i].height
      msgbox "警告:マップのサイズが異なっています。"  # マップのサイズを確認し問題があれば警告する。
    end
    for x in 0 ... map_width
      for y in 0 ... map_height
        if @multi_map_data[0].data[x, y, 2] == Calt::LAYER_DOWN_TILE
          msgbox "警告:最下層のレイヤーにタイル「下」が設置されています。" +
                 "\n問題の座標(x:#{x}, y:#{y})"
        end
        last_result = @multi_map_data.inject(false) do |result, map_data|
          if result && map_data.data[x, y, 2] == Calt::LAYER_DOWN_TILE
            msgbox "警告:タイル「上」の真上のレイヤーにタイル「下」が設置されています。" +
                   "\n問題の座標(x:#{x}, y:#{y})"
          end
          next map_data.data[x, y, 2] == Calt::LAYER_UP_TILE
        end
        if last_result
          msgbox "警告:最上層のレイヤーにタイル「上」が設置されています。" +
                 "\n問題の座標(x:#{x}, y:#{y})"
        end
      end
    end
    @multi_map_data.each do |map_data|
      map_data.events.each do |event_id, event_data|
        event_data.pages.each do |page_data|
          tile_id = page_data.graphic.tile_id
          next if tile_id == 0
          if tile_id == Calt::LAYER_UP_TILE || tile_id == Calt::LAYER_DOWN_TILE
            p "注意:タイルイベントでタイル「上」及び「下」を設置しても効果はありません。"
          end
          if Calt::BOAT_PASSABLE_TILE_ID_HASH[tile_id] ||
             Calt::SHIP_PASSABLE_TILE_ID_HASH[tile_id] ||
             Calt::SUBMERGENCE_TILE_ID_HASH[tile_id] || Calt::AIR_TILE_ID_HASH[tile_id]
            p "注意:タイルイベントでタイル「浅」、「深」、「空」及び「草」を設置しても効果はありません。"
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● イベントIDの変換に使用する配列の生成 [新規]
  #--------------------------------------------------------------------------
  def create_event_id_transformation
    indirect = 0
    max_key_list = Array.new
    @multi_map_data.each do |map_data|
      max_key_list.push max_key = map_data.events.keys.max || 0 # イベントIDの最大値
      indirect = max_key if max_key > indirect  # 全てのレイヤーのうち最大のイベントIDを取得
    end
    @event_id_transformation = [indirect] # 間接的にイベントIDを指定する範囲(1 ～ indirect)
    max_key_list.each do |max_key|
      @event_id_transformation.push @event_id_transformation[-1] + max_key  # そのレイヤーのイベントの末尾インデックス
    end
  end
  #--------------------------------------------------------------------------
  # ● 全レイヤーのイベントを統合したマップデータの生成 [新規]
  #--------------------------------------------------------------------------
  def create_all_events_map_data
    @map = @multi_map_data[0].clone # 最下層を使用
    multi_events = Hash.new # 統合したイベントデータのハッシュ
    @multi_map_data.each_index do |i|
      standard_id = @event_id_transformation[i]
      new_events = Hash.new # 変更したイベントデータのハッシュ
      @multi_map_data[i].events.each do |event_id, event_data|
        new_event_id  = standard_id + event_id  # 新しいイベントID
        event_data.id = new_event_id  # イベントデータのIDを変更
        new_events[new_event_id]   = event_data
        multi_events[new_event_id] = event_data
      end
      @multi_map_data[i].events = new_events  # イベントIDを変更したので元のデータを更新
    end
    @map.events = multi_events  # 統合したイベントデータを代入
  end
  #--------------------------------------------------------------------------
  # ● 前景スプライトの配列の生成 [新規]
  #--------------------------------------------------------------------------
  def create_foreground_sprites
    group_list = $game_temp.map_layer_list[@map_group_id]
    @foreground_sprites = Array.new(layer_size) do |index|
      map_id = group_list[index]
      Sprite_Manager.new($game_temp.map_foreground[map_id] || nil)
    end
  end
  #--------------------------------------------------------------------------
  # ● セットアップ [◆再定義]
  #--------------------------------------------------------------------------
  def setup(map_id)
    $game_player.current_floor = $game_temp.map_id_to_z(map_id) # プレイヤーの階層を更新
    return if $game_temp.map_group_list[map_id] == @map_group_id  # グループIDで比較
    create_multi_map_data(map_id)
    standard_check if $TEST
    create_event_id_transformation
    create_all_events_map_data
    create_foreground_sprites
    @multi_tileset = Array.new
    @multi_map_data.each { |map_data| @multi_tileset.push map_data.tileset_id }
    # @tileset_id は使用しないので消去
    @display_x = 0
    @display_y = 0
    referesh_vehicles
    setup_events
    setup_scroll
    setup_parallax
    setup_battleback
    @need_refresh = false
    @note = @map.note
  end
  #--------------------------------------------------------------------------
  # ● イベントのセットアップ [◆再定義]
  #--------------------------------------------------------------------------
  def setup_events
    @events = {}
    @map.events.each do |i, event|
      @events[i] = event_object = Game_Event.new(@map_id, event)
      (@event_id_transformation.size - 2).downto(0) do |floor|
        break event_object.init_floor(floor) if @event_id_transformation[floor] < i
      end
    end
    @common_events = parallel_common_events.collect do |common_event|
      Game_CommonEvent.new(common_event.id)
    end
    refresh_tile_events
  end
  #--------------------------------------------------------------------------
  # ● タイルセットの取得 [◆再定義]
  #--------------------------------------------------------------------------
  def tileset(floor = floor_omit)
    $data_tilesets[@multi_tileset[floor] || 1]
  end
  #--------------------------------------------------------------------------
  # ● マップデータの取得 [◆再定義]
  #--------------------------------------------------------------------------
  def data(floor = floor_omit)
    @multi_map_data[floor].data
  end
  #--------------------------------------------------------------------------
  # ● フィールドタイプか否か [◆再定義]
  #--------------------------------------------------------------------------
  def overworld?(floor = floor_omit)
    tileset(floor).mode == 0
  end
  #--------------------------------------------------------------------------
  # ● 指定座標のタイルを判定して階層移動後の階層を取得 [新規]
  #--------------------------------------------------------------------------
  def floor_xy(x, y, floor = floor_omit)
    return floor unless map_data = @multi_map_data[floor]
    id = map_data.data[x, y, 2] || 0
    if id == Calt::LAYER_UP_TILE
      floor += 1
      floor += 1 while @multi_map_data[floor].data[x, y, 2] == Calt::LAYER_UP_TILE
    elsif id == Calt::LAYER_DOWN_TILE
      floor -= 1
      floor -= 1 while @multi_map_data[floor].data[x, y, 2] == Calt::LAYER_DOWN_TILE
    end
    return floor
  end
  #--------------------------------------------------------------------------
  # ● 指定座標に存在するイベントの配列取得 [◆再定義]
  #--------------------------------------------------------------------------
  def events_xy(x, y, floor = floor_omit)
    @events.values.select {|event| event.pos?(x, y, floor) }
  end
  #--------------------------------------------------------------------------
  # ● 指定座標に存在するイベント（すり抜け以外）の配列取得 [◆再定義]
  #--------------------------------------------------------------------------
  def events_xy_nt(x, y, floor = floor_omit)
    @events.values.select {|event| event.pos_nt?(x, y, floor) }
  end
  #--------------------------------------------------------------------------
  # ● 指定座標に存在するタイル扱いイベント（すり抜け以外）の配列取得 [◆再定義]
  #--------------------------------------------------------------------------
  def tile_events_xy(x, y, floor = floor_omit)
    @tile_events.select {|event| event.pos_nt?(x, y, floor) }
  end
  #--------------------------------------------------------------------------
  # ● 指定座標に存在するイベントの ID 取得（一つのみ） [◆再定義]
  #--------------------------------------------------------------------------
  def event_id_xy(x, y, floor = floor_omit)
    list = events_xy(x, y, floor)
    list.empty? ? 0 : list[0].id
  end
  #--------------------------------------------------------------------------
  # ● 通行チェック [◆再定義]
  #--------------------------------------------------------------------------
  def check_passage(x, y, bit, floor = floor_omit)
    floor2 = floor_xy(x, y, floor)
    all_tiles(x, y, floor).each do |tile_id|
      flag = tileset(floor2).flags[tile_id]
      next if flag & 0x10 != 0            # [☆] : 通行に影響しない
      return true  if flag & bit == 0     # [○] : 通行可
      return false if flag & bit == bit   # [×] : 通行不可
    end
    return false                          # 通行不可
  end
  #--------------------------------------------------------------------------
  # ● 指定座標にあるタイル ID の取得 [◆再定義]
  #--------------------------------------------------------------------------
  def tile_id(x, y, z, floor = floor_omit)
    floor = floor_xy(x, y, floor)
    return 0 unless map_data = @multi_map_data[floor]
    return Calt::NOT_EXIST_TILE_TABLE[map_data.data[x, y, z] || 0]
  end
  #--------------------------------------------------------------------------
  # ● 指定座標にある全レイヤーのタイル（上から順）を配列で取得 [◆再定義]
  #--------------------------------------------------------------------------
  def layered_tiles(x, y, floor = floor_omit)
    [2, 1, 0].collect {|z| tile_id(x, y, z, floor) }
  end
  #--------------------------------------------------------------------------
  # ● 指定座標にある全てのタイル（イベント含む）を配列で取得 [◆再定義]
  #--------------------------------------------------------------------------
  def all_tiles(x, y, floor = floor_omit)
    tile_events_xy(x, y, floor).collect {|ev| Calt::NOT_EXIST_TILE_TABLE[ev.tile_id] } + layered_tiles(x, y, floor)
  end
  #--------------------------------------------------------------------------
  # ● 指定座標にあるオートタイルの種類を取得　[◆再定義]
  #--------------------------------------------------------------------------
  def autotile_type(x, y, z, floor = floor_omit)
    id = tile_id(x, y, z, floor)
    id >= 2048 ? (id - 2048) / 48 : -1
  end
  #--------------------------------------------------------------------------
  # ● 通常キャラの通行可能判定　[◆再定義]
  #--------------------------------------------------------------------------
  def passable?(x, y, d, floor = floor_omit)
    check_passage(x, y, (1 << (d / 2 - 1)) & 0x0f, floor)
  end
  #--------------------------------------------------------------------------
  # ● 配列のIDが指定座標に有効に存在するか判定　[新規]
  #--------------------------------------------------------------------------
  def valid_tile_id?(x, y, floor, tile_id_hash)
    floor2 = floor_xy(x, y, floor)
    layered_tiles(x, y, floor).each do |tile_id|
      return true if tile_id_hash[tile_id]
      next if tileset(floor2).flags[tile_id] & 0x10 != 0  # [☆] : 通行に影響しない
      return false
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 小型船の通行可能判定　[◆再定義]
  #--------------------------------------------------------------------------
  def boat_passable?(x, y, floor = floor_omit)
    check_passage(x, y, 0x0200, floor) || valid_tile_id?(x, y, floor, Calt::BOAT_PASSABLE_TILE_ID_HASH)
  end
  #--------------------------------------------------------------------------
  # ● 大型船の通行可能判定　[◆再定義]
  #--------------------------------------------------------------------------
  def ship_passable?(x, y, floor = floor_omit)
    check_passage(x, y, 0x0400, floor) || valid_tile_id?(x, y, floor, Calt::SHIP_PASSABLE_TILE_ID_HASH)
  end
  #--------------------------------------------------------------------------
  # ● 飛行船の着陸可能判定　[◆再定義]
  #--------------------------------------------------------------------------
  def airship_land_ok?(x, y, floor = floor_omit)
    check_passage(x, y, 0x0800, floor) && check_passage(x, y, 0x0f, floor)
  end
  #--------------------------------------------------------------------------
  # ● 指定座標の全レイヤーのフラグ判定 [◆再定義]
  #--------------------------------------------------------------------------
  def layered_tiles_flag?(x, y, bit, floor = floor_omit)
    floor2 = floor_xy(x, y, floor)
    layered_tiles(x, y, floor).any? {|tile_id| tileset(floor2).flags[tile_id] & bit != 0 }
  end
  #--------------------------------------------------------------------------
  # ● 梯子判定 [◆再定義]
  #--------------------------------------------------------------------------
  def ladder?(x, y, floor = floor_omit)
    valid?(x, y) && layered_tiles_flag?(x, y, 0x20, floor)
  end
  #--------------------------------------------------------------------------
  # ● 茂み判定 [◆再定義]
  #--------------------------------------------------------------------------
  def bush?(x, y, floor = floor_omit)
    valid?(x, y) && layered_tiles_flag?(x, y, 0x40, floor)
  end
  #--------------------------------------------------------------------------
  # ● カウンター判定 [◆再定義]
  #--------------------------------------------------------------------------
  def counter?(x, y, floor = floor_omit)
    valid?(x, y) && layered_tiles_flag?(x, y, 0x80, floor)
  end
  #--------------------------------------------------------------------------
  # ● ダメージ床判定 [◆再定義]
  #--------------------------------------------------------------------------
  def damage_floor?(x, y, floor = floor_omit)
    valid?(x, y) && layered_tiles_flag?(x, y, 0x100, floor)
  end
  #--------------------------------------------------------------------------
  # ● 地形タグの取得 [◆再定義]
  #--------------------------------------------------------------------------
  def terrain_tag(x, y, floor = floor_omit)
    return 0 unless valid?(x, y)
    floor2 = floor_xy(x, y, floor)
    layered_tiles(x, y, floor).each do |tile_id|
      tag = tileset(floor2).flags[tile_id] >> 12
      return tag if tag > 0
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● リージョン ID の取得 [◆再定義]
  #--------------------------------------------------------------------------
  def region_id(x, y, floor = floor_omit)
    floor = floor_xy(x, y, floor)
    valid?(x, y) ? @multi_map_data[floor].data[x, y, 3] >> 8 : 0
  end
  #--------------------------------------------------------------------------
  # ● タイルセットの変更 [◆再定義]
  #--------------------------------------------------------------------------
  def change_tileset(tileset_id, floor = floor_omit)
    @multi_tileset[floor] = tileset_id
    refresh
  end
end

#==============================================================================
# ■ Game_CharacterBase
#------------------------------------------------------------------------------
# 　キャラクターを扱う基本のクラスです。全てのキャラクターに共通する、座標やグ
# ラフィックなどの基本的な情報を保持します。
#==============================================================================
class Game_CharacterBase
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :current_floor            # 現在地のレイヤー
  attr_accessor :default_floor            # 初期地のレイヤー
  #--------------------------------------------------------------------------
  # ● 公開メンバ変数の初期化 [追加]
  #--------------------------------------------------------------------------
  alias init_public_members_Multilayer init_public_members
  def init_public_members
    init_public_members_Multilayer
    @default_floor = 0
    @current_floor = 0
  end
  #--------------------------------------------------------------------------
  # ● 非公開メンバ変数の初期化 [追加]
  #--------------------------------------------------------------------------
  alias init_private_members_Multilayer init_private_members
  def init_private_members
    init_private_members_Multilayer
    @last_x = -1
    @last_y = -1
  end
  #--------------------------------------------------------------------------
  # ● 階層(レイヤー)の初期化 [新規]
  #--------------------------------------------------------------------------
  def init_floor(floor)
    @current_floor = floor
    @default_floor = floor
    update_bush_depth
  end
  #--------------------------------------------------------------------------
  # ● 座標一致判定 [◆再定義]
  #--------------------------------------------------------------------------
  def pos?(x, y, floor = $game_map.floor_omit)
    @x == x && @y == y && @current_floor == $game_map.floor_xy(x, y, floor)
  end
  #--------------------------------------------------------------------------
  # ● 座標一致と「すり抜け OFF」判定（nt = No Through） [◆再定義]
  #--------------------------------------------------------------------------
  def pos_nt?(*args)
    pos?(*args) && !@through
  end
  #--------------------------------------------------------------------------
  # ● 階層の接続を確認 [新規]
  #--------------------------------------------------------------------------
  def update_current_floor(x, y)
    return if x == @last_x && y == @last_y
    @current_floor = $game_map.floor_xy(@last_x = x, @last_y = y, @current_floor) # 階層を更新
  end
  #--------------------------------------------------------------------------
  # ● 指定位置に移動 [追加]
  #--------------------------------------------------------------------------
  alias moveto_Multilayer moveto
  def moveto(x, y)
    update_current_floor(x, y)  # 階層の接続を確認
    moveto_Multilayer(x, y)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 [追加]
  #--------------------------------------------------------------------------
  alias update_Multilayer update
  def update
    update_Multilayer
    update_current_floor(@x, @y)  # 階層の接続を確認
  end
#~   #--------------------------------------------------------------------------
#~   # ● ジャンプ時の更新 [追加]
#~   #--------------------------------------------------------------------------
#~   alias update_jump_Multilayer update_jump
#~   def update_jump
#~     if @jump_count == 1
#~       @current_floor = @landing_floor || 0  # 着地時に階層を更新
#~       @landing_floor = false
#~     end
#~     update_jump_Multilayer
#~   end
  #--------------------------------------------------------------------------
  # ● 茂み深さの更新 [◆再定義]
  #--------------------------------------------------------------------------
  alias update_bush_depth_Multilayer update_bush_depth
  def update_bush_depth
    if normal_priority? && !jumping? && $game_map.valid_tile_id?(@x, @y, @current_floor, Calt::SUBMERGENCE_TILE_ID_HASH)
      @bush_depth = 4 unless moving?
    else
      update_bush_depth_Multilayer
    end
  end
  #--------------------------------------------------------------------------
  # ● 歩数増加 [追加]
  #--------------------------------------------------------------------------
  alias increase_steps_Multilayer increase_steps
  def increase_steps
    update_current_floor(@x, @y)  # 階層の接続を確認
    increase_steps_Multilayer
  end
end

#==============================================================================
# ■ Game_Character
#------------------------------------------------------------------------------
# 　主に移動ルートなどの処理を追加したキャラクターのクラスです。Game_Player、
# Game_Follower、GameVehicle、Game_Event のスーパークラスとして使用されます。
#==============================================================================
class Game_Character < Game_CharacterBase
#~   #--------------------------------------------------------------------------
#~   # ● ジャンプ [◆再定義]
#~   #--------------------------------------------------------------------------
#~   def jump(x_plus, y_plus)
#~     if x_plus.abs > y_plus.abs
#~       set_direction(x_plus < 0 ? 4 : 6) if x_plus != 0
#~     else
#~       set_direction(y_plus < 0 ? 8 : 2) if y_plus != 0
#~     end
#~     @x += x_plus
#~     @y += y_plus
#~     floor = $game_map.layer_size - 1 # 最上層
#~     floor -= 1 while $game_map.multi_map_data[floor].data[@x, @y, 2] == Calt::LAYER_DOWN_TILE
#~     while floor > 0
#~       break unless $game_map.valid_tile_id?(@x, @y, floor, Calt::AIR_TILE_ID_HASH)
#~       floor -= 1
#~       floor -= 1 while $game_map.multi_map_data[floor].data[@x, @y, 2] == Calt::LAYER_DOWN_TILE
#~     end
#~     @landing_floor = floor  # 着地場所の階層を記憶
#~     @current_floor = [@current_floor, @landing_floor].max # ジャンプ中の階層
#~     distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
#~     @jump_peak = 10 + distance - @move_speed
#~     @jump_count = @jump_peak * 2
#~     @stop_count = 0
#~     straighten
#~   end
  #--------------------------------------------------------------------------
  # ● 詳細設定してジャンプさせる [新規]
  #   flying_floor  : ジャンプ開始～ジャンプ終了までのレイヤー番号
  #   landing_floor : ジャンプ終了後のレイヤー番号
  #--------------------------------------------------------------------------
  def manual_jump(x_plus, y_plus, flying_floor_index, landing_floor_index)
    jump(x_plus, y_plus)
    @current_floor = $game_map.layer_index[flying_floor_index]
    @landing_floor = $game_map.layer_index[landing_floor_index]
  end
end

#==============================================================================
# ■ Game_Player
#------------------------------------------------------------------------------
# 　プレイヤーを扱うクラスです。イベントの起動判定や、マップのスクロールなどの
# 機能を持っています。このクラスのインスタンスは $game_player で参照されます。
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # ● 場所移動の実行 [◆再定義]
  #--------------------------------------------------------------------------
  def perform_transfer
    if transfer?
      set_direction(@new_direction)
      if $game_temp.map_group_list[@new_map_id] != $game_map.map_group_id
        $game_map.setup(@new_map_id)
        $game_map.autoplay
      else
        $game_map.setup(@new_map_id)
      end
      moveto(@new_x, @new_y)
      clear_transfer_info
    end
  end
  #--------------------------------------------------------------------------
  # ● 階層の接続を確認 [新規]
  #--------------------------------------------------------------------------
  def update_current_floor(x, y)
    return if in_airship? # 飛行船は最上層を飛ぶので処理しない
    super
  end
end

#==============================================================================
# ■ Game_Followers
#------------------------------------------------------------------------------
# 　フォロワーの配列のラッパーです。このクラスは Game_Player クラスの内部で使
# 用されます。
#==============================================================================
class Game_Followers
  #--------------------------------------------------------------------------
  # ● イテレータ [◆再定義]
  #--------------------------------------------------------------------------
  def each
    return unless block_given?
    @data.each do |follower|
      $game_map.temp_execute(follower) { yield follower } # 追従者を基準に実行するように変更
    end
  end
  #--------------------------------------------------------------------------
  # ● イテレータ（逆順） [◆再定義]
  #--------------------------------------------------------------------------
  def reverse_each
    return unless block_given?
    @data.reverse.each do |follower|
      $game_map.temp_execute(follower) { yield follower } # 追従者を基準に実行するように変更
    end
  end
  #--------------------------------------------------------------------------
  # ● 同期 [◆再定義]
  #--------------------------------------------------------------------------
  def synchronize(x, y, d)
    each do |follower|
      follower.current_floor = $game_player.current_floor
      follower.moveto(x, y)
      follower.set_direction(d)
    end
  end
  #--------------------------------------------------------------------------
  # ● 階層のみプレイヤーと同期 [新規]
  #--------------------------------------------------------------------------
  def synchronize_floor
    each do |follower|
      follower.current_floor = $game_player.current_floor
    end
  end
end

#==============================================================================
# ■ Game_Vehicle
#------------------------------------------------------------------------------
# 　乗り物を扱うクラスです。このクラスは Game_Map クラスの内部で使用されます。
# 現在のマップに乗り物がないときは、マップ座標 (-1,-1) に設定されます。
#==============================================================================
class Game_Vehicle < Game_Character
  #--------------------------------------------------------------------------
  # ● 現在地のレイヤーの取得 [◆再定義]
  #--------------------------------------------------------------------------
  def current_floor
    return @map_id == $game_map.map_id ? @current_floor : 0
  end
  #--------------------------------------------------------------------------
  # ● システム設定のロード [追加]
  #--------------------------------------------------------------------------
  alias load_system_settings_Multilayer load_system_settings
  def load_system_settings
    load_system_settings_Multilayer
    @current_floor = $game_temp.map_id_to_z(@map_id)  # IDから階層を取得
    @map_id = $game_temp.map_id_to_base_map_id(@map_id)   # IDから最下層のIDを取得
  end
  #--------------------------------------------------------------------------
  # ● 位置の変更 [追加]
  #--------------------------------------------------------------------------
  alias set_location_Multilayer set_location
  def set_location(map_id, x, y)
    @current_floor = $game_temp.map_id_to_z(map_id) # IDから階層を取得
    map_id = $game_temp.map_id_to_base_map_id(map_id)   # IDから最下層のIDを取得
    set_location_Multilayer(map_id, x, y)
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーとの同期 [追加]
  #--------------------------------------------------------------------------
  alias sync_with_player_Multilayer sync_with_player
  def sync_with_player
    @current_floor = $game_player.current_floor
    sync_with_player_Multilayer
  end
  #--------------------------------------------------------------------------
  # ● 階層の接続を確認 [新規]
  #--------------------------------------------------------------------------
  def update_current_floor(x, y)
    return if @driving  # 運転中はプレイヤーに同期するので処理しない
    super
  end
  #--------------------------------------------------------------------------
  # ● 乗り物に乗る [追加]
  #--------------------------------------------------------------------------
  alias get_on_Multilayer get_on
  def get_on
    get_on_Multilayer
    if @type == :airship  # 飛行船は離陸すると最上層へ移動
      $game_player.current_floor = @current_floor = $game_map.layer_size - 1
      $game_player.followers.synchronize_floor
    end
  end
  #--------------------------------------------------------------------------
  # ● 乗り物から降りる [追加]
  #--------------------------------------------------------------------------
  alias get_off_Multilayer get_off
  def get_off
    get_off_Multilayer
    if @type == :airship
      floor = @current_floor
      floor -= 1 while $game_map.multi_map_data[floor].data[x, y, 2] == Calt::LAYER_DOWN_TILE
      while floor > 0
        break unless $game_map.valid_tile_id?(x, y, floor, Calt::AIR_TILE_ID_HASH)
        floor -= 1
        floor -= 1 while $game_map.multi_map_data[floor].data[x, y, 2] == Calt::LAYER_DOWN_TILE
      end
      @land_floor = $game_player.current_floor = floor  # プレイヤーは着陸前に階層を更新
      $game_player.followers.synchronize_floor
    end
  end
  #--------------------------------------------------------------------------
  # ● 画面 Z 座標の取得 [追加]
  #--------------------------------------------------------------------------
  alias screen_z_Multilayer screen_z
  def screen_z
    return screen_z_Multilayer + (@altitude > max_altitude ? 10 : 0)  # 高高度でも上層イベントより上に表示されるように
  end
  #--------------------------------------------------------------------------
  # ● 飛行船の高度を更新 [◆再定義]
  #--------------------------------------------------------------------------
  def update_airship_altitude
    floor = current_floor
    floor -= 1 while $game_map.multi_map_data[floor].data[x, y, 2] == Calt::LAYER_DOWN_TILE
    while floor > 0
      break unless $game_map.valid_tile_id?(x, y, floor, Calt::AIR_TILE_ID_HASH)
      floor -= 1
      floor -= 1 while $game_map.multi_map_data[floor].data[x, y, 2] == Calt::LAYER_DOWN_TILE
    end
    horizon_floor = $game_map.layer_index.keys.select { |key| key < 0 }.size  # レイヤー番号が負の値のレイヤー数
    floor = [floor, horizon_floor].max
    multi_max_altitude = max_altitude + 8 * (floor - horizon_floor)
    if @driving
      if @altitude < multi_max_altitude && (takeoff_ok? || @altitude >= max_altitude)
        @altitude += 1 
      elsif @altitude > multi_max_altitude
        @altitude -= 1
      end
    elsif @altitude > 0
      @altitude -= 1
      if @altitude == 0
        @current_floor = @land_floor || 0 # 飛行船は着陸時に階層を更新
        @priority_type = 0
      end
    end
    @step_anime = (@altitude == multi_max_altitude)
    @priority_type = 2 if @altitude > 0
  end
  #--------------------------------------------------------------------------
  # ● 接岸／着陸可能判定 [◆再定義]
  #--------------------------------------------------------------------------
  def land_ok?(x, y, d)
    if @type == :airship
      floor = @current_floor
      floor -= 1 while $game_map.multi_map_data[floor].data[x, y, 2] == Calt::LAYER_DOWN_TILE
      while floor > 0
        break unless $game_map.valid_tile_id?(x, y, floor, Calt::AIR_TILE_ID_HASH)
        return false unless $game_map.events_xy(x, y, floor).empty?
        floor -= 1
        floor -= 1 while $game_map.multi_map_data[floor].data[x, y, 2] == Calt::LAYER_DOWN_TILE
      end
      return false unless $game_map.events_xy(x, y, floor).empty?
      return false unless $game_map.airship_land_ok?(x, y, floor)
      return false if $game_map.layer_index.index(floor) < 0
    else
      x2 = $game_map.round_x_with_direction(x, d)
      y2 = $game_map.round_y_with_direction(y, d)
      return false unless $game_map.valid?(x2, y2)
      return false unless $game_map.passable?(x2, y2, reverse_dir(d), @current_floor)
      return false if collide_with_characters?(x2, y2)
    end
    return true
  end
end

#==============================================================================
# ■ Game_Interpreter
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_Map クラス、
# Game_Troop クラス、Game_Event クラスの内部で使用されます。
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● キャラクターの取得 [追加]
  #--------------------------------------------------------------------------
  alias get_character_Multilayer get_character
  def get_character(param)
    if 0 < param && param <= $game_map.event_id_transformation[0] # 間接指定の範囲
      event = get_character_Multilayer(@event_id)
      default_floor = event && same_map? ? event.default_floor : 0
      param = ($game_map.event_id_transformation[default_floor] || 0) + param
    end
    return get_character_Multilayer(param)
  end
  #--------------------------------------------------------------------------
  # ● アニメーションは対象の現在地の階層で再生する [新規]
  #--------------------------------------------------------------------------
  def animation_current_floor_ON
    $game_map.animation_current_floor = true
  end
  #--------------------------------------------------------------------------
  # ● アニメーションは対象の現在地の階層で再生しない [新規]
  #--------------------------------------------------------------------------
  def animation_current_floor_OFF
    $game_map.animation_current_floor = false
  end
  #--------------------------------------------------------------------------
  # ● 前景スプライトを取得( Sprite_Manager クラス) [新規]
  #   index        : レイヤー番号
  #--------------------------------------------------------------------------
  def get_foreground_sprite(index)
    return $game_map.foreground_sprites[$game_map.layer_index[index]]
  end
  #--------------------------------------------------------------------------
  # ● 指定したIDのイベントのレイヤーを変更 [新規]
  #   event_id : 操作するイベントのID
  #   index    : 新しいレイヤー番号
  #--------------------------------------------------------------------------
  def change_layer(event_id, index)
    get_character(event_id).current_floor = $game_map.layer_index[index]
  end
  #--------------------------------------------------------------------------
  # ● 指定したIDのイベントの現在地のレイヤー番号を取得 [新規]
  #   event_id : 操作するイベントのID
  #--------------------------------------------------------------------------
  def current_layer(event_id)
    return $game_map.layer_index.index(get_character(event_id).current_floor)
  end
  #--------------------------------------------------------------------------
  # ● レイヤー番号とイベントIDから絶対イベントIDを取得 [新規]
  #   ※所属するレイヤー以外のイベントを対象にする時に使用する。「命令の対象を変更」のスクリプトとの併用を想定
  #   event_id : イベントID
  #   index    : レイヤー番号
  #--------------------------------------------------------------------------
  def absolute_event_id(event_id, index)
    if 0 < event_id && event_id <= $game_map.event_id_transformation[0] # 間接指定の範囲
      floor = $game_map.layer_index[index]
      event_id = ($game_map.event_id_transformation[floor] || 0) + event_id
    end
    return event_id
  end
  #--------------------------------------------------------------------------
  # ● タイルセットの変更 [◆再定義]
  #--------------------------------------------------------------------------
  alias command_282_Multilayer command_282
  def command_282
    $game_map.temp_execute(get_character(@event_id)) { command_282_Multilayer } # 実行したイベントを基準に実行
  end
  #--------------------------------------------------------------------------
  # ● 指定位置の情報取得 [◆再定義]
  #--------------------------------------------------------------------------
  alias command_285_Multilayer command_285
  def command_285
    $game_map.temp_execute(get_character(@event_id)) { command_285_Multilayer } # 実行したイベントを基準に取得
  end
end

#==============================================================================
# ■ Sprite_Character
#------------------------------------------------------------------------------
# 　キャラクター表示用のスプライトです。Game_Character クラスのインスタンスを
# 監視し、スプライトの状態を自動的に変化させます。
#==============================================================================
class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化 [追加]
  #--------------------------------------------------------------------------
  alias initialize_Multilayer initialize
  def initialize(viewport, character = nil)
    @current_floor = character.current_floor
    viewport = multi_viewport[@current_floor] # 引数は無視してビューポートを設定
    initialize_Multilayer(viewport, character)
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの取得 [新規]
  #--------------------------------------------------------------------------
  def multi_viewport
    return $game_temp.multi_viewport_accessor
  end
  #--------------------------------------------------------------------------
  # ● 解放 [追加]
  #--------------------------------------------------------------------------
  alias dispose_Multilayer dispose
  def dispose
    @sprites_cash_size = 0
    dispose_junction_sprites
    dispose_Multilayer
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 [◆再定義]
  #--------------------------------------------------------------------------
  def update
    super
    update_bitmap
    update_src_rect
    update_tile_src_rect    # タイルイベントの矩形を更新
    update_position
    update_other
    update_junction_sprite  # 階層の更新
    update_balloon
    setup_new_effect
  end
  #--------------------------------------------------------------------------
  # ● 指定されたタイルが含まれるタイルセット画像の取得 [◆再定義]
  #--------------------------------------------------------------------------
  def tileset_bitmap(tile_id)
    Cache.tileset($game_map.tileset(@character.default_floor).tileset_names[5 + tile_id / 256])
  end
  #--------------------------------------------------------------------------
  # ● タイルのビットマップを設定 [追加]
  #--------------------------------------------------------------------------
  alias set_tile_bitmap_Multilayer set_tile_bitmap
  def set_tile_bitmap
    set_tile_bitmap_Multilayer
    @cw = @ch = 32  # キャラクターと同様にサイズを記憶しておく
  end
  #--------------------------------------------------------------------------
  # ● タイルイベントの矩形を更新(変更した値の初期化) [新規]
  #--------------------------------------------------------------------------
  def update_tile_src_rect
    return if @tile_id == 0     # タイルイベントでない
    return unless @sprites_cash # レイヤー接合を行っていない
    self.src_rect.set((@tile_id / 128 % 2 * 8 + @tile_id % 8) * 32, @tile_id % 256 / 8 % 16 * 32, 32, 32)
    self.ox = 16
    self.oy = 32
  end
  #--------------------------------------------------------------------------
  # ● 階層の更新 [新規]
  #--------------------------------------------------------------------------
  def update_junction_sprite
    @sprites_cash_size = 0  # レイヤー接合スプライトの枚数

    screen_x = @character.screen_x  # 画面の転送元原点を基準にしたx座標
    return dispose_junction_sprites if screen_x < -@cw || Graphics.width  + @cw < screen_x  # 処理軽減(画面外)
    screen_y = @character.screen_y  # 画面の転送元原点を基準にしたy座標
    return dispose_junction_sprites if screen_y < 0    || Graphics.height + @ch < screen_y  # 処理軽減(画面外)
    return dispose_junction_sprites unless self.visible # 処理軽減(非表示は処理しない)

    reset_sprite_origin                                 # 転送元原点の再設定
    dot_x = $game_map.display_x * 32 + screen_x         # マップの原点を基準にした X 座標
    dot_y = $game_map.display_y * 32 + screen_y         # マップの原点を基準にした Y 座標
    map_x = $game_map.round_x(((dot_x - 1) / 32).floor) # マップの原点を基準にした論理 X 座標
    map_y = $game_map.round_y(((dot_y - 1) / 32).floor) # マップの原点を基準にした論理 Y 座標
    rem_x = -dot_x % 32 - 16                            # 停止状態を基準に左にずれてるドット数
    rem_y = -dot_y % 32                                 # 停止状態を基準に上にずれてるドット数
    left_width  = @cw / 2                               # 転送元原点から左側の幅
    right_width = @cw - left_width                      # 転送元原点から右側の幅
    jun_l = ((left_width  + 16 + rem_x) / 32.0).ceil    # 左のタイル数
    jun_r = ((right_width + 16 - rem_x) / 32.0).ceil    # 右のタイル数
    jun_h = ((@ch + rem_y) / 32.0).ceil                 # 縦のタイル数

    old_floor  = $game_map.floor_xy(map_x, map_y, @character.current_floor)
    old_sprite = self
    old_sprite.viewport = multi_viewport[old_floor]  # 階層の更新
    base_floors  = [old_floor]  # 中央の階層の配列
    base_sprites = [old_sprite] # 中央のスプライトの配列
    base_valid_y = [true]       # 有効座標の判定結果
    for i in 1 ... jun_h
      new_map_y = $game_map.round_y(map_y - i)
      if valid_y?(new_map_y)
        base_valid_y.push new_map_y # 有効座標を記憶
        new_floor = $game_map.floor_xy(map_x, new_map_y, old_floor)
        unless old_floor == new_floor
          new_sprite = get_junction_sprite
          new_rect_height = old_sprite.height + rem_y - 32 * i
          horz_divide_sprite(old_sprite, new_sprite, new_floor, new_rect_height)  # 横分割
          old_floor  = new_floor
          old_sprite = new_sprite
        end
      else
        base_valid_y.push false # 有効座標の判定を記憶
      end
      base_floors.push  old_floor
      base_sprites.push old_sprite
    end

    # 左側の処理
    left_floors  = base_floors  # 右隣の階層の配列
    left_sprites = base_sprites # 右隣のスプライトの配列
    for i in 1 ... jun_l
      new_map_x = $game_map.round_x(map_x - i)
      if valid_x?(new_map_x)
        floor = $game_map.floor_xy(new_map_x, map_y, left_floors[0])  # 右隣の下端の階層を基準にする
        floors = [floor]
        for j in 1 ... jun_h
          if base_valid_y[j]
            new_map_y = base_valid_y[j]
            floor = $game_map.floor_xy(new_map_x, new_map_y, floor)
          end
          floors.push floor
        end
        
        unless floors == left_floors  # 右隣と階層に変化があるか比較
          sprites = left_sprites.dup  # 右隣の階層の配列をコピー
          count = 0
          while count < jun_h
            unless floors[count] == left_floors[count]
              old_sprite  = left_sprites[count] # 基準にするスプライト
              index_floor = count # 同じスプライトが使用されている下端のインデックス
              index_ceil  = count # 同じスプライトが使用されている上端のインデックス
              index_floor -= 1 while index_floor > 0         && old_sprite == left_sprites[index_floor - 1]
              index_ceil  += 1 while index_ceil  < jun_h - 1 && old_sprite == left_sprites[index_ceil  + 1]
              count = index_ceil
              
              new_sprite = get_junction_sprite
              new_floor  = floors[index_floor]
              new_rect_width = left_width + 16 + rem_x - 32 * i
              left_divide_sprite(old_sprite, new_sprite, new_floor, new_rect_width) # 縦分割(左側用)

              old_floor = new_floor
              sprites[index_floor] = old_sprite = new_sprite
              for index in index_floor + 1 .. index_ceil
                new_floor = floors[index]
                unless old_floor == new_floor
                  new_sprite = get_junction_sprite
                  new_rect_height = old_sprite.height + rem_y - 32 * index
                  horz_divide_sprite(old_sprite, new_sprite, new_floor, new_rect_height)  # 横分割
                  old_floor  = new_floor
                  old_sprite = new_sprite
                end
                sprites[index] = old_sprite
              end
            end
            count += 1
          end
          left_sprites.push sprites # 演算で得られたスプライトの配列を追加
        end
        left_floors = floors  # 右隣の階層の配列を更新
      end
    end

    # 右側の処理
    right_floors  = base_floors   # 左隣の階層の配列
    right_sprites = base_sprites  # 左隣のスプライトの配列
    for i in 1 ... jun_r
      new_map_x = $game_map.round_x(map_x + i)
      if valid_x?(new_map_x)
        floor = $game_map.floor_xy(new_map_x, map_y, right_floors[0]) # 左隣の下端の階層を基準にする
        floors = [floor]
        for j in 1 ... jun_h
          if base_valid_y[j]
            new_map_y = base_valid_y[j]
            floor = $game_map.floor_xy(new_map_x, new_map_y, floor)
          end
          floors.push floor
        end

        unless floors == right_floors # 左隣と階層に変化があるか比較
          sprites = right_sprites.dup # 左隣の階層の配列をコピー
          count = 0
          while count < jun_h
            unless floors[count] == right_floors[count]
              old_sprite  = right_sprites[count] # 縦分割するスプライトを取得
              index_floor = count # 同じスプライトが使用されている下端のインデックス
              index_ceil  = count # 同じスプライトが使用されている上端のインデックス
              index_floor -= 1 while index_floor > 0         && old_sprite == right_sprites[index_floor - 1]
              index_ceil  += 1 while index_ceil  < jun_h - 1 && old_sprite == right_sprites[index_ceil  + 1]
              count = index_ceil

              new_sprite = get_junction_sprite
              new_floor  = floors[index_floor]
              new_rect_width = right_width + 16 - rem_x - 32 * i
              right_divide_sprite(old_sprite, new_sprite, new_floor, new_rect_width)  # 縦分割(右側用)

              old_floor = new_floor
              sprites[index_floor] = old_sprite = new_sprite
              for index in index_floor + 1 .. index_ceil
                new_floor = floors[index]
                unless old_floor == new_floor
                  new_sprite = get_junction_sprite
                  new_rect_height = old_sprite.height + rem_y - 32 * index
                  horz_divide_sprite(old_sprite, new_sprite, new_floor, new_rect_height)  # 横分割
                  old_floor  = new_floor
                  old_sprite = new_sprite
                end
                sprites[index] = old_sprite
              end
            end
            count += 1
          end
          right_sprites = sprites # 左隣のスプライトの配列を更新
        end
        right_floors = floors # 左隣の階層の配列を更新
      end
    end

    dispose_junction_sprites  # 不要なレイヤー接合スプライトの解放
  end
  #--------------------------------------------------------------------------
  # ● 有効座標判定(x座標) [新規]
  #--------------------------------------------------------------------------
  def valid_x?(x)
    return x >= 0 && x < $game_map.width
  end
  #--------------------------------------------------------------------------
  # ● 有効座標判定(y座標) [新規]
  #--------------------------------------------------------------------------
  def valid_y?(y)
    return y >= 0 && y < $game_map.height
  end
  #--------------------------------------------------------------------------
  # ● 転送元原点を再設定 [新規]
  #--------------------------------------------------------------------------
  def reset_sprite_origin
    self.ox = @cw / 2 # 転送元原点の再設定
    self.oy = @ch     # 転送元原点の再設定
  end
  #--------------------------------------------------------------------------
  # ● スプライトを横分割 [新規]
  #--------------------------------------------------------------------------
  def horz_divide_sprite(old_sprite, new_sprite, new_floor, new_rect_height)
    # ビューポートを設定
    new_sprite.viewport = multi_viewport[new_floor]

    # 転送元の矩形を計算
    new_rect_x      = old_sprite.src_rect.x
    new_rect_y      = old_sprite.src_rect.y
    new_rect_width  = old_sprite.width
    # new_rect_height = new_rect_height
    old_rect_x      = old_sprite.src_rect.x
    old_rect_y      = old_sprite.src_rect.y + new_rect_height
    old_rect_width  = old_sprite.width
    old_rect_height = old_sprite.height - new_rect_height

    # 転送元原点を設定
    new_sprite.ox = old_sprite.ox
    new_sprite.oy = old_sprite.oy
    # old_sprite.ox = old_sprite.ox
    old_sprite.oy = old_sprite.oy - old_sprite.height + old_rect_height

    # その他の同期
    set_junction_sprite(new_sprite, old_sprite)

    # 転送元の矩形を設定
    new_sprite.src_rect.set(new_rect_x, new_rect_y, new_rect_width, new_rect_height)
    old_sprite.src_rect.set(old_rect_x, old_rect_y, old_rect_width, old_rect_height)
    
    # 茂みの同期
    new_sprite.bush_depth = [old_sprite.bush_depth - old_rect_height, 0].max
  end
  #--------------------------------------------------------------------------
  # ● スプライトを縦分割(左側用) [新規]
  #--------------------------------------------------------------------------
  def left_divide_sprite(old_sprite, new_sprite, new_floor, new_rect_width)
    # ビューポートを設定
    new_sprite.viewport = multi_viewport[new_floor]

    # 転送元の矩形を計算
    new_rect_x      = old_sprite.src_rect.x
    new_rect_y      = old_sprite.src_rect.y
    # new_rect_width  = new_rect_width
    new_rect_height = old_sprite.height
    old_rect_x      = old_sprite.src_rect.x + new_rect_width
    old_rect_y      = old_sprite.src_rect.y
    old_rect_width  = old_sprite.width - new_rect_width
    old_rect_height = old_sprite.height

    # 転送元原点を設定
    new_sprite.ox = old_sprite.ox
    new_sprite.oy = old_sprite.oy
    old_sprite.ox = old_sprite.ox - old_sprite.width + old_rect_width
    # old_sprite.oy = old_sprite.oy

    # その他の同期
    set_junction_sprite(new_sprite, old_sprite)

    # 転送元の矩形を設定
    new_sprite.src_rect.set(new_rect_x, new_rect_y, new_rect_width, new_rect_height)
    old_sprite.src_rect.set(old_rect_x, old_rect_y, old_rect_width, old_rect_height)
    
    # 茂みの同期
    new_sprite.bush_depth = old_sprite.bush_depth
  end
  #--------------------------------------------------------------------------
  # ● スプライトを縦分割(右側用) [新規]
  #--------------------------------------------------------------------------
  def right_divide_sprite(old_sprite, new_sprite, new_floor, new_rect_width)
    # ビューポートを設定
    new_sprite.viewport = multi_viewport[new_floor]

    # 転送元の矩形を計算
    old_rect_x      = old_sprite.src_rect.x
    old_rect_y      = old_sprite.src_rect.y
    old_rect_width  = old_sprite.width - new_rect_width
    old_rect_height = old_sprite.height
    new_rect_x      = old_sprite.src_rect.x + old_rect_width
    new_rect_y      = old_sprite.src_rect.y
    # new_rect_width  = new_rect_width
    new_rect_height = old_sprite.height

    # 転送元原点を設定
    new_sprite.ox = old_sprite.ox - old_sprite.width + new_rect_width
    new_sprite.oy = old_sprite.oy
    old_sprite.ox = old_sprite.ox
    # old_sprite.oy = old_sprite.oy

    # その他の同期
    set_junction_sprite(new_sprite, old_sprite)

    # 転送元の矩形を設定
    new_sprite.src_rect.set(new_rect_x, new_rect_y, new_rect_width, new_rect_height)
    old_sprite.src_rect.set(old_rect_x, old_rect_y, old_rect_width, old_rect_height)
    
    # 茂みの同期
    new_sprite.bush_depth = old_sprite.bush_depth
  end
  #--------------------------------------------------------------------------
  # ● レイヤー接合スプライトの同期 [新規]
  #--------------------------------------------------------------------------
  def set_junction_sprite(new_sprite, old_sprite)
    new_sprite.bitmap  = old_sprite.bitmap
    new_sprite.visible = old_sprite.visible
    new_sprite.x = old_sprite.x
    new_sprite.y = old_sprite.y
    new_sprite.z = old_sprite.z
    # new_sprite.zoom_x = old_sprite.zoom_x # 同期は可能だが演算量の増加＆面倒
    # new_sprite.zoom_y = old_sprite.zoom_y # 同期は可能だが演算量の増加＆面倒
    # new_sprite.angle  = old_sprite.angle  # 完全な同期は困難
    # new_sprite.wave_amp    = old_sprite.wave_amp
    # new_sprite.wave_length = old_sprite.wave_length
    # new_sprite.wave_speed  = old_sprite.wave_speed
    # new_sprite.wave_phase  = old_sprite.wave_phase  # 同期は可能だが演算量の増加＆面倒
    # new_sprite.mirror = old_sprite.mirror # 同期は可能だが演算量の増加＆面倒
    new_sprite.bush_opacity = old_sprite.bush_opacity
    new_sprite.opacity    = old_sprite.opacity
    new_sprite.blend_type = old_sprite.blend_type
    new_sprite.color      = old_sprite.color
    new_sprite.tone       = old_sprite.tone
  end
  #--------------------------------------------------------------------------
  # ● レイヤー接合スプライトの取得 [新規]
  #--------------------------------------------------------------------------
  def get_junction_sprite
    @sprites_cash ||= []
    if @sprites_cash_size < @sprites_cash.size
      sprite = @sprites_cash[@sprites_cash_size]
    else
      @sprites_cash.push sprite = Sprite.new
    end
    @sprites_cash_size += 1
    return sprite
  end
  #--------------------------------------------------------------------------
  # ● レイヤー接合スプライトの解放 [新規]
  #--------------------------------------------------------------------------
  def dispose_junction_sprites
    return unless @sprites_cash # レイヤー接合を行っていない
    (@sprites_cash.size - @sprites_cash_size).times { @sprites_cash.pop.dispose }
    if @sprites_cash_size == 0  # 転送元原点の初期化が必要か？
      reset_sprite_origin # 転送元原点の再設定
      @sprites_cash = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● アニメーション用のビューポートを取得 [新規]
  #--------------------------------------------------------------------------
  def get_animation_viewport
    floor = @character.current_floor
    # 現在の階層のビューポートで再生が真、または現在の階層のビューポートが非表示の場合
    return multi_viewport[floor] if $game_map.animation_current_floor || !multi_viewport[floor].visible
    # 通常再生(非表示のビューポートを除いた最上層のビューポートで再生)
    return multi_viewport.reverse.find { |viewport| viewport.visible } || multi_viewport[floor]
  end
  #--------------------------------------------------------------------------
  # ● 一時的にビューポートを変更してブロックを実行 [新規]
  #--------------------------------------------------------------------------
  def temp_viewport
    temp = self.viewport
    self.viewport = get_animation_viewport
    yield # ブロックを実行
    self.viewport = temp
  end
  #--------------------------------------------------------------------------
  # ● フキダシアイコン表示の開始 [追加]
  #--------------------------------------------------------------------------
  alias start_balloon_Multilayer start_balloon
  def start_balloon
    temp_viewport do
      start_balloon_Multilayer
    end
  end
  #--------------------------------------------------------------------------
  # ● アニメーションの開始 [追加]
  #--------------------------------------------------------------------------
  alias start_animation_Multilayer start_animation
  def start_animation(*args)
    temp_viewport do
      start_animation_Multilayer(*args)
    end
  end
  #--------------------------------------------------------------------------
  # ● アニメーションの更新 [追加]
  #--------------------------------------------------------------------------
  alias update_animation_Multilayer update_animation
  def update_animation
    return unless animation?
    temp_viewport do
      update_animation_Multilayer
    end
  end
end

#==============================================================================
# ■ Spriteset_Map
#------------------------------------------------------------------------------
# 　マップ画面のスプライトやタイルマップなどをまとめたクラスです。このクラスは
# Scene_Map クラスの内部で使用されます。
#==============================================================================
class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● マルチレイヤーの生成(更新でも使用) [新規]
  #--------------------------------------------------------------------------
  def create_multilayer
    new_size = $game_map.layer_size
    old_size = @multi_viewport.size
    if old_size > new_size
      (old_size - new_size).times do
        @trash_objects.push @multi_tilemap.pop  # ゴミ箱に移動
        @trash_objects.push @multi_viewport.pop # ゴミ箱に移動
      end
    elsif old_size < new_size
      (new_size - old_size).times do
        @multi_viewport.push viewport = Viewport.new  # 不足しているビューポートを生成
        @multi_tilemap.push Tilemap.new(viewport)     # 不足しているタイルマップを生成
      end
    end
    $game_temp.multi_viewport_accessor = @multi_viewport
  end
  #--------------------------------------------------------------------------
  # ● マルチタイルマップにマップデータをセット [新規]
  #--------------------------------------------------------------------------
  def set_multi_tilemap
    multi_map_data = $game_map.multi_map_data
    multi_map_data.each_index do |index|
      @multi_tilemap[index].map_data = multi_map_data[index].data # マップデータをセット
    end
  end
  #--------------------------------------------------------------------------
  # ● 前景スプライトを格納する配列の作成 [新規]
  #--------------------------------------------------------------------------
  def create_foreground_sprites
    sprite_managers = $game_map.foreground_sprites
    @foreground_sprites = Array.new(sprite_managers.size) do |index|
      sprite_manager = sprite_managers[index]
      next nil unless sprite_manager.bitmap_name
      sprite = Sprite.new(@multi_viewport[index])                 # スプライトを生成
      if !sprite_manager.bitmap_change?
        sprite.bitmap = Cache.picture(sprite_manager.bitmap_name) # ビットマップを設定
      end
      next sprite
    end
  end
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化 [追加]
  #--------------------------------------------------------------------------
  alias initialize_Multilayer initialize
  def initialize
    @multi_viewport = []  # ビューポートを格納する配列
    @multi_tilemap  = []  # タイルマップを格納する配列
    @trash_objects  = []  # ゴミ箱（更新処理の最後で解放処理をして消去）
    create_multilayer
    create_foreground_sprites
    initialize_Multilayer
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの作成 [◆再定義]
  #--------------------------------------------------------------------------
  def create_viewports
    @viewport1 = @multi_viewport[0] # @viewport1 の代替として最下層を割り当てておく
    @viewport2 = Viewport.new
    @viewport3 = Viewport.new
    @viewport2.z = 50
    @viewport3.z = 100
  end
  #--------------------------------------------------------------------------
  # ● タイルマップの作成 [◆再定義]
  #--------------------------------------------------------------------------
  def create_tilemap
    # マルチレイヤーの生成でタイルマップは生成済み
    set_multi_tilemap # マップデータをセットする
    load_tileset      # タイルセットを読み込む
  end
  #--------------------------------------------------------------------------
  # ● タイルセットのロード [◆再定義]
  #--------------------------------------------------------------------------
  def load_tileset
    @multi_tileset = $game_map.multi_tileset.dup  # 後で更新の比較に使用するので参照ではなくコピー
    @multi_tilemap.each_index do |index|
      tileset = $game_map.tileset(index)
      tilemap = @multi_tilemap[index]
      tileset.tileset_names.each_with_index do |name, i|
        tilemap.bitmaps[i] = Cache.tileset(name)
      end
      Calt::BITMAP_CLEAR_TILE.each { |id| clear_tile_rect(tilemap.bitmaps, id) }  # 上層タイルの画像を消去
      tilemap.flags = tileset.flags
    end
  end
  #--------------------------------------------------------------------------
  # ● 上層タイルの画像を消去 [新規]
  #--------------------------------------------------------------------------
  def clear_tile_rect(bitmaps, tile_id)
    return unless tile_id < 1024
    number = tile_id % 256  # タイルの位置
    rect_x = 32 * (number % 8 + number / 128 * 8) # x座標
    rect_y = 32 * (number % 128 / 8)              # y座標
    bitmaps[tile_id / 256 + 5].clear_rect(rect_x, rect_y, 32, 32)
  end
  #--------------------------------------------------------------------------
  # ● キャラクタースプライトの作成 [◆再定義]
  #--------------------------------------------------------------------------
  def create_characters
    @character_sprites = []
    $game_map.events.values.each do |event|
      @character_sprites.push(Sprite_Character.new(nil, event))
    end
    $game_map.vehicles.each do |vehicle|
      @character_sprites.push(Sprite_Character.new(nil, vehicle))
    end
    $game_player.followers.reverse_each do |follower|
      @character_sprites.push(Sprite_Character.new(nil, follower))
    end
    @character_sprites.push(Sprite_Character.new(nil, $game_player))
    @map_group_id = $game_map.map_group_id  # マップのグループのID
  end
  #--------------------------------------------------------------------------
  # ● 飛行船の影スプライトの作成 [追加]
  #--------------------------------------------------------------------------
  alias create_shadow_Multilayer create_shadow
  def create_shadow
    create_shadow_Multilayer
    @shadow_sprite.viewport = @multi_viewport[$game_map.airship.current_floor]
  end
  #--------------------------------------------------------------------------
  # ● 解放 [追加]
  #--------------------------------------------------------------------------
  alias dispose_Multilayer dispose
  def dispose
    dispose_foreground_sprites
    dispose_Multilayer
    dispose_trash_objects
  end
  #--------------------------------------------------------------------------
  # ● 前景スプライトの解放 [新規]
  #--------------------------------------------------------------------------
  def dispose_foreground_sprites
    @foreground_sprites.each { |sprite| sprite.dispose if sprite }
  end
  #--------------------------------------------------------------------------
  # ● タイルマップの解放 [◆再定義]
  #--------------------------------------------------------------------------
  def dispose_tilemap
    @multi_tilemap.each { |tilemap| tilemap.dispose }
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの解放 [◆再定義]
  #--------------------------------------------------------------------------
  def dispose_viewports
    @multi_tilemap.each { |viewport| viewport.dispose }
    @viewport2.dispose
    @viewport3.dispose
  end
  #--------------------------------------------------------------------------
  # ● 不要になったオブジェクトの解放 [新規]
  #--------------------------------------------------------------------------
  def dispose_trash_objects
    return if @trash_objects.empty?
    @trash_objects.each { |object| object.dispose }
    @trash_objects.clear
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 [追加]
  #--------------------------------------------------------------------------
  alias update_Multilayer update
  def update
    update_multilayer     # 場所移動を確認したらレイヤー数の調整を行う。
    update_foreground_sprites
    update_Multilayer
    dispose_trash_objects # レイヤー数の調整で出たゴミを解放
  end
  #--------------------------------------------------------------------------
  # ● マルチレイヤーの更新 [新規]
  #--------------------------------------------------------------------------
  def update_multilayer
    if @map_group_id != $game_map.map_group_id
      create_multilayer
      set_multi_tilemap
    end
  end
  #--------------------------------------------------------------------------
  # ● 前景スプライトの更新 [新規]
  #--------------------------------------------------------------------------
  def update_foreground_sprites
    if @map_group_id != $game_map.map_group_id
      dispose_foreground_sprites
      create_foreground_sprites
    end
    @foreground_sprites.each_index do |index|
      sprite = @foreground_sprites[index]
      sprite_manager = $game_map.foreground_sprites[index]        # スプライトの管理クラス
      if sprite_manager.create_sprite? && !sprite
        sprite = Sprite.new(@multi_viewport[index])               # スプライトを生成
        @foreground_sprites[index] = sprite
      end
      if sprite_manager.dispose_sprite? && sprite
        sprite.dispose                                            # スプライトを解放
        sprite = nil
        @foreground_sprites[index] = sprite
      end
      if sprite_manager.bitmap_change?
        sprite.bitmap = Cache.picture(sprite_manager.bitmap_name) # ビットマップを更新
      end
      sprite_manager.update(sprite)                               # スプライトを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● タイルセットの更新 [◆再定義]
  #--------------------------------------------------------------------------
  def update_tileset
    if @multi_tileset != $game_map.multi_tileset
      load_tileset
      refresh_characters
    end
  end
  #--------------------------------------------------------------------------
  # ● タイルマップの更新 [◆再定義]
  #--------------------------------------------------------------------------
  def update_tilemap
    tilemap_ox = $game_map.display_x * 32
    tilemap_oy = $game_map.display_y * 32
    @multi_tilemap.each_index do |index|
      tilemap = @multi_tilemap[index]
      tilemap.ox = tilemap_ox
      tilemap.oy = tilemap_oy
      tilemap.update
    end
  end
  #--------------------------------------------------------------------------
  # ● キャラクタースプライトの更新 [◆再定義]
  #--------------------------------------------------------------------------
  def update_characters
    refresh_characters if @map_group_id != $game_map.map_group_id
    @character_sprites.each {|sprite| sprite.update }
  end
  #--------------------------------------------------------------------------
  # ● 飛行船の影スプライトの更新 [追加]
  #--------------------------------------------------------------------------
  alias update_shadow_Multilayer update_shadow
  def update_shadow
    @shadow_sprite.viewport = @multi_viewport[$game_map.airship.current_floor]
    update_shadow_Multilayer
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの更新 [◆再定義]
  #--------------------------------------------------------------------------
  NONE_TONE = Tone.new(0, 0, 0, 0)
  def update_viewports
    tone_viewport = @viewport1  # トーンを反映するビューポート
    @multi_viewport.each do |viewport|
      viewport.tone.set(NONE_TONE)
      viewport.ox = $game_map.screen.shake
      viewport.update
      tone_viewport = viewport if viewport.visible
    end
    tone_viewport.tone.set($game_map.screen.tone) # 非表示でない最上層のビューポート
    @viewport2.color.set($game_map.screen.flash_color)
    @viewport3.color.set(0, 0, 0, 255 - $game_map.screen.brightness)
    @viewport2.update
    @viewport3.update
  end
end