local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")

local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function Scrubber(props)
	local v5 = useTokens()

	local isHovering = props.isHovering or props.isPressed

	local v6, v7 = ReactOtter.useAnimatedBinding(0)
	React.useEffect(function()
		v7(ReactOtter.ease(isHovering and 1 or 0, {
			duration = isHovering and 0.12 or 0.08,
			easingStyle = Enum.EasingStyle.Quad
		}))
	end, { isHovering })

	local mapped = v6:map(function(p2)
		return {
			Color3 = MomentsCommon.Utils.Oklab.lerp(
				v5.Color.System.Neutral.Color3,
				v5.Color.System.Emphasis.Color3,
				p2
			),
			Transparency = math.lerp(
				v5.Color.System.Neutral.Transparency,
				v5.Color.System.Emphasis.Transparency,
				p2
			)
		}
	end)

	local mapped2 = v6:map(function(p2)
		local v8 = math.lerp(v5.Size.Size_100, v5.Size.Size_150, p2)
		return UDim2.new(1, 0, 0, v8)
	end)

	local mapped3 = v6:map(function(p2)
		local v8 = math.lerp(0, v5.Size.Size_300, p2)
		return UDim2.fromOffset(v8, v8)
	end)

	return React.createElement(
		view,
		{
			tag = "position-center-center anchor-center-center radius-circle bg-shift-100",
			Size = mapped2
		},
		{
			ProgressSegment = React.createElement(view, {
				tag = "radius-circle clip",
				Size = props.progressRatio:map(function(p2)
					return UDim2.fromScale(p2, 1)
				end),
				backgroundStyle = mapped
			}, {
				EndCap = React.createElement(view, {
					tag = "position-center-right anchor-center-right size-250-full",
					backgroundStyle = mapped
				})
			}),
			Handle = React.createElement(view, {
				tag = "anchor-center-center radius-circle bg-contrast",
				Size = mapped3,
				Position = props.progressRatio:map(function(p2)
					return UDim2.fromScale(p2, 0.5)
				end),
				ZIndex = 2
			})
		}
	)
end

return React.memo(Scrubber)
