local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Avatar = require(Foundation.Components.Avatar)
local ColorMode = require(Foundation.Enums.ColorMode)
local Flags = require(Foundation.Utility.Flags)
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
local getBindableValue = require(Foundation.Utility.getBindableValue)
local useCumulativeBackground = require(Foundation.Utility.useCumulativeBackground)
local getAvatarSize = require(Foundation.Components.Avatar.getAvatarSize)
local t1 = {
	max = 1e999,
	testId = "--foundation-avatar-group",
	type = AvatarGroupType.Spread,
	size = InputSize.Medium
}

local function AvatarOverflow(p1) -- line: 51
	-- upvalues: useTokens (copy), usePresentationContext (copy), useCumulativeBackground (copy), InputSize (copy), ColorMode (copy), React (copy), View (copy), withCommonProps (copy), Icon (copy), IconSize (copy), Text (copy)
	local v24 = useTokens()
	local v25 = usePresentationContext()
	local v26 = useCumulativeBackground(p1.backplateStyle, p1.backgroundStyle)
	local v27 = v25.isIconSize and (p1.size == InputSize.XSmall or p1.size == InputSize.Small)
	local v28 = not v25.isIconSize and not InputSize.XSmall and "text-caption-medium" or "text-caption-small"
	local Emphasis = v24[v25.colorMode or ColorMode.Color].Content.Emphasis

	return React.createElement(View, withCommonProps(p1, {
		tag = "row align-x-center align-y-center radius-circle",
		Size = p1.Size,
		backgroundStyle = v26
	}), if not v27 then React.createElement(Text, {
		Text = `+{ p1.count }`,
		tag = `auto-xy text-align-x-center { v28 }`,
		textStyle = Emphasis
	}) else React.createElement(Icon, {
		name = "three-dots-horizontal",
		size = IconSize.XSmall,
		style = Emphasis
	}))
end
local function AvatarGroup(p2, p3) -- line: 87
	-- upvalues: withDefaults (copy), t1 (copy), usePresentationContext (copy), useTokens (copy), AvatarGroupType (copy), InputSize (copy), ColorMode (copy), getAvatarSize (copy), Flags (copy), getBindableValue (copy), React (copy), AvatarOverflow (copy), Avatar (copy), View (copy), withCommonProps (copy)
	local v32 = withDefaults(p2, t1)
	local v33 = usePresentationContext()
	local v34 = useTokens()
	local v35 = if v32.type ~= AvatarGroupType.Spread then if not v33.isIconSize then if v32.size ~= InputSize.XSmall then -v34.Size.Size_100 else -v34.Size.Size_50 else if v32.size ~= InputSize.Large and v32.size ~= InputSize.Medium then -v34.Size.Size_0 else -v34.Size.Size_50 else v34.Size.Size_200
	local Shift_300 = v34[v33.colorMode or ColorMode.Color].Shift.Shift_300
	local v37 = getAvatarSize(v34, v32.size, v33.isIconSize)
	local v38 = v32.backplateStyle or v34.Color.Surface.Surface_0
	local t2 = {}
	local v40 = v37 + v35

	for v41, v42 in v32.avatars do
		local uDim2 = UDim2.fromOffset(v40 * (v41 - 1), 0)
		local userPresence = nil
		local userId

		if Flags.FoundationAvatarBindableUserId then
			if typeof(v42) == "table" then
				userPresence = v42.userPresence
				userId = v42.userId
			else
				userId = v42
			end
		else
			userId = v42

			if typeof(v42) == "table" then
				userPresence = v42.userPresence
				userId = v42.userId
			end
		end

		local v46 = if not Flags.FoundationAvatarBindableUserId then nil else tostring(getBindableValue(userId))
		local v47 = #v32.avatars - (v41 - 1)

		if v41 > v32.max then
			t2[v41] = React.createElement(AvatarOverflow, {
				key = "overflow",
				count = #v32.avatars - v32.max,
				size = v32.size,
				Size = UDim2.fromOffset(v37, v37),
				LayoutOrder = v41,
				Position = uDim2,
				ZIndex = v47,
				backgroundStyle = Shift_300,
				backplateStyle = v38
			})

			return React.createElement(View, withCommonProps(v32, {
				tag = "auto-xy",
				ref = p3
			}), t2)
		end

		t2[v41] = React.createElement(Avatar, {
			key = if not Flags.FoundationAvatarBindableUserId then tostring(userId) else v46,
			userId = userId,
			backgroundStyle = Shift_300,
			backplateStyle = v38,
			size = v32.size,
			userPresence = userPresence,
			LayoutOrder = v41,
			Position = uDim2,
			ZIndex = v47,
			testId = if not Flags.FoundationAvatarBindableUserId then `{ v32.testId }--avatar-{ userId }` else `{ v32.testId }--avatar-{ v46 }`
		})
	end

	return React.createElement(View, withCommonProps(v32, {
		tag = "auto-xy",
		ref = p3
	}), t2)
end

return React.memo(React.forwardRef(AvatarGroup))
