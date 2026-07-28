local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local ColorMode = require(Foundation.Enums.ColorMode)
local Icon = require(Foundation.Components.Icon)
local IconSize = require(Foundation.Enums.IconSize)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local AvatarGroupType = require(Foundation.Enums.AvatarGroupType)

require(Foundation.Enums.UserPresence)

local usePresentationContext = require(Foundation.Providers.Style.PresentationContext).usePresentationContext
local getBindableValue = require(Foundation.Utility.getBindableValue)
local useCumulativeBackground = require(Foundation.Utility.useCumulativeBackground)
local t1 = {
	isEllipsedOverflow = false,
	max = 1e999,
	testId = "--foundation-avatar-group",
	type = AvatarGroupType.Spread
}

local function AvatarOverflow(p1) -- line: 58
	-- upvalues: useTokens (copy), usePresentationContext (copy), useCumulativeBackground (copy), ColorMode (copy), React (copy), View (copy), withCommonProps (copy), Icon (copy), IconSize (copy), Text (copy)
	local v21 = useTokens()
	local v22 = usePresentationContext()
	local v23 = useCumulativeBackground(p1.backplateStyle, p1.backgroundStyle)
	local v24 = not p1.isEllipsed and "text-caption-medium" or "text-caption-small"
	local Emphasis = v21[v22.colorMode or ColorMode.Color].Content.Emphasis

	return React.createElement(View, withCommonProps(p1, {
		tag = "row align-x-center align-y-center radius-circle",
		Size = p1.Size,
		backgroundStyle = v23
	}), if not p1.isEllipsed then React.createElement(Text, {
		Text = `+{ p1.count }`,
		tag = `auto-xy text-align-x-center { v24 }`,
		textStyle = Emphasis,
		testId = `{ p1.testId }--text`
	}) else React.createElement(Icon, {
		name = "three-dots-horizontal",
		size = IconSize.XSmall,
		style = Emphasis,
		testId = `{ p1.testId }--ellipses`
	}))
end
local function InternalAvatarGroup(p2, p3) -- line: 93
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), usePresentationContext (copy), ColorMode (copy), ReactIs (copy), getBindableValue (copy), React (copy), AvatarOverflow (copy), View (copy), withCommonProps (copy)
	local v28 = withDefaults(p2, t1)
	local v29 = useTokens()
	local Shift_300 = v29[usePresentationContext().colorMode or ColorMode.Color].Shift.Shift_300
	local v31 = v28.backplateStyle or v29.Color.Surface.Surface_0
	local resolvedSize = v28.resolvedSize
	local v33 = resolvedSize + v28.gap
	local t2 = {}

	for v35, v36 in v28.avatars do
		local v37 = if not ReactIs.isBinding(v36) and typeof(v36) ~= "number" then if typeof(v36) ~= "table" then v36 else v36.userId else v36
		local str = tostring(getBindableValue(v37))
		local uDim2 = UDim2.fromOffset(v33 * (v35 - 1), 0)
		local v40 = #v28.avatars - (v35 - 1)

		if v35 > v28.max then
			t2[v35] = React.createElement(AvatarOverflow, {
				key = "overflow",
				count = #v28.avatars - v28.max,
				isEllipsed = v28.isEllipsedOverflow,
				Size = UDim2.fromOffset(resolvedSize, resolvedSize),
				LayoutOrder = v35,
				Position = uDim2,
				ZIndex = v40,
				backgroundStyle = Shift_300,
				backplateStyle = v31,
				testId = `{ v28.testId }--avatar-overflow`
			})

			return React.createElement(View, withCommonProps(v28, {
				tag = "auto-xy",
				ref = p3
			}), t2)
		end

		t2[v35] = v28.renderAvatar(v36, {
			key = str,
			LayoutOrder = v35,
			Position = uDim2,
			ZIndex = v40,
			testId = `{ v28.testId }--avatar-{ str }`,
			backgroundStyle = Shift_300,
			backplateStyle = v31
		})
	end

	return React.createElement(View, withCommonProps(v28, {
		tag = "auto-xy",
		ref = p3
	}), t2)
end

return React.memo(React.forwardRef(InternalAvatarGroup))
