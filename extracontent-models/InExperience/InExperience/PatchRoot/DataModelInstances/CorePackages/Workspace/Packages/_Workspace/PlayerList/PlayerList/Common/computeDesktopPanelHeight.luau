local parent = script.Parent.Parent
local Constants = require(parent.Common.Constants)

local function computeDesktopPanelHeight(p: number, p2: number, p3: number)
	return (math.max(math.min(p2, p * Constants.DESKTOP_MAX_VIEWPORT_FRACTION), p3))
end

return computeDesktopPanelHeight
