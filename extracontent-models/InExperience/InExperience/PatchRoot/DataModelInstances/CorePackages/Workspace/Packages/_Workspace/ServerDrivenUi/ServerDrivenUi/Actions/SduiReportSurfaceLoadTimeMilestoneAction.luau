local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker

local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local Milestone = TimeToInteractiveTracker.TimeToInteractiveTracker.Milestone

local function SduiReportSurfaceLoadTimeMilestoneAction(p, _, data, _)
	local logger = data.dependencies and data.dependencies.logger
	local configKey = data.configKey
	local actionParams = p and p.actionParams

	if actionParams and configKey then
		local v = getSduiClientPageScope(configKey).get(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY)

		if v then
			local milestone = actionParams.milestone

			if typeof(milestone) == "string" then
				local metadata

				if typeof(actionParams.metadata) == "table" then
					metadata = actionParams.metadata
				end

				if milestone == Milestone.SurfaceReady then
					v.trackSurfaceReady(metadata)
				else
					v.trackOnce(milestone)
				end
			elseif logger then
				logger.reportError(
					SduiErrorType.InvalidActionParams,
					{
						name = SduiActionType.ReportSurfaceLoadTimeMilestone,
						message = `Missing or invalid milestone param, got {typeof(milestone)}`
					},
					data.appPage
				)
			end
		elseif logger then
			logger.reportError(
				SduiErrorType.InvalidActionParams,
				{
					name = SduiActionType.ReportSurfaceLoadTimeMilestone,
					message = `No surface load timer in page scope for configKey={configKey}`
				},
				data.appPage
			)
		end
	elseif logger then
		logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.ReportSurfaceLoadTimeMilestone,
				message = "Missing actionParams"
			},
			data.appPage
		)
	end
end

return SduiReportSurfaceLoadTimeMilestoneAction
