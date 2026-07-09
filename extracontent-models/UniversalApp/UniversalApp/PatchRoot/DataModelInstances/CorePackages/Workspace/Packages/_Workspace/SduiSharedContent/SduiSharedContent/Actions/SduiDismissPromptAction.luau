local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local SduiSharedContentParent = SduiSharedContent.Parent
local SduiCoreSystem = require(SduiSharedContentParent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local SduiSharedUtilities = require(SduiSharedContentParent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local reportPromptDismiss = require(SduiSharedContent.Actions.reportPromptDismiss)

local function SduiDismissPromptAction(p1, _, p3) -- line: 19
	-- upvalues: SduiErrorType (copy), getSduiApiStore (copy), reportPromptDismiss (copy), SduiLoadTimer (copy), SduiParseHelpers (copy)
	local v14 = p1 and p1.actionParams or nil

	if v14 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "DismissPrompt",
			message = "Missing actionParams"
		}, p3.appPage)

		return
	end

	assert(v14, "actionParams must exist")

	local promptType = v14.promptType

	if typeof(promptType) ~= "string" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "DismissPrompt",
			propName = "promptType",
			message = `Invalid or missing promptType: { promptType }`
		}, p3.appPage)

		return
	end

	local promptId = v14.promptId

	if promptId ~= nil and typeof(promptId) ~= "string" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "DismissPrompt",
			propName = "promptId",
			message = `Invalid promptId: { promptId }`
		}, p3.appPage)

		return
	end

	local v17 = getSduiApiStore()
	local v18 = v17.dismissEntry(promptType)
	local networking = p3.dependencies.networking

	reportPromptDismiss(networking, promptType, promptId):andThen(function() -- line: 71
		-- upvalues: v18 (copy), v17 (copy), SduiLoadTimer (copy)
		for _, v21 in v18 do
			v17.refreshFromApi({
				configKey = v21,
				loadTimer = SduiLoadTimer.createLoadTimer(v21)
			})
		end
	end):catch(function(p4) -- line: 79
		-- upvalues: p3 (copy), SduiErrorType (copy), SduiParseHelpers (copy)
		p3.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
			name = "DismissPrompt",
			message = "reportPromptDismiss failed: " .. SduiParseHelpers.stringifyValue(p4)
		}, p3.appPage)
	end)
end

return SduiDismissPromptAction
