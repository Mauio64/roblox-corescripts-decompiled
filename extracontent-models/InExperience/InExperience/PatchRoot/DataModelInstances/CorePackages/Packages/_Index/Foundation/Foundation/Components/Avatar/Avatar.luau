local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Image = require(Foundation.Components.Image)
local StatusIndicator = require(Foundation.Components.StatusIndicator)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local mapBindable = require(Foundation.Utility.mapBindable)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local ThumbnailSize = require(Foundation.Enums.ThumbnailSize)
local ThumbnailType = require(Foundation.Enums.ThumbnailType)
local getRbxThumb = require(Foundation.Utility.getRbxThumb)

local useAvatarVariants = require(script.Parent.useAvatarVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local usePresentationContext = PresentationContext.usePresentationContext

local AvatarSize = require(Foundation.Enums.AvatarSize)

local UserPresence = require(Foundation.Enums.UserPresence)

local getAvatarSize = require(script.Parent.getAvatarSize)

local v = {
	size = AvatarSize.Medium,
	userPresence = UserPresence.None,
	testId = "--foundation-avatar"
}

local function Avatar(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = usePresentationContext()

	local v5 = useAvatarVariants(v3, v2.size, v2.userPresence, v2.backplateStyle, v4.isIconSize)
	local avatarSize = getAvatarSize(v3, v2.size, v4.isIconSize)

	local createElement = React.createElement

	local v6 = withCommonProps(v2, {
		tag = v5.container.tag,
		ref = ref,
		backgroundStyle = v5.container.backgroundStyle,
		stroke = v5.container.stroke,
		Size = UDim2.fromOffset(avatarSize, avatarSize)
	})

	local v7 = {
		Image = React.createElement(Image, {
			Image = mapBindable(v2.userId, function(p2)
				return getRbxThumb(ThumbnailType.AvatarHeadShot, p2, ThumbnailSize.Medium, {
					includeProfileFrame = v2.includeProfileFrame
				})
			end),
			tag = v5.avatar.tag,
			backgroundStyle = v2.backgroundStyle,
			testId = `{v2.testId}--image`
		}),
		Indicator = 0
	}
	local indicator

	if v5.statusIndicator.isVisible then
		indicator = React.createElement(StatusIndicator, {
			testId = `{v2.testId}--status-indicator`,
			variant = v5.statusIndicator.variant,
			shape = v5.statusIndicator.shape,
			size = v5.statusIndicator.size,
			mask = v5.statusIndicatorMask.mask,
			ZIndex = v5.statusIndicatorMask.ZIndex,
			AnchorPoint = v5.statusIndicatorMask.AnchorPoint,
			Position = v5.statusIndicatorMask.Position
		})
	end

	v7.Indicator = indicator
	return createElement(View, v6, v7)
end

return React.memo(React.forwardRef(Avatar))
