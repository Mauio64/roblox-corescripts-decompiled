local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Button = Foundation.Button
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local function BuyMoreRobuxCard(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), View (copy), FoundationText (copy), Button (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy)
	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
		testId = "BuyMoreRobuxCard",
		LayoutOrder = t1.LayoutOrder
	}, {
		Title = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
			Text = t1.title
		}),
		Description = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
			Text = t1.description
		}),
		Actions = React.createElement(View, {
			LayoutOrder = 3,
			tag = "row gap-small size-full-0 auto-y"
		}, {
			PrimaryAction = React.createElement(Button, {
				LayoutOrder = 1,
				testId = "BuyMoreRobuxCard.PrimaryAction",
				text = t1.primaryActionText,
				size = InputSize.Small,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				onActivated = t1.onPrimaryAction
			}),
			SecondaryAction = React.createElement(Button, {
				LayoutOrder = 2,
				testId = "BuyMoreRobuxCard.SecondaryAction",
				text = t1.secondaryActionText,
				size = InputSize.Small,
				variant = ButtonVariant.Standard,
				fillBehavior = FillBehavior.Fill,
				onActivated = t1.onSecondaryAction
			})
		})
	})
end

return BuyMoreRobuxCard
