local PromptsServerDrivenUi = script:FindFirstAncestor("PromptsServerDrivenUi")
local parent = PromptsServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local incrementMilestoneCount = require(PromptsServerDrivenUi.Actions.incrementMilestoneCount)

local function SduiIncrementMilestoneCountAction(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "IncrementMilestoneCount", message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local milestoneId = actionParams.milestoneId

	if typeof(milestoneId) == "string" and milestoneId ~= "" then
		incrementMilestoneCount(p2.dependencies.networking, milestoneId):catch(function(p3)
			p2.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
				name = "IncrementMilestoneCount",
				message = "incrementMilestoneCount failed: " .. SduiParseHelpers.stringifyValue(p3)
			}, p2.appPage)
		end)
	else
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "IncrementMilestoneCount",
				message = `Invalid or missing milestoneId: {milestoneId}`,
				propName = "milestoneId"
			},
			p2.appPage
		)
	end
end

return SduiIncrementMilestoneCountAction
