local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local Milestone = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker.Milestone

local function SduiReportSurfaceLoadTimeMilestoneAction(p1, _, p3, _) -- line: 23
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), getSduiClientPageScope (copy), SduiSurfaceLoadTimeTracker (copy), Milestone (copy)
	local v14 = p3.dependencies and p3.dependencies.logger
	local configKey = p3.configKey
	local v16 = p1 and p1.actionParams

	if not v16 or not configKey then
		if v14 then
			v14.reportError(SduiErrorType.InvalidActionParams, {
				message = "Missing actionParams",
				name = SduiActionType.ReportSurfaceLoadTimeMilestone
			}, p3.appPage)
		end

		return
	end

	local v17 = getSduiClientPageScope(configKey).get(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY)

	if not v17 then
		if v14 then
			v14.reportError(SduiErrorType.InvalidActionParams, {
				name = SduiActionType.ReportSurfaceLoadTimeMilestone,
				message = `No surface load timer in page scope for configKey={ configKey }`
			}, p3.appPage)
		end

		return
	end

	local milestone = v16.milestone

	if typeof(milestone) ~= "string" then
		if v14 then
			v14.reportError(SduiErrorType.InvalidActionParams, {
				name = SduiActionType.ReportSurfaceLoadTimeMilestone,
				message = `Missing or invalid milestone param, got { typeof(milestone) }`
			}, p3.appPage)
		end

		return
	end

	local v19 = if typeof(v16.metadata) ~= "table" then nil else v16.metadata

	if milestone == Milestone.SurfaceReady then
		v17.trackSurfaceReady(v19)

		return
	end

	v17.trackOnce(milestone)
end

return SduiReportSurfaceLoadTimeMilestoneAction
