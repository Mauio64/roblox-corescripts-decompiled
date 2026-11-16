local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local LocalizationService = game:GetService("LocalizationService")

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization
local React = require(parent.React)
local Localization2 = require(parent.Localization)
local useLocalization = Localization2.Hooks.useLocalization

local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local FFlagBuildExperienceFreeTrialResetPeriod = require(BuildExperience.Flags.FFlagBuildExperienceFreeTrialResetPeriod)

local Button = Foundation.Button
local Icon = Foundation.Icon
local Progress = Foundation.Progress
local Text = Foundation.Text
local Toggle = Foundation.Toggle
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize

local function noop() end

local function clampPct(pctUsed: number) -- 1 equivalent call inferred from this helper
	if pctUsed < 0 then
		return 0
	end

	return if pctUsed > 100 then 100 else pctUsed
end

local function formatNumber(p: number) -- 2 equivalent calls inferred from this helper
	return NumberLocalization.localize(string.format("%.0f", (math.floor(p))), LocalizationService.RobloxLocaleId)
end

local function FreeUsageCard(props)
	local v = clampPct(props.pctUsed) -- inferred equivalent call
	local v2 = {
		caption = LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_CAPTION,
		captionWeekly = LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_CAPTION_WEEKLY,
		captionMonthly = LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_CAPTION_MONTHLY,
		label = LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_LABEL,
		percentUsed = {
			LocalizationStrings.CREATOR_CREDIT_PERCENT_USED,
			PERCENT = math.floor(v + 0.5)
		},
		resetHours = 0
	}
	local resetHours

	if props.resetHours == 1 then
		resetHours = LocalizationStrings.CREATOR_CREDIT_RESET_ONE_HOUR
	else
		resetHours = props.resetHours ~= nil and {
			LocalizationStrings.CREATOR_CREDIT_RESET_HOURS,
			HOURS = props.resetHours
		} or nil
	end

	v2.resetHours = resetHours
	local v3 = useLocalization(v2)

	local label = v3.label
	local percentUsed = v3.percentUsed
	local text

	if FFlagBuildExperienceFreeTrialResetPeriod then
		if props.resetPeriod == "Weekly" then
			text = v3.captionWeekly
		elseif props.resetPeriod == "Monthly" then
			text = v3.captionMonthly
		else
			text = v3.caption
		end

		if
			(props.resetPeriod == nil or props.resetPeriod == "Daily")
			and math.floor(v + 0.5) > 0
			and props.resetHours ~= nil
		then
			text = v3.resetHours
		end
	else
		text = v3.caption

		if math.floor(v + 0.5) > 0 and props.resetHours ~= nil then
			text = v3.resetHours
		end
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col gap-small size-full-0 auto-y padding-large radius-large bg-shift-100",
			testId = "creator-credit-page-free-usage-card"
		},
		{
			Label = React.createElement(Text, {
				LayoutOrder = 1,
				Text = label,
				tag = "size-full-0 auto-y text-title-medium text-align-x-left content-emphasis",
				testId = "creator-credit-page-free-usage-label"
			}),
			Value = React.createElement(Text, {
				LayoutOrder = 2,
				Text = percentUsed,
				tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
				testId = "creator-credit-page-free-usage-value"
			}),
			Bar = React.createElement(Progress, {
				LayoutOrder = 3,
				shape = ProgressShape.Bar,
				size = ProgressSize.Medium,
				value = v,
				width = UDim.new(1, 0),
				testId = "creator-credit-page-daily-progress"
			}),
			Caption = React.createElement(Text, {
				LayoutOrder = 4,
				Text = text,
				tag = "size-full-0 auto-y padding-top-medium text-body-small text-align-x-left content-muted",
				testId = "creator-credit-page-free-usage-reset"
			})
		}
	)
end

local function RobuxLine(props)
	local v = formatNumber(props.amount) -- inferred equivalent call
	local usedOf = props.usedOf

	if props.kind == "used" then
		assert(usedOf ~= nil, "usedOf required when kind == 'used'")
	end

	local limit = usedOf == nil and "" or formatNumber(usedOf) -- inferred equivalent call
	local v2 = {
		available = props.kind == "available" and {
			LocalizationStrings.CREATOR_CREDIT_AMOUNT_AVAILABLE,
			AMOUNT = v
		} or nil,
		used = 0
	}
	local used

	if props.kind == "used" then
		used = {
			LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_USED,
			USED = v,
			LIMIT = limit
		}
	else
		used = props.kind == "usedNoLimit" and {
			LocalizationStrings.CREATOR_CREDIT_UNLIMITED_USED,
			USED = v
		} or nil
	end

	v2.used = used
	local v3 = useLocalization(v2)
	local text

	if props.kind == "available" then
		text = v3.available
	else
		text = v3.used
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-bottom-medium"
		},
		{
			IconEl = React.createElement(Icon, {
				LayoutOrder = 1,
				name = IconName.Robux,
				size = IconSize.Medium,
				tag = {
					["auto-xy"] = true,
					["content-muted"] = not props.isEnabled,
					["content-emphasis"] = props.isEnabled
				}
			}),
			Amount = React.createElement(Text, {
				LayoutOrder = 2,
				Text = text,
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
	local v = useLocalization({
		additionalDailyUsage = LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_DAILY_USAGE_LABEL,
		additionalUsage = LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_USAGE_LABEL,
		description = LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_USAGE_DESCRIPTION,
		setDailyLimit = LocalizationStrings.CREATOR_CREDIT_SET_DAILY_LIMIT,
		manageLimit = LocalizationStrings.CREATOR_CREDIT_MANAGE_LIMIT,
		settingsSaveError = LocalizationStrings.CREATOR_CREDIT_SETTINGS_SAVE_ERROR,
		buyRobux = LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_BUTTON
	})

	local additionalDailyUsage = v.additionalDailyUsage
	local text = v.additionalUsage
	local description = v.description
	local text2 = v.setDailyLimit
	local manageLimit = v.manageLimit
	local settingsSaveError = v.settingsSaveError
	local buyRobux = v.buyRobux
	local v2 = props.additionalEnabled and props.dailyLimit ~= nil
	local v3 = v2 or props.additionalEnabled and props.hasLimitConfigured == true
	local v4 = v3 and not v2

	if props.additionalEnabled then
		text = additionalDailyUsage
	end

	local children = {}

	children.Header = React.createElement(View, {
		LayoutOrder = 1,
		tag = "row align-y-center size-full-0 auto-y"
	}, {
		Label = React.createElement(Text, {
			LayoutOrder = 1,
			Text = text,
			tag = {
				["fill auto-y text-title-medium text-align-x-left"] = true,
				["content-default"] = not props.additionalEnabled,
				["content-emphasis"] = props.additionalEnabled
			},
			testId = "creator-credit-page-additional-usage-label"
		}),
		ToggleSwitch = React.createElement(Toggle, {
			LayoutOrder = 2,
			size = InputSize.Medium,
			label = "",
			isChecked = props.additionalEnabled,
			isDisabled = props.settingsDisabled == true,
			onActivated = function(flag: boolean)
				if not props.settingsDisabled then
					props.onToggleAdditional(flag)
				end
			end,
			testId = "creator-credit-page-additional-toggle"
		})
	})

	if v2 then
		assert(props.dailyLimit ~= nil, "dailyLimit must be provided when a numeric limit is configured")
		children.UsageLine = React.createElement(RobuxLine, {
			LayoutOrder = 2,
			amount = props.additionalUsed,
			kind = "used",
			usedOf = props.dailyLimit,
			isEnabled = props.additionalEnabled
		})
	elseif v4 then
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
		if v3 then
			text2 = manageLimit
		end

		local createElement = React.createElement
		local buyRobuxButton

		if props.showBuyRobux then
			buyRobuxButton = React.createElement(Button, {
				LayoutOrder = 1,
				text = buyRobux,
				variant = ButtonVariant.Emphasis,
				size = InputSize.Medium,
				onActivated = props.onOpenBuyRobux or noop,
				isDisabled = props.onOpenBuyRobux == nil,
				testId = "creator-credit-page-buy-robux"
			})
		end

		children.ActionsRow = createElement(
			View,
			{
				LayoutOrder = 3,
				tag = "row align-x-left align-y-center gap-small size-full-0 auto-y"
			},
			{
				BuyRobuxButton = buyRobuxButton,
				LimitButton = React.createElement(Button, {
					LayoutOrder = 2,
					text = text2,
					variant = ButtonVariant.Standard,
					size = InputSize.Medium,
					onActivated = props.onOpenLimitSheet or noop,
					isDisabled = props.settingsDisabled == true or props.onOpenLimitSheet == nil,
					testId = v3 and "creator-credit-page-manage-limit" or "creator-credit-page-set-daily-limit"
				})
			}
		)
	else
		children.Description = React.createElement(Text, {
			LayoutOrder = 3,
			Text = description,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted"
		})
	end

	if props.settingsError then
		children.SettingsError = React.createElement(Text, {
			LayoutOrder = 4,
			Text = settingsSaveError,
			tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-left content-system-alert",
			testId = "creator-credit-page-settings-error"
		})
	end

	return React.createElement(View, {
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
	return React.createElement(View, {
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
