local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/ReactOtter")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local makeOtterSpringValue = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/makeOtterSpringValue")

local view = Foundation.View

local v5 = { dampingRatio = 1, frequency = 3.5 }

local function toFullWidthSize(p2)
	return UDim2.new(1, 0, 0, p2)
end

local function DescriptionCollapseFrame(props)
	local v6, v7 = ReactOtter.useAnimatedBinding(props.height)
	local ref = React.useRef(props.isExpanded)

	React.useEffect(function()
		if ref.current == props.isExpanded then
			v7(ReactOtter.instant(props.height))

			return
		end

		ref.current = props.isExpanded
		v7(makeOtterSpringValue(props.height, v5))
	end, { props.height, props.isExpanded })

	local v8 = React.useMemo(function()
		return v6:map(toFullWidthSize)
	end, { v6 })

	return React.createElement(
		view,
		{
			tag = "clip",
			Size = v8,
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		},
		props.children
	)
end

return DescriptionCollapseFrame
