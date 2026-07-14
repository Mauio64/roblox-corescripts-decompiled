local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local Constants = require(ParentParent.Common.Constants)

local function LeaderboardRowShell(t1: {[any]: any}) -- line: 25
	-- upvalues: useTokens (copy), usePreferences (copy), Constants (copy), React (copy), View (copy), Foundation (copy)
	local v11 = useTokens()
	local v12 = usePreferences()
	local v13 = t1.flexTag or Constants.ROW_FLEX_TAG
	local t2 = {
		RowContent = React.createElement(View, {
			tag = `size-full { v13 }`
		}, t1.children)
	}

	if t1.isHighlighted then
		local OverMedia_100 = v11.Color.OverMedia.OverMedia_100
		local v16 = OverMedia_100.Transparency * v12.preferredTransparency

		t2.Highlight = React.createElement(View, {
			ZIndex = 0,
			backgroundStyle = {
				Color3 = OverMedia_100.Color3,
				Transparency = v16
			},
			Size = UDim2.fromScale(1, 1)
		})
	end

	if t1.showDivider then
		t2.Divider = React.createElement(Foundation.Divider, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1)
		})
	end

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, t1.rowHeight),
		LayoutOrder = t1.layoutOrder,
		onActivated = t1.onActivated,
		ref = t1.rowRef
	}, t2)
end

return React.memo(LeaderboardRowShell)
