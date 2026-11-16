local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Sheet = Foundation.Sheet
local Button = Foundation.Button
local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local FillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local RobuxText = require(CurrencyTransfers.Components.Generic.RobuxText)
local TransferRobuxHeader = require(CurrencyTransfers.Components.Generic.TransferRobuxHeader)
local TransferAmountOptionChips = require(CurrencyTransfers.Components.Generic.TransferAmountOptionChips)
local TransferProfileThumbnail = require(CurrencyTransfers.Components.Generic.TransferProfileThumbnail)

local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

local useTextBoxOnChangeRef = require(CurrencyTransfers.Hooks.useTextBoxOnChangeRef)
local useAutoFocusTextBoxOnMount = require(CurrencyTransfers.Hooks.useAutoFocusTextBoxOnMount)

local proceedToConfirm = require(CurrencyTransfers.Actions.Send.proceedToConfirm)
local setTransferPromptState = require(CurrencyTransfers.Actions.Send.setTransferPromptState)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local GetFIntCurrencyTransferMinAmount = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferMinAmount)
local GetFIntCurrencyTransferMaxAmount = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferMaxAmount)
local GetFFlagCurrencyTransferFixTextBoxInput = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFixTextBoxInput)

local GetFFlagCurrencyTransferFlowUIImprovementFix = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFlowUIImprovementFix)
local GetFFlagCurrencyTransferFixDesktopInput = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFixDesktopInput)
local GetFFlagCurrencyTransferFocusNavigation = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFocusNavigation)
local useTransferSheetFocus = require(CurrencyTransfers.Hooks.useTransferSheetFocus)

local GetFFlagCurrencyTransferUseBackendTransferLimits = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferUseBackendTransferLimits)
local FFlagShowRemainingTransfersForNonPlus = require(CurrencyTransfers.Flags.FFlagShowRemainingTransfersForNonPlus)

local FFlagCurrencyTransferHideAmountChipsAboveMax = require(CurrencyTransfers.Flags.FFlagCurrencyTransferHideAmountChipsAboveMax)
local TransferBenefitSource = require(CurrencyTransfers.Enums.TransferBenefitSource)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)
local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local function TransferRobuxInputSheet(_)
	local v = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxInputSheet)
	local v2 = useTokens()

	local v3 = GetFFlagCurrencyTransferFixDesktopInput() and not UserInputService.TouchEnabled

	local v4 = useTransferStore()

	React.useEffect(function(): nil
		logCurrencyTransferCounter(v4, CurrencyTransferTelemetry.CurrencyTransferInputSheetShownCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v4, RobuxTransferFlowEventName.input_shown)
		end

		return nil
	end, { v4 })

	local v5 = SignalsReact.useSignalState(v4.getSelectedAmount) or 0
	local setSelectedAmount = v4.setSelectedAmount
	local state, setState = React.useState(false)
	local robuxBalanceAmount = SignalsReact.useSignalState(v4.getRobuxBalanceAmount) or 0
	local recipient = v4.getRecipient(false)
	local ref = React.useRef(nil)
	local v6 = SignalsReact.useSignalState(v4.getMinimumTransferAmount)
	local v7 = SignalsReact.useSignalState(v4.getMaximumTransferAmount)
	local v8 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v6 or GetFIntCurrencyTransferMinAmount()
	local v9 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v7 or GetFIntCurrencyTransferMaxAmount()
	local v10

	if FFlagShowRemainingTransfersForNonPlus then
		v10 = SignalsReact.useSignalState(v4.getTransferBenefitSource)
	else
		v10 = nil
	end

	local v11

	if FFlagShowRemainingTransfersForNonPlus then
		v11 = SignalsReact.useSignalState(v4.getNumFreeTransfersRemaining)
	end

	local numFreeTransfersRemaining

	if FFlagShowRemainingTransfersForNonPlus and v11 ~= nil then
		numFreeTransfersRemaining = formatNumber(LocalizationService.RobloxLocaleId, v11)
	end

	local v12 = useLocalization({
		FreeTransfersRemaining = FFlagShowRemainingTransfersForNonPlus and numFreeTransfersRemaining ~= nil and v11 ~= 1 and {
			"Features.Transfers.RobuxTransfer.FreeTransfersRemaining",
			numFreeTransfersRemaining = numFreeTransfersRemaining
		} or nil,
		FreeTransfersRemainingSingular = FFlagShowRemainingTransfersForNonPlus and v11 == 1 and "Features.Transfers.RobuxTransfer.FreeTransfersRemainingSingular" or nil
	})

	React.useEffect(function()
		if v5 == 0 or v8 <= v5 and v5 <= v9 then
			setState(false)
		end
	end, { v5, v8, v9 })

	local onActivated = React.useCallback(function()
		if v5 and (v5 < v8 or v9 < v5) then
			setState(true)
		elseif v5 and robuxBalanceAmount < v5 then
			setTransferPromptState(v4, PromptState.TransferInsufficientBalance)
		else
			proceedToConfirm(v4, v5 or 0)
		end
	end, { v4, v5, robuxBalanceAmount, v8, v9 })

	local v13 = useTextBoxOnChangeRef(React.useCallback(function(value: number?)
		setSelectedAmount(value or 0)
	end, { setSelectedAmount }), (React.useCallback(function(flag: boolean, flag2: boolean)
		if not flag and flag2 then
			if v5 and v5 > 0 and (v5 < v8 or v9 < v5) then
				setState(true)
			else
				onActivated()
			end
		end
	end, { onActivated, v5, v8, v9 })))
	local triggerOnClose = v4.triggerOnClose
	local ref2

	if GetFFlagCurrencyTransferFocusNavigation() then
		ref2 = useTransferSheetFocus(triggerOnClose)
	end

	local v14 = useAutoFocusTextBoxOnMount(v13, 0.05)
	local ref3 = React.useCallback(function(current)
		if current then
			ref.current = current
			v14(current)
		end
	end, { v14 })

	local chips = React.useMemo(function()
		local v15 = {
			{ amount = 25, text = "25" },
			{ amount = 50, text = "50" },
			{ amount = 100, text = "100" },
			{ amount = 200, text = "200" }
		}

		if
			not FFlagCurrencyTransferHideAmountChipsAboveMax
			and (not FFlagShowRemainingTransfersForNonPlus or v10 ~= TransferBenefitSource.Free)
		then
			return v15
		end

		local result = {}

		for _, v16 in v15 do
			if v16.amount <= v9 then
				table.insert(result, v16)
			end
		end

		return result
	end, { v10, v9 })

	local onChipSelected = React.useCallback(function(p: number)
		setSelectedAmount(p)

		local current = GetFFlagCurrencyTransferFlowUIImprovementFix() and ref.current

		if current then
			current:ReleaseFocus()
		end
	end, { setSelectedAmount })

	local v15 = v5 > 0 and (v5 < v8 or v9 < v5)
	local v16 = state and v15
	local text = React.useMemo(function()
		if not v16 or not v5 or v5 <= 0 then
			return nil
		end

		if v5 < v8 then
			local v17 = formatNumber(LocalizationService.RobloxLocaleId, v8)
			return transferLocaleFormat.substituteAmount(v.LowerThanMinAmount or "", (tostring(v17)))
		end

		if v9 < v5 then
			local v17 = formatNumber(LocalizationService.RobloxLocaleId, v9)
			return transferLocaleFormat.substituteAmount(v.GreaterThanMaxAmount or "", (tostring(v17)))
		end

		return nil
	end, { v16, v5, v8, v9, v.LowerThanMinAmount, v.GreaterThanMaxAmount })

	local isDisabled = React.useMemo(function(): boolean
		return not v5 or v5 <= 0
	end, { v5 })

	local v17 = useScaledValue(500)

	local snapPoints = React.useMemo(function()
		return { v17, 0.62 }
	end, { v17 })

	local text2 = v.Disclaimer

	if FFlagShowRemainingTransfersForNonPlus and v10 == TransferBenefitSource.Free and v11 ~= nil then
		if v11 == 1 then
			text2 = v12.FreeTransfersRemainingSingular
		else
			text2 = v12.FreeTransfersRemaining
		end
	end

	local createElement = React.createElement
	local root = Sheet.Root

	local children = {
		Header = React.createElement(Sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(TransferRobuxHeader, {
				titleText = v.SendRobux,
				robuxBalanceAmount = robuxBalanceAmount
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content

	local createElement3 = React.createElement
	local robuxInputWrapper

	if not v3 then
		local createElement4 = React.createElement
		local v18 = {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = 0
		}

		local createElement5 = React.createElement
		local v19 = {
			Size = UDim2.new(0, 80, 0, 40),
			Position = UDim2.new(0, -10000, 0, 0),
			BackgroundTransparency = 1
		}

		local createElement6 = React.createElement
		local v20 = {
			Size = UDim2.new(1, 0, 1, 0),
			Text = 0,
			PlaceholderText = "",
			TextInputType = 0,
			BackgroundTransparency = 1,
			ClearTextOnFocus = 0,
			ref = 0
		}
		local text3

		if v5 and v5 > 0 then
			text3 = tostring(v5)
		else
			text3 = GetFFlagCurrencyTransferFixTextBoxInput() and "" or "0"
		end

		v20.Text = text3

		v20.TextInputType = Enum.TextInputType.Number

		v20.ClearTextOnFocus = not GetFFlagCurrencyTransferFlowUIImprovementFix()
		v20.ref = ref3
		robuxInputWrapper = createElement4("Frame", v18, {
			RobuxInput = createElement5("Frame", v19, { TextBox = createElement6("TextBox", v20) })
		})
	end

	local createElement4 = React.createElement
	local v18 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local createElement5 = React.createElement
	local recipientProfile

	if recipient and recipient.targetId then
		local createElement6 = React.createElement
		local v19 = {
			userId = tostring(recipient.targetId),
			username = 0,
			displayName = 0,
			showUsername = true,
			size = 0,
			layoutOrder = 1,
			thumbnailSize = 0
		}
		local username

		if not GetFFlagCurrencyTransferFlowUIImprovementFix() then
			username = recipient.targetName
		end

		v19.username = username
		local displayName

		if GetFFlagCurrencyTransferFlowUIImprovementFix() then
			displayName = recipient.targetDisplayName
		end

		v19.displayName = displayName

		v19.size = UDim2.fromOffset(60, 60)

		v19.thumbnailSize = Enum.ThumbnailSize.Size48x48
		recipientProfile = createElement6(TransferProfileThumbnail, v19)
	end

	local createElement6 = React.createElement

	local children2 = {
		ThumbnailAmountGap = React.createElement(View, {
			tag = "size-full-0",
			Size = UDim2.new(1, 0, 0, 20),
			LayoutOrder = 1
		}),
		AmountRow = 0,
		ErrorSlot = 0
	}

	local createElement7 = React.createElement

	local createElement8 = React.createElement
	local v19 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}
	local selectedAmountDisplay

	if not v3 then
		selectedAmountDisplay = React.createElement(RobuxText, { amount = v5, layoutOrder = 1 })
	end

	local desktopInputRow

	if v3 then
		local createElement9 = React.createElement
		local v20 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local v21 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			RobuxIconWrapper = React.createElement(
				"Frame",
				{
					Size = UDim2.fromOffset(
						math.round(v2.Typography.HeadingLarge.FontSize),
						(math.round(v2.Typography.DisplaySmall.FontSize))
					),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					RobuxIcon = React.createElement(Icon, {
						name = "robux",
						size = v2.Typography.HeadingLarge.FontSize,
						style = v2.Color.Content.Emphasis,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 4)
					})
				}
			),
			DesktopTextBox = 0
		}

		local createElement10 = React.createElement
		local v22 = {
			Text = not (v5 and v5 > 0) and "" or tostring(v5),
			PlaceholderText = "0",
			TextInputType = Enum.TextInputType.Number,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			PlaceholderColor3 = 0,
			AutomaticSize = 0,
			Size = 0,
			ClearTextOnFocus = false,
			LayoutOrder = 2,
			ref = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = v2.Typography.DisplaySmall.Font
		end

		v22.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v2.Typography.DisplaySmall.Font)
		end

		v22.FontFace = fontFace

		v22.TextSize = v2.Typography.DisplaySmall.FontSize
		v22.TextColor3 = v2.Color.Content.Emphasis.Color3
		v22.PlaceholderColor3 = v2.Color.Content.Emphasis.Color3
		v22.AutomaticSize = Enum.AutomaticSize.X
		v22.Size = UDim2.fromOffset(0, (math.round(v2.Typography.DisplaySmall.FontSize)))

		v22.ref = ref3
		v21.DesktopTextBox = createElement10("TextBox", v22)
		desktopInputRow = createElement9("Frame", v20, v21)
	end

	local amountTapTarget

	if not v3 then
		amountTapTarget = React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Text = "",
			BackgroundTransparency = 1,
			ZIndex = 2,
			[React.Event.Activated] = function()
				if ref.current then
					ref.current:CaptureFocus()
				end
			end
		})
	end

	children2.AmountRow = createElement7(View, {
		tag = "row align-x-center align-y-center",
		LayoutOrder = 2
	}, {
		AmountWrapper = createElement8("Frame", v19, {
			SelectedAmountDisplay = selectedAmountDisplay,
			DesktopInputRow = desktopInputRow,
			AmountTapTarget = amountTapTarget
		})
	})

	local createElement9 = React.createElement
	local v20 = {
		tag = "col align-x-center align-y-center size-full-0 padding-top-medium",
		Size = UDim2.new(1, 0, 0, 40),
		LayoutOrder = 3
	}
	local validationErrorText

	if text then
		validationErrorText = React.createElement(Text, {
			Text = text,
			tag = "auto-xy text-caption-small text-align-x-center content-system-alert",
			LayoutOrder = 1
		})
	end

	children2.ErrorSlot = createElement9(View, v20, { ValidationErrorText = validationErrorText })
	local v21 = {
		Content = createElement5(
			View,
			{
				tag = "col align-x-center items-center gap-xlarge size-full-0 auto-y padding-top-xlarge"
			},
			{
				RecipientProfile = recipientProfile,
				AmountContainer = createElement6(
					View,
					{ tag = "col align-x-center gap-large size-full-1600", LayoutOrder = 2 },
					children2
				)
			}
		),
		TapToFocusOverlay = 0
	}
	local tapToFocusOverlay

	if not v3 then
		tapToFocusOverlay = React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Text = "",
			BackgroundTransparency = 1,
			ZIndex = 2,
			[React.Event.Activated] = function()
				if ref.current then
					ref.current:CaptureFocus()
				end
			end
		})
	end

	v21.TapToFocusOverlay = tapToFocusOverlay
	children.Content = createElement2(content, { LayoutOrder = 2 }, {
		SheetContentContainer = createElement3(
			View,
			{
				tag = "col align-x-center items-center gap-large size-full-0 auto-y padding-x-large padding-top-xxlarge"
			},
			{
				RobuxInputWrapper = robuxInputWrapper,
				ThumbnailAndAmountArea = createElement4("Frame", v18, v21),
				AmountChips = React.createElement(
					View,
					{
						tag = "col align-x-center size-full-1600 auto-y",
						LayoutOrder = 2,
						ZIndex = 3
					},
					{
						Chips = React.createElement(TransferAmountOptionChips, {
							chips = chips,
							onChipSelected = onChipSelected,
							selectedAmount = v5,
							layoutOrder = 1
						})
					}
				)
			}
		)
	})

	children.Actions = React.createElement(Sheet.Actions, { LayoutOrder = 3 }, {
		React.createElement(View, {
			tag = "col align-x-center align-y-center gap-medium size-full-1000"
		}, {
			React.createElement(View, { tag = "row gap-small size-full-0 auto-y", LayoutOrder = 1 }, {
				React.createElement(Button, {
					text = v.Next,
					onActivated = onActivated,
					variant = ButtonVariant.Emphasis,
					fillBehavior = FillBehavior.Fill,
					isDisabled = isDisabled
				})
			}),
			Disclaimer = React.createElement(Text, {
				Text = text2,
				tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-center",
				LayoutOrder = 2
			})
		})
	})
	return createElement(
		root,
		{ preferCenterSheet = true, snapPoints = snapPoints, onClose = triggerOnClose, ref = ref2 },
		children
	)
end

return TransferRobuxInputSheet
