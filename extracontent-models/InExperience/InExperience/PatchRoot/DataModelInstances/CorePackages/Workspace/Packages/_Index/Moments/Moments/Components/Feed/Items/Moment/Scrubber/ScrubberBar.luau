local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local MomentsCommon = require(parent.MomentsCommon)
local ReactOtter = require(parent.ReactOtter)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function Scrubber(props)
	local v = useTokens()

	local isHovering = props.isHovering or props.isPressed

	local v2, v3 = ReactOtter.useAnimatedBinding(0)
	React.useEffect(function()
		v3(ReactOtter.ease(isHovering and 1 or 0, {
			duration = isHovering and 0.12 or 0.08,
			easingStyle = Enum.EasingStyle.Quad
		}))
	end, { isHovering })

	local mapped = v2:map(function(p: number)
		return {
			Color3 = MomentsCommon.Utils.Oklab.lerp(v.Color.System.Neutral.Color3, v.Color.System.Emphasis.Color3, p),
			Transparency = math.lerp(v.Color.System.Neutral.Transparency, v.Color.System.Emphasis.Transparency, p)
		}
	end)

	local mapped2 = v2:map(function(p: number)
		local v4 = math.lerp(v.Size.Size_100, v.Size.Size_150, p)
		return UDim2.new(1, 0, 0, v4)
	end)

	local mapped3 = v2:map(function(p: number)
		local v4 = math.lerp(0, v.Size.Size_300, p)
		return UDim2.fromOffset(v4, v4)
	end)

	return React.createElement(
		View,
		{
			tag = "position-center-center anchor-center-center radius-circle bg-shift-100",
			Size = mapped2
		},
		{
			ProgressSegment = React.createElement(View, {
				tag = "radius-circle clip",
				Size = props.progressRatio:map(function(p: number)
					return UDim2.fromScale(p, 1)
				end),
				backgroundStyle = mapped
			}, {
				EndCap = React.createElement(View, {
					tag = "position-center-right anchor-center-right size-250-full",
					backgroundStyle = mapped
				})
			}),
			Handle = React.createElement(View, {
				tag = "anchor-center-center radius-circle bg-contrast",
				Size = mapped3,
				Position = props.progressRatio:map(function(p: number)
					return UDim2.fromScale(p, 0.5)
				end),
				ZIndex = 2
			})
		}
	)
end

return React.memo(Scrubber)
