#==============================================================================
# □ MPTP両方表示（2013/05/25）
#------------------------------------------------------------------------------
# 　消費MPと消費TPを両方同時に表示します。
#==============================================================================

#==============================================================================
# ■ Window_SkillList
#------------------------------------------------------------------------------
# 　スキル画面で、使用できるスキルの一覧を表示するウィンドウです。
#==============================================================================

class Window_SkillList < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    if skill
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(skill, rect.x, rect.y, enable?(skill), 140)
      draw_skill_cost(rect, skill)
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルの使用コストを描画
  #--------------------------------------------------------------------------
  def draw_skill_cost(rect, skill)
    if @actor.skill_mp_cost(skill) > 0 && @actor.skill_tp_cost(skill) > 0
      change_color(mp_cost_color, enable?(skill))
      draw_text(rect, "%d    "%(@actor.skill_mp_cost(skill)), 2)
      change_color(tp_cost_color, enable?(skill))
      draw_text(rect, @actor.skill_tp_cost(skill), 2)
    elsif @actor.skill_tp_cost(skill) > 0
      change_color(tp_cost_color, enable?(skill))
      draw_text(rect, @actor.skill_tp_cost(skill), 2)
    elsif @actor.skill_mp_cost(skill) > 0
      change_color(mp_cost_color, enable?(skill))
      draw_text(rect, @actor.skill_mp_cost(skill), 2)
    end
  end
end