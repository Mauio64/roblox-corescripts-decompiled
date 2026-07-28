local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local Foundation = require(AvatarExperienceUIKitParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local getFixedTabHeight = require(AvatarExperienceUIKit.Utils.getFixedTabHeight)
local FFlagAXCategoryMenuVisualFixes = require(AvatarExperienceUIKitParent.AvatarExperienceFlags).FFlagAXCategoryMenuVisualFixes
local FoundationText = Foundation.Text
local View = Foundation.View
local t1 = {
	Transparency = 1
}
local t2 = {
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder
}
local t3 = {
	Transparency = 1
}

local function TabGroupTabComponent(t4: {[any]: any}, p1) -- line: 48
	-- upvalues: useTokens (copy), React (copy), View (copy), t1 (copy), FFlagAXCategoryMenuVisualFixes (copy), getFixedTabHeight (copy), t2 (copy), FoundationText (copy), t3 (copy)
	local v16 = useTokens()
	local v17 = if not t4.isActive then t4.textStyle or v16.Color.Content.Muted else t4.activeTextStyle or v16.Color.Content.Emphasis
	local v18 = t4.fontStyle or v16.Typography.TitleLarge
	local v19 = t4.padding or Vector2.new(v16.Padding.Small, v16.Padding.Medium)

	return React.createElement(View, {
		ref = p1,
		onActivated = t4.onActivated,
		backgroundStyle = t1,
		padding = if not FFlagAXCategoryMenuVisualFixes then v19 else Vector2.new(v19.X, 0),
		Size = if not FFlagAXCategoryMenuVisualFixes then UDim2.fromScale(0, 0) else UDim2.fromOffset(0, getFixedTabHeight(v16)),
		AutomaticSize = if not FFlagAXCategoryMenuVisualFixes then Enum.AutomaticSize.XY else Enum.AutomaticSize.X,
		layout = if not FFlagAXCategoryMenuVisualFixes then nil else t2,
		LayoutOrder = t4.LayoutOrder
	}, {
		Text = React.createElement(FoundationText, {
			Text = t4.text,
			textStyle = v17,
			fontStyle = v18,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = t3
		})
	})
end

return (React.forwardRef(TabGroupTabComponent))
