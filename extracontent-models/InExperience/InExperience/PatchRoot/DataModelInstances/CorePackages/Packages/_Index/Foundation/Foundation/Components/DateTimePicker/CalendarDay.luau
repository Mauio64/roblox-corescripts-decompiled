local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local StateLayerMode = require(Foundation.Enums.StateLayerMode)
local Text = require(Foundation.Components.Text)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function CalendarDay(t1: {[any]: any}) -- line: 21
	-- upvalues: useTokens (copy), React (copy), Text (copy), StateLayerMode (copy)
	local v9 = useTokens()
	local v10 = if not t1.isSelected then if not not t1.isSelectable and t1.emphasizeText then v9.Color.Content.Emphasis.Color3 else v9.Color.Content.Muted.Color3 else v9.Inverse.Content.Emphasis.Color3
	local v11 = (t1.isSelected or not not t1.isSelectable and t1.emphasizeText) and 0 or 0.5

	return React.createElement(Text, {
		tag = "auto-xy text-title-small text-align-x-center text-align-y-center",
		textStyle = {
			Color3 = v10,
			Transparency = v11
		},
		backgroundStyle = if not t1.isSelected then if not t1.highlight then nil else v9.Color.ActionStandard.Background else v9.Color.System.Contrast,
		LayoutOrder = t1.LayoutOrder,
		onActivated = if not t1.isSelectable then nil else t1.onActivated,
		RichText = not t1.isSelectable,
		stateLayer = {
			mode = if not t1.isSelected then StateLayerMode.Default else StateLayerMode.Inverse
		},
		Text = if not t1.isSelectable then `<s>{ t1.Text }</s>` else t1.Text,
		testId = t1.testId
	})
end

return CalendarDay
