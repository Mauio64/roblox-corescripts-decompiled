local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)

local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Sheet = Foundation.Sheet
local Button = Foundation.Button
local View = Foundation.View
local Text = Foundation.Text
local FillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local Enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

local processTransfer = require(CurrencyTransfers.Actions.Send.processTransfer)
local acceptTransfer = require(CurrencyTransfers.Actions.Receive.acceptTransfer)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)

local AmpUpsell = require(parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)

local GetFFlagCurrencyTransferUseAmpWizardContainerForInApp = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferUseAmpWizardContainerForInApp)

local AmpWizardTransferConstants = require(CurrencyTransfers.Constants.AmpWizardTransferConstants)
local getCounterUserId = require(CurrencyTransfers.Utils.getCounterUserId)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)

local GetFFlagCurrencyTransferFocusNavigation = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFocusNavigation)
local useTransferSheetFocus = require(CurrencyTransfers.Hooks.useTransferSheetFocus)

local function TransferFAEBlockSheet(p)
	local v = useLocalization(TransferLocalizationKeys.Presets.TransferFAEBlockSheet)

	local v2 = useTransferStore()
	local v3 = useDispatch()
	local direction = p.direction
	local triggerOnClose = v2.triggerOnClose
	local selectedAmount = v2.getSelectedAmount(false)
	local v4

	if GetFFlagCurrencyTransferUseAmpWizardContainerForInApp() then
		v4 = v2.getTransferOrigination(false)
	end

	local v5 = v4 == TransferOrigination.InExperience
	local v6 = useScaledValue(420)

	React.useEffect(function(): nil
		logCurrencyTransferCounter(v2, CurrencyTransferTelemetry.CurrencyTransferFAEBlockSheetShownCounter, {
			recourseSurface = "fae"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v2, RobuxTransferFlowEventName.fae_block_shown)
		end

		return nil
	end, { v2 })
	local text

	if direction == TransferDirection.Send then
		text = v.RequireSenderFAE
	else
		text = v.RequireReceiverFAE
	end

	local requireFAE = v.RequireFAE
	local ref, ref2

	if GetFFlagCurrencyTransferFocusNavigation() then
		ref, ref2 = useTransferSheetFocus(triggerOnClose)
	end

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		snapPoints = { v6, 0.5 },
		onClose = triggerOnClose,
		ref = ref
	}, {
		Content = React.createElement(Sheet.Content, { LayoutOrder = 1 }, {
			SheetContentContainer = React.createElement(
				View,
				{
					tag = "col gap-small auto-y size-full-0 align-x-center padding-top-xlarge padding-x-large"
				},
				{
					IconsContainer = React.createElement(
						View,
						{
							tag = "auto-xy position-relative padding-bottom-large",
							Size = UDim2.fromOffset(300, 140),
							LayoutOrder = 1
						},
						{
							ShieldIconContainer = React.createElement(View, {
								tag = "radius-medium stroke-default bg-surface-100 align-x-center align-y-center position-absolute",
								Size = UDim2.fromOffset(100, 100),
								Position = UDim2.new(0.5, -40, 0.5, 10),
								AnchorPoint = Vector2.new(0.5, 0.5),
								Rotation = -15,
								ZIndex = 2
							}, {
								ShieldIcon = React.createElement(Text, {
									Text = getIconRichText(Enums.IconName.ShieldCheck),
									tag = "content-emphasis text-align-x-center text-display-medium",
									RichText = true,
									Size = UDim2.fromOffset(72, 72),
									Position = UDim2.new(0.5, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0.5, 0.5)
								})
							}),
							RobuxIconContainer = React.createElement(View, {
								tag = "radius-medium stroke-default bg-surface-100 align-x-center align-y-center position-absolute",
								Size = UDim2.fromOffset(100, 100),
								Position = UDim2.new(0.5, 55, 0.5, -10),
								AnchorPoint = Vector2.new(0.5, 0.5),
								Rotation = 15,
								ZIndex = 1
							}, {
								RobuxIcon = React.createElement(Text, {
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
					TitleText = React.createElement(Text, {
						Text = text,
						tag = "text-heading-medium content-emphasis text-align-x-left text-wrap padding-top-xlarge",
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = 2
					}),
					BodyText = React.createElement(Text, {
						Text = requireFAE,
						tag = "text-body-medium content-default text-align-x-left text-wrap",
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = 3
					})
				}
			)
		}),
		Actions = React.createElement(Sheet.Actions, { LayoutOrder = 2 }, {
			React.createElement(
				View,
				{
					tag = "col auto-y align-y-center align-x-center size-full-0 gap-small padding-x-medium padding-bottom-large"
				},
				{ React.createElement(View, { tag = "row auto-y size-full-0 gap-small" }, {
						React.createElement(Button, {
							ref = ref2,
							text = v.Continue,
							onActivated = function()
								logCurrencyTransferCounter(
									v2,
									CurrencyTransferTelemetry.CurrencyTransferFAEBlockContinueClickedCounter,
									{ recourseSurface = "fae" }
								)

								if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
									logRobuxTransferFlowEvent(v2, RobuxTransferFlowEventName.fae_continue_clicked)
								end

								if p.ampFeatureCheck then
									local promptState = v2.getPromptState(false)
									v2.setPreviousPromptState(promptState)
									v2.setPromptState(PromptState.Hidden)

									local counterUserId = getCounterUserId(v2, direction)

									local v7 = counterUserId and {
										{
											name = "targetUser",
											value = tostring(counterUserId),
											type = "UserId"
										}
									} or nil

									local function fn(p2, _)
										local previousPromptState = v2.getPreviousPromptState(false)

										if previousPromptState then
											v2.setPromptState(previousPromptState)
										end

										if p2 == AccessResponseEnum.Granted then
											if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
												logRobuxTransferFlowEvent(
													v2,
													RobuxTransferFlowEventName.age_verification_completed
												)
											end

											if direction == TransferDirection.Receive then
												acceptTransfer(v2)
											elseif direction == TransferDirection.Send then
												processTransfer(v2, selectedAmount or 0)
											end
										else
											triggerOnClose()
										end
									end

									if v5 or not GetFFlagCurrencyTransferUseAmpWizardContainerForInApp() then
										InExpAmpWizardController.OpenAmpWizardContainerInExp(
											p.ampFeatureCheck,
											fn,
											nil,
											AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX,
											v7,
											AmpWizardTransferConstants.NAMESPACE_NAME
										)
									else
										v3(OpenAmpWizardContainer(
											p.ampFeatureCheck,
											fn,
											nil,
											AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX,
											v7,
											AmpWizardTransferConstants.NAMESPACE_NAME
										))
									end
								else
									print("No ampFeatureCheck available")
									triggerOnClose()
								end
							end,
							variant = ButtonVariant.Emphasis,
							fillBehavior = FillBehavior.Fill
						})
					}) }
			)
		})
	})
end

return TransferFAEBlockSheet
