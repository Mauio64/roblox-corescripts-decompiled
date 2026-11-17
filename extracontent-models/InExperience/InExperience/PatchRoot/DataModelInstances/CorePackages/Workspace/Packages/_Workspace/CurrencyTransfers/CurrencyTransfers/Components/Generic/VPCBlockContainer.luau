local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)

local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local processTransfer = require(CurrencyTransfers.Actions.Send.processTransfer)
local acceptTransfer = require(CurrencyTransfers.Actions.Receive.acceptTransfer)
local initiateTransfer = require(CurrencyTransfers.Actions.Send.initiateTransfer)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local TransferRetryOrigin = require(CurrencyTransfers.Enums.TransferRetryOrigin)

local AmpUpsell = require(parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local ActionTypeEnum = AmpUpsell.AmpEnums.ActionTypeEnum
local ActionStatusEnum = AmpUpsell.AmpEnums.ActionStatusEnum
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer

local FFlagEnableCurrencyTransferWizardVPCPrologue = require(CurrencyTransfers.Flags.FFlagEnableCurrencyTransferWizardVPCPrologue)

local FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp = require(CurrencyTransfers.Flags.FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp)
local FFlagCurrencyTransferVpcUfoDirect = require(CurrencyTransfers.Flags.FFlagCurrencyTransferVpcUfoDirect)

local AmpWizardTransferConstants = require(CurrencyTransfers.Constants.AmpWizardTransferConstants)
local getCounterUserId = require(CurrencyTransfers.Utils.getCounterUserId)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)
local getTransferRequestInternalId = require(CurrencyTransfers.Utils.getTransferRequestInternalId)

local function isVpcRequestSubmitted(p): boolean -- 2 equivalent calls inferred from this helper
	if type(p) == "table" then
		return p[ActionTypeEnum.ParentConsent] == ActionStatusEnum.Success
			or p[ActionTypeEnum.ParentLink] == ActionStatusEnum.Success
	end

	return false
end

local function WizardPrologueOpener(p): nil
	local openAmpWizard = p.openAmpWizard

	local ref = React.useRef(false)
	React.useEffect(function(): nil
		if not ref.current then
			ref.current = true
			openAmpWizard()
		end

		return nil
	end, { openAmpWizard })

	return nil
end

local function VPCBlockContainer(p)
	local v = useLocalization(TransferLocalizationKeys.Presets.VPCBlockContainer)

	local v2 = useTransferStore()
	local v3

	if FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp then
		v3 = useDispatch()
	else
		v3 = nil
	end

	local direction = p.direction
	local triggerOnClose = v2.triggerOnClose
	local selectedAmount = v2.getSelectedAmount(false)
	local transferRetryOrigin = v2.getTransferRetryOrigin(false)
	local transferRequestId = v2.getTransferRequestId(false)

	local v4 = FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp
		and v2.getTransferOrigination(false) == TransferOrigination.InExperience

	if FFlagCurrencyTransferVpcUfoDirect and not FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp then
		v4 = v2.getTransferOrigination(false) == TransferOrigination.InExperience
	end

	local v5

	if direction == TransferDirection.Send then
		v5 = v.AskParentBodySend
	else
		v5 = v.AskParentBodyReceive
	end

	local v6 = FFlagEnableCurrencyTransferWizardVPCPrologue
		and AmpUpsell.GetFFlagEnableAmpVPCPrologue()
		and AmpUpsell.GetFFlagEnableReusableVPCPrologue()

	React.useEffect(function(): nil
		logCurrencyTransferCounter(v2, CurrencyTransferTelemetry.CurrencyTransferVPCBlockDialogShownCounter, {
			recourseSurface = "vpc"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v2, RobuxTransferFlowEventName.vpc_block_shown)
		end

		return nil
	end, { v2 })

	local function logAskClicked() -- 2 equivalent calls inferred from this helper
		logCurrencyTransferCounter(v2, CurrencyTransferTelemetry.CurrencyTransferVPCBlockAskClickedCounter, {
			recourseSurface = "vpc"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v2, RobuxTransferFlowEventName.vpc_ask_clicked)
		end
	end

	local function logCancelClicked() -- 2 equivalent calls inferred from this helper
		logCurrencyTransferCounter(v2, CurrencyTransferTelemetry.CurrencyTransferVPCBlockCancelClickedCounter, {
			recourseSurface = "vpc"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v2, RobuxTransferFlowEventName.vpc_cancel_clicked)
		end
	end

	local function onCancelClicked()
		logCancelClicked() -- inferred equivalent call
		triggerOnClose()
	end

	local v7

	if FFlagCurrencyTransferVpcUfoDirect then
		local AmpV2Wizard = require(parent.AmpV2Wizard)
		local useAmpUpsellLauncher = AmpV2Wizard.useAmpUpsellLauncher
		local onEvent = React.useCallback(function(p2)
			if not v6 or p2.node ~= "Prologue" then
				return
			end

			if p2.outcome == "ODP" or p2.outcome == "Remote" then
				logAskClicked() -- inferred equivalent call
			elseif p2.outcome == "Cancel" then
				logCancelClicked() -- inferred equivalent call
			end
		end, { v2, v6 })

		v7 = useAmpUpsellLauncher({
			surface = AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX,
			odpEventContext = AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX,
			onEvent = onEvent
		})
	else
		v7 = nil
	end

	local function openAmpWizard()
		if not v6 then
			logAskClicked() -- inferred equivalent call
		end

		if not p.ampFeatureCheck then
			triggerOnClose()
			return
		end

		local promptState = v2.getPromptState(false)
		v2.setPreviousPromptState(promptState)
		v2.setPromptState(PromptState.Hidden)

		local requestDetails = {
			transferType = "Robux",
			transferId = getTransferRequestInternalId(transferRequestId),
			robuxTransferAmount = tostring(selectedAmount or 0)
		}

		local counterUserId = getCounterUserId(v2, direction)

		local v8 = counterUserId and {
			{ name = "targetUser", value = tostring(counterUserId), type = "UserId" }
		} or nil

		if FFlagCurrencyTransferVpcUfoDirect and SharedFlags.FFlagEnableAmpV2Wizard and not v4 and v7 then
			local AmpV2Wizard = require(parent.AmpV2Wizard)

			if AmpV2Wizard.FFlagAmpV2WizardTerminalOutcome then
				local UniversalAppPolicy = require(parent.UniversalAppPolicy)
				local appFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies()
				local vpcRequestTypeEnum = AmpUpsell.AmpEnums.VPCRequestTypeEnum
				local requestType

				if direction == TransferDirection.Receive then
					requestType = vpcRequestTypeEnum.ReceiveTransfer
				else
					requestType = vpcRequestTypeEnum.SendTransfer
				end

				if
					appFeaturePolicies.getUseAmpV2WizardForVpc()
					and table.find(appFeaturePolicies.getAmpV2VpcExcludedRequestTypes(), requestType) == nil
				then
					local function handleVpcSubmitted() -- 1 equivalent call inferred from this helper
						if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
							logRobuxTransferFlowEvent(v2, RobuxTransferFlowEventName.vpc_submitted)
						end

						if
							SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction
							and direction == TransferDirection.Receive
						then
							v2.triggerOnPromptOptimisticHide()
						end
					end

					local extraProps = {
						usePrologue = v6 == true
					}

					if v6 then
						extraProps.prologueCopy = {
							title = v.AskParentTitle,
							description = v5,
							confirmLabel = v.Ask
						}
					end

					v7({
						flow = {
							name = "VPC",
							props = { requestType = requestType, requestDetails = requestDetails }
						},
						extraProps = extraProps
					}):andThen(function(p2)
						if p2.reason == "Completed" and (p2.outcome == "Done" or p2.outcome == "Success") then
							handleVpcSubmitted() -- inferred equivalent call
						end

						triggerOnClose()
					end)
					return
				end
			end
		end

		if FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp and not v4 then
			v3(OpenAmpWizardContainer(p.ampFeatureCheck, function(p2, p3)
				local vpcRequestSubmitted = isVpcRequestSubmitted(p3) -- inferred equivalent call

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest and vpcRequestSubmitted then
					logRobuxTransferFlowEvent(v2, RobuxTransferFlowEventName.vpc_submitted)
				end

				if
					SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction
					and vpcRequestSubmitted
					and direction == TransferDirection.Receive
				then
					v2.triggerOnPromptOptimisticHide()
				end

				if p2 ~= AccessResponseEnum.Granted then
					triggerOnClose()

					return
				end

				local previousPromptState = v2.getPreviousPromptState(false)

				if previousPromptState then
					v2.setPromptState(previousPromptState)
				end

				if transferRetryOrigin == TransferRetryOrigin.AcceptTransfer then
					acceptTransfer(v2)
				elseif transferRetryOrigin == TransferRetryOrigin.InitiateTransfer then
					initiateTransfer(v2)
				elseif transferRetryOrigin == TransferRetryOrigin.ProcessTransfer then
					processTransfer(v2, selectedAmount or 0)
				elseif direction == TransferDirection.Receive then
					acceptTransfer(v2)
				else
					processTransfer(v2, selectedAmount or 0)
				end
			end, requestDetails, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, v8, AmpWizardTransferConstants.NAMESPACE_NAME, nil, nil, nil, v6 and true or nil, v6 and {
				config = {
					titleText = v.AskParentTitle,
					bodyText = v5,
					confirmText = v.Ask,
					hideCancel = true,
					actionOrientation = "Vertical",
					hasBackdrop = true,
					closeOnClickOutside = true,
					onCloseCancels = true
				},
				onConfirm = logAskClicked,
				onCancel = logCancelClicked
			} or nil))
		else
			InExpAmpWizardController.OpenAmpWizardContainerInExp(p.ampFeatureCheck, function(p2, p3)
				local vpcRequestSubmitted = isVpcRequestSubmitted(p3) -- inferred equivalent call

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest and vpcRequestSubmitted then
					logRobuxTransferFlowEvent(v2, RobuxTransferFlowEventName.vpc_submitted)
				end

				if
					SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction
					and vpcRequestSubmitted
					and direction == TransferDirection.Receive
				then
					v2.triggerOnPromptOptimisticHide()
				end

				if p2 ~= AccessResponseEnum.Granted then
					triggerOnClose()

					return
				end

				local previousPromptState = v2.getPreviousPromptState(false)

				if previousPromptState then
					v2.setPromptState(previousPromptState)
				end

				if transferRetryOrigin == TransferRetryOrigin.AcceptTransfer then
					acceptTransfer(v2)
				elseif transferRetryOrigin == TransferRetryOrigin.InitiateTransfer then
					initiateTransfer(v2)
				elseif transferRetryOrigin == TransferRetryOrigin.ProcessTransfer then
					processTransfer(v2, selectedAmount or 0)
				elseif direction == TransferDirection.Receive then
					acceptTransfer(v2)
				else
					processTransfer(v2, selectedAmount or 0)
				end
			end, requestDetails, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, v8, AmpWizardTransferConstants.NAMESPACE_NAME, nil, nil, nil, v6 and true or nil, v6 and {
				config = {
					titleText = v.AskParentTitle,
					bodyText = v5,
					confirmText = v.Ask,
					hideCancel = true,
					actionOrientation = "Vertical",
					hasBackdrop = true,
					closeOnClickOutside = true,
					onCloseCancels = true
				},
				onConfirm = logAskClicked,
				onCancel = logCancelClicked
			} or nil)
		end
	end

	if v6 then
		return React.createElement(WizardPrologueOpener, { openAmpWizard = openAmpWizard })
	end

	return React.createElement(
		Dialog.Root,
		{
			size = DialogSize.Small,
			hasBackdrop = true,
			closeOnClickOutside = true,
			onClose = onCancelClicked
		},
		{
			DialogTitle = React.createElement(Dialog.Title, { text = v.AskParentTitle }),
			DialogContent = React.createElement(Dialog.Content, nil, {
				DialogText = React.createElement(Dialog.Text, { Text = v5 })
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				orientation = Orientation.Vertical,
				actions = {
					{ text = v.Ask, variant = ButtonVariant.Emphasis, onActivated = openAmpWizard }
				}
			})
		}
	)
end

return VPCBlockContainer
