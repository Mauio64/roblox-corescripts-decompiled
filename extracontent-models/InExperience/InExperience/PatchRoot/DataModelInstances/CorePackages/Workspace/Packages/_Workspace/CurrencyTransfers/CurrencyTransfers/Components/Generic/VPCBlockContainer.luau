local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local Foundation = require(CurrencyTransfersParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local EnumsOrientation = Foundation.Enums.Orientation
local useLocalization = require(CurrencyTransfersParent.Localization).Hooks.useLocalization
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)
local processTransfer = require(CurrencyTransfers.Actions.Send.processTransfer)
local acceptTransfer = require(CurrencyTransfers.Actions.Receive.acceptTransfer)
local initiateTransfer = require(CurrencyTransfers.Actions.Send.initiateTransfer)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
local TransferRetryOrigin = require(CurrencyTransfers.Enums.TransferRetryOrigin)
local AmpUpsell = require(CurrencyTransfersParent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local ActionTypeEnum = AmpUpsell.AmpEnums.ActionTypeEnum
local ActionStatusEnum = AmpUpsell.AmpEnums.ActionStatusEnum
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local AmpWizardTransferConstants = require(CurrencyTransfers.Constants.AmpWizardTransferConstants)
local getCounterUserId = require(CurrencyTransfers.Utils.getCounterUserId)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)
local getTransferRequestInternalId = require(CurrencyTransfers.Utils.getTransferRequestInternalId)

local function isVpcRequestSubmitted(p1) -- line: 59
	-- upvalues: ActionTypeEnum (copy), ActionStatusEnum (copy)
	if type(p1) ~= "table" then
		return false
	end

	return p1[ActionTypeEnum.ParentConsent] == ActionStatusEnum.Success or p1[ActionTypeEnum.ParentLink] == ActionStatusEnum.Success
end
local function VPCBlockContainer(t1: {[any]: any}) -- line: 67
	-- upvalues: useLocalization (copy), TransferLocalizationKeys (copy), useTransferStore (copy), TransferDirection (copy), React (copy), logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), PromptState (copy), getTransferRequestInternalId (copy), getCounterUserId (copy), InExpAmpWizardController (copy), ActionTypeEnum (copy), ActionStatusEnum (copy), AccessResponseEnum (copy), TransferRetryOrigin (copy), acceptTransfer (copy), initiateTransfer (copy), processTransfer (copy), AmpWizardTransferConstants (copy), Dialog (copy), DialogSize (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local v35 = useLocalization(TransferLocalizationKeys.Presets.VPCBlockContainer)
	local v36 = useTransferStore()
	local direction = t1.direction
	local triggerOnClose = v36.triggerOnClose
	local v39 = v36.getSelectedAmount(false)
	local v40 = v36.getTransferRetryOrigin(false)
	local v41 = v36.getTransferRequestId(false)
	local v42 = if direction ~= TransferDirection.Send then v35.AskParentBodyReceive else v35.AskParentBodySend

	React.useEffect(function() -- line: 81
		-- upvalues: logCurrencyTransferCounter (copy), v36 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy)
		logCurrencyTransferCounter(v36, CurrencyTransferTelemetry.CurrencyTransferVPCBlockDialogShownCounter, {
			recourseSurface = "vpc"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v36, RobuxTransferFlowEventName.vpc_block_shown)
		end

		return nil
	end, { v36 })

	local function onCancelClicked() -- line: 91
		-- upvalues: logCurrencyTransferCounter (copy), v36 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), triggerOnClose (copy)
		logCurrencyTransferCounter(v36, CurrencyTransferTelemetry.CurrencyTransferVPCBlockCancelClickedCounter, {
			recourseSurface = "vpc"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v36, RobuxTransferFlowEventName.vpc_cancel_clicked)
		end

		triggerOnClose()
	end
	local function openAmpWizard() -- line: 101
		-- upvalues: logCurrencyTransferCounter (copy), v36 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), t1 (copy), triggerOnClose (copy), PromptState (copy), getTransferRequestInternalId (copy), v41 (copy), v39 (copy), getCounterUserId (copy), direction (copy), InExpAmpWizardController (copy), ActionTypeEnum (copy), ActionStatusEnum (copy), AccessResponseEnum (copy), v40 (copy), TransferRetryOrigin (copy), acceptTransfer (copy), initiateTransfer (copy), processTransfer (copy), TransferDirection (copy), AmpWizardTransferConstants (copy)
		logCurrencyTransferCounter(v36, CurrencyTransferTelemetry.CurrencyTransferVPCBlockAskClickedCounter, {
			recourseSurface = "vpc"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v36, RobuxTransferFlowEventName.vpc_ask_clicked)
		end

		if not t1.ampFeatureCheck then
			triggerOnClose()

			return
		end

		local v45 = v36.getPromptState(false)

		v36.setPreviousPromptState(v45)
		v36.setPromptState(PromptState.Hidden)

		local t2 = {
			transferType = "Robux",
			transferId = getTransferRequestInternalId(v41),
			robuxTransferAmount = tostring(v39 or 0)
		}
		local v47 = getCounterUserId(v36, direction)
		local t3 = nil

		if v47 then
			t3 = {{
				name = "targetUser",
				type = "UserId",
				value = tostring(v47)
			}}
		end

		InExpAmpWizardController.OpenAmpWizardContainerInExp(t1.ampFeatureCheck, function(p2, p3) -- line: 133
			-- upvalues: ActionTypeEnum (copy), ActionStatusEnum (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), v36 (copy), RobuxTransferFlowEventName (copy), AccessResponseEnum (copy), v40 (copy), TransferRetryOrigin (copy), acceptTransfer (copy), initiateTransfer (copy), processTransfer (copy), v39 (copy), direction (copy), TransferDirection (copy), triggerOnClose (copy)
			local v51 = type(p3) == "table" and (p3[ActionTypeEnum.ParentConsent] == ActionStatusEnum.Success or p3[ActionTypeEnum.ParentLink] == ActionStatusEnum.Success)

			if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest and v51 then
				logRobuxTransferFlowEvent(v36, RobuxTransferFlowEventName.vpc_submitted)
			end

			if p2 == AccessResponseEnum.Granted then
				local v52 = v36.getPreviousPromptState(false)

				if v52 then
					v36.setPromptState(v52)
				end

				if v40 == TransferRetryOrigin.AcceptTransfer then
					acceptTransfer(v36)

					return
				end

				if v40 == TransferRetryOrigin.InitiateTransfer then
					initiateTransfer(v36)

					return
				end

				if v40 == TransferRetryOrigin.ProcessTransfer then
					processTransfer(v36, v39 or 0)

					return
				end

				if direction == TransferDirection.Receive then
					acceptTransfer(v36)

					return
				end

				processTransfer(v36, v39 or 0)

				return
			end

			triggerOnClose()
		end, t2, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, t3, AmpWizardTransferConstants.NAMESPACE_NAME)
	end

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		closeOnClickOutside = true,
		size = DialogSize.Small,
		onClose = onCancelClicked
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v35.AskParentTitle
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogText = React.createElement(Dialog.Text, {
				Text = v42
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			orientation = EnumsOrientation.Vertical,
			actions = {{
				text = v35.Ask,
				variant = ButtonVariant.Emphasis,
				onActivated = openAmpWizard
			}}
		})
	})
end

return VPCBlockContainer
