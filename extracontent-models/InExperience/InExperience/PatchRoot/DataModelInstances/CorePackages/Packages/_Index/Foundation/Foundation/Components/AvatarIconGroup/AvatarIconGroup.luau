local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local AvatarIcon = require(Foundation.Components.AvatarIcon)
local InternalAvatarGroup = require(Foundation.Components.InternalAvatarGroup)

require(Foundation.Components.Types)

local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local AvatarIconSize = require(Foundation.Enums.AvatarIconSize)
local AvatarGroupType = require(Foundation.Enums.AvatarGroupType)
local useAvatarIconVariants = require(Foundation.Components.AvatarIcon.useAvatarIconVariants)

local function renderAvatarIcon(p1, p2, p3) -- line: 28
	-- upvalues: React (copy), AvatarIcon (copy)
	return React.createElement(AvatarIcon, {
		userId = p1,
		key = p2.key,
		backgroundStyle = p2.backgroundStyle,
		backplateStyle = p2.backplateStyle,
		size = p3,
		LayoutOrder = p2.LayoutOrder,
		Position = p2.Position,
		ZIndex = p2.ZIndex,
		testId = p2.testId
	})
end

local t1 = {
	max = 1e999,
	testId = "--foundation-avatar-icon-group",
	type = AvatarGroupType.Spread,
	size = AvatarIconSize.Medium
}

local function AvatarIconGroup(p4, p5) -- line: 53
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useAvatarIconVariants (copy), AvatarGroupType (copy), AvatarIconSize (copy), React (copy), InternalAvatarGroup (copy), withCommonProps (copy), renderAvatarIcon (copy)
	local v20 = withDefaults(p4, t1)
	local v21 = useTokens()
	local size = useAvatarIconVariants(v21, v20.size).container.size
	local size2 = v20.size
	local v24 = if v20.type ~= AvatarGroupType.Spread then if size2 ~= AvatarIconSize.Large and size2 ~= AvatarIconSize.Medium then -v21.Size.Size_0 else -v21.Size.Size_50 else v21.Size.Size_200

	return React.createElement(InternalAvatarGroup, withCommonProps(v20, {
		isEllipsedOverflow = true,
		ref = p5,
		type = v20.type,
		max = v20.max,
		resolvedSize = size,
		gap = v24,
		backplateStyle = v20.backplateStyle,
		avatars = v20.avatars,
		renderAvatar = function(p6, p7) -- line: 78
			-- upvalues: renderAvatarIcon (copy), v20 (copy)
			return renderAvatarIcon(p6, p7, v20.size)
		end
	}))
end

return React.memo(React.forwardRef(AvatarIconGroup))
