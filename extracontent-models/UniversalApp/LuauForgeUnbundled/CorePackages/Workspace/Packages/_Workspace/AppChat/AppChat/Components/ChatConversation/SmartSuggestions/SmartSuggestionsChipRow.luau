local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local Types = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/Types")

local chipGroup = Foundation.ChipGroup
local chipGroupVariant = Foundation.Enums.ChipGroupVariant
local chipSize = Foundation.Enums.ChipSize
local divider = Foundation.Divider
local view = Foundation.View

local suggestionType = Types.SuggestionType

local v5 = {
	[suggestionType.GameCard] = Foundation.Enums.IconName.Controller,
	[suggestionType.StartParty] = Foundation.Enums.IconName.ThreePeople
}

local function SmartSuggestionsChipRow(props)
	local v6 = {}

	for k, suggestion in props.suggestions do
		v6[k] = {
			text = suggestion.display_text,
			leading = v5[suggestion.type],
			onActivated = function()
				props.onActivated(suggestion)
			end
		}
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col gap-small size-full-0 auto-y clip",
			testId = "SmartSuggestionsChipRow--clip"
		},
		{
			Divider = React.createElement(divider, {
				LayoutOrder = 1,
				testId = "SmartSuggestionsChipRow--divider"
			}),
			ChipGroup = React.createElement(chipGroup, {
				chips = v6,
				LayoutOrder = 2,
				size = chipSize.Medium,
				variant = chipGroupVariant.Row,
				testId = "SmartSuggestionsChipRow"
			})
		}
	)
end

return React.memo(SmartSuggestionsChipRow)
