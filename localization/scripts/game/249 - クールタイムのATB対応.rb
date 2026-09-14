#==============================================================================
# ■ クールタイムのATB対応 by gentlawk via ココナラ ver1.00
#==============================================================================
#------------------------------------------------------------------------------
# ■内容
# C Winter様「ATBスクリプト」およびレーネ様「スキルクールタイムスクリプト」を
# 併用した場合のスキルクールタイムの減少タイミングをATB向けに最適化します。
#
# ■位置
# C Winter様「ATBスクリプト」
# レーネ様「スキルクールタイムスクリプト」
# より下
#
# ■使用方法
# 詳細設定欄にて以下の項目を設定してください。
# ○SELF_COOL_TIME_LABEL
# 　セルフクールタイム中のスキルに表示するクールタイムの文字列です。
# ○SELF_COOL_TIME_COLOR
# 　セフルクールタイム中のスキルに表示するクールタイムの色です。
#
# □クールタイムとセルフクールタイム
# レーネ様「スキルクールタイムスクリプト」のデフォルトクールタイムを
# 　”クールタイム”
# と呼びます。
# これは本スクリプト未導入時のバトラーが行動するたびに減少するクールタイムです。
# こちらのクールタイムを適用する場合はスキルのメモ欄に以下を記述します。
# 　<クールタイム:N>
# ※Nはクールタイム数
# 「スキルクールタイムスクリプト」と同じフォーマットです。
# 
# 本スクリプトで導入されるクールタイムを
# 　”セルフクールタイム”
# と呼びます。
# これはクールタイム中スキルを持つバトラー自身が行動した時のみ減少するクールタイムです。
# こちらのクールタイムを適用する場合はスキルのメモ欄に以下を記述します。
# 　<セルフクールタイム:N>
# ※Nはクールタイム数
# また、セルフクールタイムの場合「逃げる」コマンドもコマンドを実行したアクターの
# クールタイムのみが減少します。
# 
# 1つのスキルにクールタイムとセルフクールタイムを
# 同時に設定はできませんのでご注意ください。
#
#------------------------------------------------------------------------------
module Gentlawk
  @@gentlawk_includes ||= {}
  @@gentlawk_includes[:I_CoolTimeForATB] = 1.00
  module CoolTimeForATB
    #▲▽▲▽▲▽▲▽▲▽▲▽▲▽▲▽
    #詳細設定
    
    # セルフクールタイムのラベル
    SELF_COOL_TIME_LABEL = "FC"
    # セルフクールタイムの文字色
    SELF_COOL_TIME_COLOR = 29
    
    #▲▽▲▽▲▽▲▽▲▽▲▽▲▽▲▽
  end
  class RequirementException < StandardError; end
  def self.requirement(name, version)
    if include?(name, version)
      return true
    end
    raise RequirementException, "#{name} ver#{version}以上が導入されていません"
  end
  def self.include?(name, version)
    @@gentlawk_includes[name] && @@gentlawk_includes[name] >= version
  end
end
#==============================================================================
# ■ RPG::Skill
#==============================================================================
class RPG::Skill
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  SELF_COOL_TIME = /<セルフクールタイム:(\d+)>/
  #--------------------------------------------------------------------------
  # ● セルフクールタイムを取得
  #--------------------------------------------------------------------------
  def self_cool_time
    return @self_cool_time if @self_cool_time != nil
    @self_cool_time = note =~ SELF_COOL_TIME ? $1.to_i + 1 : false
  end
end
#==============================================================================
# ■ Game_Temp
#==============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :self_cool_time
  #--------------------------------------------------------------------------
  # ● クールタイムの変数を初期化
  #--------------------------------------------------------------------------
  alias gentlawk_cool_time_variables_initialize cool_time_variables_initialize
  def cool_time_variables_initialize
    gentlawk_cool_time_variables_initialize
    @self_cool_time = Hash.new{|h, k| h[k] = Hash.new(0)}
  end
  #--------------------------------------------------------------------------
  # ● 指定バトラーのセルフクールタイム減少
  #--------------------------------------------------------------------------
  def battler_loss_cool_time(battler, n = 1)
    return unless @self_cool_time[battler]
    @self_cool_time[battler].keys.each{|key|
      @self_cool_time[battler][key] -= n
    }
  end
  #--------------------------------------------------------------------------
  # ● アクターのみクールタイム減少
  #--------------------------------------------------------------------------
  alias gentlawk_cool_time_actor_loss_cool_time actor_loss_cool_time
  def actor_loss_cool_time(n = 1)
    gentlawk_cool_time_actor_loss_cool_time(n)
    @self_cool_time.each{|k, v| v.keys.each{|key| v[key] -= n} if k.actor?}  
  end
  #--------------------------------------------------------------------------
  # ● エネミーのみクールタイム減少
  #--------------------------------------------------------------------------
  alias gentlawk_cool_time_enemy_loss_cool_time enemy_loss_cool_time
  def enemy_loss_cool_time(n = 1)
    gentlawk_cool_time_enemy_loss_cool_time(n)
    @self_cool_time.each{|k, v| v.keys.each{|key| v[key] -= n} if k.enemy?}  
  end
end
#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● セルフクールタイムを取得
  #--------------------------------------------------------------------------
  def self_cool_time
    $game_temp.self_cool_time[self]
  end
  #--------------------------------------------------------------------------
  # ● クールタイム中かどうか
  #--------------------------------------------------------------------------
  alias gentlawk_cool_time_skill_cooling? skill_cooling?
  def skill_cooling?(skill)
    gentlawk_cool_time_skill_cooling?(skill) || skill.self_cool_time && self_cool_time[skill.id] > 0
  end
  #--------------------------------------------------------------------------
  # ● クールタイムの適用
  #--------------------------------------------------------------------------
  alias gentlawk_cool_time_count_cool_time count_cool_time
  def count_cool_time(skill)
    gentlawk_cool_time_count_cool_time(skill)
    return if !($game_party.in_battle && RPG::Skill === skill)
    return if !skill.self_cool_time
    $game_temp.self_cool_time[self][skill.id] = skill.self_cool_time
  end
end
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  # ● 戦闘行動終了時の処理
  #--------------------------------------------------------------------------
  alias gentawk_process_action_end process_action_end
  def process_action_end
    $game_temp.battler_loss_cool_time(@subject) if @subject
    gentawk_process_action_end
  end
  #--------------------------------------------------------------------------
  # ● コマンド［逃げる］
  #--------------------------------------------------------------------------
  alias gentlawk_cool_time_command_escape command_escape
  def command_escape
    $game_temp.battler_loss_cool_time(BattleManager.actor) if BattleManager.actor
    gentlawk_cool_time_command_escape
  end
end
#==============================================================================
# ■ Window_BattleSkill
#==============================================================================
class Window_BattleSkill < Window_SkillList
  #--------------------------------------------------------------------------
  # ● クールタイムの描画
  #--------------------------------------------------------------------------
  alias gentlawk_cool_time_draw_cool_time draw_cool_time
  def draw_cool_time(rect, skill)
    if skill.cool_time
      gentlawk_cool_time_draw_cool_time(rect, skill)
    elsif skill.self_cool_time
      change_color(text_color(Gentlawk::CoolTimeForATB::SELF_COOL_TIME_COLOR), false)
      draw_text(rect, "#{Gentlawk::CoolTimeForATB::SELF_COOL_TIME_LABEL} #{@actor.self_cool_time[skill.id]}", 2)
    end
  end
end