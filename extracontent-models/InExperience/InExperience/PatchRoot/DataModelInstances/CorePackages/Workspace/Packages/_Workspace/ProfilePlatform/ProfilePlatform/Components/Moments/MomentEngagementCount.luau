local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useAbbreviatedNumberLocalization = require(Parent.Localization).Hooks.useAbbreviatedNumberLocalization
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local useTokens = Foundation.Hooks.useTokens

local function MomentEngagementCount(t1: {[any]: any}) -- line: 23
	-- upvalues: useAbbreviatedNumberLocalization (copy), useTokens (copy), React (copy), View (copy), Icon (copy), IconSize (copy), IconVariant (copy), FoundationText (copy)
	local v13 = useAbbreviatedNumberLocalization(t1.count or 0)
	local v14 = useTokens()
	local v15 = t1.onMedia == true
	local v16 = if not v15 then nil else v14.Color.Extended.White.White_100

	return React.createElement(View, {
		tag = "row align-x-left align-y-center gap-xxsmall auto-xy",
		LayoutOrder = t1.layoutOrder
	}, {
		Glyph = React.createElement(Icon, {
			LayoutOrder = 1,
			name = t1.icon,
			size = IconSize.XSmall,
			variant = if not v15 then nil else IconVariant.Filled,
			style = v16
		}),
		Count = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = {
				["auto-xy text-body-small"] = true,
				["content-default"] = not v15
			},
			textStyle = v16,
			Text = v13 or ""
		})
	})
end

return MomentEngagementCount
