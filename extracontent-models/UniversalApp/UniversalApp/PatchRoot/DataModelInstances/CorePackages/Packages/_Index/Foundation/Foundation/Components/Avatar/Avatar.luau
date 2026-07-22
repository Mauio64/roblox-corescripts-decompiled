local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Dash = require(FoundationParent.Dash)
local Flags = require(Foundation.Utility.Flags)
local Image = require(Foundation.Components.Image)
local Indicator = require(script.Parent.Indicator)
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
local usePresentationContext = require(Foundation.Providers.Style.PresentationContext).usePresentationContext
local AvatarSize = require(Foundation.Enums.AvatarSize)
local UserPresence = require(Foundation.Enums.UserPresence)
local getAvatarSize = require(script.Parent.getAvatarSize)
local t1 = {
	testId = "--foundation-avatar",
	size = AvatarSize.Medium,
	userPresence = UserPresence.None
}

local function Avatar(p1, p2) -- line: 49
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), usePresentationContext (copy), useAvatarVariants (copy), getAvatarSize (copy), React (copy), View (copy), withCommonProps (copy), Image (copy), Flags (copy), mapBindable (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy), Dash (copy), StatusIndicator (copy), Indicator (copy)
	local v26 = withDefaults(p1, t1)
	local v27 = useTokens()
	local v28 = usePresentationContext()
	local v29 = useAvatarVariants(v27, v26.size, v26.userPresence, v26.backplateStyle, v28.isIconSize)
	local v30 = getAvatarSize(v27, v26.size, v28.isIconSize)

	return React.createElement(View, withCommonProps(v26, {
		tag = v29.container.tag,
		ref = p2,
		backgroundStyle = v29.container.backgroundStyle,
		stroke = v29.container.stroke,
		Size = UDim2.fromOffset(v30, v30)
	}), {
		Image = React.createElement(Image, {
			Image = if not Flags.FoundationAvatarBindableUserId then getRbxThumb(ThumbnailType.AvatarHeadShot, v26.userId, ThumbnailSize.Medium) else mapBindable(v26.userId, function(p3) -- line: 70
				-- upvalues: getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy)
				return getRbxThumb(ThumbnailType.AvatarHeadShot, p3, ThumbnailSize.Medium)
			end),
			tag = v29.avatar.tag,
			backgroundStyle = v26.backgroundStyle,
			testId = if not Flags.FoundationAvatarBindableUserId then nil else `{ v26.testId }--image`
		}),
		Indicator = if not Flags.FoundationAvatarBeta then if not v29.indicator.isVisible then nil else React.createElement(View, Dash.join(v29.indicatorBackplate, {
			testId = `{ v26.testId }--indicator`
		}), React.createElement(Indicator, v29.indicator)) else if not v29.statusIndicator.isVisible then nil else React.createElement(View, Dash.join(v29.statusIndicatorBackplate, {
			testId = `{ v26.testId }--indicator-backplate`
		}), React.createElement(StatusIndicator, {
			testId = `{ v26.testId }--status-indicator`,
			variant = v29.statusIndicator.variant,
			shape = v29.statusIndicator.shape,
			size = v29.statusIndicator.size
		}))
	})
end

return React.memo(React.forwardRef(Avatar))
