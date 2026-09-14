# Фикс названия карты
class Window_MapName < Window_Base
	def window_width
		return Graphics.width / 2
	end
end