local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(Foundation.Components.Types)

local FoundationImages = require(FoundationParent.FoundationImages)

local function getScaledSlice(rect: Rect?, n1: number?) -- line: 9
	-- upvalues: FoundationImages (copy)
	local v7 = FoundationImages.getResolutionScale()

	if rect then
		local v8 = rect.Min * v7
		local v9 = rect.Max * v7

		rect = Rect.new(v8, v9)
		n1 = (n1 or 1) / v7
	end

	return {
		center = rect,
		scale = n1
	}
end

return getScaledSlice
