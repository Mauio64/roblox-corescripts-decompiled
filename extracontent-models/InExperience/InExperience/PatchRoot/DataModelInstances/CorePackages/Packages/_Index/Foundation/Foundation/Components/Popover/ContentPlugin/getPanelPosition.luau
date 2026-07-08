local Foundation = script:FindFirstAncestor("Foundation")
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)

require(Foundation.Providers.StudioPanels.Types)

local function getPanelPosition(p1, p2, vector2: Vector2?, n1: number?, n2: number?) -- line: 24
	-- upvalues: PopoverAlign (copy), PopoverSide (copy)
	local n3 = 0
	local n4 = 0

	if type(p1) == "table" then
		n3 = p1.offset
		p1 = p1.position
	end

	if type(p2) == "table" then
		n4 = p2.offset
		p2 = p2.position
	end

	local v12 = n4
	local v13 = n3 + (n2 or 0)
	local n5 = 0

	if p2 == PopoverAlign.Center then
		n5 = 0.5
		n4 = 0
	elseif p2 == PopoverAlign.End then
		n5 = 1
		n4 = -n4
	end

	local vector2_2 = nil
	local vector2_3 = nil
	local vector2_4 = nil

	if p1 == PopoverSide.Top then
		vector2_2 = Vector2.new(n4, -v13)
		vector2_3 = Vector2.new(n5, 0)
		vector2_4 = Vector2.new(n5, 1)
	elseif p1 == PopoverSide.Bottom then
		vector2_2 = Vector2.new(n4, v13)
		vector2_3 = Vector2.new(n5, 1)
		vector2_4 = Vector2.new(n5, 0)
	elseif p1 == PopoverSide.Left then
		vector2_2 = Vector2.new(-v13, n4)
		vector2_3 = Vector2.new(0, n5)
		vector2_4 = Vector2.new(1, n5)
	elseif p1 == PopoverSide.Right then
		vector2_2 = Vector2.new(v13, n4)
		vector2_3 = Vector2.new(1, n5)
		vector2_4 = Vector2.new(0, n5)
	end

	local v18 = n1 or 0

	if v18 > 0 then
		local v19 = p1 == PopoverSide.Top or p1 == PopoverSide.Bottom
		local v20 = v18 * 2
		local v21 = v18 * 2
		local v22, v23

		if v19 then
			v22 = v20 + v12
			v23 = v21 + v13
		else
			v22 = v20 + v13
			v23 = v21 + v12
		end

		vector2_2 += Vector2.new(vector2_4.X * v22 - v18, vector2_4.Y * v23 - v18)
	end

	if vector2 then
		vector2_2 = vector2
		vector2_3 = Vector2.zero
	end

	return {
		targetAnchorPoint = vector2_3,
		subjectAnchorPoint = vector2_4,
		offset = vector2_2
	}
end

return getPanelPosition
