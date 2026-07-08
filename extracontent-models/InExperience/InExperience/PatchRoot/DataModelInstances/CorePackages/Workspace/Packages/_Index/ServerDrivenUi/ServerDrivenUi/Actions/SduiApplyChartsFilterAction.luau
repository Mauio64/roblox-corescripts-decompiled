local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiLoadTimer = require(Parent.SduiSharedUtilities).SduiLoadTimer
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

return function(p1, _, p3) -- line: 15
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), Parent (copy), getSduiClientPageScope (copy), SduiLoadTimer (copy)
	local v10 = p1 and p1.actionParams or nil

	if v10 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.ApplyChartsFilter
		}, p3.appPage)

		return
	end

	if p3.configKey == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing sduiContext.configKey; filter selections cannot be persisted in client page scope",
			name = SduiActionType.ApplyChartsFilter
		}, p3.appPage)

		return
	end

	local filterSelections = v10.filterSelections
	local Charts = require(Parent.Charts)

	getSduiClientPageScope(p3.configKey).set(Charts.ChartsPageScopeFields.FilterSelections, filterSelections)

	local v13 = SduiLoadTimer.createLoadTimer("ChartsPage")

	v13.start("filter_refetch")

	local v14 = Charts.fetchChartsPage(v13, true)

	if v14 then
		v14:finally(function() -- line: 46
			-- upvalues: v13 (copy)
			v13.logRefreshComplete()
		end)
	end

	return v14
end
