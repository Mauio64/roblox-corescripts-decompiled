local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Dash = require(FoundationParent.Dash)
local Image = require(Foundation.Components.Image)
local Indicator = require(script.Parent.Indicator)

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
local InputSize = require(Foundation.Enums.InputSize)
local UserPresence = require(Foundation.Enums.UserPresence)
local getAvatarSize = require(script.Parent.getAvatarSize)
local t1 = {
	testId = "--foundation-avatar",
	size = InputSize.Medium,
	userPresence = UserPresence.None
}

local function Avatar(p1, p2) -- line: 45
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), usePresentationContext (copy), useAvatarVariants (copy), getAvatarSize (copy), React (copy), View (copy), withCommonProps (copy), Image (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy), Dash (copy), Indicator (copy)
	local v23 = withDefaults(p1, t1)
	local v24 = useTokens()
	local v25 = usePresentationContext()
	local v26 = useAvatarVariants(v24, v23.size, v23.userPresence, v23.backplateStyle, v25.isIconSize)
	local v27 = getAvatarSize(v24, v23.size, v25.isIconSize)

	return React.createElement(View, withCommonProps(v23, {
		tag = v26.container.tag,
		ref = p2,
		backgroundStyle = v26.container.backgroundStyle,
		stroke = v26.container.stroke,
		Size = UDim2.fromOffset(v27, v27)
	}), {
		Image = React.createElement(Image, {
			Image = getRbxThumb(ThumbnailType.AvatarHeadShot, v23.userId, ThumbnailSize.Medium),
			tag = v26.avatar.tag,
			backgroundStyle = v23.backgroundStyle
		}),
		Indicator = if not v26.indicator.isVisible then nil else React.createElement(View, Dash.join(v26.indicatorBackplate, {
			testId = `{ v23.testId }--indicator`
		}), React.createElement(Indicator, v26.indicator))
	})
end

return React.memo(React.forwardRef(Avatar))
