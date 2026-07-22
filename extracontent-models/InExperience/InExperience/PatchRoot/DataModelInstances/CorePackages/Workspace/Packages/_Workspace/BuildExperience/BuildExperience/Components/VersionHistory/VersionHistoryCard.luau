local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Badge = Foundation.Badge
local Button = Foundation.Button
local FoundationText = Foundation.Text
local View = Foundation.View
local BadgeVariant = Foundation.Enums.BadgeVariant
local BadgeShape = Foundation.Enums.BadgeShape
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local function VersionHistoryCard(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), View (copy), FoundationText (copy), Badge (copy), BadgeShape (copy), BadgeVariant (copy), Button (copy), LocalizationStrings (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy)
	local v17 = t1.testId or "version-history-card"
	local v18 = React.useCallback(function() -- line: 32
		-- upvalues: t1 (copy)
		t1.onRestore()
	end, { t1.onRestore })

	return React.createElement(View, {
		tag = "size-full-0 auto-y stroke-standard stroke-default radius-large clip bg-surface-100",
		LayoutOrder = t1.layoutOrder,
		testId = v17
	}, {
		Content = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col size-full-0 auto-y padding-x-large padding-bottom-large padding-top-medium"
		}, {
			Header = React.createElement(View, {
				LayoutOrder = 1,
				tag = "col gap-xxsmall size-full-0 auto-y"
			}, {
				Version = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y padding-bottom-xxsmall text-caption-large text-align-x-left content-default",
					Text = t1.versionLabel
				}),
				TitleRow = React.createElement(View, {
					LayoutOrder = 2,
					tag = "row align-y-center gap-small size-full-0 auto-y"
				}, {
					Title = React.createElement(FoundationText, {
						LayoutOrder = 1,
						tag = "shrink auto-xy text-title-medium text-wrap text-align-x-left text-truncate-none content-emphasis",
						Text = t1.title
					}),
					Badge = if not t1.badgeText then nil else React.createElement(Badge, {
						LayoutOrder = 2,
						text = t1.badgeText,
						shape = BadgeShape.Box,
						variant = BadgeVariant.Neutral
					})
				})
			}),
			Slot = React.createElement(View, {
				LayoutOrder = 2,
				tag = "col gap-large size-full-0 auto-y"
			}, {
				Description = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-emphasis",
					Text = t1.description,
					testId = `{ v17 }-description`
				}),
				RestoreRow = React.createElement(View, {
					tag = "row size-full-0 auto-y",
					LayoutOrder = 2
				}, {
					Restore = React.createElement(Button, {
						text = LocalizationStrings.VERSION_HISTORY_RESTORE,
						size = InputSize.Small,
						variant = ButtonVariant.Standard,
						fillBehavior = FillBehavior.Fill,
						isDisabled = t1.isRestoreDisabled,
						onActivated = v18,
						testId = `{ v17 }-restore`
					})
				})
			})
		})
	})
end

return VersionHistoryCard
