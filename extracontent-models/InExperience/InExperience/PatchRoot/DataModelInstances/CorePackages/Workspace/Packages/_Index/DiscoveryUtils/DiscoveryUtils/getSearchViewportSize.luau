local parent = script:FindFirstAncestor("DiscoveryUtils").Parent

local function getSearchViewportSize()
	local Display = require(parent.Display)
	local displayStore = Display.GetDisplayStore(false)
	local viewportSize = displayStore.getViewportSize(false)

	if viewportSize.X <= 1 or viewportSize.Y <= 1 then
		return nil
	end

	local platformScale = displayStore.getPlatformScale(false)

	if platformScale and platformScale > 0 then
		viewportSize /= platformScale
	end

	return viewportSize
end

return getSearchViewportSize
