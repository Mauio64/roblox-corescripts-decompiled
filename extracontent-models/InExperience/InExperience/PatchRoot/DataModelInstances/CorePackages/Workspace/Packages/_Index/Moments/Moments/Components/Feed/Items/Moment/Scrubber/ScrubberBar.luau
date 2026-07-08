local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local MomentsCommon = require(Parent.MomentsCommon)
local ReactOtter = require(Parent.ReactOtter)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function Scrubber(t1: {[any]: any}) -- line: 18
	-- upvalues: useTokens (copy), ReactOtter (copy), React (copy), MomentsCommon (copy), View (copy)
	local v10 = useTokens()
	local v11 = t1.isHovering or t1.isPressed
	local v12, v13 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function() -- line: 24
		-- upvalues: v13 (copy), ReactOtter (copy), v11 (copy)
		v13(ReactOtter.ease(not v11 and 0 or 1, {
			duration = not v11 and 0.08 or 0.12,
			easingStyle = Enum.EasingStyle.Quad
		}))
	end, { v11 })

	local v14 = v12:map(function(n1: number) -- line: 31
		-- upvalues: MomentsCommon (copy), v10 (copy)
		return {
			Color3 = MomentsCommon.Utils.Oklab.lerp(v10.Color.System.Neutral.Color3, v10.Color.System.Emphasis.Color3, n1),
			Transparency = math.lerp(v10.Color.System.Neutral.Transparency, v10.Color.System.Emphasis.Transparency, n1)
		}
	end)
	local v15 = v12:map(function(n2: number) -- line: 46
		-- upvalues: v10 (copy)
		local v19 = math.lerp(v10.Size.Size_100, v10.Size.Size_150, n2)

		return UDim2.new(1, 0, 0, v19)
	end)
	local v16 = v12:map(function(n3: number) -- line: 51
		-- upvalues: v10 (copy)
		local v21 = math.lerp(0, v10.Size.Size_300, n3)

		return UDim2.fromOffset(v21, v21)
	end)

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center radius-circle bg-shift-100",
		Size = v15
	}, {
		ProgressSegment = React.createElement(View, {
			tag = "radius-circle clip",
			Size = t1.progressRatio:map(function(n4: number) -- line: 62
				return UDim2.fromScale(n4, 1)
			end),
			backgroundStyle = v14
		}, {
			EndCap = React.createElement(View, {
				tag = "position-center-right anchor-center-right size-250-full",
				backgroundStyle = v14
			})
		}),
		Handle = React.createElement(View, {
			tag = "anchor-center-center radius-circle bg-contrast",
			ZIndex = 2,
			Size = v16,
			Position = t1.progressRatio:map(function(n5: number) -- line: 76
				return UDim2.fromScale(n5, 0.5)
			end)
		})
	})
end

return React.memo(Scrubber)
