local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")
local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local orientation = Foundation.Enums.Orientation

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Localization").Hooks.useLocalization

local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/RoactUtils").Hooks.RoactRodux.useDispatch

local processTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/processTransfer")
local acceptTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Receive/acceptTransfer")
local initiateTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/initiateTransfer")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
local TransferDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferDirection")
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")
local TransferRetryOrigin = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferRetryOrigin")

local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/AmpUpsell")
local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local actionTypeEnum = AmpUpsell.AmpEnums.ActionTypeEnum
local actionStatusEnum = AmpUpsell.AmpEnums.ActionStatusEnum
local inExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local openAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer

local FFlagEnableCurrencyTransferWizardVPCPrologue = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/FFlagEnableCurrencyTransferWizardVPCPrologue")

local FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp")
local FFlagCurrencyTransferVpcUfoDirect = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/FFlagCurrencyTransferVpcUfoDirect")

local AmpWizardTransferConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Constants/AmpWizardTransferConstants")
local getCounterUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/getCounterUserId")
local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local RobuxTransferFlowEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/RobuxTransferFlowEventName")
local logCurrencyTransferCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logCurrencyTransferCounter")
local logRobuxTransferFlowEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logRobuxTransferFlowEvent")
local getTransferRequestInternalId = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/getTransferRequestInternalId")

local function isVpcRequestSubmitted(p2): boolean
	if type(p2) == "table" then
		return p2[actionTypeEnum.ParentConsent] == actionStatusEnum.Success
			or p2[actionTypeEnum.ParentLink] == actionStatusEnum.Success
	end

	return false
end

local function WizardPrologueOpener(p2): nil
	local openAmpWizard = p2.openAmpWizard

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

local function VPCBlockContainer(p2)
	local v5 = useLocalization(TransferLocalizationKeys.Presets.VPCBlockContainer)

	local v6 = useTransferStore()
	local v7 = if FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp then useDispatch() else nil
	local direction = p2.direction
	local triggerOnClose = v6.triggerOnClose
	local selectedAmount = v6.getSelectedAmount(false)
	local transferRetryOrigin = v6.getTransferRetryOrigin(false)
	local transferRequestId = v6.getTransferRequestId(false)

	local v8 = FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp and v6.getTransferOrigination(false) == TransferOrigination.InExperience

	if FFlagCurrencyTransferVpcUfoDirect and not FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp then
		v8 = v6.getTransferOrigination(false) == TransferOrigination.InExperience
	end

	local v9 = if direction == TransferDirection.Send then v5.AskParentBodySend else v5.AskParentBodyReceive

	local v10 = FFlagEnableCurrencyTransferWizardVPCPrologue
		and AmpUpsell.GetFFlagEnableAmpVPCPrologue()
		and AmpUpsell.GetFFlagEnableReusableVPCPrologue()

	React.useEffect(function(): nil
		logCurrencyTransferCounter(v6, CurrencyTransferTelemetry.CurrencyTransferVPCBlockDialogShownCounter, {
			recourseSurface = "vpc"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.vpc_block_shown)
		end

		return nil
	end, { v6 })

	local function logAskClicked()
		logCurrencyTransferCounter(v6, CurrencyTransferTelemetry.CurrencyTransferVPCBlockAskClickedCounter, {
			recourseSurface = "vpc"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.vpc_ask_clicked)
		end
	end

	local function logCancelClicked()
		logCurrencyTransferCounter(v6, CurrencyTransferTelemetry.CurrencyTransferVPCBlockCancelClickedCounter, {
			recourseSurface = "vpc"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.vpc_cancel_clicked)
		end
	end

	local function onCancelClicked()
		logCurrencyTransferCounter(v6, CurrencyTransferTelemetry.CurrencyTransferVPCBlockCancelClickedCounter, {
			recourseSurface = "vpc"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.vpc_cancel_clicked)
		end

		triggerOnClose()
	end

	local v11

	if FFlagCurrencyTransferVpcUfoDirect then
		local useAmpUpsellLauncher = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/AmpV2Wizard").useAmpUpsellLauncher
		local v12 = React.useCallback(function(p3)
			if not v10 or p3.node ~= "Prologue" then
				return
			end

			if p3.outcome == "ODP" or p3.outcome == "Remote" then
				logCurrencyTransferCounter(v6, CurrencyTransferTelemetry.CurrencyTransferVPCBlockAskClickedCounter, {
					recourseSurface = "vpc"
				})

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.vpc_ask_clicked)
				end
			elseif p3.outcome == "Cancel" then
				logCurrencyTransferCounter(v6, CurrencyTransferTelemetry.CurrencyTransferVPCBlockCancelClickedCounter, {
					recourseSurface = "vpc"
				})

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.vpc_cancel_clicked)
				end
			end
		end, { v6, v10 })

		v11 = useAmpUpsellLauncher({
			surface = AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX,
			odpEventContext = AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX,
			onEvent = v12
		})
	else
		v11 = nil
	end

	local function openAmpWizard()
		if not v10 then
			logCurrencyTransferCounter(v6, CurrencyTransferTelemetry.CurrencyTransferVPCBlockAskClickedCounter, {
				recourseSurface = "vpc"
			})

			if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
				logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.vpc_ask_clicked)
			end
		end

		if not p2.ampFeatureCheck then
			triggerOnClose()
			return
		end

		local promptState = v6.getPromptState(false)
		v6.setPreviousPromptState(promptState)
		v6.setPromptState(PromptState.Hidden)

		local v12 = {
			transferType = "Robux",
			transferId = getTransferRequestInternalId(transferRequestId),
			robuxTransferAmount = tostring(selectedAmount or 0)
		}

		local v13 = getCounterUserId(v6, direction)

		local v14 = v13 and {
			{ name = "targetUser", value = tostring(v13), type = "UserId" }
		} or nil

		if
			FFlagCurrencyTransferVpcUfoDirect
			and SharedFlags.FFlagEnableAmpV2Wizard
			and not v8
			and v11
			and require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/AmpV2Wizard").FFlagAmpV2WizardTerminalOutcome
		then
			local appFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/UniversalAppPolicy").getAppFeaturePolicies()
			local vpcRequestTypeEnum = AmpUpsell.AmpEnums.VPCRequestTypeEnum
			local v15

			if direction == TransferDirection.Receive then
				v15 = vpcRequestTypeEnum.ReceiveTransfer
			else
				v15 = vpcRequestTypeEnum.SendTransfer
			end

			if
				appFeaturePolicies.getUseAmpV2WizardForVpc()
				and table.find(appFeaturePolicies.getAmpV2VpcExcludedRequestTypes(), v15) == nil
			then
				local function handleVpcSubmitted()
					if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
						logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.vpc_submitted)
					end

					if
						SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction
						and direction == TransferDirection.Receive
					then
						v6.triggerOnPromptOptimisticHide()
					end
				end

				local v16 = {
					usePrologue = v10 == true
				}

				if v10 then
					v16.prologueCopy = {
						title = v5.AskParentTitle,
						description = v9,
						confirmLabel = v5.Ask
					}
				end

				v11({
					flow = {
						name = "VPC",
						props = { requestType = v15, requestDetails = v12 }
					},
					extraProps = v16
				}):andThen(function(p3)
					if p3.reason == "Completed" and (p3.outcome == "Done" or p3.outcome == "Success") then
						if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
							logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.vpc_submitted)
						end

						if
							SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction
							and direction == TransferDirection.Receive
						then
							v6.triggerOnPromptOptimisticHide()
						end
					end

					triggerOnClose()
				end)
				return
			end
		end

		if FFlagCurrencyTransferVPCUseAmpWizardContainerForInApp and not v8 then
			v7(openAmpWizardContainer(p2.ampFeatureCheck, function(p3, p4)
				local v15

				if type(p4) == "table" then
					v15 = p4[actionTypeEnum.ParentConsent] == actionStatusEnum.Success
						or p4[actionTypeEnum.ParentLink] == actionStatusEnum.Success
				else
					v15 = false
				end

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest and v15 then
					logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.vpc_submitted)
				end

				if
					SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction
					and v15
					and direction == TransferDirection.Receive
				then
					v6.triggerOnPromptOptimisticHide()
				end

				if p3 ~= accessResponseEnum.Granted then
					triggerOnClose()

					return
				end

				local previousPromptState = v6.getPreviousPromptState(false)

				if previousPromptState then
					v6.setPromptState(previousPromptState)
				end

				if transferRetryOrigin == TransferRetryOrigin.AcceptTransfer then
					acceptTransfer(v6)
				elseif transferRetryOrigin == TransferRetryOrigin.InitiateTransfer then
					initiateTransfer(v6)
				elseif transferRetryOrigin == TransferRetryOrigin.ProcessTransfer then
					processTransfer(v6, selectedAmount or 0)
				elseif direction == TransferDirection.Receive then
					acceptTransfer(v6)
				else
					processTransfer(v6, selectedAmount or 0)
				end
			end, v12, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, v14, AmpWizardTransferConstants.NAMESPACE_NAME, nil, nil, nil, v10 and true or nil, v10 and {
				config = {
					titleText = v5.AskParentTitle,
					bodyText = v9,
					confirmText = v5.Ask,
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
			inExpAmpWizardController.OpenAmpWizardContainerInExp(p2.ampFeatureCheck, function(p3, p4)
				local v15

				if type(p4) == "table" then
					v15 = p4[actionTypeEnum.ParentConsent] == actionStatusEnum.Success
						or p4[actionTypeEnum.ParentLink] == actionStatusEnum.Success
				else
					v15 = false
				end

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest and v15 then
					logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.vpc_submitted)
				end

				if
					SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction
					and v15
					and direction == TransferDirection.Receive
				then
					v6.triggerOnPromptOptimisticHide()
				end

				if p3 ~= accessResponseEnum.Granted then
					triggerOnClose()

					return
				end

				local previousPromptState = v6.getPreviousPromptState(false)

				if previousPromptState then
					v6.setPromptState(previousPromptState)
				end

				if transferRetryOrigin == TransferRetryOrigin.AcceptTransfer then
					acceptTransfer(v6)
				elseif transferRetryOrigin == TransferRetryOrigin.InitiateTransfer then
					initiateTransfer(v6)
				elseif transferRetryOrigin == TransferRetryOrigin.ProcessTransfer then
					processTransfer(v6, selectedAmount or 0)
				elseif direction == TransferDirection.Receive then
					acceptTransfer(v6)
				else
					processTransfer(v6, selectedAmount or 0)
				end
			end, v12, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, v14, AmpWizardTransferConstants.NAMESPACE_NAME, nil, nil, nil, v10 and true or nil, v10 and {
				config = {
					titleText = v5.AskParentTitle,
					bodyText = v9,
					confirmText = v5.Ask,
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

	if v10 then
		return React.createElement(WizardPrologueOpener, {
			openAmpWizard = openAmpWizard
		})
	end

	return React.createElement(
		dialog.Root,
		{
			size = dialogSize.Small,
			hasBackdrop = true,
			closeOnClickOutside = true,
			onClose = onCancelClicked
		},
		{
			DialogTitle = React.createElement(dialog.Title, {
				text = v5.AskParentTitle
			}),
			DialogContent = React.createElement(dialog.Content, nil, {
				DialogText = React.createElement(dialog.Text, { Text = v9 })
			}),
			DialogActions = React.createElement(dialog.Actions, {
				orientation = orientation.Vertical,
				actions = {
					{
						text = v5.Ask,
						variant = buttonVariant.Emphasis,
						onActivated = openAmpWizard
					}
				}
			})
		}
	)
end

return VPCBlockContainer
