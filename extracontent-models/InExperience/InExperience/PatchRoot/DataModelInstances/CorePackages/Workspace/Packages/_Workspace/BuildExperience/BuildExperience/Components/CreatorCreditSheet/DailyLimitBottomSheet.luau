local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local LocalizationService = game:GetService("LocalizationService")

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Localization2 = require(parent.Localization)
local useLocalization = Localization2.Hooks.useLocalization

local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport

local Button = Foundation.Button
local Chip = Foundation.Chip
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View
local Sheet = Foundation.Sheet

local ButtonVariant = Foundation.Enums.ButtonVariant
local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize

local v = { 2000, 5000 }

local function formatNumber(p: number) -- 3 equivalent calls inferred from this helper
	return NumberLocalization.localize(string.format("%.0f", (math.floor(p))), LocalizationService.RobloxLocaleId)
end

local function DailyLimitBottomSheetContent(props)
	local additionalUsed = props.additionalUsed or 0
	local v2 = useLocalization({
		belowSpend = {
			LocalizationStrings.CREATOR_CREDIT_LIMIT_BELOW_SPEND,
			ALREADY_SPENT = formatNumber(additionalUsed) -- inferred equivalent call
		},
		confirm = LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_CONFIRM,
		noLimit = LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_NO_LIMIT,
		saveError = LocalizationStrings.CREATOR_CREDIT_SETTINGS_SAVE_ERROR,
		title = LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_TITLE
	})

	local belowSpend = v2.belowSpend
	local confirm = v2.confirm
	local text = v2.noLimit
	local text2 = v2.saveError
	local title = v2.title
	local testId = props.testId or "creator-credit-limit-sheet"

	local v3 = math.max(props.initialValue or 500, 100)
	local isSaving = props.isSaving == true

	local state, setState = React.useState(v3)
	local state2, setState2 = React.useState(props.initialIsNoLimit == true)

	local onActivated = React.useCallback(function()
		setState2(false)
		setState(function(p)
			return (math.max(p - 500, 100))
		end)
	end, {})

	local onActivated2 = React.useCallback(function()
		setState2(false)
		setState(function(p)
			return p + 500
		end)
	end, {})

	local v4 = React.useCallback(function(p: number)
		setState2(false)
		setState((math.max(p, 100)))
	end, {})

	local onActivated3 = React.useCallback(function()
		setState2(true)
	end, {})

	local v5 = not state2 and state < additionalUsed

	if v5 then
		text2 = belowSpend
	elseif not props.saveError then
		text2 = nil
	end

	local onActivated4 = React.useCallback(function()
		if state2 then
			props.onConfirm(nil)
			return
		end

		if state < additionalUsed then
			return
		end

		props.onConfirm(state)
	end, { state, additionalUsed, state2, props.onConfirm })

	local children = {
		NoLimit = React.createElement(Chip, {
			LayoutOrder = 1,
			text = text,
			leading = IconName.CircleX,
			variant = ChipVariant.Standard,
			size = ChipSize.Medium,
			onActivated = onActivated3,
			isDisabled = isSaving,
			testId = `{testId}-preset-no-limit`
		})
	}

	for k, v6 in v do
		children[`Preset{v6}`] = React.createElement(Chip, {
			LayoutOrder = 1 + k,
			text = formatNumber(v6), -- inferred equivalent call
			leading = IconName.Robux,
			variant = ChipVariant.Standard,
			size = ChipSize.Medium,
			onActivated = function()
				v4(v6)
			end,
			isDisabled = isSaving,
			testId = `{testId}-preset-{v6}`
		})
	end

	local createElement = React.createElement
	local root = Sheet.Root
	local v6 = { isOpen = true, preferCenterSheet = true, onClose = props.onCancel }
	local children2 = {
		Header = React.createElement(Sheet.Header, { hasCloseAffordance = true }, {
			Title = React.createElement(Text, {
				Text = title,
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content
	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local children4 = {
		Minus = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = IconName.MinusSmall,
			isCircular = true,
			variant = ButtonVariant.Utility,
			size = InputSize.Medium,
			onActivated = onActivated,
			isDisabled = isSaving or state2 or state <= 100,
			testId = `{testId}-decrement`
		}),
		ValueDisplay = 0,
		Plus = 0
	}

	local createElement5 = React.createElement

	local createElement6 = React.createElement

	local name = if state2 then IconName.CircleX else IconName.Robux
	local children5 = {
		IconEl = createElement6(Icon, {
			LayoutOrder = 1,
			name = name,
			size = IconSize.Large,
			tag = "auto-xy content-emphasis"
		}),
		Amount = 0
	}

	local createElement7 = React.createElement

	if not state2 then
		text = formatNumber(state) -- inferred equivalent call
	end

	children5.Amount = createElement7(Text, {
		LayoutOrder = 2,
		Text = text,
		tag = "auto-xy text-heading-medium content-emphasis",
		OpenTypeFeatures = GetFFlagLuaAppEnableOpenTypeSupport() and "tnum" or nil,
		testId = `{testId}-value`
	})
	children4.ValueDisplay = createElement5(
		View,
		{ LayoutOrder = 2, tag = "row align-y-center gap-small auto-xy" },
		children5
	)

	children4.Plus = React.createElement(IconButton, {
		LayoutOrder = 3,
		icon = IconName.PlusSmall,
		isCircular = true,
		variant = ButtonVariant.Utility,
		size = InputSize.Medium,
		onActivated = onActivated2,
		isDisabled = isSaving or state2,
		testId = `{testId}-increment`
	})
	local children3 = {
		Stepper = createElement4(
			View,
			{
				LayoutOrder = 1,
				tag = "row align-x-center align-y-center gap-large size-full-0 auto-y padding-y-medium"
			},
			children4
		),
		Chips = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row align-x-center align-y-center gap-small size-full-0 auto-y"
			},
			children
		),
		Error = 0
	}
	local err

	if text2 then
		local createElement8 = React.createElement
		local testId2

		if v5 then
			testId2 = `{testId}-below-spend-error`
		else
			testId2 = `{testId}-save-error`
		end

		err = createElement8(Text, {
			LayoutOrder = 3,
			Text = text2,
			tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-center content-system-alert",
			testId = testId2
		})
	end

	children3.Error = err
	children2.Content = createElement2(content, nil, {
		Body = createElement3(View, { tag = "col gap-large size-full-0 auto-y" }, children3)
	})

	children2.Actions = React.createElement(Sheet.Actions, nil, {
		Confirm = React.createElement(Button, {
			text = confirm,
			size = InputSize.Large,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill,
			onActivated = onActivated4,
			isDisabled = isSaving or v5,
			testId = `{testId}-confirm`
		})
	})
	return createElement(root, v6, children2)
end

local function DailyLimitBottomSheet(p)
	if p.isOpen then
		return React.createElement(DailyLimitBottomSheetContent, p)
	end

	return nil
end

return DailyLimitBottomSheet
