local LocalizationService = game:GetService("LocalizationService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").NumberLocalization
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local FFlagBuildExperienceFreeTrialResetPeriod = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFreeTrialResetPeriod")

local button = Foundation.Button
local icon = Foundation.Icon
local progress = Foundation.Progress
local text = Foundation.Text
local toggle = Foundation.Toggle
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local progressShape = Foundation.Enums.ProgressShape
local progressSize = Foundation.Enums.ProgressSize

local function noop() end

local function clampPct(p2)
	if p2 < 0 then
		return 0
	end

	if p2 > 100 then
		return 100
	end

	return p2
end

local function formatNumber(p2)
	return numberLocalization.localize(
		string.format("%.0f", (math.floor(p2))),
		LocalizationService.RobloxLocaleId
	)
end

local function FreeUsageCard(props)
	local pctUsed = props.pctUsed
	local v5 = pctUsed < 0 and 0 or pctUsed > 100 and 100 or pctUsed

	local v7 = {
		caption = LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_CAPTION,
		captionWeekly = LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_CAPTION_WEEKLY,
		captionMonthly = LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_CAPTION_MONTHLY,
		label = LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_LABEL,
		percentUsed = {
			LocalizationStrings.CREATOR_CREDIT_PERCENT_USED,
			PERCENT = math.floor(v5 + 0.5)
		},
		resetHours = 0
	}

	local v8 = if props.resetHours == 1 then LocalizationStrings.CREATOR_CREDIT_RESET_ONE_HOUR else props.resetHours ~= nil and {
		LocalizationStrings.CREATOR_CREDIT_RESET_HOURS,
		HOURS = props.resetHours
	} or nil
	v7.resetHours = v8
	local v9 = useLocalization(v7)

	local label = v9.label
	local percentUsed = v9.percentUsed
	local v10

	if FFlagBuildExperienceFreeTrialResetPeriod then
		if props.resetPeriod == "Weekly" then
			v10 = v9.captionWeekly
		else
			v10 = if props.resetPeriod == "Monthly" then v9.captionMonthly else v9.caption
		end

		if
			(props.resetPeriod == nil or props.resetPeriod == "Daily")
			and math.floor(v5 + 0.5) > 0
			and props.resetHours ~= nil
		then
			v10 = v9.resetHours
		end
	else
		v10 = v9.caption

		if math.floor(v5 + 0.5) > 0 and props.resetHours ~= nil then
			v10 = v9.resetHours
		end
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col gap-small size-full-0 auto-y padding-large radius-large bg-shift-100",
			testId = "creator-credit-page-free-usage-card"
		},
		{
			Label = React.createElement(text, {
				LayoutOrder = 1,
				Text = label,
				tag = "size-full-0 auto-y text-title-medium text-align-x-left content-emphasis",
				testId = "creator-credit-page-free-usage-label"
			}),
			Value = React.createElement(text, {
				LayoutOrder = 2,
				Text = percentUsed,
				tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
				testId = "creator-credit-page-free-usage-value"
			}),
			Bar = React.createElement(progress, {
				LayoutOrder = 3,
				shape = progressShape.Bar,
				size = progressSize.Medium,
				value = v5,
				width = UDim.new(1, 0),
				testId = "creator-credit-page-daily-progress"
			}),
			Caption = React.createElement(text, {
				LayoutOrder = 4,
				Text = v10,
				tag = "size-full-0 auto-y padding-top-medium text-body-small text-align-x-left content-muted",
				testId = "creator-credit-page-free-usage-reset"
			})
		}
	)
end

local function RobuxLine(props)
	local amount = props.amount
	local localize = numberLocalization.localize(
		string.format("%.0f", (math.floor(amount))),
		LocalizationService.RobloxLocaleId
	)

	local usedOf = props.usedOf

	if props.kind == "used" then
		assert(usedOf ~= nil, "usedOf required when kind == 'used'")
	end

	local v5 = usedOf == nil and ""
		or numberLocalization.localize(
			string.format("%.0f", (math.floor(usedOf))),
			LocalizationService.RobloxLocaleId
		)
	local v7 = {
		available = props.kind == "available" and {
			LocalizationStrings.CREATOR_CREDIT_AMOUNT_AVAILABLE,
			AMOUNT = localize
		} or nil,
		used = 0
	}

	local v8 = if props.kind == "used" then {
		LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_USED,
		USED = localize,
		LIMIT = v5
	} else props.kind == "usedNoLimit" and {
		LocalizationStrings.CREATOR_CREDIT_UNLIMITED_USED,
		USED = localize
	} or nil
	v7.used = v8
	local v9 = useLocalization(v7)

	local v10 = if props.kind == "available" then v9.available else v9.used

	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-bottom-medium"
		},
		{
			IconEl = React.createElement(icon, {
				LayoutOrder = 1,
				name = iconName.Robux,
				size = iconSize.Medium,
				tag = {
					["auto-xy"] = true,
					["content-muted"] = not props.isEnabled,
					["content-emphasis"] = props.isEnabled
				}
			}),
			Amount = React.createElement(text, {
				LayoutOrder = 2,
				Text = v10,
				tag = {
					["auto-xy text-heading-small"] = true,
					["content-muted"] = not props.isEnabled,
					["content-emphasis"] = props.isEnabled
				},
				testId = "creator-credit-page-robux-line"
			})
		}
	)
end

local function AdditionalUsageCard(props)
	local v5 = useLocalization({
		additionalDailyUsage = LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_DAILY_USAGE_LABEL,
		additionalUsage = LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_USAGE_LABEL,
		description = LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_USAGE_DESCRIPTION,
		setDailyLimit = LocalizationStrings.CREATOR_CREDIT_SET_DAILY_LIMIT,
		manageLimit = LocalizationStrings.CREATOR_CREDIT_MANAGE_LIMIT,
		settingsSaveError = LocalizationStrings.CREATOR_CREDIT_SETTINGS_SAVE_ERROR,
		buyRobux = LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_BUTTON
	})

	local additionalDailyUsage = v5.additionalDailyUsage
	local v6 = v5.additionalUsage
	local description = v5.description
	local v7 = v5.setDailyLimit
	local manageLimit = v5.manageLimit
	local settingsSaveError = v5.settingsSaveError
	local buyRobux = v5.buyRobux
	local v8 = props.additionalEnabled and props.dailyLimit ~= nil
	local v9 = v8 or props.additionalEnabled and props.hasLimitConfigured == true
	local v10 = v9 and not v8

	if props.additionalEnabled then
		v6 = additionalDailyUsage
	end

	local children = {}

	children.Header = React.createElement(
		view,
		{ LayoutOrder = 1, tag = "row align-y-center size-full-0 auto-y" },
		{
			Label = React.createElement(text, {
				LayoutOrder = 1,
				Text = v6,
				tag = {
					["fill auto-y text-title-medium text-align-x-left"] = true,
					["content-default"] = not props.additionalEnabled,
					["content-emphasis"] = props.additionalEnabled
				},
				testId = "creator-credit-page-additional-usage-label"
			}),
			ToggleSwitch = React.createElement(toggle, {
				LayoutOrder = 2,
				size = inputSize.Medium,
				label = "",
				isChecked = props.additionalEnabled,
				isDisabled = props.settingsDisabled == true,
				onActivated = function(p2)
					if not props.settingsDisabled then
						props.onToggleAdditional(p2)
					end
				end,
				testId = "creator-credit-page-additional-toggle"
			})
		}
	)

	if v8 then
		assert(props.dailyLimit ~= nil, "dailyLimit must be provided when a numeric limit is configured")
		children.UsageLine = React.createElement(RobuxLine, {
			LayoutOrder = 2,
			amount = props.additionalUsed,
			kind = "used",
			usedOf = props.dailyLimit,
			isEnabled = props.additionalEnabled
		})
	elseif v10 then
		children.UsageLine = React.createElement(RobuxLine, {
			LayoutOrder = 2,
			amount = props.additionalUsed,
			kind = "usedNoLimit",
			isEnabled = props.additionalEnabled
		})
	else
		children.AvailableLine = React.createElement(RobuxLine, {
			LayoutOrder = 2,
			amount = props.robuxAvailable,
			kind = "available",
			isEnabled = props.additionalEnabled
		})
	end

	if props.additionalEnabled then
		if v9 then
			v7 = manageLimit
		end

		local createElement = React.createElement

		local v15 = if props.showBuyRobux then React.createElement(button, {
			LayoutOrder = 1,
			text = buyRobux,
			variant = buttonVariant.Emphasis,
			size = inputSize.Medium,
			onActivated = props.onOpenBuyRobux or noop,
			isDisabled = props.onOpenBuyRobux == nil,
			testId = "creator-credit-page-buy-robux"
		}) else nil
		children.ActionsRow = createElement(
			view,
			{
				LayoutOrder = 3,
				tag = "row align-x-left align-y-center gap-small size-full-0 auto-y"
			},
			{
				BuyRobuxButton = v15,
				LimitButton = React.createElement(button, {
					LayoutOrder = 2,
					text = v7,
					variant = buttonVariant.Standard,
					size = inputSize.Medium,
					onActivated = props.onOpenLimitSheet or noop,
					isDisabled = props.settingsDisabled == true or props.onOpenLimitSheet == nil,
					testId = v9 and "creator-credit-page-manage-limit" or "creator-credit-page-set-daily-limit"
				})
			}
		)
	else
		children.Description = React.createElement(text, {
			LayoutOrder = 3,
			Text = description,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted"
		})
	end

	if props.settingsError then
		children.SettingsError = React.createElement(text, {
			LayoutOrder = 4,
			Text = settingsSaveError,
			tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-left content-system-alert",
			testId = "creator-credit-page-settings-error"
		})
	end

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["col gap-small size-full-0 auto-y padding-large radius-large"] = true,
			["bg-shift-100"] = props.additionalEnabled,
			["stroke-standard stroke-default"] = not props.additionalEnabled
		},
		testId = "creator-credit-page-additional-usage-card"
	}, children)
end

local function CreatorCreditPageView(props)
	return React.createElement(view, {
		tag = "col gap-medium size-full-0 auto-y padding-y-xlarge",
		testId = props.testId or "creator-credit-page"
	}, {
		FreeUsage = React.createElement(FreeUsageCard, {
			LayoutOrder = 1,
			pctUsed = props.dailyPctUsed,
			resetHours = props.resetHours,
			resetPeriod = props.resetPeriod
		}),
		AdditionalUsage = React.createElement(AdditionalUsageCard, {
			LayoutOrder = 2,
			additionalEnabled = props.additionalEnabled,
			dailyLimit = props.dailyLimit,
			hasLimitConfigured = props.hasLimitConfigured,
			additionalUsed = props.additionalUsed,
			robuxAvailable = props.robuxAvailable,
			settingsDisabled = props.settingsDisabled,
			settingsError = props.settingsError,
			showBuyRobux = props.showBuyRobux,
			onToggleAdditional = props.onToggleAdditional,
			onOpenLimitSheet = props.onOpenLimitSheet,
			onOpenBuyRobux = props.onOpenBuyRobux
		})
	})
end

return CreatorCreditPageView
