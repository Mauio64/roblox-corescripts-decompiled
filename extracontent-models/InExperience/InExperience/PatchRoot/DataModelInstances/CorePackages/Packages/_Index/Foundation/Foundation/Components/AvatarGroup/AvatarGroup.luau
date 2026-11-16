local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Avatar = require(Foundation.Components.Avatar)
local InputSize = require(Foundation.Enums.InputSize)

local InternalAvatarGroup = require(Foundation.Components.InternalAvatarGroup)
require(Foundation.Components.Types)
require(Foundation.Enums.UserPresence)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local AvatarGroupType = require(Foundation.Enums.AvatarGroupType)

local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local usePresentationContext = PresentationContext.usePresentationContext

local getAvatarSize = require(Foundation.Components.Avatar.getAvatarSize)

local v = {
	type = AvatarGroupType.Spread,
	max = 1e999,
	size = InputSize.Medium,
	testId = "--foundation-avatar-group"
}

local function AvatarGroup(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = usePresentationContext()
	local v4 = useTokens()
	local size = v2.size
	local gap

	if v2.type == AvatarGroupType.Spread then
		gap = v4.Size.Size_200
	elseif v3.isIconSize then
		if size == InputSize.Large or size == InputSize.Medium then
			gap = -v4.Size.Size_50
		else
			gap = -v4.Size.Size_0
		end
	elseif size == InputSize.XSmall then
		gap = -v4.Size.Size_50
	else
		gap = -v4.Size.Size_100
	end

	local avatarSize = getAvatarSize(v4, size, v3.isIconSize)
	local backplateStyle = v2.backplateStyle or v4.Color.Surface.Surface_0
	local renderAvatar = React.useCallback(function(userId, props)
		local userPresence

		if typeof(userId) == "table" then
			userPresence = userId.userPresence
			userId = userId.userId
		end

		return React.createElement(Avatar, {
			userId = userId,
			key = props.key,
			backgroundStyle = props.backgroundStyle,
			backplateStyle = props.backplateStyle,
			size = v2.size,
			userPresence = userPresence,
			LayoutOrder = props.LayoutOrder,
			Position = props.Position,
			ZIndex = props.ZIndex,
			testId = props.testId
		})
	end, { v2.size })

	return (React.createElement(InternalAvatarGroup, withCommonProps(v2, {
		ref = ref,
		type = v2.type,
		max = v2.max,
		resolvedSize = avatarSize,
		isEllipsedOverflow = size == InputSize.XSmall or v3.isIconSize and size == InputSize.Small,
		gap = gap,
		backplateStyle = backplateStyle,
		avatars = v2.avatars,
		renderAvatar = renderAvatar
	})))
end

return React.memo(React.forwardRef(AvatarGroup))
