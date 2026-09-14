#==============================================================================
# ■ Skip Empty Messages
#==============================================================================

class Game_Interpreter
  
  # команда 101
  alias skip_empty_command_101 command_101
  def command_101
    #команды 401
    texts = []
    i = @index + 1
    while @list[i] && @list[i].code == 401
      texts << @list[i].parameters[0].to_s
      i += 1
    end

    has_text = texts.any? { |line| !line.strip.empty? }

    if has_text
      skip_empty_command_101
    else
      @index = i - 1
    end
  end
end