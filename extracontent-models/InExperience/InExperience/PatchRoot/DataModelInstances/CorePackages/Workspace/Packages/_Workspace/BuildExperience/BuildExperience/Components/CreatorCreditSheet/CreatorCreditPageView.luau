local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local LocalizationService = game:GetService("LocalizationService")
local Foundation = require(BuildExperienceParent.Foundation)
local NumberLocalization = require(BuildExperienceParent.Localization).NumberLocalization
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Button = Foundation.Button
local Icon = Foundation.Icon
local Progress = Foundation.Progress
local FoundationText = Foundation.Text
local Toggle = Foundation.Toggle
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize

local function noop() -- line: 28
end
local function clampPct(n1: number) -- line: 48
	if n1 < 0 then
		return 0
	end

	if n1 > 100 then
		return 100
	end

	return n1
end
local function formatNumber(n2: number) -- line: 57
	-- upvalues: NumberLocalization (copy), LocalizationService (copy)
	return NumberLocalization.localize(string.format("%.0f", (math.floor(n2))), LocalizationService.RobloxLocaleId)
end
local function FreeUsageCard(t1: {[any]: any}) -- line: 61
	-- upvalues: LocalizationStrings (copy), React (copy), View (copy), FoundationText (copy), Progress (copy), ProgressShape (copy), ProgressSize (copy)
	local pctUsed = t1.pctUsed
	local v31 = if not (pctUsed < 0) then if not (pctUsed > 100) then pctUsed else 100 else 0
	local v32 = if not (math.floor(v31 + 0.5) > 0) or t1.resetHours == nil then LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_CAPTION else LocalizationStrings.formatCreatorCreditResetHours(t1.resetHours)

	return React.createElement(View, {
		tag = "col gap-small size-full-0 auto-y padding-large radius-large bg-shift-100",
		testId = "creator-credit-page-free-usage-card",
		LayoutOrder = t1.LayoutOrder
	}, {
		Label = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-align-x-left content-emphasis",
			testId = "creator-credit-page-free-usage-label",
			Text = LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_LABEL
		}),
		Value = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
			testId = "creator-credit-page-free-usage-value",
			Text = LocalizationStrings.formatCreatorCreditPercentUsed(v31)
		}),
		Bar = React.createElement(Progress, {
			LayoutOrder = 3,
			testId = "creator-credit-page-daily-progress",
			shape = ProgressShape.Bar,
			size = ProgressSize.Medium,
			value = v31,
			width = UDim.new(1, 0)
		}),
		Caption = React.createElement(FoundationText, {
			LayoutOrder = 4,
			tag = "size-full-0 auto-y padding-top-medium text-body-small text-align-x-left content-muted",
			testId = "creator-credit-page-free-usage-reset",
			Text = v32
		})
	})
end
local function RobuxLine(t2: {[any]: any}) -- line: 105
	-- upvalues: LocalizationStrings (copy), NumberLocalization (copy), LocalizationService (copy), formatNumber (copy), React (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy)
	local v36

	if t2.kind == "used" then
		assert(t2.usedOf ~= nil, "usedOf required when kind == 'used'")

		local formatCreatorCreditAdditionalUsed = LocalizationStrings.formatCreatorCreditAdditionalUsed
		local amount = t2.amount

		v36 = formatCreatorCreditAdditionalUsed(NumberLocalization.localize(string.format("%.0f", (math.floor(amount))), LocalizationService.RobloxLocaleId), formatNumber(t2.usedOf))
	elseif t2.kind == "usedNoLimit" then
		v36 = LocalizationStrings.formatCreatorCreditAdditionalUsedNoLimit(formatNumber(t2.amount))
	else
		local amount = t2.amount

		v36 = `{ NumberLocalization.localize(string.format("%.0f", (math.floor(amount))), LocalizationService.RobloxLocaleId) } { LocalizationStrings.CREATOR_CREDIT_AVAILABLE_SUFFIX }`
	end

	return React.createElement(View, {
		tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-bottom-medium",
		LayoutOrder = t2.LayoutOrder
	}, {
		IconEl = React.createElement(Icon, {
			LayoutOrder = 1,
			name = IconName.Robux,
			size = IconSize.Medium,
			tag = {
				["auto-xy"] = true,
				["content-muted"] = not t2.isEnabled,
				["content-emphasis"] = t2.isEnabled
			}
		}),
		Amount = React.createElement(FoundationText, {
			LayoutOrder = 2,
			testId = "creator-credit-page-robux-line",
			Text = v36,
			tag = {
				["auto-xy text-heading-small"] = true,
				["content-muted"] = not t2.isEnabled,
				["content-emphasis"] = t2.isEnabled
			}
		})
	})
end
local function AdditionalUsageCard(t3: {[any]: any}) -- line: 152
	-- upvalues: LocalizationStrings (copy), React (copy), View (copy), FoundationText (copy), Toggle (copy), InputSize (copy), RobuxLine (copy), Button (copy), ButtonVariant (copy), noop (copy)
	local v39 = t3.additionalEnabled and t3.dailyLimit ~= nil
	local v40 = v39 or t3.additionalEnabled and t3.hasLimitConfigured == true
	local v41 = v40 and not v39
	local v42 = if not t3.additionalEnabled then LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_USAGE_LABEL else LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_DAILY_USAGE_LABEL
	local t4 = {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center size-full-0 auto-y"
		}, {
			Label = React.createElement(FoundationText, {
				LayoutOrder = 1,
				testId = "creator-credit-page-additional-usage-label",
				Text = v42,
				tag = {
					["fill auto-y text-title-medium text-align-x-left"] = true,
					["content-default"] = not t3.additionalEnabled,
					["content-emphasis"] = t3.additionalEnabled
				}
			}),
			ToggleSwitch = React.createElement(Toggle, {
				LayoutOrder = 2,
				label = "",
				testId = "creator-credit-page-additional-toggle",
				size = InputSize.Medium,
				isChecked = t3.additionalEnabled,
				isDisabled = t3.settingsDisabled == true,
				onActivated = function(b1: boolean) -- line: 195
					-- upvalues: t3 (copy)
					if not t3.settingsDisabled then
						t3.onToggleAdditional(b1)
					end
				end
			})
		})
	}

	if v39 then
		assert(t3.dailyLimit ~= nil, "dailyLimit must be provided when a numeric limit is configured")
		t4.UsageLine = React.createElement(RobuxLine, {
			LayoutOrder = 2,
			kind = "used",
			amount = t3.additionalUsed,
			usedOf = t3.dailyLimit,
			isEnabled = t3.additionalEnabled
		})
	elseif v41 then
		t4.UsageLine = React.createElement(RobuxLine, {
			LayoutOrder = 2,
			kind = "usedNoLimit",
			amount = t3.additionalUsed,
			isEnabled = t3.additionalEnabled
		})
	else
		t4.AvailableLine = React.createElement(RobuxLine, {
			LayoutOrder = 2,
			kind = "available",
			amount = t3.robuxAvailable,
			isEnabled = t3.additionalEnabled
		})
	end

	if not t3.additionalEnabled then
		t4.Description = React.createElement(FoundationText, {
			LayoutOrder = 3,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
			Text = LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_USAGE_DESCRIPTION
		})
	else
		local v44 = if not v40 then LocalizationStrings.CREATOR_CREDIT_SET_DAILY_LIMIT else LocalizationStrings.CREATOR_CREDIT_MANAGE_LIMIT
		local v45 = not v40 and "creator-credit-page-set-daily-limit" or "creator-credit-page-manage-limit"

		t4.ActionsRow = React.createElement(View, {
			LayoutOrder = 3,
			tag = "row align-x-left align-y-center gap-small size-full-0 auto-y"
		}, {
			BuyRobuxButton = if not t3.showBuyRobux then nil else React.createElement(Button, {
				LayoutOrder = 1,
				testId = "creator-credit-page-buy-robux",
				text = LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_BUTTON,
				variant = ButtonVariant.Emphasis,
				size = InputSize.Medium,
				onActivated = t3.onOpenBuyRobux or noop,
				isDisabled = t3.onOpenBuyRobux == nil
			}),
			LimitButton = React.createElement(Button, {
				LayoutOrder = 2,
				text = v44,
				variant = ButtonVariant.Standard,
				size = InputSize.Medium,
				onActivated = t3.onOpenLimitSheet or noop,
				isDisabled = t3.settingsDisabled == true or t3.onOpenLimitSheet == nil,
				testId = v45
			})
		})
	end

	if t3.settingsError then
		t4.SettingsError = React.createElement(FoundationText, {
			LayoutOrder = 4,
			tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-left content-system-alert",
			testId = "creator-credit-page-settings-error",
			Text = LocalizationStrings.CREATOR_CREDIT_SETTINGS_SAVE_ERROR
		})
	end

	return React.createElement(View, {
		testId = "creator-credit-page-additional-usage-card",
		LayoutOrder = t3.LayoutOrder,
		tag = {
			["col gap-small size-full-0 auto-y padding-large radius-large"] = true,
			["bg-shift-100"] = t3.additionalEnabled,
			["stroke-standard stroke-default"] = not t3.additionalEnabled
		}
	}, t4)
end
local function CreatorCreditPageView(t5: {[any]: any}) -- line: 290
	-- upvalues: React (copy), View (copy), FreeUsageCard (copy), AdditionalUsageCard (copy)
	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-y-xlarge",
		testId = t5.testId or "creator-credit-page"
	}, {
		FreeUsage = React.createElement(FreeUsageCard, {
			LayoutOrder = 1,
			pctUsed = t5.dailyPctUsed,
			resetHours = t5.resetHours
		}),
		AdditionalUsage = React.createElement(AdditionalUsageCard, {
			LayoutOrder = 2,
			additionalEnabled = t5.additionalEnabled,
			dailyLimit = t5.dailyLimit,
			hasLimitConfigured = t5.hasLimitConfigured,
			additionalUsed = t5.additionalUsed,
			robuxAvailable = t5.robuxAvailable,
			settingsDisabled = t5.settingsDisabled,
			settingsError = t5.settingsError,
			showBuyRobux = t5.showBuyRobux,
			onToggleAdditional = t5.onToggleAdditional,
			onOpenLimitSheet = t5.onOpenLimitSheet,
			onOpenBuyRobux = t5.onOpenBuyRobux
		})
	})
end

return CreatorCreditPageView
