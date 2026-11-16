local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local incrementMilestoneCount = require("@game/CorePackages/Workspace/Packages/_Index/PromptsServerDrivenUi/PromptsServerDrivenUi/Actions/incrementMilestoneCount")

local function SduiIncrementMilestoneCountAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = "IncrementMilestoneCount", message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	local milestoneId = actionParams.milestoneId

	if typeof(milestoneId) == "string" and milestoneId ~= "" then
		incrementMilestoneCount(p4.dependencies.networking, milestoneId):catch(function(p5)
			p4.dependencies.logger.reportError(sduiErrorType.ActionNetworkRequestFailed, {
				name = "IncrementMilestoneCount",
				message = "incrementMilestoneCount failed: " .. sduiParseHelpers.stringifyValue(p5)
			}, p4.appPage)
		end)
	else
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "IncrementMilestoneCount",
				message = `Invalid or missing milestoneId: {milestoneId}`,
				propName = "milestoneId"
			},
			p4.appPage
		)
	end
end

return SduiIncrementMilestoneCountAction
