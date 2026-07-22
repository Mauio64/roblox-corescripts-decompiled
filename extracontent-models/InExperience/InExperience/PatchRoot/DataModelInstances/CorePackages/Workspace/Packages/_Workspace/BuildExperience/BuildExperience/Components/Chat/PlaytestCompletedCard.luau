local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Button = Foundation.Button
local IconName = Foundation.Enums.IconName
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function PlaytestCompletedCard(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), View (copy), FoundationText (copy), LocalizationStrings (copy), Button (copy), IconName (copy), InputSize (copy), ButtonVariant (copy)
	local v14 = t1.isLoading == true

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-medium stroke-standard stroke-emphasis radius-medium clip",
		LayoutOrder = t1.LayoutOrder,
		testId = t1.testId or "playtest-completed-card"
	}, {
		Title = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
			Text = t1.title or LocalizationStrings.CHAT_COMPLETED_GAME_CREATION_TITLE
		}),
		Description = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			Text = t1.description or LocalizationStrings.CHAT_COMPLETED_GAME_CREATION_DESCRIPTION
		}),
		Playtest = React.createElement(Button, {
			LayoutOrder = 3,
			testId = "playtest-completed-card-playtest-button",
			text = LocalizationStrings.CHAT_PLAYTEST,
			icon = IconName.PlaySmall,
			size = InputSize.Small,
			variant = ButtonVariant.SoftEmphasis,
			width = UDim.new(1, 0),
			isLoading = v14,
			onActivated = t1.onPlaytest
		})
	})
end

return PlaytestCompletedCard
