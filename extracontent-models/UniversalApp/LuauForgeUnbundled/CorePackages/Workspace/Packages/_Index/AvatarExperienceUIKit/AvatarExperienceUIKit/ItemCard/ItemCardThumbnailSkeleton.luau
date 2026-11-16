local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")

local view = Foundation.View
local radius = Foundation.Enums.Radius
local usePulseBinding = Foundation.Hooks.usePulseBinding
local useTokens = Foundation.Hooks.useTokens
local withCommonProps = Foundation.Utility.withCommonProps
local withDefaults = Foundation.Utility.withDefaults

local function lerp(p2, p3, p4)
	return (1 - p4) * p2 + p3 * p4
end

local v5 = {
	radius = radius.None,
	Size = UDim2.fromScale(1, 1),
	testId = "--foundation-skeleton"
}

local function ItemCardThumbnailSkeleton(p2, p3)
	local v6 = withDefaults(p2, v5)
	local v7 = usePulseBinding(2)
	local v8 = useTokens()

	local v9 = if v6.radius ~= radius.None then UDim.new(0, v8.Radius[v6.radius]) else nil

	return React.createElement(view, withCommonProps(v6, {
		cornerRadius = v9,
		backgroundStyle = v7:map(function(p4)
			local v10 = { Color3 = v8.Color.Shift.Shift_300.Color3, Transparency = 0 }

			local transparency = v8.Color.Extended.White.White_10.Transparency
			local v11 = v8.Color.Extended.White.White_10.Transparency - 0.1
			v10.Transparency = (1 - p4) * transparency + v11 * p4
			return v10
		end),
		Size = v6.Size,
		ref = p3
	}))
end

return React.memo(React.forwardRef(ItemCardThumbnailSkeleton))
