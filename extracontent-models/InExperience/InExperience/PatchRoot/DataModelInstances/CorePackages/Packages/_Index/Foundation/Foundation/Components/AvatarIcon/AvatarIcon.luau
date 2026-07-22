local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Image = require(Foundation.Components.Image)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local mapBindable = require(Foundation.Utility.mapBindable)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local ThumbnailSize = require(Foundation.Enums.ThumbnailSize)
local ThumbnailType = require(Foundation.Enums.ThumbnailType)
local getRbxThumb = require(Foundation.Utility.getRbxThumb)
local AvatarIconSize = require(Foundation.Enums.AvatarIconSize)
local useAvatarIconVariants = require(script.Parent.useAvatarIconVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local t1 = {
	testId = "--foundation-avatar-icon",
	size = AvatarIconSize.Medium
}

local function AvatarIcon(p1, p2) -- line: 37
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useAvatarIconVariants (copy), React (copy), View (copy), withCommonProps (copy), Image (copy), mapBindable (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy)
	local v19 = withDefaults(p1, t1)
	local v20 = useTokens()
	local v21 = useAvatarIconVariants(v20, v19.size, v19.backplateStyle)

	return React.createElement(View, withCommonProps(v19, {
		tag = v21.container.tag,
		ref = p2,
		stroke = v21.container.stroke,
		backgroundStyle = v19.backplateStyle,
		Size = UDim2.fromOffset(v21.container.size, v21.container.size)
	}), {
		Image = React.createElement(Image, {
			Image = mapBindable(v19.userId, function(p3) -- line: 54
				-- upvalues: getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy)
				return getRbxThumb(ThumbnailType.AvatarHeadShot, p3, ThumbnailSize.Medium)
			end),
			tag = v21.avatar.tag,
			backgroundStyle = v19.backgroundStyle
		})
	})
end

return React.memo(React.forwardRef(AvatarIcon))
