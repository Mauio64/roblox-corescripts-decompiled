local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")
local transferLocaleFormat = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/transferLocaleFormat")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SignalsReact")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local sheet = Foundation.Sheet
local button = Foundation.Button
local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local fillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Localization").Hooks.useLocalization

local RobuxText = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/RobuxText")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/TransferRobuxHeader")
local TransferAmountOptionChips = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/TransferAmountOptionChips")
local TransferProfileThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/TransferProfileThumbnail")

local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")

local useTextBoxOnChangeRef = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTextBoxOnChangeRef")
local useAutoFocusTextBoxOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useAutoFocusTextBoxOnMount")

local proceedToConfirm = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/proceedToConfirm")
local setTransferPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/setTransferPromptState")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
local GetFIntCurrencyTransferMinAmount = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFIntCurrencyTransferMinAmount")
local GetFIntCurrencyTransferMaxAmount = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFIntCurrencyTransferMaxAmount")
local GetFFlagCurrencyTransferFixTextBoxInput = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFixTextBoxInput")

local GetFFlagCurrencyTransferFlowUIImprovementFix = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFlowUIImprovementFix")
local GetFFlagCurrencyTransferFixDesktopInput = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFixDesktopInput")
local GetFFlagCurrencyTransferFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFocusNavigation")
local useTransferSheetFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferSheetFocus")

local GetFFlagCurrencyTransferUseBackendTransferLimits = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferUseBackendTransferLimits")
local FFlagShowRemainingTransfersForNonPlus = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/FFlagShowRemainingTransfersForNonPlus")

local FFlagCurrencyTransferHideAmountChipsAboveMax = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/FFlagCurrencyTransferHideAmountChipsAboveMax")
local TransferBenefitSource = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferBenefitSource")
local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local RobuxTransferFlowEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/RobuxTransferFlowEventName")
local logCurrencyTransferCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logCurrencyTransferCounter")
local logRobuxTransferFlowEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logRobuxTransferFlowEvent")
local formatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/formatNumber")

local function TransferRobuxInputSheet(p2)
	local v5 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxInputSheet)
	local v6 = useTokens()

	local v7 = GetFFlagCurrencyTransferFixDesktopInput() and not UserInputService.TouchEnabled

	local v8 = useTransferStore()

	React.useEffect(function(): nil
		logCurrencyTransferCounter(v8, CurrencyTransferTelemetry.CurrencyTransferInputSheetShownCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v8, RobuxTransferFlowEventName.input_shown)
		end

		return nil
	end, { v8 })

	local v9 = SignalsReact.useSignalState(v8.getSelectedAmount) or 0
	local setSelectedAmount = v8.setSelectedAmount
	local state, setState = React.useState(false)
	local v10 = SignalsReact.useSignalState(v8.getRobuxBalanceAmount) or 0
	local recipient = v8.getRecipient(false)
	local ref = React.useRef(nil)
	local v11 = SignalsReact.useSignalState(v8.getMinimumTransferAmount)
	local v12 = SignalsReact.useSignalState(v8.getMaximumTransferAmount)
	local v13 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v11 or GetFIntCurrencyTransferMinAmount()
	local v14 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v12 or GetFIntCurrencyTransferMaxAmount()

	local v15 = if FFlagShowRemainingTransfersForNonPlus then SignalsReact.useSignalState(v8.getTransferBenefitSource) else nil

	local v16 = if FFlagShowRemainingTransfersForNonPlus then SignalsReact.useSignalState(v8.getNumFreeTransfersRemaining) else nil

	local v17 = if FFlagShowRemainingTransfersForNonPlus and v16 ~= nil then formatNumber(LocalizationService.RobloxLocaleId, v16) else nil

	local v18 = useLocalization({
		FreeTransfersRemaining = FFlagShowRemainingTransfersForNonPlus and v17 ~= nil and v16 ~= 1 and {
			"Features.Transfers.RobuxTransfer.FreeTransfersRemaining",
			numFreeTransfersRemaining = v17
		} or nil,
		FreeTransfersRemainingSingular = FFlagShowRemainingTransfersForNonPlus and v16 == 1 and "Features.Transfers.RobuxTransfer.FreeTransfersRemainingSingular" or nil
	})

	React.useEffect(function()
		if v9 == 0 or v13 <= v9 and v9 <= v14 then
			setState(false)
		end
	end, { v9, v13, v14 })

	local v19 = React.useCallback(function()
		if v9 and (v9 < v13 or v14 < v9) then
			setState(true)
		elseif v9 and v10 < v9 then
			setTransferPromptState(v8, PromptState.TransferInsufficientBalance)
		else
			proceedToConfirm(v8, v9 or 0)
		end
	end, { v8, v9, v10, v13, v14 })

	local v22 = useTextBoxOnChangeRef(React.useCallback(function(value)
		setSelectedAmount(value or 0)
	end, { setSelectedAmount }), (React.useCallback(function(p3, p4)
		if not p3 and p4 then
			if v9 and v9 > 0 and (v9 < v13 or v14 < v9) then
				setState(true)
			else
				v19()
			end
		end
	end, { v19, v9, v13, v14 })))
	local triggerOnClose = v8.triggerOnClose

	local v23 = if GetFFlagCurrencyTransferFocusNavigation() then useTransferSheetFocus(triggerOnClose) else nil

	local v24 = useAutoFocusTextBoxOnMount(v22, 0.05)
	local v25 = React.useCallback(function(current)
		if current then
			ref.current = current
			v24(current)
		end
	end, { v24 })

	local v26 = React.useMemo(function()
		local v27 = {
			{ amount = 25, text = "25" },
			{ amount = 50, text = "50" },
			{ amount = 100, text = "100" },
			{ amount = 200, text = "200" }
		}

		if not FFlagCurrencyTransferHideAmountChipsAboveMax and (not FFlagShowRemainingTransfersForNonPlus or v15 ~= TransferBenefitSource.Free) then
			return v27
		end

		local result = {}

		for k, v28 in v27 do
			if v28.amount <= v14 then
				table.insert(result, v28)
			end
		end

		return result
	end, { v15, v14 })

	local v27 = React.useCallback(function(p3)
		setSelectedAmount(p3)

		local current = GetFFlagCurrencyTransferFlowUIImprovementFix() and ref.current

		if current then
			current:ReleaseFocus()
		end
	end, { setSelectedAmount })

	local v28 = v9 > 0 and (v9 < v13 or v14 < v9)
	local v29 = state and v28
	local v30 = React.useMemo(function()
		if not v29 or not v9 or v9 <= 0 then
			return nil
		end

		if v9 < v13 then
			local v31 = formatNumber(LocalizationService.RobloxLocaleId, v13)
			return transferLocaleFormat.substituteAmount(v5.LowerThanMinAmount or "", (tostring(v31)))
		end

		if v14 < v9 then
			local v31 = formatNumber(LocalizationService.RobloxLocaleId, v14)
			return transferLocaleFormat.substituteAmount(v5.GreaterThanMaxAmount or "", (tostring(v31)))
		end

		return nil
	end, { v29, v9, v13, v14, v5.LowerThanMinAmount, v5.GreaterThanMaxAmount })

	local v31 = React.useMemo(function(): boolean
		return not v9 or v9 <= 0
	end, { v9 })

	local v32 = useScaledValue(500)

	local v33 = React.useMemo(function()
		return { v32, 0.62 }
	end, { v32 })

	local v34 = v5.Disclaimer

	if FFlagShowRemainingTransfersForNonPlus and v15 == TransferBenefitSource.Free and v16 ~= nil then
		v34 = if v16 == 1 then v18.FreeTransfersRemainingSingular else v18.FreeTransfersRemaining
	end

	local createElement = React.createElement
	local root = sheet.Root

	local children = {
		Header = React.createElement(sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(module8, {
				titleText = v5.SendRobux,
				robuxBalanceAmount = v10
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content

	local createElement3 = React.createElement
	local v40

	if not v7 then
		local createElement4 = React.createElement
		local v42 = {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = 0
		}

		local createElement5 = React.createElement
		local v45 = {
			Size = UDim2.new(0, 80, 0, 40),
			Position = UDim2.new(0, -10000, 0, 0),
			BackgroundTransparency = 1
		}

		local createElement6 = React.createElement
		local v48 = {
			Size = UDim2.new(1, 0, 1, 0),
			Text = 0,
			PlaceholderText = "",
			TextInputType = 0,
			BackgroundTransparency = 1,
			ClearTextOnFocus = 0,
			ref = 0
		}

		local v49 = if v9 and v9 > 0 then tostring(v9) else GetFFlagCurrencyTransferFixTextBoxInput() and "" or "0"
		v48.Text = v49

		v48.TextInputType = Enum.TextInputType.Number

		v48.ClearTextOnFocus = not GetFFlagCurrencyTransferFlowUIImprovementFix()
		v48.ref = v25
		v40 = createElement4("Frame", v42, {
			RobuxInput = createElement5("Frame", v45, {
				TextBox = createElement6("TextBox", v48)
			})
		})
	end

	local createElement4 = React.createElement
	local v42 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local createElement5 = React.createElement
	local v47

	if recipient and recipient.targetId then
		local createElement6 = React.createElement
		local v49 = {
			userId = tostring(recipient.targetId),
			username = 0,
			displayName = 0,
			showUsername = true,
			size = 0,
			layoutOrder = 1,
			thumbnailSize = 0
		}
		local v50 = if not GetFFlagCurrencyTransferFlowUIImprovementFix() then recipient.targetName else nil
		v49.username = v50

		local v51 = if GetFFlagCurrencyTransferFlowUIImprovementFix() then recipient.targetDisplayName else nil
		v49.displayName = v51

		v49.size = UDim2.fromOffset(60, 60)

		v49.thumbnailSize = Enum.ThumbnailSize.Size48x48
		v47 = createElement6(TransferProfileThumbnail, v49)
	end

	local createElement6 = React.createElement

	local children3 = {
		ThumbnailAmountGap = React.createElement(view, {
			tag = "size-full-0",
			Size = UDim2.new(1, 0, 0, 20),
			LayoutOrder = 1
		}),
		AmountRow = 0,
		ErrorSlot = 0
	}

	local createElement7 = React.createElement

	local createElement8 = React.createElement
	local v54 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local v56 = if not v7 then React.createElement(RobuxText, {
		amount = v9,
		layoutOrder = 1
	}) else nil
	local v57

	if v7 then
		local createElement9 = React.createElement
		local v59 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local v60 = {
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
						math.round(v6.Typography.HeadingLarge.FontSize),
						(math.round(v6.Typography.DisplaySmall.FontSize))
					),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					RobuxIcon = React.createElement(icon, {
						name = "robux",
						size = v6.Typography.HeadingLarge.FontSize,
						style = v6.Color.Content.Emphasis,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 4)
					})
				}
			),
			DesktopTextBox = 0
		}

		local createElement10 = React.createElement
		local v62 = {
			Text = not (v9 and v9 > 0) and "" or tostring(v9),
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

		local v63 = if not foundationFontFaceMigration then v6.Typography.DisplaySmall.Font else nil
		v62.Font = v63

		local v64 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.DisplaySmall.Font) else nil
		v62.FontFace = v64

		v62.TextSize = v6.Typography.DisplaySmall.FontSize
		v62.TextColor3 = v6.Color.Content.Emphasis.Color3
		v62.PlaceholderColor3 = v6.Color.Content.Emphasis.Color3
		v62.AutomaticSize = Enum.AutomaticSize.X
		v62.Size = UDim2.fromOffset(0, (math.round(v6.Typography.DisplaySmall.FontSize)))

		v62.ref = v25
		v60.DesktopTextBox = createElement10("TextBox", v62)
		v57 = createElement9("Frame", v59, v60)
	end

	local v58

	if not v7 then
		v58 = React.createElement("TextButton", {
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

	children3.AmountRow = createElement7(
		view,
		{ tag = "row align-x-center align-y-center", LayoutOrder = 2 },
		{
			AmountWrapper = createElement8("Frame", v54, {
				SelectedAmountDisplay = v56,
				DesktopInputRow = v57,
				AmountTapTarget = v58
			})
		}
	)

	local createElement9 = React.createElement
	local v60 = {
		tag = "col align-x-center align-y-center size-full-0 padding-top-medium",
		Size = UDim2.new(1, 0, 0, 40),
		LayoutOrder = 3
	}

	local v62 = if v30 then React.createElement(text, {
		Text = v30,
		tag = "auto-xy text-caption-small text-align-x-center content-system-alert",
		LayoutOrder = 1
	}) else nil
	children3.ErrorSlot = createElement9(view, v60, { ValidationErrorText = v62 })
	local v43 = {
		Content = createElement5(
			view,
			{
				tag = "col align-x-center items-center gap-xlarge size-full-0 auto-y padding-top-xlarge"
			},
			{
				RecipientProfile = v47,
				AmountContainer = createElement6(
					view,
					{
						tag = "col align-x-center gap-large size-full-1600",
						LayoutOrder = 2
					},
					children3
				)
			}
		),
		TapToFocusOverlay = 0
	}
	local v63

	if not v7 then
		v63 = React.createElement("TextButton", {
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

	v43.TapToFocusOverlay = v63
	children.Content = createElement2(content, { LayoutOrder = 2 }, {
		SheetContentContainer = createElement3(
			view,
			{
				tag = "col align-x-center items-center gap-large size-full-0 auto-y padding-x-large padding-top-xxlarge"
			},
			{
				RobuxInputWrapper = v40,
				ThumbnailAndAmountArea = createElement4("Frame", v42, v43),
				AmountChips = React.createElement(
					view,
					{
						tag = "col align-x-center size-full-1600 auto-y",
						LayoutOrder = 2,
						ZIndex = 3
					},
					{
						Chips = React.createElement(TransferAmountOptionChips, {
							chips = v26,
							onChipSelected = v27,
							selectedAmount = v9,
							layoutOrder = 1
						})
					}
				)
			}
		)
	})

	children.Actions = React.createElement(sheet.Actions, { LayoutOrder = 3 }, {
		React.createElement(
			view,
			{ tag = "col align-x-center align-y-center gap-medium size-full-1000" },
			{
				React.createElement(view, {
					tag = "row gap-small size-full-0 auto-y",
					LayoutOrder = 1
				}, {
					React.createElement(button, {
						text = v5.Next,
						onActivated = v19,
						variant = buttonVariant.Emphasis,
						fillBehavior = fillBehavior.Fill,
						isDisabled = v31
					})
				}),
				Disclaimer = React.createElement(text, {
					Text = v34,
					tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-center",
					LayoutOrder = 2
				})
			}
		)
	})
	return createElement(
		root,
		{
			preferCenterSheet = true,
			snapPoints = v33,
			onClose = triggerOnClose,
			ref = v23
		},
		children
	)
end

return TransferRobuxInputSheet
