local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

local initiateTransfer = require(CurrencyTransfers.Actions.Send.initiateTransfer)
local processTransfer = require(CurrencyTransfers.Actions.Send.processTransfer)
local acceptTransfer = require(CurrencyTransfers.Actions.Receive.acceptTransfer)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local TransferRetryOrigin = require(CurrencyTransfers.Enums.TransferRetryOrigin)

local AmpWizardTransferConstants = require(CurrencyTransfers.Constants.AmpWizardTransferConstants)
local getCounterUserId = require(CurrencyTransfers.Utils.getCounterUserId)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)

local AmpUpsell = require(parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext

local function SubscriptionUpsellContainer(p)
	local v = useTransferStore()
	local v2 = useLocalization(TransferLocalizationKeys.Presets.SubscriptionUpsellContainer)
	local direction = p.direction
	local triggerOnClose = v.triggerOnClose
	local selectedAmount = v.getSelectedAmount(false)
	local transferRetryOrigin = v.getTransferRetryOrigin(false)
	local surfaceContext

	if v.getTransferOrigination(false) == TransferOrigination.InExperience then
		surfaceContext = SurfaceContext.InGame
	else
		surfaceContext = SurfaceContext.InApp
	end

	local transferClientSessionId = v.getTransferClientSessionId(false)
	local analyticsContext = SharedFlags.FFlagEnableRobuxTransferFlowEventIngest and transferClientSessionId ~= "" and {
		clientSessionId = {
			clientSessionIdType = RobloxSubscriptionPurchaseApp.PurchaseClientSessionIdType.CurrencyTransferSessionId,
			clientSessionId = transferClientSessionId
		}
	} or nil

	local v3 = {
		purchaseUIOptions = {
			title = v2.UpsellSubscriptionTitle or ""
		},
		surfaceName = SurfaceName.RobuxTransferUpsell,
		surfaceContext = surfaceContext,
		analyticsContext = analyticsContext
	}

	React.useEffect(function()
		if not p.ampFeatureCheck then
			triggerOnClose()
			return
		end

		logCurrencyTransferCounter(v, CurrencyTransferTelemetry.CurrencyTransferSubscriptionUpsellWizardOpenedCounter, {
			recourseSurface = "subscription"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v, RobuxTransferFlowEventName.subscription_upsell_wizard_opened)
		end

		local promptState = v.getPromptState(false)
		v.setPreviousPromptState(promptState)
		v.setPromptState(PromptState.Hidden)

		local counterUserId = getCounterUserId(v, direction)

		local v4 = counterUserId and {
			{ name = "targetUser", value = tostring(counterUserId), type = "UserId" }
		} or nil

		InExpAmpWizardController.OpenAmpWizardContainerInExp(p.ampFeatureCheck, function(p2, _)
			if p2 == AccessResponseEnum.Granted then
				logCurrencyTransferCounter(
					v,
					CurrencyTransferTelemetry.CurrencyTransferSubscriptionUpsellWizardResultGrantedCounter,
					{ recourseSurface = "subscription" }
				)

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(v, RobuxTransferFlowEventName.subscription_upsell_wizard_result_granted)
				end

				local previousPromptState = v.getPreviousPromptState(false)

				if previousPromptState then
					v.setPromptState(previousPromptState)
				end

				if transferRetryOrigin == TransferRetryOrigin.AcceptTransfer then
					acceptTransfer(v)
				elseif transferRetryOrigin == TransferRetryOrigin.InitiateTransfer then
					initiateTransfer(v)
				elseif transferRetryOrigin == TransferRetryOrigin.ProcessTransfer then
					processTransfer(v, selectedAmount or 0)
				elseif direction == TransferDirection.Receive then
					acceptTransfer(v)
				else
					processTransfer(v, selectedAmount or 0)
				end
			else
				logCurrencyTransferCounter(
					v,
					CurrencyTransferTelemetry.CurrencyTransferSubscriptionUpsellWizardResultDeniedCounter,
					{ recourseSurface = "subscription" }
				)

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(v, RobuxTransferFlowEventName.subscription_upsell_wizard_result_denied)
				end

				triggerOnClose()
			end
		end, v3, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, v4, AmpWizardTransferConstants.NAMESPACE_NAME)
	end, {})

	return React.createElement(React.Fragment, {})
end

return SubscriptionUpsellContainer
