local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/UniversalAppPolicy")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagAppIaScrollAwayGuac = SharedFlags.FFlagAppIaScrollAwayGuac
local defineFastFlag = game:DefineFastFlag("EnableFlyoutWithScrollAway2", false)
local flyoutSidePanelIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedExperimentDefinition").FlyoutSidePanelIXP

local function getScrollAwayEnabled(): boolean
	if
		not fFlagAppIaScrollAway
		or fFlagAppIaScrollAwayGuac and not UniversalAppPolicy.getAppFeaturePolicies().getAppIaScrollAwayEnabled()
	then
		return false
	end

	if defineFastFlag and flyoutSidePanelIXP.isScrollAwayEnabled() then
		return true
	end

	return false
end

local v5 = nil

return function()
	if v5 ~= nil then
		return v5
	end

	v5 = if fFlagAppIaScrollAway and (not fFlagAppIaScrollAwayGuac or UniversalAppPolicy.getAppFeaturePolicies().getAppIaScrollAwayEnabled()) then defineFastFlag and flyoutSidePanelIXP.isScrollAwayEnabled() and true or false else false

	return v5
end
