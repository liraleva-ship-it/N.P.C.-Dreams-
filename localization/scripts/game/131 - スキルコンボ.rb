=begin
RGSS3 スキルコンボ　2012/04/20　 mo-to

ＴＫＯＯＬ　ＣＯＯＬ
http://mototkool.blog.fc2.com/

★概要★
スキルを繋ぐことができるスキルコンボを作成できる。

★使用法★
スクリプトの▼ 素材　以下  ▼ メイン　以上にこれをコピーして張り付ける。
スキルのメモ欄に <スキルコンボ n:m%> n=スキルID:m=発動確率1～100％と記述する。

例１）通常スキルコンボ
デフォスキル『ファイア』のメモ欄に <スキルコンボ 55:50%> と記述すると
ファイアを使った際、デフォでは50％の確率で『アイス』が発動される。

例２) トリプルスキルコンボ
デフォスキル『ファイア』のメモ欄に <スキルコンボ 55:100%>と記述し
デフォスキルＩＤ55番『アイス』のメモ欄に <スキルコンボ 59:100%>と記述すると
ファイアを使った際アイス→サンダーと繋がるトリプルコンボになる。
例以外にも設定次第で四連、五連…にでも繋ぐことが可能。

例３) セルフコンボ
デフォスキル『ファイア』のメモ欄に <スキルコンボ 51:50%> と記述すると
確率に当選する限りファイアが発動し続ける。
確率を100％にすると対象が戦闘不能になるまで発動し続けるので要注意。

★注意・仕様★
一部再定義(Scene_Battle#invoke_item)を使っているので上部に挿入推薦。
同一スキルのメモ欄には一種類の設定のみ有効。二列以上記述した場合は
後の記述が有効となる。

・スキルコンボは戦闘中のみ有効
・スキルコンボは発動してもトリガースキル以外は消費コストが掛からない。
・スキルコンボが発動してもスキル名はトリガースキルの名称が表示される。
・スキルが回避されるか反射されるとコンボは途切れる。
・コンボ内にコモンイベントをいくつ組み込んでもひとつしか発動しない。
・トリガースキルを全体化すると一体ずつにコンボが発動する。
　なので全体スキル→全体スキルとコンボを繋げると大変なことになる(笑)

★その他★
おまけとして、コンボ数表示ウィンドウを実装しています。
スキルコンボが繋がるとヒット数が上がっていきます。
飽くまで、おまけなので特別な機能(コンボボーナス等)はありません。
ヒット数を見てニヤニヤするくらいです(笑)
ただ、ヒットの最大数をゲーム変数へ代入する機能がありますので
それを使って、イベントなどを組むといろいろ出来るかも知れません。
また、この機能が必要ないならカスタマイズでオフにすることも可能です。

=end

#↓カスタマイズ
module MOTO
  
  #単体スキルで対象が戦闘不能に陥ってもコンボを繋げるか？
  DEAD_COMBO_SKILL = false
  
  #対象に与えたダメージが0でもコンボを繋げるか？
  NO_DAMAGE_COMBO_SKILL = true
  
  #コンボウィンドウを表示するか？
  COMBO_SKIL_WINDOW = false
    #表示するなら以下をカスタマイズ
    #コンボ名とその単位名
    COMBO_NAME1 = "Combo"
    COMBO_NAME2 = "Hits!"
    #コンボウィンドウのX座標とY座標
    COMBO_SKIL_WINDOW_X = 0
    COMBO_SKIL_WINDOW_Y = 248
    #コンボの最大ヒット数を保存するゲーム変数ＩＤ
    MAX_COMBO_VARIABLES = 293
    
end
#ここまで

module RPG
  class Skill < UsableItem
  #--------------------------------------------------------------------------
  # ☆ キャッシュの作成とメモ欄からスキルIDを取得
  #-------------------------------------------------------------------------- 
    def add_combo_skills_set
      @add_combo_skills = []
      self.note.each_line { |line|
      case line
      when /<スキルコンボ\s*(\d+):\s*(\d+)([%％])?>/
        skill_id = $1.to_i
        rate = $2.to_i
        if @add_combo_skills[skill_id] == nil
          @add_combo_skills[skill_id] = 0
        end
        @add_combo_skills[skill_id] = rate
      end
      }
    end
    def add_combo_skills
      add_combo_skills_set if @add_combo_skills == nil
      return @add_combo_skills
    end
  end
end

#==============================================================================
# ■ Game_System
#------------------------------------------------------------------------------
# 　システム周りのデータを扱うクラスです。セーブやメニューの禁止状態などを保存
# します。このクラスのインスタンスは $game_system で参照されます。
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :combo_count
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  alias ori_moto_combo_skills_initialize initialize
  def initialize
    ori_moto_combo_skills_initialize
    
    @combo_count = 0
  end
end

#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# 　スプライトや行動に関するメソッドを追加したバトラーのクラスです。このクラス
# は Game_Actor クラスと Game_Enemy クラスのスーパークラスとして使用されます。
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :add_combo_skills_id
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  alias ori_moto_combo_skills_initialize initialize
  def initialize
    ori_moto_combo_skills_initialize
    
    @add_combo_skills_id = nil
  end
  #--------------------------------------------------------------------------
  # ☆ スキル／アイテムの使用
  #    行動側に対して呼び出され、使用対象以外に対する効果を適用する。
  #    (コモンイベント)
  #--------------------------------------------------------------------------
  def use_item_common_event(item)
    item.effects.each {|effect| item_global_effect_apply(effect) }
  end  
  #--------------------------------------------------------------------------
  # ○ スキル／アイテムの効果適用
  #--------------------------------------------------------------------------
  alias ori_moto_combo_skills_item_apply item_apply
  def item_apply(user, item)
    ori_moto_combo_skills_item_apply(user, item)
    
    add_combo_skills_flag(user, item) if item.is_a?(RPG::Skill)
  end
  #--------------------------------------------------------------------------
  # ☆ 発動確率と追加スキルIDの取得フラグ
  #--------------------------------------------------------------------------  
  def add_combo_skills_flag(user, item)
    @add_combo_skills_id = nil
    (0...item.add_combo_skills.size).each do |skill_id|
      if item.add_combo_skills[skill_id] != nil &&
        item.add_combo_skills[skill_id] >= rand(100) + 1
        @add_combo_skills_id = skill_id
      end
    end
    return @add_combo_skills_id != nil ? true : false
  end
end

class Window_Combo < Window_Base
  #--------------------------------------------------------------------------
  # ☆ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, fitting_height(1))
    $game_system.combo_count = 0
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ☆ ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return 160
  end
  #--------------------------------------------------------------------------
  # ☆ リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(system_color)
    draw_text(0, 0, 100, 32, MOTO::COMBO_NAME1)
    change_color(normal_color)
    draw_text(70, 0, 50, 32, $game_system.combo_count)
    change_color(system_color)
    draw_text(90, 0, 100, 32, MOTO::COMBO_NAME2)
  end
end

#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ○ 全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias ori_moto_combo_skills_create_all_windows create_all_windows
  def create_all_windows
    ori_moto_combo_skills_create_all_windows
    
    create_combo_window
  end
  #--------------------------------------------------------------------------
  # ○ 終了処理
  #--------------------------------------------------------------------------
  alias ori_moto_combo_skills_terminate terminate
  def terminate
    ori_moto_combo_skills_terminate
    @combo_window.dispose
    $game_system.combo_count = 0
  end
  #--------------------------------------------------------------------------
  # ☆ コンボウィンドウの作成
  #--------------------------------------------------------------------------
  def create_combo_window
    @combo_window = Window_Combo.new
    @combo_window.x = MOTO::COMBO_SKIL_WINDOW_X
    @combo_window.y = MOTO::COMBO_SKIL_WINDOW_Y
    @combo_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの発動　※再定義
  #--------------------------------------------------------------------------
  def invoke_item(target, item)
    if rand < target.item_cnt(@subject, item)
      invoke_counter_attack(target, item)
    elsif rand < target.item_mrf(@subject, item)
      invoke_magic_reflection(target, item)
    else
      apply_item_effects(apply_substitute(target, item), item)
      return if $game_troop.all_dead? || $game_party.all_dead? || @subject.current_action == nil
      unless MOTO::DEAD_COMBO_SKILL
        return if target.dead? 
      end
      if combo_check?(target) && item.is_a?(RPG::Skill)
        if !@subject.confusion? && @subject.add_combo_skills_flag(@subject, item)
          @subject.current_action.set_skill(@subject.add_combo_skills_id)
          @combo_window.show.refresh if MOTO::COMBO_SKIL_WINDOW
          add_combo_skills_action
        end 
      end
    end
    @combo_window.hide
    if MOTO::COMBO_SKIL_WINDOW
      if $game_system.combo_count > $game_variables[MOTO::MAX_COMBO_VARIABLES]
        $game_variables[MOTO::MAX_COMBO_VARIABLES] = $game_system.combo_count
      end
    end
    $game_system.combo_count = 0
    @combo_window.refresh
    @subject.last_target_index = target.index
  end
  #--------------------------------------------------------------------------
  # ☆ 追加スキル発動
  #--------------------------------------------------------------------------
  def add_combo_skills_action
    item = @subject.current_action.item
    targets = @subject.current_action.make_targets.compact
    @subject.use_item_common_event(item)
    show_animation(targets, item.animation_id)
    $game_system.combo_count += 1
    @combo_window.refresh    
    targets.each{ |target|
    invoke_item(target, item)
    }
  end
  #--------------------------------------------------------------------------
  # ☆ コンボチェック
  #--------------------------------------------------------------------------
  def combo_check?(target)
    unless MOTO::NO_DAMAGE_COMBO_SKILL
      target.result.hit? && (target.result.hp_damage > 0 || target.result.mp_damage > 0 ||
      target.result.tp_damage > 0 || target.result.hp_drain > 0 || target.result.mp_drain > 0)
    else
      target.result.hit?
    end
  end
end