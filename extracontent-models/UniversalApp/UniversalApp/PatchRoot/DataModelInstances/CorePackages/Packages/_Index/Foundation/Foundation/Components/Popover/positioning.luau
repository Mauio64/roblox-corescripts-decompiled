local Foundation = script:FindFirstAncestor("Foundation")

local Flags = require(Foundation.Utility.Flags)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Positioning = {}

function Positioning.adjustForOnScreenKeyboard(rect: Rect, vector2: Vector2, vector2_2: Vector2)
	local v = vector2 - vector2_2

	local v2 = math.min(rect.Max.Y, v.Y)
	return Rect.new(rect.Min, Vector2.new(rect.Max.X, v2))
end

function Positioning.isOnScreen(rect: Rect, rect2: Rect): boolean
	return not (rect.Min.X > rect2.Max.X or rect.Max.X < rect2.Min.X or rect.Min.Y > rect2.Max.Y or rect.Max.Y < rect2.Min.Y)
end

function Positioning.calculateSide(p, rect: Rect, rect2: Rect, vector2: Vector2)
	if p == PopoverSide.Top then
		if rect.Min.Y - vector2.Y < rect2.Min.Y and rect.Max.Y + vector2.Y < rect2.Max.Y then
			return PopoverSide.Bottom
		end
	elseif p == PopoverSide.Bottom then
		if rect.Max.Y + vector2.Y > rect2.Max.Y and rect.Min.Y - vector2.Y > rect2.Min.Y then
			return PopoverSide.Top
		end
	elseif p == PopoverSide.Left then
		if rect.Min.X - vector2.X < rect2.Min.X and rect.Max.X + vector2.X < rect2.Max.X then
			return PopoverSide.Right
		end
	elseif p == PopoverSide.Right and rect.Max.X + vector2.X > rect2.Max.X and rect.Min.X - vector2.X > rect2.Min.X then
		return PopoverSide.Left
	end

	return p
end

function Positioning.calculatePositions(p, p2: number, p3, p4: number, rect: Rect, rect2: Rect, p5: number, vector2: Vector2)
	local v = { X = 0, Y = 0 }
	local v2 = { X = 0, Y = 0 }
	local v3 = { X = 0, Y = 0 }

	local v4 = p == PopoverSide.Top or p == PopoverSide.Bottom

	local v5 = p == PopoverSide.Top or p == PopoverSide.Left

	local v6 = rect.Height
	local v7 = rect.Min.X
	local v8 = rect.Min.Y
	local v9 = vector2.Y
	local v10 = vector2.X
	local v11 = rect.Max.X
	local v12 = rect.Max.Y
	local v13 = rect2.Min.Y
	local v14 = rect2.Max.Y
	local v15 = rect2.Min.X
	local v16 = rect2.Max.X
	local v17, v18

	if v4 then
		v6 = rect.Width
		v7 = rect.Min.Y
		v8 = rect.Min.X
		v9 = vector2.X
		v10 = vector2.Y
		v11 = rect.Max.Y
		v12 = rect.Max.X
		v13 = rect2.Min.X
		v14 = rect2.Max.X
		v15 = rect2.Min.Y
		v16 = rect2.Max.Y
		v17 = "Y"
		v18 = "X"
	else
		v17 = "X"
		v18 = "Y"
	end

	local v19 = p2 + p5

	if v5 then
		v[v17] = v7 - v19 - v10
		v2[v17] = v10
	else
		v[v17] = v11 + v19
		v2[v17] = 0
	end

	if p3 == PopoverAlign.Start then
		v[v18] = v8 + p4
	elseif p3 == PopoverAlign.Center then
		v[v18] = v8 + v6 / 2 - v9 / 2 + p4
	else
		v[v18] = v12 + -p4
		v3[v18] = 1
	end

	local v20 = v[v18] - v3[v18] * v9

	local v21 = v20 + v9

	if v20 < v13 then
		v3[v18] = 0
		v[v18] = v13
	elseif v14 < v21 then
		v3[v18] = 1
		v[v18] = v14
	end

	local v22 = v[v18] - v3[v18] * v9
	local v23 = v22 + v9

	local v24 = math.max(v8, v22)
	local v25 = math.min(v12, v23)
	local v26

	if v24 <= v25 then
		v26 = (v24 + v25) / 2
	elseif v23 < v8 then
		v26 = v23 - p5
	else
		v26 = v22 + p5
	end

	v2[v18] = v26 - v[v18]

	v[v17] = math.clamp(v[v17], v15, (math.max(v16 - v10 - v19, not Flags.FoundationPopoverClampMinBound and 0 or v15)))

	v.X -= rect2.Min.X
	v.Y -= rect2.Min.Y

	return Vector2.new(v.X, v.Y), Vector2.new(v2.X, v2.Y), Vector2.new(v3.X, v3.Y)
end

function Positioning.calculatePopoverBounds(p, p2: number, p3: number, p4: number, vector2: Vector2)
	if p == PopoverSide.Top or p == PopoverSide.Bottom then
		return vector2 + Vector2.new(p3, p2 + p4)
	end

	return vector2 + Vector2.new(p2 + p4, p3)
end

function Positioning.calculateAlign(p, p2, rect: Rect, rect2: Rect, vector2: Vector2)
	if p == PopoverSide.Top or p == PopoverSide.Bottom then
		if p2 == PopoverAlign.Start then
			if rect.Min.X + vector2.X > rect2.Max.X then
				return PopoverAlign.End
			end
		elseif p2 == PopoverAlign.End and rect.Max.X - vector2.X < rect2.Min.X then
			return PopoverAlign.Start
		end
	elseif p2 == PopoverAlign.Start then
		if rect.Min.Y + vector2.Y > rect2.Max.Y then
			return PopoverAlign.End
		end
	elseif p2 == PopoverAlign.End and rect.Max.Y - vector2.Y < rect2.Min.Y then
		return PopoverAlign.Start
	end

	return p2
end

return Positioning
