local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local IncomingTransferHomepagePromptDismiss = require(CurrencyTransfers.Utils.IncomingTransferHomepagePromptDismiss)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local FFlagSduiDismissPromptPageScope = SharedFlags.FFlagSduiDismissPromptPageScope

local function parseTransferRequestIdFromUrl(url: string)
	local v = string.lower(url)

	local v2 = string.find(v, "transferrequestid=", 1, true)

	if not v2 then
		return nil
	end

	local selected = string.sub(url, v2 + 18)
	local v3 = string.find(selected, "&", 1, true)

	if v3 then
		selected = string.sub(selected, 1, v3 - 1)
	end

	return if selected ~= "" then selected else nil
end

local function resolveTransferId(actionParams) -- 1 equivalent call inferred from this helper
	local transferId = actionParams.transferId

	if typeof(transferId) == "string" and transferId ~= "" then
		return transferId
	end

	local url = actionParams.url

	if typeof(url) == "string" and url ~= "" then
		return parseTransferRequestIdFromUrl(url)
	end

	return nil
end

local function SduiOpenIncomingTransferUpsellAction(p, _, data)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenIncomingTransferUpsell, message = "Missing actionParams" },
			data.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local transferId = resolveTransferId(actionParams) -- inferred equivalent call

	if transferId == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenIncomingTransferUpsell,
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
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenIncomingTransferUpsell,
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
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenIncomingTransferUpsell,
				message = `Invalid promptId: {promptId}`,
				propName = "promptId"
			},
			data.appPage
		)
		return
	end

	local networking = data.dependencies.networking

	local createCallbacks = IncomingTransferHomepagePromptDismiss.createCallbacks
	local v = {
		networking = networking,
		promptId = promptId,
		optimisticHidePromptType = promptType,
		onReportPromptDismissFailed = function(p2)
			data.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
				name = SduiActionType.OpenIncomingTransferUpsell,
				message = "reportPromptDismiss failed: " .. SduiParseHelpers.stringifyValue(p2)
			}, data.appPage)
		end,
		configKey = 0
	}
	local configKey

	if FFlagSduiDismissPromptPageScope then
		configKey = data.configKey
	end

	v.configKey = configKey
	local callbacks = createCallbacks(v)

	local v2 = {
		name = AppPage.TransferRobuxFlow,
		extraProps = {
			direction = "receive",
			transferId = transferId,
			onPromptOptimisticHide = callbacks.optimisticHide,
			onPromptDismissCommitted = callbacks.commitDismiss
		}
	}

	if FFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v2))
	else
		data.dependencies.dispatch(NavigateDown(v2))
	end
end

return SduiOpenIncomingTransferUpsellAction
