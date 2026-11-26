local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities")
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local sduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker

local milestone = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/TimeToInteractiveTracker").TimeToInteractiveTracker.Milestone

local function SduiReportSurfaceLoadTimeMilestoneAction(p2, p3, data, p4)
	local logger = data.dependencies and data.dependencies.logger
	local configKey = data.configKey
	local actionParams = p2 and p2.actionParams

	if actionParams and configKey then
		local v5 = getSduiClientPageScope(configKey).get(sduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY)

		if v5 then
			local milestone2 = actionParams.milestone

			if typeof(milestone2) == "string" then
				local metadata = if typeof(actionParams.metadata) == "table" then actionParams.metadata else nil

				if milestone2 == milestone.SurfaceReady then
					v5.trackSurfaceReady(metadata)
				else
					v5.trackOnce(milestone2)
				end
			elseif logger then
				logger.reportError(
					sduiErrorType.InvalidActionParams,
					{
						name = sduiActionType.ReportSurfaceLoadTimeMilestone,
						message = `Missing or invalid milestone param, got {typeof(milestone2)}`
					},
					data.appPage
				)
			end
		elseif logger then
			logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = sduiActionType.ReportSurfaceLoadTimeMilestone,
					message = `No surface load timer in page scope for configKey={configKey}`
				},
				data.appPage
			)
		end
	elseif logger then
		logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ReportSurfaceLoadTimeMilestone,
				message = "Missing actionParams"
			},
			data.appPage
		)
	end
end

return SduiReportSurfaceLoadTimeMilestoneAction
