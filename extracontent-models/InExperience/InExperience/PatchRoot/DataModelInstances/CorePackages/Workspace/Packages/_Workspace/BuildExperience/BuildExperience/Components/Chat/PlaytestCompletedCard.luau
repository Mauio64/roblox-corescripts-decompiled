local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Button = Foundation.Button
local IconName = Foundation.Enums.IconName
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function PlaytestCompletedCard(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), View (copy), FoundationText (copy), Button (copy), IconName (copy), InputSize (copy), ButtonVariant (copy)
	local v12 = t1.isLoading == true

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-medium stroke-standard stroke-emphasis radius-medium clip",
		LayoutOrder = t1.LayoutOrder,
		testId = t1.testId or "playtest-completed-card"
	}, {
		Title = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
			Text = t1.title or "Completed game creation"
		}),
		Description = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			Text = t1.description or "I've completed creating and publishing your game. You can open it to playtest."
		}),
		Playtest = React.createElement(Button, {
			LayoutOrder = 3,
			text = "Playtest",
			testId = "playtest-completed-card-playtest-button",
			icon = IconName.PlaySmall,
			size = InputSize.Small,
			variant = ButtonVariant.SoftEmphasis,
			width = UDim.new(1, 0),
			isLoading = v12,
			onActivated = t1.onPlaytest
		})
	})
end

return PlaytestCompletedCard
