local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(Foundation.Components.Types)

local FoundationImages = require(parent.FoundationImages)

local function getScaledSlice(center: Rect?, scale: number?)
	local resolutionScale = FoundationImages.getResolutionScale()

	if center then
		local v = center.Min * resolutionScale
		local v2 = center.Max * resolutionScale
		center = Rect.new(v, v2)
		scale = (scale or 1) / resolutionScale
	end

	return { center = center, scale = scale }
end

return getScaledSlice
