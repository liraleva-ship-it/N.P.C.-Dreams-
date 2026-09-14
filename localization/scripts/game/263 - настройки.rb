#==============================================================================
# Settings System for Project 2
#------------------------------------------------------------------------------
# Объединённые настройки проекта.
#
# ВАЖНО:
# 1. Поставить этот скрипт НИЖЕ HZM_VXA::AudioVol.
# 2. Поставить НИЖЕ RU UI Overrides.
#
# Не требует Yanfly System Options.
# Не использует лок_Q.
#
# ИЗМЕНЕНИЯ:
# - Пункт "Громкость" встроен прямо в окно "Настройки" и открывает
#   родную Scene_VolConfig из HZM_VXA::AudioVol.
# - Отдельные пункты "Звук" / "Громкость" (HZM AudioVol) в меню
#   и на титуле удалены, чтобы не было двух разделов.
# - Убран пункт полноэкранного режима.
# - Исправлена ошибка "wrong number of parameters: expected 3, got 4"
#   (неверная сигнатура WritePrivateProfileStringA — было 3 параметра,
#   должно быть 4).
#==============================================================================


#==============================================================================
# ■ Settings_Config
#------------------------------------------------------------------------------
# Глобальное хранение настроек в Game.ini.
#==============================================================================

module Settings_Config

  SECTION = "Settings"

  GetPrivateProfileString = Win32API.new(
    "kernel32", "GetPrivateProfileStringA",
    "ppppip", "i"
  )

  WritePrivateProfileString = Win32API.new(
    "kernel32", "WritePrivateProfileStringA",
    "pppp", "i"
  )

  def self.ini_path
    File.expand_path("Game.ini")
  end

  def self.read(key, default = "")
    buffer = "\0" * 256

    GetPrivateProfileString.call(
      SECTION,
      key.to_s,
      default.to_s,
      buffer,
      256,
      ini_path
    )

    buffer.delete!("\0")
    buffer
  end

  def self.write(key, value)
    WritePrivateProfileString.call(
      SECTION,
      key.to_s,
      value.to_s,
      ini_path
    )
  end


  #--------------------------------------------------------------------------
  # ■ Boolean
  #--------------------------------------------------------------------------

  def self.bool(key, default = false)
    value = read(key, default ? "1" : "0")
    value == "1"
  end

  def self.write_bool(key, value)
    write(key, value ? "1" : "0")
  end


  #--------------------------------------------------------------------------
  # ■ Instant Text
  #--------------------------------------------------------------------------

  def self.instant_message?
    bool("InstantMessage", false)
  end

  def self.instant_message=(value)
    write_bool("InstantMessage", value)
  end


  #--------------------------------------------------------------------------
  # ■ Battle Animations
  #--------------------------------------------------------------------------

  def self.battle_animations?
    bool("BattleAnimations", true)
  end

  def self.battle_animations=(value)
    write_bool("BattleAnimations", value)
  end


  #--------------------------------------------------------------------------
  # ■ WASD
  #--------------------------------------------------------------------------

  def self.wasd?
    bool("WASD", false)
  end

  def self.wasd=(value)
    write_bool("WASD", value)
  end

end


#==============================================================================
# ■ Game_System
#------------------------------------------------------------------------------
# Методы совместимости.
#
# Они позволяют другим скриптам обращаться к настройкам привычным способом.
#==============================================================================

class Game_System

  def instant_message?
    Settings_Config.instant_message?
  end

  def instant_message=(value)
    Settings_Config.instant_message = value
  end

  def battle_animations?
    Settings_Config.battle_animations?
  end

  def battle_animations=(value)
    Settings_Config.battle_animations = value
  end

  def wasd_enabled?
    Settings_Config.wasd?
  end

  def set_wasd(value)
    Settings_Config.wasd = value
  end

end


#==============================================================================
# ■ WASD Input
#------------------------------------------------------------------------------
# Только WASD.
#
# Никаких Q/C.
# Никаких remap X/L/R/Y/Z.
# Никаких специальных Scene_Item.
#==============================================================================

module Settings_WASD_Input

  VK = {
    :UP    => 0x57, # W
    :LEFT  => 0x41, # A
    :DOWN  => 0x53, # S
    :RIGHT => 0x44  # D
  }

  GetAsyncKeyState = Win32API.new(
    "user32", "GetAsyncKeyState",
    "i", "i"
  )

  class << Input

    alias settings_wasd_original_update update
    alias settings_wasd_original_press press?
    alias settings_wasd_original_trigger trigger?
    alias settings_wasd_original_repeat repeat?
    alias settings_wasd_original_dir4 dir4
    alias settings_wasd_original_dir8 dir8


    #--------------------------------------------------------------------------
    # ■ update
    #--------------------------------------------------------------------------

    def update
      settings_wasd_original_update

      @settings_wasd_counter ||= Hash.new(0)

      Settings_WASD_Input::VK.each do |key, vk|
        if Settings_Config.wasd?
          if Settings_WASD_Input::GetAsyncKeyState.call(vk) & 0x8000 != 0
            @settings_wasd_counter[key] += 1
          else
            @settings_wasd_counter[key] = 0
          end
        else
          @settings_wasd_counter[key] = 0
        end
      end
    end


    #--------------------------------------------------------------------------
    # ■ Physical state
    #--------------------------------------------------------------------------

    def settings_wasd_press?(key)
      return false unless Settings_Config.wasd?

      @settings_wasd_counter ||= Hash.new(0)

      @settings_wasd_counter[key].to_i > 0
    end

    def settings_wasd_trigger?(key)
      return false unless Settings_Config.wasd?

      @settings_wasd_counter ||= Hash.new(0)

      @settings_wasd_counter[key].to_i == 1
    end

    def settings_wasd_repeat?(key)
      return false unless Settings_Config.wasd?

      @settings_wasd_counter ||= Hash.new(0)

      count = @settings_wasd_counter[key].to_i

      count == 1 || (count >= 20 && count % 6 == 0)
    end


    #--------------------------------------------------------------------------
    # ■ press?
    #--------------------------------------------------------------------------

    def press?(key)
      case key
      when Input::UP
        return true if settings_wasd_press?(:UP)
      when Input::DOWN
        return true if settings_wasd_press?(:DOWN)
      when Input::LEFT
        return true if settings_wasd_press?(:LEFT)
      when Input::RIGHT
        return true if settings_wasd_press?(:RIGHT)
      end

      settings_wasd_original_press(key)
    end


    #--------------------------------------------------------------------------
    # ■ trigger?
    #--------------------------------------------------------------------------

    def trigger?(key)
      case key
      when Input::UP
        return true if settings_wasd_trigger?(:UP)
      when Input::DOWN
        return true if settings_wasd_trigger?(:DOWN)
      when Input::LEFT
        return true if settings_wasd_trigger?(:LEFT)
      when Input::RIGHT
        return true if settings_wasd_trigger?(:RIGHT)
      end

      settings_wasd_original_trigger(key)
    end


    #--------------------------------------------------------------------------
    # ■ repeat?
    #--------------------------------------------------------------------------

    def repeat?(key)
      case key
      when Input::UP
        return true if settings_wasd_repeat?(:UP)
      when Input::DOWN
        return true if settings_wasd_repeat?(:DOWN)
      when Input::LEFT
        return true if settings_wasd_repeat?(:LEFT)
      when Input::RIGHT
        return true if settings_wasd_repeat?(:RIGHT)
      end

      settings_wasd_original_repeat(key)
    end


    #--------------------------------------------------------------------------
    # ■ dir4
    #--------------------------------------------------------------------------

    def dir4
      return 8 if settings_wasd_press?(:UP)
      return 2 if settings_wasd_press?(:DOWN)
      return 4 if settings_wasd_press?(:LEFT)
      return 6 if settings_wasd_press?(:RIGHT)

      settings_wasd_original_dir4
    end


    #--------------------------------------------------------------------------
    # ■ dir8
    #--------------------------------------------------------------------------

    def dir8

      up    = settings_wasd_press?(:UP)
      down  = settings_wasd_press?(:DOWN)
      left  = settings_wasd_press?(:LEFT)
      right = settings_wasd_press?(:RIGHT)

      if up && left
        return 7
      elsif up && right
        return 9
      elsif down && left
        return 1
      elsif down && right
        return 3
      elsif up
        return 8
      elsif down
        return 2
      elsif left
        return 4
      elsif right
        return 6
      end

      settings_wasd_original_dir8
    end

  end

end


#==============================================================================
# ■ Window_Settings
#==============================================================================

class Window_Settings < Window_Command

  def initialize
    super(0, 0)
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height - height) / 2
  end

  def window_width
    420
  end

  def visible_line_number
    8
  end

  def make_command_list

    # Громкость — встроенный пункт, открывает родную Scene_VolConfig
    # из HZM_VXA::AudioVol. Значение в окне настроек не отображаем —
    # оно всё равно редактируется на отдельном экране.
    add_command(
      "Громкость",
      :audio_vol
    )

    add_command(
      "Мгновенный текст",
      :instant_message
    )

    add_command(
      "Анимации битвы",
      :battle_animations
    )

    add_command(
      "Управление",
      :wasd
    )

    add_command(
      "Назад",
      :cancel
    )
  end


  #--------------------------------------------------------------------------
  # ■ draw_item
  #--------------------------------------------------------------------------

  def draw_item(index)

    rect = item_rect(index)

    draw_text(
      rect.x,
      rect.y,
      rect.width - 100,
      rect.height,
      command_name(index),
      0
    )

    symbol = @list[index][:symbol]
    value = settings_value(symbol)

    draw_text(
      rect.x,
      rect.y,
      rect.width,
      rect.height,
      value,
      2
    )
  end


  #--------------------------------------------------------------------------
  # ■ Значение настройки
  #--------------------------------------------------------------------------

  def settings_value(symbol)

    case symbol

    when :audio_vol
      return ""

    when :instant_message
      return Settings_Config.instant_message? ? "ВКЛ." : "ВЫКЛ."

    when :battle_animations
      return Settings_Config.battle_animations? ? "ВКЛ." : "ВЫКЛ."

    when :wasd
      return Settings_Config.wasd? ? "WASD" : "Стрелки"

    when :cancel
      return ""

    end

    ""
  end

end


#==============================================================================
# ■ Scene_Settings
#==============================================================================

class Scene_Settings < Scene_MenuBase

  def start
    super

    create_help_window
    create_settings_window
  end


  #--------------------------------------------------------------------------
  # ■ Help
  #--------------------------------------------------------------------------

  def create_help_window

    @help_window = Window_Help.new(2)

    @help_window.set_text(
      "Enter — выбрать    Esc — назад"
    )

    @help_window.y = 0
  end


  #--------------------------------------------------------------------------
  # ■ Settings Window
  #--------------------------------------------------------------------------

  def create_settings_window

    @settings_window = Window_Settings.new

    @settings_window.y = @help_window.height + 8

    @settings_window.set_handler(
      :cancel,
      method(:return_scene)
    )

    @settings_window.set_handler(
      :audio_vol,
      method(:command_audio_vol)
    )

    @settings_window.set_handler(
      :instant_message,
      method(:command_instant_message)
    )

    @settings_window.set_handler(
      :battle_animations,
      method(:command_battle_animations)
    )

    @settings_window.set_handler(
      :wasd,
      method(:command_wasd)
    )
  end


  #--------------------------------------------------------------------------
  # ■ Refresh
  #--------------------------------------------------------------------------

  def refresh
    @settings_window.refresh
  end


  #--------------------------------------------------------------------------
  # ■ Audio Volume
  #
  # Открывает родную Scene_VolConfig из HZM_VXA::AudioVol.
  # Никаких собственных ползунков — громкость полностью на стороне
  # HZM_VXA::AudioVol, включая сохранение в Game.ini (AudioVol).
  #--------------------------------------------------------------------------

  def command_audio_vol

    if defined?(HZM_VXA::AudioVol::Scene_VolConfig)

      SceneManager.call(HZM_VXA::AudioVol::Scene_VolConfig)

    else

      Sound.play_buzzer

    end

  end


  #--------------------------------------------------------------------------
  # ■ Instant Message
  #--------------------------------------------------------------------------

  def command_instant_message

    value = !Settings_Config.instant_message?

    Settings_Config.instant_message = value

    Sound.play_ok

    @settings_window.activate
    @settings_window.refresh
  end


  #--------------------------------------------------------------------------
  # ■ Battle Animations
  #--------------------------------------------------------------------------

  def command_battle_animations

    value = !Settings_Config.battle_animations?

    Settings_Config.battle_animations = value

    Sound.play_ok

    @settings_window.activate
    @settings_window.refresh
  end


  #--------------------------------------------------------------------------
  # ■ WASD
  #--------------------------------------------------------------------------

  def command_wasd

    value = !Settings_Config.wasd?

    Settings_Config.wasd = value

    Sound.play_ok

    @settings_window.activate
    @settings_window.refresh
  end

end


#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# Добавляем Настройки в существующее меню.
#==============================================================================

class Scene_Menu

  alias settings_create_command_window create_command_window

  def create_command_window

    settings_create_command_window

    @command_window.set_handler(
      :settings,
      method(:command_settings)
    )

  end


  def command_settings
    SceneManager.call(Scene_Settings)
  end

end


#==============================================================================
# ■ Window_MenuCommand
#------------------------------------------------------------------------------
# Добавляем пункт Настройки.
#
# Старый отдельный пункт HZM AudioVol (Звук) удаляем —
# громкость теперь внутри Настроек.
#==============================================================================

class Window_MenuCommand

  alias settings_original_make_command_list make_command_list

  def make_command_list

    settings_original_make_command_list

    # Убираем старый пункт HZM AudioVol.
    @list.delete_if do |command|
      command[:symbol] == :hzm_vxa_audioVol
    end

    # Не добавляем второй Settings, если он уже был.
    unless @list.any? { |command| command[:symbol] == :settings }

      add_command(
        "Настройки",
        :settings,
        true
      )

    end

  end

end


#==============================================================================
# ■ Window_TitleCommand
#------------------------------------------------------------------------------
# Добавляем Настройки на титульный экран.
#
# Старую кнопку HZM AudioVol (Громкость) удаляем —
# громкость теперь внутри Настроек.
#==============================================================================

class Window_TitleCommand

  alias settings_original_make_command_list make_command_list

  def make_command_list

    settings_original_make_command_list

    # Удаляем старую кнопку HZM AudioVol.
    @list.delete_if do |command|
      command[:symbol] == :hzm_vxa_audioVol
    end

    # Добавляем Настройки перед Выходом.
    unless @list.any? { |command| command[:symbol] == :settings }

      shutdown_index = @list.index do |command|
        command[:symbol] == :shutdown
      end

      command = {
        :name    => "Настройки",
        :symbol  => :settings,
        :enabled => true,
        :ext     => nil
      }

      if shutdown_index
        @list.insert(shutdown_index, command)
      else
        @list << command
      end

    end

  end

end


#==============================================================================
# ■ Scene_Title
#------------------------------------------------------------------------------
# Обработчик Настроек.
#==============================================================================

class Scene_Title

  alias settings_original_create_command_window create_command_window

  def create_command_window

    settings_original_create_command_window

    @command_window.set_handler(
      :settings,
      method(:command_settings)
    )

  end


  def command_settings
    SceneManager.call(Scene_Settings)
  end

end


#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
# Мгновенный текст.
#
# Существующий fast text игрока не ломается.
# Если настройка включена — ожидание между символами отсутствует.
#==============================================================================

class Window_Message

  alias settings_original_wait_for_one_character wait_for_one_character

  def wait_for_one_character

    if Settings_Config.instant_message?
      return
    end

    settings_original_wait_for_one_character

  end

end


#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# Отключение отображения боевых анимаций.
#==============================================================================
#
# Само нанесение урона и лог боя не затрагиваются.
# Отключается именно визуальная анимация.
#==============================================================================

class Scene_Battle

  alias settings_original_show_animation show_animation

  def show_animation(targets, animation_id)

    unless Settings_Config.battle_animations?
      return
    end

    settings_original_show_animation(
      targets,
      animation_id
    )

  end

end