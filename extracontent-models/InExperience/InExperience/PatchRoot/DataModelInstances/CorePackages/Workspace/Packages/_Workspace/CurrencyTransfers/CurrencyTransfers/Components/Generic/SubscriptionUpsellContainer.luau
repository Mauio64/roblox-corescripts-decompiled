local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local useLocalization = require(CurrencyTransfersParent.Localization).Hooks.useLocalization
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
local AmpUpsell = require(CurrencyTransfersParent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local RobloxSubscriptionPurchaseApp = require(CurrencyTransfersParent.RobloxSubscriptionPurchaseApp)
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext

local function SubscriptionUpsellContainer(t1: {[any]: any}) -- line: 56
	-- upvalues: useTransferStore (copy), useLocalization (copy), TransferLocalizationKeys (copy), TransferOrigination (copy), SurfaceContext (copy), SharedFlags (copy), RobloxSubscriptionPurchaseApp (copy), SurfaceName (copy), React (copy), logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), PromptState (copy), getCounterUserId (copy), InExpAmpWizardController (copy), AccessResponseEnum (copy), TransferRetryOrigin (copy), acceptTransfer (copy), initiateTransfer (copy), processTransfer (copy), TransferDirection (copy), AmpWizardTransferConstants (copy)
	local v29 = useTransferStore()
	local v30 = useLocalization(TransferLocalizationKeys.Presets.SubscriptionUpsellContainer)
	local direction = t1.direction
	local triggerOnClose = v29.triggerOnClose
	local v33 = v29.getSelectedAmount(false)
	local v34 = v29.getTransferRetryOrigin(false)
	local v35 = if v29.getTransferOrigination(false) ~= TransferOrigination.InExperience then SurfaceContext.InApp else SurfaceContext.InGame
	local v36 = v29.getTransferClientSessionId(false)
	local v37 = if not SharedFlags.FFlagEnableRobuxTransferFlowEventIngest or v36 == "" then nil else {
		clientSessionId = {
			clientSessionIdType = RobloxSubscriptionPurchaseApp.PurchaseClientSessionIdType.CurrencyTransferSessionId,
			clientSessionId = v36
		}
	}
	local t2 = {
		purchaseUIOptions = {
			title = v30.UpsellSubscriptionTitle or ""
		},
		surfaceName = SurfaceName.RobuxTransferUpsell,
		surfaceContext = v35,
		analyticsContext = v37
	}

	React.useEffect(function() -- line: 99
		-- upvalues: t1 (copy), triggerOnClose (copy), logCurrencyTransferCounter (copy), v29 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), PromptState (copy), getCounterUserId (copy), direction (copy), InExpAmpWizardController (copy), AccessResponseEnum (copy), v34 (copy), TransferRetryOrigin (copy), acceptTransfer (copy), initiateTransfer (copy), processTransfer (copy), v33 (copy), TransferDirection (copy), t2 (copy), AmpWizardTransferConstants (copy)
		if not t1.ampFeatureCheck then
			triggerOnClose()

			return
		end

		logCurrencyTransferCounter(v29, CurrencyTransferTelemetry.CurrencyTransferSubscriptionUpsellWizardOpenedCounter, {
			recourseSurface = "subscription"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v29, RobuxTransferFlowEventName.subscription_upsell_wizard_opened)
		end

		local v39 = v29.getPromptState(false)

		v29.setPreviousPromptState(v39)
		v29.setPromptState(PromptState.Hidden)

		local v40 = getCounterUserId(v29, direction)
		local t3 = nil

		if v40 then
			t3 = {{
				name = "targetUser",
				type = "UserId",
				value = tostring(v40)
			}}
		end

		InExpAmpWizardController.OpenAmpWizardContainerInExp(t1.ampFeatureCheck, function(p1, _) -- line: 128
			-- upvalues: AccessResponseEnum (copy), logCurrencyTransferCounter (copy), v29 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), v34 (copy), TransferRetryOrigin (copy), acceptTransfer (copy), initiateTransfer (copy), processTransfer (copy), v33 (copy), direction (copy), TransferDirection (copy), triggerOnClose (copy)
			if p1 == AccessResponseEnum.Granted then
				logCurrencyTransferCounter(v29, CurrencyTransferTelemetry.CurrencyTransferSubscriptionUpsellWizardResultGrantedCounter, {
					recourseSurface = "subscription"
				})

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(v29, RobuxTransferFlowEventName.subscription_upsell_wizard_result_granted)
				end

				local v44 = v29.getPreviousPromptState(false)

				if v44 then
					v29.setPromptState(v44)
				end

				if v34 == TransferRetryOrigin.AcceptTransfer then
					acceptTransfer(v29)

					return
				end

				if v34 == TransferRetryOrigin.InitiateTransfer then
					initiateTransfer(v29)

					return
				end

				if v34 == TransferRetryOrigin.ProcessTransfer then
					processTransfer(v29, v33 or 0)

					return
				end

				if direction == TransferDirection.Receive then
					acceptTransfer(v29)

					return
				end

				processTransfer(v29, v33 or 0)

				return
			end

			logCurrencyTransferCounter(v29, CurrencyTransferTelemetry.CurrencyTransferSubscriptionUpsellWizardResultDeniedCounter, {
				recourseSurface = "subscription"
			})

			if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
				logRobuxTransferFlowEvent(v29, RobuxTransferFlowEventName.subscription_upsell_wizard_result_denied)
			end

			triggerOnClose()
		end, t2, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, t3, AmpWizardTransferConstants.NAMESPACE_NAME)
	end, {})

	return React.createElement(React.Fragment, {})
end

return SubscriptionUpsellContainer
