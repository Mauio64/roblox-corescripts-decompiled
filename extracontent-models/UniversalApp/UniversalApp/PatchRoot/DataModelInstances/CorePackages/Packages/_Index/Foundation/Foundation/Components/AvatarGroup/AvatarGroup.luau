local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Avatar = require(Foundation.Components.Avatar)
local InputSize = require(Foundation.Enums.InputSize)
local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local Flags = require(Foundation.Utility.Flags)
local Icon = require(Foundation.Components.Icon)
local IconSize = require(Foundation.Enums.IconSize)
local InternalAvatarGroup = require(Foundation.Components.InternalAvatarGroup)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)
require(Foundation.Enums.UserPresence)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
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

local function AvatarOverflow(p1) -- line: 53
	-- upvalues: useTokens (copy), usePresentationContext (copy), useCumulativeBackground (copy), InputSize (copy), ColorNamespace (copy), React (copy), View (copy), withCommonProps (copy), Icon (copy), IconSize (copy), Text (copy)
	local v25 = useTokens()
	local v26 = usePresentationContext()
	local v27 = useCumulativeBackground(p1.backplateStyle, p1.backgroundStyle)
	local v28 = v26.isIconSize and (p1.size == InputSize.XSmall or p1.size == InputSize.Small)
	local v29 = not v26.isIconSize and not InputSize.XSmall and "text-caption-medium" or "text-caption-small"
	local Emphasis = v25[v26.colorNamespace or ColorNamespace.Color].Content.Emphasis

	return React.createElement(View, withCommonProps(p1, {
		tag = "row align-x-center align-y-center radius-circle",
		Size = p1.Size,
		backgroundStyle = v27
	}), if not v28 then React.createElement(Text, {
		Text = `+{ p1.count }`,
		tag = `auto-xy text-align-x-center { v29 }`,
		textStyle = Emphasis
	}) else React.createElement(Icon, {
		name = "three-dots-horizontal",
		size = IconSize.XSmall,
		style = Emphasis
	}))
end
local function AvatarGroup(p2, p3) -- line: 89
	-- upvalues: withDefaults (copy), t1 (copy), usePresentationContext (copy), useTokens (copy), AvatarGroupType (copy), InputSize (copy), ColorNamespace (copy), getAvatarSize (copy), Flags (copy), React (copy), Avatar (copy), InternalAvatarGroup (copy), withCommonProps (copy), getBindableValue (copy), AvatarOverflow (copy), View (copy)
	local v33 = withDefaults(p2, t1)
	local v34 = usePresentationContext()
	local v35 = useTokens()
	local size = v33.size
	local v37 = if v33.type ~= AvatarGroupType.Spread then if not v34.isIconSize then if size ~= InputSize.XSmall then -v35.Size.Size_100 else -v35.Size.Size_50 else if size ~= InputSize.Large and size ~= InputSize.Medium then -v35.Size.Size_0 else -v35.Size.Size_50 else v35.Size.Size_200
	local Shift_300 = v35[v34.colorNamespace or ColorNamespace.Color].Shift.Shift_300
	local v39 = getAvatarSize(v35, size, v34.isIconSize)
	local v40 = v33.backplateStyle or v35.Color.Surface.Surface_0

	if Flags.FoundationAvatarBeta then
		local v41 = React.useCallback(function(p4, p5) -- line: 112
			-- upvalues: React (copy), Avatar (copy), v33 (copy)
			local userPresence = nil

			if typeof(p4) == "table" then
				userPresence = p4.userPresence
				p4 = p4.userId
			end

			return React.createElement(Avatar, {
				userId = p4,
				key = p5.key,
				backgroundStyle = p5.backgroundStyle,
				backplateStyle = p5.backplateStyle,
				size = v33.size,
				userPresence = userPresence,
				LayoutOrder = p5.LayoutOrder,
				Position = p5.Position,
				ZIndex = p5.ZIndex,
				testId = p5.testId
			})
		end, { v33.size })

		return (React.createElement(InternalAvatarGroup, withCommonProps(v33, {
			ref = p3,
			type = v33.type,
			max = v33.max,
			resolvedSize = v39,
			isEllipsedOverflow = size == InputSize.XSmall or v34.isIconSize and size == InputSize.Small,
			gap = v37,
			backplateStyle = v40,
			avatars = v33.avatars,
			renderAvatar = v41
		})))
	end

	local t2 = {}
	local v43 = v39 + v37

	for v44, v45 in v33.avatars do
		local uDim2 = UDim2.fromOffset(v43 * (v44 - 1), 0)
		local userPresence = nil
		local userId

		if Flags.FoundationAvatarBindableUserId then
			if typeof(v45) == "table" then
				userPresence = v45.userPresence
				userId = v45.userId
			else
				userId = v45
			end
		else
			userId = v45

			if typeof(v45) == "table" then
				userPresence = v45.userPresence
				userId = v45.userId
			end
		end

		local v49 = if not Flags.FoundationAvatarBindableUserId then nil else tostring(getBindableValue(userId))
		local v50 = #v33.avatars - (v44 - 1)

		if v44 > v33.max then
			t2[v44] = React.createElement(AvatarOverflow, {
				key = "overflow",
				count = #v33.avatars - v33.max,
				size = v33.size,
				Size = UDim2.fromOffset(v39, v39),
				LayoutOrder = v44,
				Position = uDim2,
				ZIndex = v50,
				backgroundStyle = Shift_300,
				backplateStyle = v40
			})

			return React.createElement(View, withCommonProps(v33, {
				tag = "auto-xy",
				ref = p3
			}), t2)
		end

		t2[v44] = React.createElement(Avatar, {
			key = if not Flags.FoundationAvatarBindableUserId then tostring(userId) else v49,
			userId = userId,
			backgroundStyle = Shift_300,
			backplateStyle = v40,
			size = v33.size,
			userPresence = userPresence,
			LayoutOrder = v44,
			Position = uDim2,
			ZIndex = v50,
			testId = if not Flags.FoundationAvatarBindableUserId then `{ v33.testId }--avatar-{ userId }` else `{ v33.testId }--avatar-{ v49 }`
		})
	end

	return React.createElement(View, withCommonProps(v33, {
		tag = "auto-xy",
		ref = p3
	}), t2)
end

return React.memo(React.forwardRef(AvatarGroup))
