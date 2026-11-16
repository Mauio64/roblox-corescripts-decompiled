local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useClock = ReactUtils.useClock

local Components = Foundation.Components
require(Components.Types)
local View = require(Components.View)

local Radius = require(Foundation.Enums.Radius)

local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local usePulseBinding = require(Foundation.Utility.usePulseBinding)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local lerp = require(Foundation.Utility.lerp)

local v = { radius = Radius.None, Size = UDim2.fromScale(1, 1), testId = "--foundation-skeleton" }

local function Skeleton(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useClock()
	local v4 = usePulseBinding(2)
	local v5 = useTokens()
	local v6 = usePreferences()
	local udim

	if v2.radius ~= Radius.None then
		udim = UDim.new(0, v5.Radius[v2.radius])
	end

	local shimmer = v5.Color.Common.Shimmer

	local createElement = React.createElement
	local backgroundStyle

	if v6.reducedMotion then
		backgroundStyle = v4:map(function(p2: number)
			local transparency = shimmer.Transparency
			return {
				Color3 = shimmer.Color3,
				Transparency = lerp(transparency, transparency - 0.1, p2)
			}
		end)
	else
		backgroundStyle = v5.Color.Extended.White.White_100
	end

	local v7 = withCommonProps(v2, {
		cornerRadius = udim,
		backgroundStyle = backgroundStyle,
		Size = v2.Size,
		ref = ref
	})
	local gradient

	if not v6.reducedMotion then
		gradient = React.createElement("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, shimmer.Color3),
				ColorSequenceKeypoint.new(0.5, v5.Color.Extended.White.White_30.Color3),
				ColorSequenceKeypoint.new(1, shimmer.Color3)
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, shimmer.Transparency),
				NumberSequenceKeypoint.new(0.5, v5.Color.Extended.White.White_30.Transparency),
				NumberSequenceKeypoint.new(1, shimmer.Transparency)
			}),
			Offset = v3:map(function(p2: number)
				return Vector2.new(p2 * 2 % 3 - 1.5, 0)
			end),
			Rotation = 15
		})
	end

	return createElement(View, v7, { Gradient = gradient })
end

return React.memo(React.forwardRef(Skeleton))
