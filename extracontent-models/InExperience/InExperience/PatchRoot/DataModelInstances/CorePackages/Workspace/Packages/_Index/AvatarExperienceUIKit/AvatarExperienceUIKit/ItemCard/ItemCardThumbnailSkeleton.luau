local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Radius = Foundation.Enums.Radius
local usePulseBinding = Foundation.Hooks.usePulseBinding
local useTokens = Foundation.Hooks.useTokens
local withCommonProps = Foundation.Utility.withCommonProps
local withDefaults = Foundation.Utility.withDefaults

local function lerp(transparency: number, p: number, p2: number) -- 1 equivalent call inferred from this helper
	return (1 - p2) * transparency + p * p2
end

local v = { radius = Radius.None, Size = UDim2.fromScale(1, 1), testId = "--foundation-skeleton" }

local function ItemCardThumbnailSkeleton(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = usePulseBinding(2)
	local v4 = useTokens()
	local cornerRadius

	if v2.radius ~= Radius.None then
		cornerRadius = UDim.new(0, v4.Radius[v2.radius])
	end

	return React.createElement(View, withCommonProps(v2, {
		cornerRadius = cornerRadius,
		backgroundStyle = v3:map(function(p2: number)
			return {
				Color3 = v4.Color.Shift.Shift_300.Color3,
				Transparency = lerp( -- inferred equivalent call
					v4.Color.Extended.White.White_10.Transparency,
					v4.Color.Extended.White.White_10.Transparency - 0.1,
					p2
				)
			}
		end),
		Size = v2.Size,
		ref = ref
	}))
end

return React.memo(React.forwardRef(ItemCardThumbnailSkeleton))
