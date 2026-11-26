local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")
local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")

local FFlagCurrencyTransferNoFreeTransfersRemainingUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/FFlagCurrencyTransferNoFreeTransfersRemainingUpsell")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Localization").Hooks.useLocalization

local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")

local initiateTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/initiateTransfer")
local processTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/processTransfer")
local acceptTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Receive/acceptTransfer")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
local TransferDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferDirection")
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")
local TransferRetryOrigin = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferRetryOrigin")

local AmpWizardTransferConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Constants/AmpWizardTransferConstants")
local getCounterUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/getCounterUserId")
local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local RobuxTransferFlowEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/RobuxTransferFlowEventName")
local logCurrencyTransferCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logCurrencyTransferCounter")
local logRobuxTransferFlowEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logRobuxTransferFlowEvent")

local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/AmpUpsell")
local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local inExpAmpWizardController = AmpUpsell.InExpAmpWizardController

local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/RobloxSubscriptionPurchaseApp")
local surfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local surfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext

local function SubscriptionUpsellContainer(p2)
	local v5 = useTransferStore()
	local v6 = useLocalization(TransferLocalizationKeys.Presets.SubscriptionUpsellContainer)
	local direction = p2.direction
	local triggerOnClose = v5.triggerOnClose
	local selectedAmount = v5.getSelectedAmount(false)
	local transferRetryOrigin = v5.getTransferRetryOrigin(false)
	local v7

	if v5.getTransferOrigination(false) == TransferOrigination.InExperience then
		v7 = surfaceContext.InGame
	else
		v7 = surfaceContext.InApp
	end

	local freeTransfersExhausted = v5.getFreeTransfersExhausted(false)
	local v8 = v6.UpsellSubscriptionTitle or ""

	if FFlagCurrencyTransferNoFreeTransfersRemainingUpsell and freeTransfersExhausted then
		v8 = v6.FreeTransfersExhaustedTitle
	end

	local transferClientSessionId = v5.getTransferClientSessionId(false)
	local v9 = SharedFlags.FFlagEnableRobuxTransferFlowEventIngest and transferClientSessionId ~= "" and {
		clientSessionId = {
			clientSessionIdType = RobloxSubscriptionPurchaseApp.PurchaseClientSessionIdType.CurrencyTransferSessionId,
			clientSessionId = transferClientSessionId
		}
	} or nil

	local v10 = {
		purchaseUIOptions = { title = v8 },
		surfaceName = surfaceName.RobuxTransferUpsell,
		surfaceContext = v7,
		analyticsContext = v9
	}

	React.useEffect(function()
		if not p2.ampFeatureCheck then
			triggerOnClose()
			return
		end

		logCurrencyTransferCounter(v5, CurrencyTransferTelemetry.CurrencyTransferSubscriptionUpsellWizardOpenedCounter, {
			recourseSurface = "subscription"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v5, RobuxTransferFlowEventName.subscription_upsell_wizard_opened)
		end

		local promptState = v5.getPromptState(false)
		v5.setPreviousPromptState(promptState)
		v5.setPromptState(PromptState.Hidden)

		local v11 = getCounterUserId(v5, direction)

		local v12 = v11 and {
			{ name = "targetUser", value = tostring(v11), type = "UserId" }
		} or nil

		inExpAmpWizardController.OpenAmpWizardContainerInExp(p2.ampFeatureCheck, function(p3, p4)
			if p3 == accessResponseEnum.Granted then
				logCurrencyTransferCounter(v5, CurrencyTransferTelemetry.CurrencyTransferSubscriptionUpsellWizardResultGrantedCounter, {
					recourseSurface = "subscription"
				})

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(v5, RobuxTransferFlowEventName.subscription_upsell_wizard_result_granted)
				end

				local previousPromptState = v5.getPreviousPromptState(false)

				if previousPromptState then
					v5.setPromptState(previousPromptState)
				end

				if transferRetryOrigin == TransferRetryOrigin.AcceptTransfer then
					acceptTransfer(v5)
				elseif transferRetryOrigin == TransferRetryOrigin.InitiateTransfer then
					initiateTransfer(v5)
				elseif transferRetryOrigin == TransferRetryOrigin.ProcessTransfer then
					processTransfer(v5, selectedAmount or 0)
				elseif direction == TransferDirection.Receive then
					acceptTransfer(v5)
				else
					processTransfer(v5, selectedAmount or 0)
				end
			else
				logCurrencyTransferCounter(v5, CurrencyTransferTelemetry.CurrencyTransferSubscriptionUpsellWizardResultDeniedCounter, {
					recourseSurface = "subscription"
				})

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(v5, RobuxTransferFlowEventName.subscription_upsell_wizard_result_denied)
				end

				triggerOnClose()
			end
		end, v10, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, v12, AmpWizardTransferConstants.NAMESPACE_NAME)
	end, {})

	return React.createElement(React.Fragment, {})
end

return SubscriptionUpsellContainer
