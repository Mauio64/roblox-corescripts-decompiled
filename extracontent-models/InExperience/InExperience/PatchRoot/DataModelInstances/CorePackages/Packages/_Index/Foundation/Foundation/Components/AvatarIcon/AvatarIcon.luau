local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

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

local v = { size = AvatarIconSize.Medium, testId = "--foundation-avatar-icon" }

local function AvatarIcon(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useAvatarIconVariants(useTokens(), v2.size, v2.backplateStyle)

	return React.createElement(View, withCommonProps(v2, {
		tag = v3.container.tag,
		ref = ref,
		stroke = v3.container.stroke,
		backgroundStyle = v2.backplateStyle,
		Size = UDim2.fromOffset(v3.container.size, v3.container.size)
	}), {
		Image = React.createElement(Image, {
			Image = mapBindable(v2.userId, function(p2)
				return getRbxThumb(ThumbnailType.AvatarHeadShot, p2, ThumbnailSize.Medium)
			end),
			tag = v3.avatar.tag,
			backgroundStyle = v2.backgroundStyle
		})
	})
end

return React.memo(React.forwardRef(AvatarIcon))
