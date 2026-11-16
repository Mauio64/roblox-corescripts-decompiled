local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

local Icon = BuilderIcons.Icon

local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local Icon2 = require(Foundation.Components.Icon)
local IconSize = require(Foundation.Enums.IconSize)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local AvatarGroupType = require(Foundation.Enums.AvatarGroupType)

require(Foundation.Enums.UserPresence)

local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local usePresentationContext = PresentationContext.usePresentationContext
local getBindableValue = require(Foundation.Utility.getBindableValue)
local useCumulativeBackground = require(Foundation.Utility.useCumulativeBackground)

local v = {
	type = AvatarGroupType.Spread,
	isEllipsedOverflow = false,
	max = 1e999,
	testId = "--foundation-avatar-group"
}

local function AvatarOverflow(props)
	local v2 = useTokens()
	local v3 = usePresentationContext()
	local backgroundStyle = useCumulativeBackground(props.backplateStyle, props.backgroundStyle)
	local v4 = props.isEllipsed and "text-caption-small" or "text-caption-medium"
	local emphasis = v2[v3.colorNamespace or ColorNamespace.Color].Content.Emphasis
	local createElement = React.createElement

	local v5 = withCommonProps(props, {
		Size = props.Size,
		backgroundStyle = backgroundStyle,
		tag = "row align-x-center align-y-center radius-circle"
	})
	local v6

	if props.isEllipsed then
		v6 = React.createElement(Icon2, {
			name = Icon.ThreeDotsHorizontal,
			size = IconSize.XSmall,
			style = emphasis,
			testId = `{props.testId}--ellipses`
		})
	else
		v6 = React.createElement(Text, {
			Text = `+{props.count}`,
			tag = `auto-xy text-align-x-center {v4}`,
			textStyle = emphasis,
			testId = `{props.testId}--text`
		})
	end

	return createElement(View, v5, v6)
end

local function InternalAvatarGroup(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local shift_300 = v3[usePresentationContext().colorNamespace or ColorNamespace.Color].Shift.Shift_300
	local backplateStyle = v2.backplateStyle or v3.Color.Surface.Surface_0

	local resolvedSize = v2.resolvedSize
	local v4 = resolvedSize + v2.gap

	local children = {}

	for k, avatar in v2.avatars do
		local v5

		if ReactIs.isBinding(avatar) or typeof(avatar) == "number" or typeof(avatar) ~= "table" then
			v5 = avatar
		else
			v5 = avatar.userId
		end

		local v6 = tostring(getBindableValue(v5))

		local udim = UDim2.fromOffset(v4 * (k - 1), 0)
		local zIndex = #v2.avatars - (k - 1)

		if v2.max < k then
			children[k] = React.createElement(AvatarOverflow, {
				key = "overflow",
				count = #v2.avatars - v2.max,
				isEllipsed = v2.isEllipsedOverflow,
				Size = UDim2.fromOffset(resolvedSize, resolvedSize),
				LayoutOrder = k,
				Position = udim,
				ZIndex = zIndex,
				backgroundStyle = shift_300,
				backplateStyle = backplateStyle,
				testId = `{v2.testId}--avatar-overflow`
			})
			break
		end

		children[k] = v2.renderAvatar(avatar, {
			key = v6,
			LayoutOrder = k,
			Position = udim,
			ZIndex = zIndex,
			testId = `{v2.testId}--avatar-{v6}`,
			backgroundStyle = shift_300,
			backplateStyle = backplateStyle
		})
	end

	return React.createElement(View, withCommonProps(v2, { ref = ref, tag = "auto-xy" }), children)
end

return React.memo(React.forwardRef(InternalAvatarGroup))
