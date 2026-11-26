local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local setMilestoneCount = require("@game/CorePackages/Workspace/Packages/_Index/PromptsServerDrivenUi/PromptsServerDrivenUi/Actions/setMilestoneCount")

local function SduiSetMilestoneCountAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = "SetMilestoneCount", message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	local milestoneId = actionParams.milestoneId

	if typeof(milestoneId) ~= "string" or milestoneId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "SetMilestoneCount",
				message = `Invalid or missing milestoneId: {milestoneId}`,
				propName = "milestoneId"
			},
			p4.appPage
		)
		return
	end

	local count = actionParams.count

	if
		typeof(count) == "number"
		and not (count < 0)
		and not (count > 2147483647)
		and count == math.floor(count)
	then
		setMilestoneCount(p4.dependencies.networking, milestoneId, count):catch(function(p5)
			p4.dependencies.logger.reportError(sduiErrorType.ActionNetworkRequestFailed, {
				name = "SetMilestoneCount",
				message = "setMilestoneCount failed: " .. sduiParseHelpers.stringifyValue(p5)
			}, p4.appPage)
		end)
	else
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "SetMilestoneCount",
				message = `Invalid or missing count: {count}`,
				propName = "count"
			},
			p4.appPage
		)
	end
end

return SduiSetMilestoneCountAction
