local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")
local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local sheet = Foundation.Sheet
local button = Foundation.Button
local view = Foundation.View
local text = Foundation.Text
local fillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Localization").Hooks.useLocalization

local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")

local processTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/processTransfer")
local acceptTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Receive/acceptTransfer")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
local TransferDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferDirection")

local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/AmpUpsell")
local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local inExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local openAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/RoactUtils").Hooks.RoactRodux.useDispatch
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")

local GetFFlagCurrencyTransferUseAmpWizardContainerForInApp = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferUseAmpWizardContainerForInApp")

local AmpWizardTransferConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Constants/AmpWizardTransferConstants")
local getCounterUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/getCounterUserId")
local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local RobuxTransferFlowEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/RobuxTransferFlowEventName")
local logCurrencyTransferCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logCurrencyTransferCounter")
local logRobuxTransferFlowEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logRobuxTransferFlowEvent")

local GetFFlagCurrencyTransferFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFocusNavigation")
local useTransferSheetFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferSheetFocus")

local function TransferFAEBlockSheet(p2)
	local v5 = useLocalization(TransferLocalizationKeys.Presets.TransferFAEBlockSheet)

	local v6 = useTransferStore()
	local v7 = useDispatch()
	local direction = p2.direction
	local triggerOnClose = v6.triggerOnClose
	local selectedAmount = v6.getSelectedAmount(false)
	local v9 = (if GetFFlagCurrencyTransferUseAmpWizardContainerForInApp() then v6.getTransferOrigination(false) else nil) == TransferOrigination.InExperience
	local v10 = useScaledValue(420)

	React.useEffect(function(): nil
		logCurrencyTransferCounter(v6, CurrencyTransferTelemetry.CurrencyTransferFAEBlockSheetShownCounter, {
			recourseSurface = "fae"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.fae_block_shown)
		end

		return nil
	end, { v6 })

	local v11 = if direction == TransferDirection.Send then v5.RequireSenderFAE else v5.RequireReceiverFAE
	local requireFAE = v5.RequireFAE
	local v12, v13

	if GetFFlagCurrencyTransferFocusNavigation() then
		v12, v13 = useTransferSheetFocus(triggerOnClose)
	end

	return React.createElement(sheet.Root, {
		preferCenterSheet = true,
		snapPoints = { v10, 0.5 },
		onClose = triggerOnClose,
		ref = v12
	}, {
		Content = React.createElement(sheet.Content, { LayoutOrder = 1 }, {
			SheetContentContainer = React.createElement(
				view,
				{
					tag = "col gap-small auto-y size-full-0 align-x-center padding-top-xlarge padding-x-large"
				},
				{
					IconsContainer = React.createElement(
						view,
						{
							tag = "auto-xy position-relative padding-bottom-large",
							Size = UDim2.fromOffset(300, 140),
							LayoutOrder = 1
						},
						{
							ShieldIconContainer = React.createElement(view, {
								tag = "radius-medium stroke-default bg-surface-100 align-x-center align-y-center position-absolute",
								Size = UDim2.fromOffset(100, 100),
								Position = UDim2.new(0.5, -40, 0.5, 10),
								AnchorPoint = Vector2.new(0.5, 0.5),
								Rotation = -15,
								ZIndex = 2
							}, {
								ShieldIcon = React.createElement(text, {
									Text = getIconRichText(enums.IconName.ShieldCheck),
									tag = "content-emphasis text-align-x-center text-display-medium",
									RichText = true,
									Size = UDim2.fromOffset(72, 72),
									Position = UDim2.new(0.5, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0.5, 0.5)
								})
							}),
							RobuxIconContainer = React.createElement(view, {
								tag = "radius-medium stroke-default bg-surface-100 align-x-center align-y-center position-absolute",
								Size = UDim2.fromOffset(100, 100),
								Position = UDim2.new(0.5, 55, 0.5, -10),
								AnchorPoint = Vector2.new(0.5, 0.5),
								Rotation = 15,
								ZIndex = 1
							}, {
								RobuxIcon = React.createElement(text, {
									Text = getIconRichText("robux"),
									tag = "content-emphasis text-align-x-center text-display-medium",
									RichText = true,
									Size = UDim2.fromOffset(72, 72),
									Position = UDim2.new(0.5, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0.5, 0.5)
								})
							})
						}
					),
					TitleText = React.createElement(text, {
						Text = v11,
						tag = "text-heading-medium content-emphasis text-align-x-left text-wrap padding-top-xlarge",
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = 2
					}),
					BodyText = React.createElement(text, {
						Text = requireFAE,
						tag = "text-body-medium content-default text-align-x-left text-wrap",
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = 3
					})
				}
			)
		}),
		Actions = React.createElement(sheet.Actions, { LayoutOrder = 2 }, {
			React.createElement(
				view,
				{
					tag = "col auto-y align-y-center align-x-center size-full-0 gap-small padding-x-medium padding-bottom-large"
				},
				{ React.createElement(view, {
						tag = "row auto-y size-full-0 gap-small"
					}, {
						React.createElement(button, {
							ref = v13,
							text = v5.Continue,
							onActivated = function()
								logCurrencyTransferCounter(v6, CurrencyTransferTelemetry.CurrencyTransferFAEBlockContinueClickedCounter, {
									recourseSurface = "fae"
								})

								if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
									logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.fae_continue_clicked)
								end

								if p2.ampFeatureCheck then
									local promptState = v6.getPromptState(false)
									v6.setPreviousPromptState(promptState)
									v6.setPromptState(PromptState.Hidden)

									local v14 = getCounterUserId(v6, direction)

									local v15 = v14 and {
										{
											name = "targetUser",
											value = tostring(v14),
											type = "UserId"
										}
									} or nil

									local function fn(p3, p4)
										local previousPromptState = v6.getPreviousPromptState(false)

										if previousPromptState then
											v6.setPromptState(previousPromptState)
										end

										if p3 == accessResponseEnum.Granted then
											if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
												logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.age_verification_completed)
											end

											if direction == TransferDirection.Receive then
												acceptTransfer(v6)
											elseif direction == TransferDirection.Send then
												processTransfer(v6, selectedAmount or 0)
											end
										else
											triggerOnClose()
										end
									end

									if v9 or not GetFFlagCurrencyTransferUseAmpWizardContainerForInApp() then
										inExpAmpWizardController.OpenAmpWizardContainerInExp(
											p2.ampFeatureCheck,
											fn,
											nil,
											AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX,
											v15,
											AmpWizardTransferConstants.NAMESPACE_NAME
										)
									else
										v7(openAmpWizardContainer(
											p2.ampFeatureCheck,
											fn,
											nil,
											AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX,
											v15,
											AmpWizardTransferConstants.NAMESPACE_NAME
										))
									end
								else
									print("No ampFeatureCheck available")
									triggerOnClose()
								end
							end,
							variant = buttonVariant.Emphasis,
							fillBehavior = fillBehavior.Fill
						})
					}) }
			)
		})
	})
end

return TransferFAEBlockSheet
