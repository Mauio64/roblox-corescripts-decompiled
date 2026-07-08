local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local Foundation = require(CurrencyTransfersParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Sheet = Foundation.Sheet
local Button = Foundation.Button
local View = Foundation.View
local FoundationText = Foundation.Text
local FillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local Enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText
local useLocalization = require(CurrencyTransfersParent.Localization).Hooks.useLocalization
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)
local processTransfer = require(CurrencyTransfers.Actions.Send.processTransfer)
local acceptTransfer = require(CurrencyTransfers.Actions.Receive.acceptTransfer)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
local AmpUpsell = require(CurrencyTransfersParent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local useDispatch = require(CurrencyTransfersParent.RoactUtils).Hooks.RoactRodux.useDispatch
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local GetFFlagCurrencyTransferUseAmpWizardContainerForInApp = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferUseAmpWizardContainerForInApp)
local AmpWizardTransferConstants = require(CurrencyTransfers.Constants.AmpWizardTransferConstants)
local getCounterUserId = require(CurrencyTransfers.Utils.getCounterUserId)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)

local function TransferFAEBlockSheet(t1: {[any]: any}) -- line: 60
	-- upvalues: useLocalization (copy), TransferLocalizationKeys (copy), useTransferStore (copy), useDispatch (copy), GetFFlagCurrencyTransferUseAmpWizardContainerForInApp (copy), TransferOrigination (copy), useScaledValue (copy), React (copy), logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), TransferDirection (copy), Sheet (copy), View (copy), FoundationText (copy), getIconRichText (copy), Enums (copy), Button (copy), PromptState (copy), getCounterUserId (copy), AccessResponseEnum (copy), acceptTransfer (copy), processTransfer (copy), InExpAmpWizardController (copy), AmpWizardTransferConstants (copy), OpenAmpWizardContainer (copy), ButtonVariant (copy), FillBehavior (copy)
	local v37 = useLocalization(TransferLocalizationKeys.Presets.TransferFAEBlockSheet)
	local v38 = useTransferStore()
	local v39 = useDispatch()
	local direction = t1.direction
	local triggerOnClose = v38.triggerOnClose
	local v42 = v38.getSelectedAmount(false)
	local v43 = ((if not GetFFlagCurrencyTransferUseAmpWizardContainerForInApp() then nil else v38.getTransferOrigination(false))) == TransferOrigination.InExperience
	local v44 = useScaledValue(420)

	React.useEffect(function() -- line: 74
		-- upvalues: logCurrencyTransferCounter (copy), v38 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy)
		logCurrencyTransferCounter(v38, CurrencyTransferTelemetry.CurrencyTransferFAEBlockSheetShownCounter, {
			recourseSurface = "fae"
		})

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v38, RobuxTransferFlowEventName.fae_block_shown)
		end

		return nil
	end, { v38 })

	local v45 = if direction ~= TransferDirection.Send then v37.RequireReceiverFAE else v37.RequireSenderFAE
	local RequireFAE = v37.RequireFAE

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		snapPoints = {
			v44,
			0.5
		},
		onClose = triggerOnClose
	}, {
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 1
		}, {
			SheetContentContainer = React.createElement(View, {
				tag = "col gap-small auto-y size-full-0 align-x-center padding-top-xlarge padding-x-large"
			}, {
				IconsContainer = React.createElement(View, {
					tag = "auto-xy position-relative padding-bottom-large",
					LayoutOrder = 1,
					Size = UDim2.fromOffset(300, 140)
				}, {
					ShieldIconContainer = React.createElement(View, {
						tag = "radius-medium stroke-default bg-surface-100 align-x-center align-y-center position-absolute",
						Rotation = -15,
						ZIndex = 2,
						Size = UDim2.fromOffset(100, 100),
						Position = UDim2.new(0.5, -40, 0.5, 10),
						AnchorPoint = Vector2.new(0.5, 0.5)
					}, {
						ShieldIcon = React.createElement(FoundationText, {
							tag = "content-emphasis text-align-x-center text-display-medium",
							RichText = true,
							Text = getIconRichText(Enums.IconName.ShieldCheck),
							Size = UDim2.fromOffset(72, 72),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5)
						})
					}),
					RobuxIconContainer = React.createElement(View, {
						tag = "radius-medium stroke-default bg-surface-100 align-x-center align-y-center position-absolute",
						Rotation = 15,
						ZIndex = 1,
						Size = UDim2.fromOffset(100, 100),
						Position = UDim2.new(0.5, 55, 0.5, -10),
						AnchorPoint = Vector2.new(0.5, 0.5)
					}, {
						RobuxIcon = React.createElement(FoundationText, {
							tag = "content-emphasis text-align-x-center text-display-medium",
							RichText = true,
							Text = getIconRichText("robux"),
							Size = UDim2.fromOffset(72, 72),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5)
						})
					})
				}),
				TitleText = React.createElement(FoundationText, {
					tag = "text-heading-medium content-emphasis text-align-x-left text-wrap padding-top-xlarge",
					LayoutOrder = 2,
					Text = v45,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}),
				BodyText = React.createElement(FoundationText, {
					tag = "text-body-medium content-default text-align-x-left text-wrap",
					LayoutOrder = 3,
					Text = RequireFAE,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 2
		}, { React.createElement(View, {
			tag = "col auto-y align-y-center align-x-center size-full-0 gap-small padding-x-medium padding-bottom-large"
		}, { React.createElement(View, {
			tag = "row auto-y size-full-0 gap-small"
		}, { React.createElement(Button, {
			text = v37.Continue,
			onActivated = function() -- line: 168
				-- upvalues: logCurrencyTransferCounter (copy), v38 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), t1 (copy), PromptState (copy), getCounterUserId (copy), direction (copy), AccessResponseEnum (copy), TransferDirection (copy), acceptTransfer (copy), processTransfer (copy), v42 (copy), triggerOnClose (copy), v43 (copy), GetFFlagCurrencyTransferUseAmpWizardContainerForInApp (copy), InExpAmpWizardController (copy), AmpWizardTransferConstants (copy), v39 (copy), OpenAmpWizardContainer (copy)
				logCurrencyTransferCounter(v38, CurrencyTransferTelemetry.CurrencyTransferFAEBlockContinueClickedCounter, {
					recourseSurface = "fae"
				})

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(v38, RobuxTransferFlowEventName.fae_continue_clicked)
				end

				if t1.ampFeatureCheck then
					local v47 = v38.getPromptState(false)

					v38.setPreviousPromptState(v47)
					v38.setPromptState(PromptState.Hidden)

					local v48 = getCounterUserId(v38, direction)
					local t2 = nil

					if v48 then
						t2 = {{
							name = "targetUser",
							type = "UserId",
							value = tostring(v48)
						}}
					end

					local function v50(p1, _) -- line: 193
						-- upvalues: v38 (copy), AccessResponseEnum (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), direction (copy), TransferDirection (copy), acceptTransfer (copy), processTransfer (copy), v42 (copy), triggerOnClose (copy)
						local v53 = v38.getPreviousPromptState(false)

						if v53 then
							v38.setPromptState(v53)
						end

						if p1 == AccessResponseEnum.Granted then
							if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
								logRobuxTransferFlowEvent(v38, RobuxTransferFlowEventName.age_verification_completed)
							end

							if direction == TransferDirection.Receive then
								acceptTransfer(v38)

								return
							end

							if direction == TransferDirection.Send then
								processTransfer(v38, v42 or 0)

								return
							end
						else
							triggerOnClose()
						end
					end

					if v43 or not GetFFlagCurrencyTransferUseAmpWizardContainerForInApp() then
						InExpAmpWizardController.OpenAmpWizardContainerInExp(t1.ampFeatureCheck, v50, nil, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, t2, AmpWizardTransferConstants.NAMESPACE_NAME)

						return
					end

					v39(OpenAmpWizardContainer(t1.ampFeatureCheck, v50, nil, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, t2, AmpWizardTransferConstants.NAMESPACE_NAME))

					return
				end

				print("No ampFeatureCheck available")
				triggerOnClose()
			end,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill
		}) }) }) })
	})
end

return TransferFAEBlockSheet
