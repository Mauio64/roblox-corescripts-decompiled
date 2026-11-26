local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local IncomingTransferHomepagePromptDismiss = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/IncomingTransferHomepagePromptDismiss")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/NavigationRodux").Thunks.NavigateDown
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/RobloxAppNavigation").NavigationCommands else nil

local fFlagSduiDismissPromptPageScope = SharedFlags.FFlagSduiDismissPromptPageScope

local function parseTransferRequestIdFromUrl(url)
	local v5 = string.lower(url)

	local v6 = string.find(v5, "transferrequestid=", 1, true)

	if not v6 then
		return nil
	end

	local v7 = string.sub(url, v6 + 18)
	local v8 = string.find(v7, "&", 1, true)

	if v8 then
		v7 = string.sub(v7, 1, v8 - 1)
	end

	if v7 == "" then
		return nil
	end

	return v7
end

local function resolveTransferId(p2)
	local transferId = p2.transferId

	if typeof(transferId) == "string" and transferId ~= "" then
		return transferId
	end

	local url = p2.url

	if typeof(url) == "string" and url ~= "" then
		return parseTransferRequestIdFromUrl(url)
	end

	return nil
end

local function SduiOpenIncomingTransferUpsellAction(p2, p3, data)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenIncomingTransferUpsell,
				message = "Missing actionParams"
			},
			data.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local v5 = actionParams.transferId

	if typeof(v5) ~= "string" or v5 == "" then
		local url = actionParams.url
		v5 = if typeof(url) == "string" and url ~= "" then parseTransferRequestIdFromUrl(url) else nil
	end

	if v5 == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenIncomingTransferUpsell,
				message = "Invalid or missing transferId (set transferId or url with transferrequestid)",
				propName = "transferId"
			},
			data.appPage
		)
		return
	end

	local promptType = actionParams.promptType

	if typeof(promptType) ~= "string" then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenIncomingTransferUpsell,
				message = `Invalid or missing promptType: {promptType}`,
				propName = "promptType"
			},
			data.appPage
		)
		return
	end

	local promptId = actionParams.promptId

	if promptId ~= nil and typeof(promptId) ~= "string" then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenIncomingTransferUpsell,
				message = `Invalid promptId: {promptId}`,
				propName = "promptId"
			},
			data.appPage
		)
		return
	end

	local networking = data.dependencies.networking

	local createCallbacks = IncomingTransferHomepagePromptDismiss.createCallbacks
	local v6 = {
		networking = networking,
		promptId = promptId,
		optimisticHidePromptType = promptType,
		onReportPromptDismissFailed = function(p4)
			data.dependencies.logger.reportError(sduiErrorType.ActionNetworkRequestFailed, {
				name = sduiActionType.OpenIncomingTransferUpsell,
				message = "reportPromptDismiss failed: " .. sduiParseHelpers.stringifyValue(p4)
			}, data.appPage)
		end,
		configKey = 0
	}
	local v7 = if fFlagSduiDismissPromptPageScope then data.configKey else nil
	v6.configKey = v7
	local callbacks = createCallbacks(v6)

	local v8 = {
		name = appPage.TransferRobuxFlow,
		extraProps = {
			direction = "receive",
			transferId = v5,
			onPromptOptimisticHide = callbacks.optimisticHide,
			onPromptDismissCommitted = callbacks.commitDismiss
		}
	}

	if fFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v8))
	else
		data.dependencies.dispatch(navigateDown(v8))
	end
end

return SduiOpenIncomingTransferUpsellAction
