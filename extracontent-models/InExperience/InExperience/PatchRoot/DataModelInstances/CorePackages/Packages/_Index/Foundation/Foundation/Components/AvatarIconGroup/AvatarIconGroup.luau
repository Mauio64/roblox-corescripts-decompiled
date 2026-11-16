local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local AvatarIcon = require(Foundation.Components.AvatarIcon)
local InternalAvatarGroup = require(Foundation.Components.InternalAvatarGroup)
require(Foundation.Components.Types)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local AvatarIconSize = require(Foundation.Enums.AvatarIconSize)

local AvatarGroupType = require(Foundation.Enums.AvatarGroupType)

local useAvatarIconVariants = require(Foundation.Components.AvatarIcon.useAvatarIconVariants)

local function renderAvatarIcon(userId, props, size)
	return React.createElement(AvatarIcon, {
		userId = userId,
		key = props.key,
		backgroundStyle = props.backgroundStyle,
		backplateStyle = props.backplateStyle,
		size = size,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		ZIndex = props.ZIndex,
		testId = props.testId
	})
end

local v = {
	type = AvatarGroupType.Spread,
	max = 1e999,
	size = AvatarIconSize.Medium,
	testId = "--foundation-avatar-icon-group"
}

local function AvatarIconGroup(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()

	local size = useAvatarIconVariants(v3, v2.size).container.size

	local size2 = v2.size
	local gap

	if v2.type == AvatarGroupType.Spread then
		gap = v3.Size.Size_200
	elseif size2 == AvatarIconSize.Large or size2 == AvatarIconSize.Medium then
		gap = -v3.Size.Size_50
	else
		gap = -v3.Size.Size_0
	end

	return React.createElement(InternalAvatarGroup, withCommonProps(v2, {
		ref = ref,
		type = v2.type,
		max = v2.max,
		resolvedSize = size,
		gap = gap,
		isEllipsedOverflow = true,
		backplateStyle = v2.backplateStyle,
		avatars = v2.avatars,
		renderAvatar = function(userId, p2)
			return renderAvatarIcon(userId, p2, v2.size)
		end
	}))
end

return React.memo(React.forwardRef(AvatarIconGroup))
