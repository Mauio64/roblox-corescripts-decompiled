local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Types = require(script.Parent.Types)
local useSmartSuggestions = require(script.Parent.useSmartSuggestions)
local Chip = Foundation.Chip
local ChipSize = Foundation.Enums.ChipSize
local useTokens = Foundation.Hooks.useTokens
local SuggestionType = Types.SuggestionType
local t1 = {
	[SuggestionType.GameCard] = Foundation.Enums.IconName.Controller,
	[SuggestionType.StartParty] = Foundation.Enums.IconName.ThreePeople
}

local function attachGrowFlexItem(p1) -- line: 43
	if p1 ~= nil and p1:FindFirstChildOfClass("UIFlexItem") == nil then
		local UIFlexItem = Instance.new("UIFlexItem")

		UIFlexItem.FlexMode = Enum.UIFlexMode.Grow
		UIFlexItem.Parent = p1
	end
end
local function SmartSuggestionsChipRow(t2: {[any]: any}) -- line: 51
	-- upvalues: useTokens (copy), useSmartSuggestions (copy), React (copy), Chip (copy), t1 (copy), ChipSize (copy), attachGrowFlexItem (copy), Foundation (copy)
	local v16 = useTokens()
	local v17 = useSmartSuggestions(t2.conversationId, t2.sendMessage, t2.sendGameLinkChatMessage)
	local v18 = t2.suggestions or v17.suggestions
	local hiddenSuggestions = v17.hiddenSuggestions
	local onActivated = v17.onActivated
	local t3 = {}
	local v22 = false

	for v23, v24 in v18 do
		local v25 = hiddenSuggestions[v24] == true

		v22 = v22 or not v25
		t3[`chip_{ v23 }`] = React.createElement(Chip, {
			text = v24.display_text,
			leading = t1[v24.type],
			size = ChipSize.Large,
			LayoutOrder = v23,
			Visible = not v25,
			ref = attachGrowFlexItem,
			onActivated = function() -- line: 70
				-- upvalues: onActivated (copy), v24 (copy)
				onActivated(v24)
			end
		})
	end

	if not v22 then
		return nil
	end

	return React.createElement(Foundation.ScrollView, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t2.LayoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v16.Gap.Small),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		scroll = {
			ScrollingDirection = Enum.ScrollingDirection.X,
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			AutomaticSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(),
			scrollBarVisibility = Foundation.Enums.Visibility.None
		}
	}, t3)
end

return React.memo(SmartSuggestionsChipRow)
