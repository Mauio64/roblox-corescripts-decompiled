local Foundation = script:FindFirstAncestor("Foundation")
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)

return {
	adjustForOnScreenKeyboard = function(rect: Rect, vector2: Vector2, vector2_2: Vector2) -- line: 93
		local v23 = vector2 - vector2_2
		local v24 = math.min(rect.Max.Y, v23.Y)

		return Rect.new(rect.Min, Vector2.new(rect.Max.X, v24))
	end,
	isOnScreen = function(rect: Rect, rect2: Rect) -- line: 25
		if rect.Min.X > rect2.Max.X or (rect.Max.X < rect2.Min.X or rect.Min.Y > rect2.Max.Y or rect.Max.Y < rect2.Min.Y) then
			return false
		end

		return true
	end,
	calculateSide = function(p1, rect: Rect, rect3: Rect, vector2: Vector2) -- line: 38
		-- upvalues: PopoverSide (copy)
		if p1 == PopoverSide.Top then
			if rect.Min.Y - vector2.Y < rect3.Min.Y and rect.Max.Y + vector2.Y < rect3.Max.Y then
				return PopoverSide.Bottom
			end
		elseif p1 == PopoverSide.Bottom then
			if rect.Max.Y + vector2.Y > rect3.Max.Y and rect.Min.Y - vector2.Y > rect3.Min.Y then
				return PopoverSide.Top
			end
		elseif p1 == PopoverSide.Left then
			if rect.Min.X - vector2.X < rect3.Min.X and rect.Max.X + vector2.X < rect3.Max.X then
				return PopoverSide.Right
			end
		elseif p1 == PopoverSide.Right and rect.Max.X + vector2.X > rect3.Max.X and rect.Min.X - vector2.X > rect3.Min.X then
			return PopoverSide.Left
		end

		return p1
	end,
	calculatePositions = function(p2, n1: number, p3, n2: number, rect: Rect, rect4: Rect, n3: number, vector2: Vector2) -- line: 102
		-- upvalues: PopoverSide (copy), PopoverAlign (copy)
		local t1 = {
			X = 0,
			Y = 0
		}
		local t2 = {
			X = 0,
			Y = 0
		}
		local t3 = {
			X = 0,
			Y = 0
		}
		local v36 = p2 == PopoverSide.Top or p2 == PopoverSide.Bottom
		local v37 = p2 == PopoverSide.Top or p2 == PopoverSide.Left
		local s1 = "X"
		local s2 = "Y"
		local rectHeight = rect.Height
		local MinX = rect.Min.X
		local MinY = rect.Min.Y
		local vector2Y = vector2.Y
		local vector2X = vector2.X
		local MaxX = rect.Max.X
		local MaxY = rect.Max.Y
		local MinY2 = rect4.Min.Y
		local MaxY2 = rect4.Max.Y
		local MinX2 = rect4.Min.X
		local MaxX2 = rect4.Max.X

		if v36 then
			s1 = "Y"
			s2 = "X"
			rectHeight = rect.Width
			MinX = rect.Min.Y
			MinY = rect.Min.X
			vector2Y = vector2.X
			vector2X = vector2.Y
			MaxX = rect.Max.Y
			MaxY = rect.Max.X
			MinY2 = rect4.Min.X
			MaxY2 = rect4.Max.X
			MinX2 = rect4.Min.Y
			MaxX2 = rect4.Max.Y
		end

		local v51 = n1 + n3

		if v37 then
			t1[s1] = MinX - v51 - vector2X
			t2[s1] = vector2X
		else
			t1[s1] = MaxX + v51
			t2[s1] = 0
		end

		if p3 == PopoverAlign.Start then
			t1[s2] = MinY + n2
		elseif p3 == PopoverAlign.Center then
			t1[s2] = MinY + rectHeight / 2 - vector2Y / 2 + n2
		else
			t1[s2] = MaxY + -n2
			t3[s2] = 1
		end

		local v52 = t1[s2] - t3[s2] * vector2Y
		local v53 = v52 + vector2Y

		if v52 < MinY2 then
			t3[s2] = 0
			t1[s2] = MinY2
		elseif MaxY2 < v53 then
			t3[s2] = 1
			t1[s2] = MaxY2
		end

		local v54 = t1[s2] - t3[s2] * vector2Y
		local v55 = v54 + vector2Y
		local v56 = math.max(MinY, v54)
		local v57 = math.min(MaxY, v55)

		t2[s2] = ((if not (v56 <= v57) then (if not (v55 < MinY) then v54 + n3 else v55 - n3) else (v56 + v57) / 2)) - t1[s2]
		t1[s1] = math.clamp(t1[s1], MinX2, (math.max(MaxX2 - vector2X - v51, 0)))
		t1.X = t1.X - rect4.Min.X
		t1.Y = t1.Y - rect4.Min.Y

		return Vector2.new(t1.X, t1.Y), Vector2.new(t2.X, t2.Y), Vector2.new(t3.X, t3.Y)
	end,
	calculatePopoverBounds = function(p4, n4: number, n5: number, n6: number, vector2: Vector2) -- line: 9
		-- upvalues: PopoverSide (copy)
		if p4 == PopoverSide.Top or p4 == PopoverSide.Bottom then
			return vector2 + Vector2.new(n5, n4 + n6)
		end

		return vector2 + Vector2.new(n4 + n6, n5)
	end,
	calculateAlign = function(p5, p6, rect: Rect, rect5: Rect, vector2: Vector2) -- line: 59
		-- upvalues: PopoverSide (copy), PopoverAlign (copy)
		if p5 == PopoverSide.Top or p5 == PopoverSide.Bottom then
			if p6 == PopoverAlign.Start then
				if rect.Min.X + vector2.X > rect5.Max.X then
					return PopoverAlign.End
				end
			elseif p6 == PopoverAlign.End and rect.Max.X - vector2.X < rect5.Min.X then
				return PopoverAlign.Start
			end
		elseif p6 == PopoverAlign.Start then
			if rect.Min.Y + vector2.Y > rect5.Max.Y then
				return PopoverAlign.End
			end
		elseif p6 == PopoverAlign.End and rect.Max.Y - vector2.Y < rect5.Min.Y then
			return PopoverAlign.Start
		end

		return p6
	end
}
