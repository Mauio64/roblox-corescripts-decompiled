local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local parent = AvatarExperienceUIKit.Parent
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Foundation = require(parent.Foundation)
local makeOtterSpringValue = require(AvatarExperienceUIKit.Utils.makeOtterSpringValue)

local View = Foundation.View

local v = { dampingRatio = 1, frequency = 3.5 }

local function toFullWidthSize(p: number)
	return UDim2.new(1, 0, 0, p)
end

local function DescriptionCollapseFrame(props)
	local v2, v3 = ReactOtter.useAnimatedBinding(props.height)
	local ref = React.useRef(props.isExpanded)

	React.useEffect(function()
		if ref.current == props.isExpanded then
			v3((ReactOtter.instant(props.height)))

			return
		end

		ref.current = props.isExpanded
		v3(makeOtterSpringValue(props.height, v))
	end, { props.height, props.isExpanded })

	local size = React.useMemo(function()
		return v2:map(toFullWidthSize)
	end, { v2 })

	return React.createElement(
		View,
		{ tag = "clip", Size = size, LayoutOrder = props.LayoutOrder, testId = props.testId },
		props.children
	)
end

return DescriptionCollapseFrame
