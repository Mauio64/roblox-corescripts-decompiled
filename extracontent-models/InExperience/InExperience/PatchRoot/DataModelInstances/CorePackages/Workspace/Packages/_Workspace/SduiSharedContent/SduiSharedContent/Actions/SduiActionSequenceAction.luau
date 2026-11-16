local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)

local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local function SduiActionSequenceAction(p, _, p2, p3)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.ActionSequence, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local actions = actionParams.actions

	if typeof(actions) ~= "table" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.ActionSequence,
				message = `Invalid actionParam: actions is {typeof(actions)}`,
				propName = "actions"
			},
			p2.appPage
		)
		return
	end

	local v = 0

	for k in actions do
		if typeof(k) == "number" and v < k then
			v = k
		end
	end

	for i = 1, v do
		local action = actions[i]

		if action == nil then
			continue
		end

		if typeof(action) == "function" then
			local success, result = pcall(action, nil, p3)

			if not success then
				p2.dependencies.logger.reportError(SduiErrorType.FailedToExecuteAction, {
					name = SduiActionType.ActionSequence,
					message = `Child action at index {i} failed: ` .. SduiParseHelpers.stringifyValue(result)
				}, p2.appPage)
			end
		else
			p2.dependencies.logger.reportError(
				SduiErrorType.InvalidActionParams,
				{
					name = SduiActionType.ActionSequence,
					message = `Child action at index {i} is not callable: {typeof(action)}`,
					propName = "actions"
				},
				p2.appPage
			)
		end
	end
end

return SduiActionSequenceAction
