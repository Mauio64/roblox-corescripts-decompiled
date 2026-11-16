local LocalizationService = game:GetService("LocalizationService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").NumberLocalization
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local getFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport

local button = Foundation.Button
local chip = Foundation.Chip
local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local text = Foundation.Text
local view = Foundation.View
local sheet = Foundation.Sheet

local buttonVariant = Foundation.Enums.ButtonVariant
local chipSize = Foundation.Enums.ChipSize
local chipVariant = Foundation.Enums.ChipVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize

local v5 = { 2000, 5000 }

local function formatNumber(p2)
	return numberLocalization.localize(
		string.format("%.0f", (math.floor(p2))),
		LocalizationService.RobloxLocaleId
	)
end

local function DailyLimitBottomSheetContent(props)
	local additionalUsed = props.additionalUsed or 0
	local v6 = useLocalization({
		belowSpend = {
			LocalizationStrings.CREATOR_CREDIT_LIMIT_BELOW_SPEND,
			ALREADY_SPENT = numberLocalization.localize(
				string.format("%.0f", (math.floor(additionalUsed))),
				LocalizationService.RobloxLocaleId
			)
		},
		confirm = LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_CONFIRM,
		noLimit = LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_NO_LIMIT,
		saveError = LocalizationStrings.CREATOR_CREDIT_SETTINGS_SAVE_ERROR,
		title = LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_TITLE
	})

	local belowSpend = v6.belowSpend
	local confirm = v6.confirm
	local v7 = v6.noLimit
	local v8 = v6.saveError
	local title = v6.title
	local testId = props.testId or "creator-credit-limit-sheet"

	local v9 = math.max(props.initialValue or 500, 100)
	local isSaving = props.isSaving == true

	local state, setState = React.useState(v9)
	local state2, setState2 = React.useState(props.initialIsNoLimit == true)

	local v10 = React.useCallback(function()
		setState2(false)
		setState(function(p2)
			return (math.max(p2 - 500, 100))
		end)
	end, {})

	local v11 = React.useCallback(function()
		setState2(false)
		setState(function(p2)
			return p2 + 500
		end)
	end, {})

	local v12 = React.useCallback(function(p2)
		setState2(false)
		setState((math.max(p2, 100)))
	end, {})

	local v13 = React.useCallback(function()
		setState2(true)
	end, {})

	local v14 = not state2 and state < additionalUsed

	if v14 then
		v8 = belowSpend
	elseif not props.saveError then
		v8 = nil
	end

	local v15 = React.useCallback(function()
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
		NoLimit = React.createElement(chip, {
			LayoutOrder = 1,
			text = v7,
			leading = iconName.CircleX,
			variant = chipVariant.Standard,
			size = chipSize.Medium,
			onActivated = v13,
			isDisabled = isSaving,
			testId = `{testId}-preset-no-limit`
		})
	}

	for k, v16 in v5 do
		children[`Preset{v16}`] = React.createElement(chip, {
			LayoutOrder = 1 + k,
			text = numberLocalization.localize(
				string.format("%.0f", (math.floor(v16))),
				LocalizationService.RobloxLocaleId
			),
			leading = iconName.Robux,
			variant = chipVariant.Standard,
			size = chipSize.Medium,
			onActivated = function()
				v12(v16)
			end,
			isDisabled = isSaving,
			testId = `{testId}-preset-{v16}`
		})
	end

	local createElement = React.createElement
	local root = sheet.Root
	local v16 = { isOpen = true, preferCenterSheet = true, onClose = props.onCancel }
	local children2 = {
		Header = React.createElement(sheet.Header, { hasCloseAffordance = true }, {
			Title = React.createElement(text, {
				Text = title,
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content
	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local children4 = {
		Minus = React.createElement(iconButton, {
			LayoutOrder = 1,
			icon = iconName.MinusSmall,
			isCircular = true,
			variant = buttonVariant.Utility,
			size = inputSize.Medium,
			onActivated = v10,
			isDisabled = isSaving or state2 or state <= 100,
			testId = `{testId}-decrement`
		}),
		ValueDisplay = 0,
		Plus = 0
	}

	local createElement5 = React.createElement

	local createElement6 = React.createElement

	local v27 = if state2 then iconName.CircleX else iconName.Robux
	local children5 = {
		IconEl = createElement6(icon, {
			LayoutOrder = 1,
			name = v27,
			size = iconSize.Large,
			tag = "auto-xy content-emphasis"
		}),
		Amount = 0
	}

	local createElement7 = React.createElement

	if not state2 then
		v7 = numberLocalization.localize(
			string.format("%.0f", (math.floor(state))),
			LocalizationService.RobloxLocaleId
		)
	end

	children5.Amount = createElement7(text, {
		LayoutOrder = 2,
		Text = v7,
		tag = "auto-xy text-heading-medium content-emphasis",
		OpenTypeFeatures = getFFlagLuaAppEnableOpenTypeSupport() and "tnum" or nil,
		testId = `{testId}-value`
	})
	children4.ValueDisplay = createElement5(
		view,
		{ LayoutOrder = 2, tag = "row align-y-center gap-small auto-xy" },
		children5
	)

	children4.Plus = React.createElement(iconButton, {
		LayoutOrder = 3,
		icon = iconName.PlusSmall,
		isCircular = true,
		variant = buttonVariant.Utility,
		size = inputSize.Medium,
		onActivated = v11,
		isDisabled = isSaving or state2,
		testId = `{testId}-increment`
	})
	local children3 = {
		Stepper = createElement4(
			view,
			{
				LayoutOrder = 1,
				tag = "row align-x-center align-y-center gap-large size-full-0 auto-y padding-y-medium"
			},
			children4
		),
		Chips = React.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "row align-x-center align-y-center gap-small size-full-0 auto-y"
			},
			children
		),
		Error = 0
	}
	local v30

	if v8 then
		local createElement8 = React.createElement

		local v33 = if v14 then `{testId}-below-spend-error` else `{testId}-save-error`
		v30 = createElement8(text, {
			LayoutOrder = 3,
			Text = v8,
			tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-center content-system-alert",
			testId = v33
		})
	end

	children3.Error = v30
	children2.Content = createElement2(content, nil, {
		Body = createElement3(view, { tag = "col gap-large size-full-0 auto-y" }, children3)
	})

	children2.Actions = React.createElement(sheet.Actions, nil, {
		Confirm = React.createElement(button, {
			text = confirm,
			size = inputSize.Large,
			variant = buttonVariant.Emphasis,
			fillBehavior = fillBehavior.Fill,
			onActivated = v15,
			isDisabled = isSaving or v14,
			testId = `{testId}-confirm`
		})
	})
	return createElement(root, v16, children2)
end

local function DailyLimitBottomSheet(p2)
	if p2.isOpen then
		return React.createElement(DailyLimitBottomSheetContent, p2)
	end

	return nil
end

return DailyLimitBottomSheet
