local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local Promise = require(parent.Promise)
local SduiCoreSystem = require(parent.SduiCoreSystem)

local getSduiContentReactionVerticalRegistry = require(SduiSharedContent.Actions.getSduiContentReactionVerticalRegistry)

local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getStringParam = SduiCoreSystem.SduiActionParams.getStringParam

local v = { "entityId", "vertical", "emoteId" }

local function rejectInvalidParams(p, message: string, propName: string?)
	p.dependencies.logger.reportError(
		SduiErrorType.InvalidActionParams,
		{ name = SduiActionType.ToggleContentReaction, message = message, propName = propName },
		p.appPage
	)
	return Promise.reject(message)
end

local function SduiToggleContentReactionAction(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		return rejectInvalidParams(p2, "Missing actionParams", nil)
	end

	for _, v2 in v do
		local stringParam = getStringParam(actionParams, v2)

		if stringParam == nil or stringParam == "" then
			return rejectInvalidParams(p2, `Missing actionParam: {v2}`, v2)
		end
	end

	local shouldAdd = actionParams.shouldAdd

	if typeof(shouldAdd) ~= "boolean" then
		return rejectInvalidParams(p2, "actionParam shouldAdd must be a boolean", "shouldAdd")
	end

	local vertical = actionParams.vertical
	local vertical2 = getSduiContentReactionVerticalRegistry().getVertical(vertical)

	if vertical2 == nil then
		return rejectInvalidParams(p2, `No content reaction adapter for vertical: {vertical}`, "vertical")
	end

	return Promise.try(vertical2.toggle, {
		entityId = actionParams.entityId,
		vertical = vertical,
		emoteId = actionParams.emoteId,
		shouldAdd = shouldAdd
	}):catch(function(p3)
		p2.dependencies.logger.reportError(
			SduiErrorType.FailedToExecuteAction,
			{ name = SduiActionType.ToggleContentReaction, message = tostring(p3) },
			p2.appPage
		)
		return Promise.reject(p3)
	end)
end

return SduiToggleContentReactionAction
