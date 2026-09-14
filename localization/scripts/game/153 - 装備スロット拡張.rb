#==============================================================================
# □ 装備スロット拡張 (for VX Ace)
#------------------------------------------------------------------------------
# Version : 2_20121217
# by サリサ・タイクーン
# http://www.tycoon812.com/rgss/
#==============================================================================

#==============================================================================
# □ 素材スイッチ
#==============================================================================
$rgsslab = {} if $rgsslab == nil
$rgsslab["装備スロット拡張"] = true

if $rgsslab["装備スロット拡張"]

#==============================================================================
# □ カスタマイズポイント
#==============================================================================
module RGSSLAB end
module RGSSLAB::Equipment_Slots_Extension
  #--------------------------------------------------------------------------
  # ○ 新しく追加する装備部位名
  #    新しい部位の設定を行います。
  #--------------------------------------------------------------------------
  APPEND_ARMOR_PART = [
   "耳", # 部位番号5 : 耳
   "足", # 部位番号6 : 足
   "腕", # 部位番号7 : 腕
  ]
  #--------------------------------------------------------------------------
  # ○ 装備部位の文字列設定
  #    防具のメモ欄において、記述する文字列を指定します。
  #
  #    メモ欄に、[ + ARMOR_PART_NOTEの値 + 部位番号 +] と記述して
  #    装備部位を変更します。
  #    （部位以外の設定は、そのまま引き継がれます）
  #
  #    例：
  #    ARMOR_PART_NOTEの値が"部位番号："で、部位番号が5の場合
  #    [部位番号：5] と記述します。
  #--------------------------------------------------------------------------
  ARMOR_PART_NOTE = "部位番号："
  #--------------------------------------------------------------------------
  # ○ モードの指定
  #    "アクター"か"職業"のどちらかを記述します。
  #    （それ以外は、全て"アクター"と同じ扱いとなります）
  #
  #    EQUIP_SLOTS_ARRAYの設定において、影響を受けます。
  #
  #    ゲーム中に途中で切り替える機能はありませんので
  #    ご注意下さい。
  #--------------------------------------------------------------------------
  MODE = "アクター"
  #--------------------------------------------------------------------------
  # ○ 装備スロットの配列設定
  #    アクター（職業）毎にスロットを指定します。
  #    （MODEの値によって、異なります）
  #
  #    ・記述方法
  #     アクターID（職業のID） => [２番目のスロット, …],
  #    （最後の設定のみ、後ろのカンマを省略する事ができます）
  #
  #    この設定で、武器のスロット（0の事）を指定してしまうと
  #    不具合が生じますので、絶対に0を指定しないで下さい。
  #
  #    又、二刀流が有効の場合は
  #    0番目の配列が武器へ自動的に切り替わります。
  #    （色んな都合上、あえてそういう風にしてあります）
  #
  #    どのように設定しても、武器は必ず１番目になります。
  #    （二刀流の武器は強制的に２番目になります）
  #
  #    尚、スロットの標準は[1, 2, 3, 4],となっていますが
  #    スロット番号は重複させる事が可能です。
  #
  #    スロット配列の最初の添字だけは特殊ですので、できる限り
  #    最初の添字は、盾（スロット番号：1）にした方が良いです。
  #    （両手持ちや二刀流等の影響をそのまま受ける為）
  #
  #    ・スロット番号について
  #    1     : 盾
  #    2     : 頭
  #    3     : 身体
  #    4     : 装飾品
  #    5以降 : この素材で定義した部位番号に対応
  #
  #    上記以外のスロット番号は指定しないで下さい。
  #--------------------------------------------------------------------------
  EQUIP_SLOTS_ARRAY = {
   1 => [1, 2, 3, 4, 4, 4, 4],
  }
  #--------------------------------------------------------------------------
  # ○ 初期装備の設定
  #    EQUIP_SLOTS_ARRAYの関係上、データベースでの設定とは
  #    合致しない場合もある上に、追加した部分まで反映はされません。
  #
  #    そこで、この素材による設定で初期装備を行いたいアクターのみ
  #    INITIALIZE_EQUIPに設定する事で、解決させます。
  #    （記述されていないアクターは、データベースの初期装備が行われます）
  #
  #    ・記述方法
  #     アクターID => [値, …],
  #    （最後の設定のみ、後ろのカンマを省略する事ができます）
  #
  #    値は、防具のIDを記述しますが、装備部位と合致させる必要がありますので
  #    必ずご確認下さい。
  #
  #    二刀流の場合は、最初の添字のみ二刀流の武器へ自動的に切り替わります。
  #    （どんな値であっても、最初の添字だけ無視されます）
  #--------------------------------------------------------------------------
  INITIALIZE_EQUIP = {
   #1 => [46, 0, 1, 51, 61],
  }
  #--------------------------------------------------------------------------
  # ○ 装備固定の設定：アクター
  #    ・記述方法
  #    アクターID => [スロット番号0の固定フラグ, …],
  #
  #    固定フラグは、true（固定させる）とfalse（固定させない）となります。
  #--------------------------------------------------------------------------
  ACTOR_FIXED_SETTING = {
   1 => [false, false, false, false, false, false, false, false],
  }
  #--------------------------------------------------------------------------
  # ○ 装備固定の設定：職業
  #    ・記述方法
  #    職業ID => [スロット番号0の固定フラグ, …],
  #
  #    固定フラグは、true（固定させる）とfalse（固定させない）となります。
  #--------------------------------------------------------------------------
  CLASS_FIXED_SETTING = {
   1 => [false, false, false, false, false, false, false, false],
  }
  #--------------------------------------------------------------------------
  # ○ 装備固定の設定：武器
  #    ・記述方法
  #    武器ID => [スロット番号0の固定フラグ, …],
  #
  #    固定フラグは、true（固定させる）とfalse（固定させない）となります。
  #--------------------------------------------------------------------------
  WEAPON_FIXED_SETTING = {
   1 => [false, false, false, false, false, false, false, false],
  }
  #--------------------------------------------------------------------------
  # ○ 装備固定の設定：防具
  #    ・記述方法
  #    防具ID => [スロット番号0の固定フラグ, …],
  #
  #    固定フラグは、true（固定させる）とfalse（固定させない）となります。
  #--------------------------------------------------------------------------
  ARMOR_FIXED_SETTING = {
   1 => [false, false, false, false, false, false, false, false],
  }
  #--------------------------------------------------------------------------
  # ○ 装備封印の設定：アクター
  #    ・記述方法
  #    アクターID => [スロット番号0の封印フラグ, …],
  #
  #    封印フラグは、true（封印させる）とfalse（封印させない）となります。
  #--------------------------------------------------------------------------
  ACTOR_SEALED_SETTING = {
   1 => [false, false, false, false, false, false, false, false],
  }
  #--------------------------------------------------------------------------
  # ○ 装備封印の設定：職業
  #    ・記述方法
  #    職業ID => [スロット番号0の封印フラグ, …],
  #
  #    封印フラグは、true（封印させる）とfalse（封印させない）となります。
  #--------------------------------------------------------------------------
  CLASS_SEALED_SETTING = {
   1 => [false, false, false, false, false, false, false, false],
  }
  #--------------------------------------------------------------------------
  # ○ 装備封印の設定：武器
  #    ・記述方法
  #    武器ID => [スロット番号0の封印フラグ, …],
  #
  #    封印フラグは、true（封印させる）とfalse（封印させない）となります。
  #--------------------------------------------------------------------------
  WEAPON_SEALED_SETTING = {
   1 => [false, false, false, false, false, false, false, false],
  }
  #--------------------------------------------------------------------------
  # ○ 装備封印の設定：防具
  #    ・記述方法
  #    防具ID => [スロット番号0の封印フラグ, …],
  #
  #    封印フラグは、true（封印させる）とfalse（封印させない）となります。
  #--------------------------------------------------------------------------
  ARMOR_SEALED_SETTING = {
   1 => [false, false, false, false, false, false, false, false],
  }
end

# カスタマイズポイントは、ここまで

#==============================================================================
# □ RGSSLAB::Equipment_Slots_Extension [module]
#==============================================================================
module RGSSLAB::Equipment_Slots_Extension
  #--------------------------------------------------------------------------
  # ○ 素材設定用の定数定義
  #--------------------------------------------------------------------------
  MATERIAL_NAME = "装備スロット拡張"
  VERSION       = 2
  RELEASE       = 20121217
end

#==============================================================================
# ■ DataManager [module]
#==============================================================================
module DataManager
  #--------------------------------------------------------------------------
  # ○ モジュールの設定
  #--------------------------------------------------------------------------
  RGSSLAB_039 = RGSSLAB::Equipment_Slots_Extension
  #--------------------------------------------------------------------------
  # ● データベースのロード [再定義]
  #--------------------------------------------------------------------------
  def self.load_database
    if $BTEST
      load_battle_test_database
    else
      load_normal_database
      check_player_location
    end
    self.armor_setting
  end
  #--------------------------------------------------------------------------
  # ○ 装備部位の変更
  #--------------------------------------------------------------------------
  def self.armor_setting
    for i in 1...$data_armors.size
      if $data_armors[i].note[/\[#{RGSSLAB_039::ARMOR_PART_NOTE}(\d+)\]/]
        $data_armors[i].etype_id = $data_armors[i].note[/\[#{RGSSLAB_039::ARMOR_PART_NOTE}(\d+)\]/].scan(/[0-9]+/)[0][0].to_i
      end
    end
  end
end

#==============================================================================
# ■ Game_Actor [class]
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ○ モジュールの設定
  #--------------------------------------------------------------------------
  RGSSLAB_039 = RGSSLAB::Equipment_Slots_Extension
  #--------------------------------------------------------------------------
  # ● 装備品の初期化 [再定義]
  #     equips : 初期装備の配列
  #--------------------------------------------------------------------------
  def init_equips(equips)
    if RGSSLAB_039::INITIALIZE_EQUIP[@actor_id] != nil
      equips = []
      equips[0] = actor.equips[0]
      equips += RGSSLAB_039::INITIALIZE_EQUIP[@actor_id].dup
      equips[1] = actor.equips[1] if dual_wield?
    end
    if RGSSLAB_039::ACTOR_SEALED_SETTING[@actor_id]
      for equip_id in 0...equip_slots.size
        if RGSSLAB_039::ACTOR_SEALED_SETTING[@actor_id][equip_id]
          equips[equip_id] = 0
        end
      end
    end
    if RGSSLAB_039::CLASS_SEALED_SETTING[@class_id]
      for equip_id in 0...equip_slots.size
        if RGSSLAB_039::CLASS_SEALED_SETTING[@class_id][equip_id]
          equips[equip_id] = 0
        end
      end
    end
    e = 0
    for equip in equips
      if equip_slots[e] < 1
        if RGSSLAB_039::WEAPON_SEALED_SETTING[equip]
          for equip_id in 0...equip_slots.size
            if RGSSLAB_039::WEAPON_SEALED_SETTING[equip][equip_id]
              equips[equip_id] = 0
            end
          end
        end
      else
        if RGSSLAB_039::ARMOR_SEALED_SETTING[equip]
          for equip_id in 0...equip_slots.size
            if RGSSLAB_039::ARMOR_SEALED_SETTING[equip][equip_id]
              equips[equip_id] = 0
            end
          end
        end
      end
      e += 1
    end
    @equips = Array.new(equip_slots.size) { Game_BaseItem.new }
    equips.each_with_index do |item_id, i|
      etype_id = index_to_etype_id(i)
      slot_id = empty_slot(etype_id)
      @equips[slot_id].set_equip(etype_id == 0, item_id) if slot_id
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 装備スロットの配列を取得 [再定義]
  #--------------------------------------------------------------------------
  def equip_slots
    use_type = RGSSLAB_039::MODE == "職業" ? @class_id : @actor_id
    if RGSSLAB_039::EQUIP_SLOTS_ARRAY[use_type] == nil
      return [0,0,2,3,4] if dual_wield?
      return [0,1,2,3,4]
    end
    slots_array = [0]
    slots_array += RGSSLAB_039::EQUIP_SLOTS_ARRAY[use_type].dup
    slots_array[1] = 0 if dual_wield?
    return slots_array
  end
  #--------------------------------------------------------------------------
  # ● 装備変更の可能判定 [再定義]
  #     slot_id : 装備スロット ID
  #--------------------------------------------------------------------------
  def equip_change_ok?(slot_id)
    return false if equip_type_fixed?(equip_slots[slot_id])
    return false if equip_type_fixed_rgsslab039(equip_slots[slot_id])  if $rgsslab["装備スロット拡張"]
    return false if equip_type_sealed?(equip_slots[slot_id])
    return false if equip_type_sealed_rgsslab039(equip_slots[slot_id]) if $rgsslab["装備スロット拡張"]
    return true
  end
  #--------------------------------------------------------------------------
  # ○ 装備固定の判定
  #     slot_id : 装備スロット ID
  #--------------------------------------------------------------------------
  def equip_type_fixed_rgsslab039(slot_id)
    if RGSSLAB_039::ACTOR_FIXED_SETTING[@actor_id]
      if RGSSLAB_039::ACTOR_FIXED_SETTING[@actor_id][slot_id]
        return RGSSLAB_039::ACTOR_FIXED_SETTING[@actor_id][slot_id]
      end
    end
    if RGSSLAB_039::CLASS_FIXED_SETTING[@class_id]
      if RGSSLAB_039::CLASS_FIXED_SETTING[@class_id][slot_id]
        return RGSSLAB_039::CLASS_FIXED_SETTING[@class_id][slot_id]
      end
    end
    for weapon in weapons
      if RGSSLAB_039::WEAPON_FIXED_SETTING[weapon.id]
        if RGSSLAB_039::WEAPON_FIXED_SETTING[weapon.id][slot_id]
          return RGSSLAB_039::WEAPON_FIXED_SETTING[weapon.id][slot_id]
        end
      end
    end
    for armor in armors
      if RGSSLAB_039::ARMOR_FIXED_SETTING[armor.id]
        if RGSSLAB_039::ARMOR_FIXED_SETTING[armor.id][slot_id]
          return RGSSLAB_039::ARMOR_FIXED_SETTING[armor.id][slot_id]
        end
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ○ 装備封印の判定
  #     slot_id : 装備スロット ID
  #--------------------------------------------------------------------------
  def equip_type_sealed_rgsslab039(slot_id)
    if RGSSLAB_039::ACTOR_SEALED_SETTING[@actor_id]
      if RGSSLAB_039::ACTOR_SEALED_SETTING[@actor_id][slot_id]
        change_equip(slot_id, nil)
        return RGSSLAB_039::ACTOR_SEALED_SETTING[@actor_id][slot_id]
      end
    end
    if RGSSLAB_039::CLASS_SEALED_SETTING[@class_id]
      if RGSSLAB_039::CLASS_SEALED_SETTING[@class_id][slot_id]
        change_equip(slot_id, nil)
        return RGSSLAB_039::CLASS_SEALED_SETTING[@class_id][slot_id]
      end
    end
    for weapon in weapons
      if RGSSLAB_039::WEAPON_SEALED_SETTING[weapon.id]
        if RGSSLAB_039::WEAPON_SEALED_SETTING[weapon.id][slot_id]
          change_equip(slot_id, nil)
          return RGSSLAB_039::WEAPON_SEALED_SETTING[weapon.id][slot_id]
        end
      end
    end
    for armor in armors
      if RGSSLAB_039::ARMOR_SEALED_SETTING[armor.id]
        if RGSSLAB_039::ARMOR_SEALED_SETTING[armor.id][slot_id]
          change_equip(slot_id, nil)
          return RGSSLAB_039::ARMOR_SEALED_SETTING[armor.id][slot_id]
        end
      end
    end
    return false
  end
end

#==============================================================================
# ■ Window_EquipSlot [class]
#==============================================================================
class Window_EquipSlot < Window_Selectable
  #--------------------------------------------------------------------------
  # ○ モジュールの設定
  #--------------------------------------------------------------------------
  RGSSLAB_039 = RGSSLAB::Equipment_Slots_Extension
  #--------------------------------------------------------------------------
  # ○ ウィンドウ内容の作成 [オーバーライド]
  #--------------------------------------------------------------------------
  def create_contents
    contents.dispose
    if contents_width > 0 && contents_height > 0
      self.contents = Bitmap.new(contents_width, standard_padding * 2 * get_contents_height)
    else
      self.contents = Bitmap.new(1, 1)
    end
    contents.font.name = $game_system.rgsslab144.window if $rgsslab["フォントセッティング"]
  end
  #--------------------------------------------------------------------------
  # ○ 高さの取得
  #--------------------------------------------------------------------------
  def get_contents_height
    return 5 if @actor == nil
    use_type = RGSSLAB_039::MODE == "職業" ? @actor.class_id : @actor.id
    return 5 if RGSSLAB_039::EQUIP_SLOTS_ARRAY[use_type] == nil
    return RGSSLAB_039::EQUIP_SLOTS_ARRAY[use_type].size + 1
  end
  #--------------------------------------------------------------------------
  # ● 装備スロットの名前を取得 [再定義]
  #     index : 装備部位番号
  #--------------------------------------------------------------------------
  def slot_name(index)
    array = []
    for i in 0..4
      array.push($data_system.terms.etypes[i])
    end
    for i in 0...RGSSLAB_039::APPEND_ARMOR_PART.size
      array.push(RGSSLAB_039::APPEND_ARMOR_PART[i])
    end
    return @actor ? array[@actor.equip_slots[index]] : ""
  end
end

#==============================================================================
# ■ Scene_Equip [class]
#==============================================================================
class Scene_Equip < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● スロットウィンドウの作成 [再定義]
  #--------------------------------------------------------------------------
  def create_slot_window
    wx = @status_window.width
    wy = @command_window.y + @command_window.height
    ww = Graphics.width - @status_window.width
    @slot_window = Window_EquipSlot.new(wx, wy, ww)
    @slot_window.viewport = @viewport
    @slot_window.help_window = @help_window
    @slot_window.status_window = @status_window
    @slot_window.actor = @actor
    @slot_window.create_contents
    @slot_window.refresh
    @slot_window.set_handler(:ok,       method(:on_slot_ok))
    @slot_window.set_handler(:cancel,   method(:on_slot_cancel))
  end
  #--------------------------------------------------------------------------
  # ● アクターの切り替え [再定義]
  #--------------------------------------------------------------------------
  def on_actor_change
    @status_window.actor = @actor
    @slot_window.actor = @actor
    @slot_window.create_contents
    @slot_window.refresh
    @item_window.actor = @actor
    @command_window.activate
  end
end

end