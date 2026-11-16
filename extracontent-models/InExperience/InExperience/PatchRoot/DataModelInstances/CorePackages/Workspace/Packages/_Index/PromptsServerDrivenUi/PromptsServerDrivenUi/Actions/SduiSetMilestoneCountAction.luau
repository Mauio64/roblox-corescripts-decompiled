local PromptsServerDrivenUi = script:FindFirstAncestor("PromptsServerDrivenUi")
local parent = PromptsServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local setMilestoneCount = require(PromptsServerDrivenUi.Actions.setMilestoneCount)

local function SduiSetMilestoneCountAction(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "SetMilestoneCount", message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local milestoneId = actionParams.milestoneId

	if typeof(milestoneId) ~= "string" or milestoneId == "" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "SetMilestoneCount",
				message = `Invalid or missing milestoneId: {milestoneId}`,
				propName = "milestoneId"
			},
			p2.appPage
		)
		return
	end

	local count = actionParams.count

	if typeof(count) == "number" and not (count < 0) and not (count > 2147483647) and count == math.floor(count) then
		setMilestoneCount(p2.dependencies.networking, milestoneId, count):catch(function(p3)
			p2.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
				name = "SetMilestoneCount",
				message = "setMilestoneCount failed: " .. SduiParseHelpers.stringifyValue(p3)
			}, p2.appPage)
		end)
	else
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "SetMilestoneCount",
				message = `Invalid or missing count: {count}`,
				propName = "count"
			},
			p2.appPage
		)
	end
end

return SduiSetMilestoneCountAction
