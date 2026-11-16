local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Types = require(script.Parent.Types)

local ChipGroup = Foundation.ChipGroup
local ChipGroupVariant = Foundation.Enums.ChipGroupVariant
local ChipSize = Foundation.Enums.ChipSize
local Divider = Foundation.Divider
local View = Foundation.View

local SuggestionType = Types.SuggestionType

local v = {
	[SuggestionType.GameCard] = Foundation.Enums.IconName.Controller,
	[SuggestionType.StartParty] = Foundation.Enums.IconName.ThreePeople
}

local function SmartSuggestionsChipRow(props)
	local chips = {}

	for k, suggestion in props.suggestions do
		chips[k] = {
			text = suggestion.display_text,
			leading = v[suggestion.type],
			onActivated = function()
				props.onActivated(suggestion)
			end
		}
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col gap-small size-full-0 auto-y clip",
			testId = "SmartSuggestionsChipRow--clip"
		},
		{
			Divider = React.createElement(Divider, {
				LayoutOrder = 1,
				testId = "SmartSuggestionsChipRow--divider"
			}),
			ChipGroup = React.createElement(ChipGroup, {
				chips = chips,
				LayoutOrder = 2,
				size = ChipSize.Medium,
				variant = ChipGroupVariant.Row,
				testId = "SmartSuggestionsChipRow"
			})
		}
	)
end

return React.memo(SmartSuggestionsChipRow)
