local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")

local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local function SduiActionSequenceAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.ActionSequence, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	local actions = actionParams.actions

	if typeof(actions) ~= "table" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ActionSequence,
				message = `Invalid actionParam: actions is {typeof(actions)}`,
				propName = "actions"
			},
			p4.appPage
		)
		return
	end

	local v5 = 0

	for k in actions do
		if typeof(k) == "number" and v5 < k then
			v5 = k
		end
	end

	for i = 1, v5 do
		local action = actions[i]

		if action == nil then
			continue
		end

		if typeof(action) == "function" then
			local success, result = pcall(action, nil, p5)

			if not success then
				p4.dependencies.logger.reportError(sduiErrorType.FailedToExecuteAction, {
					name = sduiActionType.ActionSequence,
					message = `Child action at index {i} failed: ` .. sduiParseHelpers.stringifyValue(result)
				}, p4.appPage)
			end
		else
			p4.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = sduiActionType.ActionSequence,
					message = `Child action at index {i} is not callable: {typeof(action)}`,
					propName = "actions"
				},
				p4.appPage
			)
		end
	end
end

return SduiActionSequenceAction
