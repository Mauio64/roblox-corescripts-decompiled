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

local function Avatar(p1, p2) -- line: 47
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), usePresentationContext (copy), useAvatarVariants (copy), getAvatarSize (copy), React (copy), View (copy), withCommonProps (copy), Image (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy), Flags (copy), Dash (copy), StatusIndicator (copy), Indicator (copy)
	local v25 = withDefaults(p1, t1)
	local v26 = useTokens()
	local v27 = usePresentationContext()
	local v28 = useAvatarVariants(v26, v25.size, v25.userPresence, v25.backplateStyle, v27.isIconSize)
	local v29 = getAvatarSize(v26, v25.size, v27.isIconSize)

	return React.createElement(View, withCommonProps(v25, {
		tag = v28.container.tag,
		ref = p2,
		backgroundStyle = v28.container.backgroundStyle,
		stroke = v28.container.stroke,
		Size = UDim2.fromOffset(v29, v29)
	}), {
		Image = React.createElement(Image, {
			Image = getRbxThumb(ThumbnailType.AvatarHeadShot, v25.userId, ThumbnailSize.Medium),
			tag = v28.avatar.tag,
			backgroundStyle = v25.backgroundStyle
		}),
		Indicator = if not Flags.FoundationAvatarBeta then if not v28.indicator.isVisible then nil else React.createElement(View, Dash.join(v28.indicatorBackplate, {
			testId = `{ v25.testId }--indicator`
		}), React.createElement(Indicator, v28.indicator)) else if not v28.statusIndicator.isVisible then nil else React.createElement(View, Dash.join(v28.statusIndicatorBackplate, {
			testId = `{ v25.testId }--indicator-backplate`
		}), React.createElement(StatusIndicator, {
			testId = `{ v25.testId }--status-indicator`,
			variant = v28.statusIndicator.variant,
			shape = v28.statusIndicator.shape,
			size = v28.statusIndicator.size
		}))
	})
end

return React.memo(React.forwardRef(Avatar))
