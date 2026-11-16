local parent = script:FindFirstAncestor("Groups").Parent

local Display = require(parent.Display)
local Responsive = require(parent.Responsive)
require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableLuaCommunityList = SharedFlags.FFlagEnableLuaCommunityList
local FFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane

local function getIsCompactTouch(p)
	local viewportSize = Display.GetDisplayStore(false).getViewportSize(p)
	local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(p)
	return Responsive.getIsCompactTouch(viewportSize, preferredInputType)
end

local function getIsDirectionalInput(): boolean -- 2 equivalent calls inferred from this helper
	return Responsive.GetInputModeStore(false).getPreferredInputType(false) == Responsive.Input.Directional
end

local CommunityListRouting = {}
CommunityListRouting.getIsCompactTouch = getIsCompactTouch

function CommunityListRouting.getShouldOpenGroupOverviewPane()
	if not FFlagEnableGroupOverviewPane or getIsDirectionalInput() then -- inferred equivalent call
		return false
	end

	return getIsCompactTouch(false)
end

function CommunityListRouting.getShouldUseLuaCommunityList()
	if not FFlagEnableLuaCommunityList or getIsDirectionalInput() then -- inferred equivalent call
		return false
	end

	if FFlagEnableGroupOverviewPane then
		return true
	end

	return getIsCompactTouch(false)
end

return CommunityListRouting
