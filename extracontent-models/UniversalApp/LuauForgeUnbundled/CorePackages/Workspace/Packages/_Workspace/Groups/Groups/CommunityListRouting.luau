local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Display")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Responsive")
require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Signals")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SharedFlags")
local fFlagEnableLuaCommunityList = SharedFlags.FFlagEnableLuaCommunityList
local fFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane

local function getIsCompactTouch(p2)
	local viewportSize = Display.GetDisplayStore(false).getViewportSize(p2)
	local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(p2)
	return Responsive.getIsCompactTouch(viewportSize, preferredInputType)
end

local function getIsDirectionalInput(): boolean
	return Responsive.GetInputModeStore(false).getPreferredInputType(false) == Responsive.Input.Directional
end

return {
	getIsCompactTouch = getIsCompactTouch,
	getShouldOpenGroupOverviewPane = function()
		if not (fFlagEnableGroupOverviewPane and Responsive.GetInputModeStore(false).getPreferredInputType(false) ~= Responsive.Input.Directional) then
			return false
		end

		return getIsCompactTouch(false)
	end,
	getShouldUseLuaCommunityList = function()
		if not (fFlagEnableLuaCommunityList and Responsive.GetInputModeStore(false).getPreferredInputType(false) ~= Responsive.Input.Directional) then
			return false
		end

		if fFlagEnableGroupOverviewPane then
			return true
		end

		return getIsCompactTouch(false)
	end
}
