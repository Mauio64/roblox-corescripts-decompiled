local ParentParent = script.Parent.Parent
local UniversalAppPolicy = require(ParentParent.UniversalAppPolicy)
local SharedFlags = require(ParentParent.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAppIaScrollAwayGuac = SharedFlags.FFlagAppIaScrollAwayGuac
local v6 = game:DefineFastFlag("EnableFlyoutWithScrollAway2", false)
local FlyoutSidePanelIXP = require(ParentParent.SharedExperimentDefinition).FlyoutSidePanelIXP

local function getScrollAwayEnabled() -- line: 12
	-- upvalues: FFlagAppIaScrollAway (copy), FFlagAppIaScrollAwayGuac (copy), UniversalAppPolicy (copy), v6 (copy), FlyoutSidePanelIXP (copy)
	if not FFlagAppIaScrollAway then
		return false
	end

	if FFlagAppIaScrollAwayGuac and not UniversalAppPolicy.getAppFeaturePolicies().getAppIaScrollAwayEnabled() then
		return false
	end

	if v6 and FlyoutSidePanelIXP.isScrollAwayEnabled() then
		return true
	end

	return false
end

local u9 = nil

return function() -- line: 29
	-- upvalues: u9 (ref), FFlagAppIaScrollAway (copy), FFlagAppIaScrollAwayGuac (copy), UniversalAppPolicy (copy), v6 (copy), FlyoutSidePanelIXP (copy)
	if u9 == nil then
		u9 = if FFlagAppIaScrollAway then if not FFlagAppIaScrollAwayGuac or UniversalAppPolicy.getAppFeaturePolicies().getAppIaScrollAwayEnabled() then not not v6 and not not FlyoutSidePanelIXP.isScrollAwayEnabled() else false else false
	end

	return u9
end
