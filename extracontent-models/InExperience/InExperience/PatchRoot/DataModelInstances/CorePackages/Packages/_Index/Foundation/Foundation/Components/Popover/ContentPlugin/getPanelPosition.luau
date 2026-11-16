local Foundation = script:FindFirstAncestor("Foundation")

local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)

require(Foundation.Providers.StudioPanels.Types)

local function getPanelPosition(p, p2, vector2: Vector2?, value: number?, value2: number?)
	local v = 0
	local v2

	if type(p) == "table" then
		v2 = p.offset
		p = p.position
	else
		v2 = 0
	end

	if type(p2) == "table" then
		v = p2.offset
		p2 = p2.position
	end

	local v3 = v2 + (value2 or 0)
	local v4 = 0
	local v5

	if p2 == PopoverAlign.Center then
		v5 = 0
		v4 = 0.5
	elseif p2 == PopoverAlign.End then
		v5 = -v
		v4 = 1
	else
		v5 = v
	end

	local offset = nil
	local targetAnchorPoint = nil
	local vector2_2 = nil

	if p == PopoverSide.Top then
		offset = Vector2.new(v5, -v3)
		targetAnchorPoint = Vector2.new(v4, 0)
		vector2_2 = Vector2.new(v4, 1)
	elseif p == PopoverSide.Bottom then
		offset = Vector2.new(v5, v3)
		targetAnchorPoint = Vector2.new(v4, 1)
		vector2_2 = Vector2.new(v4, 0)
	elseif p == PopoverSide.Left then
		offset = Vector2.new(-v3, v5)
		targetAnchorPoint = Vector2.new(0, v4)
		vector2_2 = Vector2.new(1, v4)
	elseif p == PopoverSide.Right then
		offset = Vector2.new(v3, v5)
		targetAnchorPoint = Vector2.new(1, v4)
		vector2_2 = Vector2.new(0, v4)
	end

	local v6 = value or 0

	if v6 > 0 then
		local v7 = p == PopoverSide.Top or p == PopoverSide.Bottom
		local v8 = v6 * 2
		local v9 = v6 * 2
		local v10, v11

		if v7 then
			v10 = v8 + v
			v11 = v9 + v3
		else
			v10 = v8 + v3
			v11 = v9 + v
		end

		offset += Vector2.new(vector2_2.X * v10 - v6, vector2_2.Y * v11 - v6)
	end

	if vector2 then
		targetAnchorPoint = Vector2.zero
		offset = vector2
	end

	return {
		targetAnchorPoint = targetAnchorPoint,
		subjectAnchorPoint = vector2_2,
		offset = offset
	}
end

return getPanelPosition
