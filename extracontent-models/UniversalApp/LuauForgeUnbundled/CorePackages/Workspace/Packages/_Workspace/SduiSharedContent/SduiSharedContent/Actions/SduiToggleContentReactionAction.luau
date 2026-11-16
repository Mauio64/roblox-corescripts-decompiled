local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Promise")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")

local getSduiContentReactionVerticalRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/getSduiContentReactionVerticalRegistry")

local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getStringParam = SduiCoreSystem.SduiActionParams.getStringParam

local v5 = { "entityId", "vertical", "emoteId" }

local function rejectInvalidParams(p2, p3, p4)
	p2.dependencies.logger.reportError(
		sduiErrorType.InvalidActionParams,
		{ name = sduiActionType.ToggleContentReaction, message = p3, propName = p4 },
		p2.appPage
	)
	return Promise.reject(p3)
end

local function SduiToggleContentReactionAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		return rejectInvalidParams(p4, "Missing actionParams", nil)
	end

	for k, v6 in v5 do
		local stringParam = getStringParam(actionParams, v6)

		if stringParam == nil or stringParam == "" then
			return rejectInvalidParams(p4, `Missing actionParam: {v6}`, v6)
		end
	end

	local shouldAdd = actionParams.shouldAdd

	if typeof(shouldAdd) ~= "boolean" then
		return rejectInvalidParams(p4, "actionParam shouldAdd must be a boolean", "shouldAdd")
	end

	local vertical = actionParams.vertical
	local vertical2 = getSduiContentReactionVerticalRegistry().getVertical(vertical)

	if vertical2 == nil then
		return rejectInvalidParams(p4, `No content reaction adapter for vertical: {vertical}`, "vertical")
	end

	return Promise.try(vertical2.toggle, {
		entityId = actionParams.entityId,
		vertical = vertical,
		emoteId = actionParams.emoteId,
		shouldAdd = shouldAdd
	}):catch(function(p6)
		p4.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{ name = sduiActionType.ToggleContentReaction, message = tostring(p6) },
			p4.appPage
		)
		return Promise.reject(p6)
	end)
end

return SduiToggleContentReactionAction
