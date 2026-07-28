local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Types = require(script.Parent.Types)
local useSmartSuggestions = require(script.Parent.useSmartSuggestions)
local Chip = Foundation.Chip
local ChipSize = Foundation.Enums.ChipSize
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	[Types.SuggestionType.GameCard] = Foundation.Enums.IconName.Controller
}

local function attachGrowFlexItem(p1) -- line: 45
	if p1 ~= nil and p1:FindFirstChildOfClass("UIFlexItem") == nil then
		local UIFlexItem = Instance.new("UIFlexItem")

		UIFlexItem.FlexMode = Enum.UIFlexMode.Grow
		UIFlexItem.Parent = p1
	end
end
local function SmartSuggestionsChipRow(t2: {[any]: any}) -- line: 53
	-- upvalues: useTokens (copy), useSmartSuggestions (copy), React (copy), Chip (copy), t1 (copy), ChipSize (copy), attachGrowFlexItem (copy), Foundation (copy)
	local v15 = useTokens()
	local v16 = useSmartSuggestions(t2.conversationId, t2.sendMessage, t2.sendGameLinkChatMessage)
	local v17 = t2.suggestions or v16.suggestions
	local hiddenSuggestions = v16.hiddenSuggestions
	local onActivated = v16.onActivated
	local t3 = {}
	local v21 = false

	for v22, v23 in v17 do
		local v24 = hiddenSuggestions[v23] == true

		v21 = v21 or not v24
		t3[`chip_{ v22 }`] = React.createElement(Chip, {
			text = v23.display_text,
			leading = t1[v23.type],
			size = ChipSize.Large,
			LayoutOrder = v22,
			Visible = not v24,
			ref = attachGrowFlexItem,
			onActivated = function() -- line: 72
				-- upvalues: onActivated (copy), v23 (copy)
				onActivated(v23)
			end
		})
	end

	if not v21 then
		return nil
	end

	return React.createElement(Foundation.ScrollView, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t2.LayoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v15.Gap.Small),
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
