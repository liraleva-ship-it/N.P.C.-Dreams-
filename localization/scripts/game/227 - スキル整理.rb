#==============================================================================
# ■ RGSS3 スキル整理 Ver1.10　by 星潟
#------------------------------------------------------------------------------
# 非戦闘中のスキル画面でスキルにカーソルを合わせた状態で特定のキーを押す事で
# 該当するスキルをスキルウィンドウから消去します。
# また、戦闘中にそのスキルを表示・使用することができなくなります。
#
# 消去中のスキルウィンドウは新たに追加されている
# 「整理済」のスキルタイプから確認する事が出来ます
# また、「整理済」のスキルウィンドウで、スキルにカーソルを合わせた状態で
# 特定のキーを押す事で、そのスキルを元のスキルタイプウィンドウに復帰させます。
#
# 当方の「スキルタイプ選択コマンド消去スクリプト」導入時は
# 本スクリプトは正常に機能しません。
#==============================================================================
# スキルのメモ欄に指定
#------------------------------------------------------------------------------
# <整理禁止スキル>
# 
# このスキルはスキル整理の対象にならない。
#==============================================================================
# アクター・職業のメモ欄に指定
#------------------------------------------------------------------------------
# <整理禁止>
# 
# このアクターもしくはこの職業の者はスキル整理機能を使用できない。
#==============================================================================
module AB_SSS2
  
  #スキル整理時のキー
  #デフォルトでは:Aとしてありますが
  #これはキーボード上のAではなく内部のコマンド処理上のA、です。
  #ゲームパッド設定時に出てくるものですね。
  #
  #キーボード上でのキーはSHIFTキーとなります。
  
  KEY   = :A
  
  #忘れたスキルが装備等でも追加されていない場合（完全に消滅している場合）
  #整理済み状態から自動的に除外するかを指定。
  
  FS    = true
  
  #整理中スキルの一覧を表示するスキルタイプの名前を決定します。
  
  Name  = "Removed"
  
  #整理禁止スキルの設定用キーワードを指定します。
  
  Word1 = "整理禁止スキル"
  
  #整理禁止の設定用キーワードを指定します。
  
  Word2 = "整理禁止"
  
  #便宜上、整理済の項目の為のスキルタイプIDを指定します。
  
  STI   = 10001
  
  #指定したスキルタイプを整理済み禁止にします。
  #例.SSTI = [2,10000]
  #この場合、スキルタイプIDが2か10000の場合は
  #整理機能が働かなくなります。
  
  SSTI  = []
  
end
class Window_SkillCommand < Window_Command
  #--------------------------------------------------------------------------
  # コマンドリストの作成
  #--------------------------------------------------------------------------
  alias make_command_list_skill_seal2 make_command_list
  def make_command_list
    make_command_list_skill_seal2
    add_command(AB_SSS2::Name, :skill, true, AB_SSS2::STI)
  end
end
class Window_SkillList < Window_Selectable
  #--------------------------------------------------------------------------
  # 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader :actor                     # アクター
  #--------------------------------------------------------------------------
  # スキルをリストに含めるかどうか
  #--------------------------------------------------------------------------
  alias include_skill_seal2? include?
  def include?(item)
    if !@actor.skill_seal.include?(item.id)
      return include_skill_seal2?(item)
    elsif @stype_id == AB_SSS2::STI
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # 決定やキャンセルなどのハンドリング処理
  #--------------------------------------------------------------------------
  unless method_defined?(:process_handling_skill_seal2)
  alias process_handling_skill_seal2 process_handling
  def process_handling
    process_handling_skill_seal2
    return if AB_SSS2::SSTI.include?(@stype_id)
    return unless open? && active
    return call_handler(:sh_pss2) if ok_enabled? && Input.trigger?(AB_SSS2::KEY)
  end
  end
end
class Scene_Skill < Scene_ItemBase
  #--------------------------------------------------------------------------
  # アイテムウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_item_window_skill_seal2 create_item_window
  def create_item_window
    create_item_window_skill_seal2
    @item_window.set_handler(:sh_pss2, method(:pss2))
  end
  #--------------------------------------------------------------------------
  # スキル整理
  #--------------------------------------------------------------------------
  def pss2
    return if item == nil
    return Sound.play_buzzer if item.seal_seal?
    s_id = item.id
    if @actor.skill_seal.include?(s_id)
      Sound.play_ok
      @actor.skill_seal.delete(s_id)
    else
      if @actor.seal_seal? or item.seal_seal?
        Sound.play_buzzer
      else
        Sound.play_ok
        @actor.skill_seal.push(s_id)
      end
    end
    @item_window.refresh
    @item_window.index -= 1 if item == nil
    @item_window.index = 0 if @item_window.index < 0
    @help_window.set_item(item)
    @help_window.refresh
  end
end
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :skill_seal
  #--------------------------------------------------------------------------
  # セットアップ
  #--------------------------------------------------------------------------
  alias setup_skill_seal2 setup
  def setup(actor_id)
    setup_skill_seal2(actor_id)
    @skill_seal = []
  end
  #--------------------------------------------------------------------------
  # スキル封印の配列を取得
  #--------------------------------------------------------------------------
  def skill_seal
    @skill_seal ||= []
    if @skill_seal_version_id != $data_system.version_id
      neo_array = []
      unless seal_seal?
        @skill_seal.each {|sid|
        neo_array.push(sid) if $data_skills[sid] && !$data_skills[sid].seal_seal?}
      end
      @skill_seal_version_id = $data_system.version_id.to_i
      @skill_seal = neo_array
    end
    @skill_seal
  end
  #--------------------------------------------------------------------------
  # スキルを忘れる
  #--------------------------------------------------------------------------
  alias forget_skill_skill_seal2 forget_skill
  def forget_skill(skill_id)
    forget_skill_skill_seal2(skill_id)
    skill_seal.delete(skill_id) if AB_SSS2::FS && !skills.include?($data_skills[skill_id])
  end
  #--------------------------------------------------------------------------
  # 職業の変更
  #--------------------------------------------------------------------------
  alias change_class_skill_seal2 change_class
  def change_class(class_id, keep_exp = false)
    change_class_skill_seal2(class_id, keep_exp)
    @skill_seal = [] if seal_seal?
  end
  #--------------------------------------------------------------------------
  # スキル整理の禁止フラグ
  #--------------------------------------------------------------------------
  def seal_seal?
    actor.seal_seal? or self.class.seal_seal?
  end
end
class Game_Action
  #--------------------------------------------------------------------------
  # 行動の価値評価（自動戦闘用）
  #--------------------------------------------------------------------------
  alias evaluate_skill_seal2 evaluate
  def evaluate
    if @subject.actor? && !@subject.skill_seal.empty? &&
      @subject.skill_seal.include?(item.id)
      @value = 0
      return self
    end
    evaluate_skill_seal2
  end
end
class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  # スキル整理の禁止フラグ
  #--------------------------------------------------------------------------
  def seal_seal?
    (@seal_seal ||= /<#{AB_SSS2::Word1}>/ =~ note ? 1 : 0) == 1
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # スキル整理の禁止フラグ
  #--------------------------------------------------------------------------
  def seal_seal?
    (@seal_seal ||= /<#{AB_SSS2::Word2}>/ =~ note ? 1 : 0) == 1
  end
end