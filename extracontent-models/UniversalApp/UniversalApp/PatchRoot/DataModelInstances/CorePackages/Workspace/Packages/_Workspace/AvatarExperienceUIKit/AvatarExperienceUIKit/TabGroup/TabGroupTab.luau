local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local View = Foundation.View
local t1 = {
	Transparency = 1
}
local t2 = {
	Transparency = 1
}

local function TabGroupTab(t3: {[any]: any}, p1) -- line: 32
	-- upvalues: useTokens (copy), React (copy), View (copy), t1 (copy), FoundationText (copy), t2 (copy)
	local v12 = useTokens()
	local v13 = if not t3.isActive then t3.textStyle or v12.Color.Content.Muted else t3.activeTextStyle or v12.Color.Content.Emphasis
	local v14 = t3.fontStyle or v12.Typography.TitleLarge
	local v15 = t3.padding or Vector2.new(v12.Padding.Small, v12.Padding.Medium)

	return React.createElement(View, {
		ref = p1,
		onActivated = t3.onActivated,
		backgroundStyle = t1,
		padding = v15,
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = t3.LayoutOrder
	}, {
		Text = React.createElement(FoundationText, {
			Text = t3.text,
			textStyle = v13,
			fontStyle = v14,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = t2
		})
	})
end

return React.forwardRef(TabGroupTab)
