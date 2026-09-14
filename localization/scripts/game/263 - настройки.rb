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
# ИЗМЕНЕНИЯ (эта версия):
#
# В RPG Maker VX Ace физические клавиши W/A/S/D изначально ЗАШИТЫ в
# движок как ВТОРАЯ, отдельная привязка:
#   W -> кнопка R (след. страница / PageDown)
#   A -> кнопка X
#   S -> кнопка Y
#   D -> кнопка Z
#   (Q -> кнопка L, но Q не используется в WASD-схеме и не трогается)
#
# Раньше скрипт перехватывал только UP/DOWN/LEFT/RIGHT, поэтому W всё
# равно продолжал параллельно листать страницы (через R), а A/S/D —
# дёргать X/Y/Z. Из-за двух конкурирующих источников ввода поведение
# в окне сохранений (15 слотов) было нестабильным.
#
# Теперь скрипт полностью перехватывает ОБЕ группы кнопок сразу —
# UP/DOWN/LEFT/RIGHT и R/X/Y/Z — и делает настоящий обмен местами:
#
#   WASD ВЫКЛ (обычный режим):
#     Стрелки  -> движение (UP/DOWN/LEFT/RIGHT)
#     W/A/S/D  -> R/X/Y/Z (как в ванильном движке)
#
#   WASD ВКЛ (переключено):
#     W/A/S/D  -> движение (UP/DOWN/LEFT/RIGHT)
#     Стрелки  -> R/X/Y/Z (функции W/A/S/D переходят на стрелки)
#
# Физическая клавиша PageDown отдельно всегда работает как R (не
# зависит от переключателя) — это не мешает обмену, а Q всегда
# работает как L, как и было.
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
# ■ WASD / Arrows Full Swap
#------------------------------------------------------------------------------
# Полный обмен местами двух групп клавиш (см. пояснение вверху файла).
# Перехватываются: UP, DOWN, LEFT, RIGHT, R, X, Y, Z.
# Не трогаются: L (Q / PageUp), A (Shift), B, C и всё остальное.
#==============================================================================

module Settings_WASD_Input

  # Виртуальные коды клавиш
  VK_UP        = 0x26
  VK_DOWN      = 0x28
  VK_LEFT      = 0x25
  VK_RIGHT     = 0x27
  VK_PAGE_DOWN = 0x22
  VK_W         = 0x57
  VK_A         = 0x41
  VK_S         = 0x53
  VK_D         = 0x44

  # Обычный режим (WASD выключен):
  #   стрелки -> движение, W/A/S/D -> R/X/Y/Z (как в ванильном движке)
  NORMAL_VK = {
    :UP    => [VK_UP],
    :DOWN  => [VK_DOWN],
    :LEFT  => [VK_LEFT],
    :RIGHT => [VK_RIGHT],
    :R     => [VK_W, VK_PAGE_DOWN],
    :X     => [VK_A],
    :Y     => [VK_S],
    :Z     => [VK_D],
  }

  # Режим WASD (переключено):
  #   W/A/S/D -> движение, стрелки -> R/X/Y/Z (обмен местами)
  SWAPPED_VK = {
    :UP    => [VK_W],
    :DOWN  => [VK_S],
    :LEFT  => [VK_A],
    :RIGHT => [VK_D],
    :R     => [VK_UP, VK_PAGE_DOWN],
    :X     => [VK_LEFT],
    :Y     => [VK_DOWN],
    :Z     => [VK_RIGHT],
  }

  # Задержка перед авто-повтором и интервал повтора (в кадрах),
  # такие же, как у родных стрелок.
  REPEAT_DELAY    = 23
  REPEAT_INTERVAL = 6

  GetAsyncKeyState = Win32API.new(
    "user32", "GetAsyncKeyState",
    "i", "i"
  )

  class << Input

    alias settings_dir_original_press?   press?
    alias settings_dir_original_trigger? trigger?
    alias settings_dir_original_repeat?  repeat?
    alias settings_dir_original_update   update
    alias settings_dir_original_dir4     dir4
    alias settings_dir_original_dir8     dir8


    #--------------------------------------------------------------------------
    # ■ Активная таблица клавиш
    #--------------------------------------------------------------------------

    def settings_active_vk_table
      Settings_Config.wasd? ? Settings_WASD_Input::SWAPPED_VK : Settings_WASD_Input::NORMAL_VK
    end


    #--------------------------------------------------------------------------
    # ■ Обновление счётчиков удержания (раз в кадр)
    #--------------------------------------------------------------------------

    def update
      settings_dir_original_update

      @settings_but_counter ||= Hash.new(0)
      table = settings_active_vk_table

      table.each_key do |btn|
        vk_list = table[btn]
        down = vk_list.any? { |vk| Settings_WASD_Input::GetAsyncKeyState.call(vk) & 0x8000 != 0 }

        if down
          @settings_but_counter[btn] += 1
        else
          @settings_but_counter[btn] = 0
        end
      end
    end


    #--------------------------------------------------------------------------
    # ■ Физическое состояние / trigger / repeat по логической кнопке
    #--------------------------------------------------------------------------

    def settings_but_down?(btn)
      (@settings_but_counter ||= Hash.new(0))[btn].to_i > 0
    end

    def settings_but_trigger?(btn)
      (@settings_but_counter ||= Hash.new(0))[btn].to_i == 1
    end

    def settings_but_repeat?(btn)
      count = (@settings_but_counter ||= Hash.new(0))[btn].to_i
      delay    = Settings_WASD_Input::REPEAT_DELAY
      interval = Settings_WASD_Input::REPEAT_INTERVAL
      count == 1 || (count >= delay && (count - delay) % interval == 0)
    end


    #--------------------------------------------------------------------------
    # ■ Определение логической кнопки по константе Input::*
    #--------------------------------------------------------------------------

    def settings_button_for(key)
      case key
      when Input::UP    then :UP
      when Input::DOWN  then :DOWN
      when Input::LEFT  then :LEFT
      when Input::RIGHT then :RIGHT
      when Input::R     then :R
      when Input::X     then :X
      when Input::Y     then :Y
      when Input::Z     then :Z
      else nil
      end
    end


    #--------------------------------------------------------------------------
    # ■ press? / trigger? / repeat?
    #--------------------------------------------------------------------------

    def press?(key)
      btn = settings_button_for(key)
      return settings_but_down?(btn) if btn
      settings_dir_original_press?(key)
    end

    def trigger?(key)
      btn = settings_button_for(key)
      return settings_but_trigger?(btn) if btn
      settings_dir_original_trigger?(key)
    end

    def repeat?(key)
      btn = settings_button_for(key)
      return settings_but_repeat?(btn) if btn
      settings_dir_original_repeat?(key)
    end


    #--------------------------------------------------------------------------
    # ■ dir4 / dir8
    #--------------------------------------------------------------------------

    def dir4
      return 8 if settings_but_down?(:UP)
      return 2 if settings_but_down?(:DOWN)
      return 4 if settings_but_down?(:LEFT)
      return 6 if settings_but_down?(:RIGHT)
      0
    end

    def dir8
      up    = settings_but_down?(:UP)
      down  = settings_but_down?(:DOWN)
      left  = settings_but_down?(:LEFT)
      right = settings_but_down?(:RIGHT)

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

      0
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
# Добавляем пункт Настройки после "Сортировка".
#
# Старый отдельный пункт HZM AudioVol (Звук) удаляем —
# громкость теперь внутри Настроек.
#
# Важно: :settings добавляется в add_original_commands, потому что
# этот метод вызывается ПОСЛЕ make_command_list. Если добавить в
# make_command_list — команда окажется в конце.
#==============================================================================

class Window_MenuCommand

  alias settings_original_add_original_commands add_original_commands

  def add_original_commands

    settings_original_add_original_commands

    # Убираем старый пункт HZM AudioVol.
    @list.delete_if do |command|
      command[:symbol] == :hzm_vxa_audioVol
    end

    # Убираем возможный дубликат :settings, если его кто-то добавил.
    @list.delete_if do |command|
      command[:symbol] == :settings
    end

    command = {
      :name    => "Настройки",
      :symbol  => :settings,
      :enabled => true,
      :ext     => nil
    }

    # Ищем "Сортировка" (:sort) и вставляем сразу после неё.
    sort_index = @list.index { |c| c[:symbol] == :sort }

    if sort_index
      @list.insert(sort_index + 1, command)
    else
      # Если сортировки нет — перед "Сохранить" (:save).
      save_index = @list.index { |c| c[:symbol] == :save }
      if save_index
        @list.insert(save_index, command)
      else
        @list << command
      end
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