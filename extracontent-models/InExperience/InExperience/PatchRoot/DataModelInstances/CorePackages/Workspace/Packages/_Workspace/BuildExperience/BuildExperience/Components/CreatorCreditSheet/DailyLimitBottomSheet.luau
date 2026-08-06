local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local LocalizationService = game:GetService("LocalizationService")
local Foundation = require(BuildExperienceParent.Foundation)
local NumberLocalization = require(BuildExperienceParent.Localization).NumberLocalization
local React = require(BuildExperienceParent.React)
local GetFFlagLuaAppEnableOpenTypeSupport = require(BuildExperienceParent.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Button = Foundation.Button
local Chip = Foundation.Chip
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local View = Foundation.View
local Sheet = Foundation.Sheet
local ButtonVariant = Foundation.Enums.ButtonVariant
local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local t1 = {
	2000,
	5000
}

local function formatNumber(n1: number) -- line: 83
	-- upvalues: NumberLocalization (copy), LocalizationService (copy)
	return NumberLocalization.localize(string.format("%.0f", (math.floor(n1))), LocalizationService.RobloxLocaleId)
end
local function DailyLimitBottomSheetContent(t2: {[any]: any}) -- line: 87
	-- upvalues: React (copy), LocalizationStrings (copy), formatNumber (copy), Chip (copy), IconName (copy), ChipVariant (copy), ChipSize (copy), t1 (copy), NumberLocalization (copy), LocalizationService (copy), Sheet (copy), FoundationText (copy), View (copy), IconButton (copy), ButtonVariant (copy), InputSize (copy), Icon (copy), IconSize (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), Button (copy), FillBehavior (copy)
	local v29 = t2.testId or "creator-credit-limit-sheet"
	local v30 = math.max(t2.initialValue or 500, 100)
	local v31 = t2.additionalUsed or 0
	local v32 = t2.isSaving == true
	local v33, v34 = React.useState(v30)
	local v35, v36 = React.useState(t2.initialIsNoLimit == true)
	local v37 = React.useCallback(function() -- line: 97
		-- upvalues: v36 (copy), v34 (copy)
		v36(false)
		v34(function(p1) -- line: 99
			return (math.max(p1 - 500, 100))
		end)
	end, {})
	local v38 = React.useCallback(function() -- line: 104
		-- upvalues: v36 (copy), v34 (copy)
		v36(false)
		v34(function(p2) -- line: 106
			return p2 + 500
		end)
	end, {})
	local v39 = React.useCallback(function(n2: number) -- line: 111
		-- upvalues: v36 (copy), v34 (copy)
		v36(false)
		v34((math.max(n2, 100)))
	end, {})
	local v40 = React.useCallback(function() -- line: 116
		-- upvalues: v36 (copy)
		v36(true)
	end, {})
	local v41 = not v35 and v33 < v31
	local v42 = if not v41 then if not t2.saveError then nil else LocalizationStrings.CREATOR_CREDIT_SETTINGS_SAVE_ERROR else LocalizationStrings.formatCreatorCreditLimitBelowSpend(formatNumber(v31))
	local v43 = React.useCallback(function() -- line: 128
		-- upvalues: v35 (copy), t2 (copy), v33 (copy), v31 (copy)
		if v35 then
			t2.onConfirm(nil)

			return
		end

		if v33 < v31 then
			return
		end

		t2.onConfirm(v33)
	end, {
		v33,
		v31,
		v35,
		t2.onConfirm
	})
	local t3 = {
		NoLimit = React.createElement(Chip, {
			LayoutOrder = 1,
			text = LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_NO_LIMIT,
			leading = IconName.CircleX,
			variant = ChipVariant.Standard,
			size = ChipSize.Medium,
			onActivated = v40,
			isDisabled = v32,
			testId = `{ v29 }-preset-no-limit`
		})
	}

	for v45, v46 in t1 do
		t3[`Preset{ v46 }`] = React.createElement(Chip, {
			LayoutOrder = 1 + v45,
			text = NumberLocalization.localize(string.format("%.0f", (math.floor(v46))), LocalizationService.RobloxLocaleId),
			leading = IconName.Robux,
			variant = ChipVariant.Standard,
			size = ChipSize.Medium,
			onActivated = function() -- line: 168
				-- upvalues: v39 (copy), v46 (copy)
				v39(v46)
			end,
			isDisabled = v32,
			testId = `{ v29 }-preset-{ v46 }`
		})
	end

	return React.createElement(Sheet.Root, {
		isOpen = true,
		preferCenterSheet = true,
		onClose = t2.onCancel
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = true
		}, {
			Title = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-small content-emphasis",
				Text = LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_TITLE
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			Body = React.createElement(View, {
				tag = "col gap-large size-full-0 auto-y"
			}, {
				Stepper = React.createElement(View, {
					LayoutOrder = 1,
					tag = "row align-x-center align-y-center gap-large size-full-0 auto-y padding-y-medium"
				}, {
					Minus = React.createElement(IconButton, {
						LayoutOrder = 1,
						isCircular = true,
						icon = IconName.MinusSmall,
						variant = ButtonVariant.Utility,
						size = InputSize.Medium,
						onActivated = v37,
						isDisabled = v32 or (v35 or v33 <= 100),
						testId = `{ v29 }-decrement`
					}),
					ValueDisplay = React.createElement(View, {
						LayoutOrder = 2,
						tag = "row align-y-center gap-small auto-xy"
					}, {
						IconEl = React.createElement(Icon, {
							LayoutOrder = 1,
							tag = "auto-xy content-emphasis",
							name = if not v35 then IconName.Robux else IconName.CircleX,
							size = IconSize.Large
						}),
						Amount = React.createElement(FoundationText, {
							LayoutOrder = 2,
							tag = "auto-xy text-heading-medium content-emphasis",
							Text = if not v35 then NumberLocalization.localize(string.format("%.0f", (math.floor(v33))), LocalizationService.RobloxLocaleId) else LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_NO_LIMIT,
							OpenTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else "tnum",
							testId = `{ v29 }-value`
						})
					}),
					Plus = React.createElement(IconButton, {
						LayoutOrder = 3,
						isCircular = true,
						icon = IconName.PlusSmall,
						variant = ButtonVariant.Utility,
						size = InputSize.Medium,
						onActivated = v38,
						isDisabled = v32 or v35,
						testId = `{ v29 }-increment`
					})
				}),
				Chips = React.createElement(View, {
					LayoutOrder = 2,
					tag = "row align-x-center align-y-center gap-small size-full-0 auto-y"
				}, t3),
				Error = if not v42 then nil else React.createElement(FoundationText, {
					LayoutOrder = 3,
					tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-center content-system-alert",
					Text = v42,
					testId = if not v41 then `{ v29 }-save-error` else `{ v29 }-below-spend-error`
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, nil, {
			Confirm = React.createElement(Button, {
				text = LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_CONFIRM,
				size = InputSize.Large,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				onActivated = v43,
				isDisabled = v32 or v41,
				testId = `{ v29 }-confirm`
			})
		})
	})
end
local function DailyLimitBottomSheet(t4: {[any]: any}) -- line: 282
	-- upvalues: React (copy), DailyLimitBottomSheetContent (copy)
	if not t4.isOpen then
		return nil
	end

	return React.createElement(DailyLimitBottomSheetContent, t4)
end

return DailyLimitBottomSheet
