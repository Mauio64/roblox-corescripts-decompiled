local parent = script.Parent.Parent

local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAppIaScrollAwayGuac = SharedFlags.FFlagAppIaScrollAwayGuac
local defineFastFlag = game:DefineFastFlag("EnableFlyoutWithScrollAway2", false)
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutSidePanelIXP = SharedExperimentDefinition.FlyoutSidePanelIXP

local function getScrollAwayEnabled(): boolean -- 1 equivalent call inferred from this helper
	if
		not FFlagAppIaScrollAway
		or FFlagAppIaScrollAwayGuac and not UniversalAppPolicy.getAppFeaturePolicies().getAppIaScrollAwayEnabled()
	then
		return false
	end

	if defineFastFlag and FlyoutSidePanelIXP.isScrollAwayEnabled() then
		return true
	end

	return false
end

local v = nil

return function()
	if v == nil then
		v = getScrollAwayEnabled() -- inferred equivalent call
	end

	return v
end
