local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Avatar = require(Foundation.Components.Avatar)
local ColorMode = require(Foundation.Enums.ColorMode)
local Icon = require(Foundation.Components.Icon)
local IconSize = require(Foundation.Enums.IconSize)
local InputSize = require(Foundation.Enums.InputSize)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Enums.UserPresence)

local AvatarGroupType = require(Foundation.Enums.AvatarGroupType)
local usePresentationContext = require(Foundation.Providers.Style.PresentationContext).usePresentationContext
local useCumulativeBackground = require(Foundation.Utility.useCumulativeBackground)
local getAvatarSize = require(Foundation.Components.Avatar.getAvatarSize)
local t1 = {
	max = 1e999,
	testId = "--foundation-avatar-group",
	type = AvatarGroupType.Spread,
	size = InputSize.Medium
}

local function AvatarOverflow(p1) -- line: 43
	-- upvalues: useTokens (copy), usePresentationContext (copy), useCumulativeBackground (copy), InputSize (copy), ColorMode (copy), React (copy), View (copy), withCommonProps (copy), Icon (copy), IconSize (copy), Text (copy)
	local v22 = useTokens()
	local v23 = usePresentationContext()
	local v24 = useCumulativeBackground(p1.backplateStyle, p1.backgroundStyle)
	local v25 = v23.isIconSize and (p1.size == InputSize.XSmall or p1.size == InputSize.Small)
	local v26 = not v23.isIconSize and not InputSize.XSmall and "text-caption-medium" or "text-caption-small"
	local Emphasis = v22[v23.colorMode or ColorMode.Color].Content.Emphasis

	return React.createElement(View, withCommonProps(p1, {
		tag = "row align-x-center align-y-center radius-circle",
		Size = p1.Size,
		backgroundStyle = v24
	}), if not v25 then React.createElement(Text, {
		Text = `+{ p1.count }`,
		tag = `auto-xy text-align-x-center { v26 }`,
		textStyle = Emphasis
	}) else React.createElement(Icon, {
		name = "three-dots-horizontal",
		size = IconSize.XSmall,
		style = Emphasis
	}))
end
local function AvatarGroup(p2, p3) -- line: 79
	-- upvalues: withDefaults (copy), t1 (copy), usePresentationContext (copy), useTokens (copy), AvatarGroupType (copy), InputSize (copy), ColorMode (copy), getAvatarSize (copy), React (copy), AvatarOverflow (copy), Avatar (copy), View (copy), withCommonProps (copy)
	local v30 = withDefaults(p2, t1)
	local v31 = usePresentationContext()
	local v32 = useTokens()
	local v33 = if v30.type ~= AvatarGroupType.Spread then if not v31.isIconSize then if v30.size ~= InputSize.XSmall then -v32.Size.Size_100 else -v32.Size.Size_50 else if v30.size ~= InputSize.Large and v30.size ~= InputSize.Medium then -v32.Size.Size_0 else -v32.Size.Size_50 else v32.Size.Size_200
	local Shift_300 = v32[v31.colorMode or ColorMode.Color].Shift.Shift_300
	local v35 = getAvatarSize(v32, v30.size, v31.isIconSize)
	local v36 = v30.backplateStyle or v32.Color.Surface.Surface_0
	local t2 = {}
	local v38 = v35 + v33

	for v39, v40 in v30.avatars do
		local uDim2 = UDim2.fromOffset(v38 * (v39 - 1), 0)
		local userPresence = nil
		local v43 = v40

		if typeof(v40) == "table" then
			userPresence = v40.userPresence
			v43 = v40.userId
		end

		local v44 = #v30.avatars - (v39 - 1)

		if v39 > v30.max then
			t2[v39] = React.createElement(AvatarOverflow, {
				key = "overflow",
				count = #v30.avatars - v30.max,
				size = v30.size,
				Size = UDim2.fromOffset(v35, v35),
				LayoutOrder = v39,
				Position = uDim2,
				ZIndex = v44,
				backgroundStyle = Shift_300,
				backplateStyle = v36
			})

			return React.createElement(View, withCommonProps(v30, {
				tag = "auto-xy",
				ref = p3
			}), t2)
		end

		t2[v39] = React.createElement(Avatar, {
			key = tostring(v43),
			userId = v43,
			backgroundStyle = Shift_300,
			backplateStyle = v36,
			size = v30.size,
			userPresence = userPresence,
			LayoutOrder = v39,
			Position = uDim2,
			ZIndex = v44,
			testId = `{ v30.testId }--avatar-{ v43 }`
		})
	end

	return React.createElement(View, withCommonProps(v30, {
		tag = "auto-xy",
		ref = p3
	}), t2)
end

return React.memo(React.forwardRef(AvatarGroup))
