local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local BuilderIcons = require(SchoolsParent.BuilderIcons)
local Foundation = require(SchoolsParent.Foundation)
local React = require(SchoolsParent.React)
local useLocalization = require(SchoolsParent.Localization).Hooks.useLocalization
local TextKeys = require(Schools.Common.TextKeys)
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View
local Icon = Foundation.Icon
local FoundationImage = Foundation.Image
local Button = Foundation.Button
local useTokens = Foundation.Hooks.useTokens
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local Icon2 = BuilderIcons.Icon

Foundation.Utility.preloadCloudAssets("pictograms/group_exp")

local function PerkRow(t1: {[any]: any}) -- line: 41
	-- upvalues: React (copy), View (copy), Icon (copy), IconSize (copy), FoundationText (copy)
	return React.createElement(View, {
		tag = "row items-center gap-small size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder
	}, {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = t1.icon,
			size = IconSize.Medium
		}),
		Label = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "fill auto-y text-body-medium text-align-x-left text-truncate-end content-default",
			Text = t1.text
		})
	})
end
local function AddSchoolUpsell(t2: {[any]: any}) -- line: 63
	-- upvalues: useTokens (copy), useLocalization (copy), TextKeys (copy), React (copy), Sheet (copy), View (copy), FoundationImage (copy), FoundationText (copy), PerkRow (copy), Icon2 (copy), Button (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy)
	local v24 = t2.isOpen == nil or t2.isOpen
	local v25 = useTokens()
	local v26 = useLocalization({
		heading = TextKeys.UpsellHeading,
		body = TextKeys.UpsellBody,
		perkFindFriends = TextKeys.UpsellPerkFindFriends,
		perkPlayAndChat = TextKeys.UpsellPerkPlayAndChat,
		perkTrends = TextKeys.UpsellPerkTrends,
		disclaimer = TextKeys.UpsellDisclaimer,
		actionContinue = TextKeys.UpsellActionContinue
	})
	local v27 = 320 * v25.Config.UI.Scale
	local v28 = 180 * v25.Config.UI.Scale

	return React.createElement(Sheet.Root, {
		testId = "schools-add-school-upsell-sheet",
		isOpen = v24,
		onClose = t2.onClose
	}, {
		Content = React.createElement(Sheet.Content, nil, {
			Illustration = React.createElement(View, {
				LayoutOrder = 1,
				tag = "col items-center size-full-0 auto-y padding-bottom-medium"
			}, {
				Art = React.createElement(FoundationImage, {
					Image = "pictograms/group_exp",
					testId = "schools-add-school-upsell-hero",
					imageStyle = v25.Color.Content.Emphasis,
					ScaleType = Enum.ScaleType.Fit,
					Size = UDim2.fromOffset(v27, v28)
				})
			}),
			Header = React.createElement(View, {
				LayoutOrder = 2,
				tag = "col gap-xsmall size-full-0 auto-y"
			}, {
				Heading = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis",
					Text = v26.heading
				}),
				Body = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					Text = v26.body
				})
			}),
			Perks = React.createElement(View, {
				LayoutOrder = 3,
				tag = "col gap-medium size-full-0 auto-y padding-top-small"
			}, {
				FindFriends = React.createElement(PerkRow, {
					layoutOrder = 1,
					icon = Icon2.PersonMagnifyingGlass,
					text = v26.perkFindFriends
				}),
				PlayAndChat = React.createElement(PerkRow, {
					layoutOrder = 2,
					icon = Icon2.ThreePeople,
					text = v26.perkPlayAndChat
				}),
				Trends = React.createElement(PerkRow, {
					layoutOrder = 3,
					icon = Icon2.Flame,
					text = v26.perkTrends
				})
			}),
			Disclaimer = React.createElement(FoundationText, {
				LayoutOrder = 4,
				tag = "size-full-0 auto-y padding-top-small text-body-medium text-wrap text-align-x-left content-default",
				Text = v26.disclaimer
			})
		}),
		Actions = React.createElement(Sheet.Actions, nil, {
			Continue = React.createElement(Button, {
				LayoutOrder = 1,
				text = v26.actionContinue,
				size = InputSize.Large,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				onActivated = t2.onContinue
			})
		})
	})
end

return AddSchoolUpsell
