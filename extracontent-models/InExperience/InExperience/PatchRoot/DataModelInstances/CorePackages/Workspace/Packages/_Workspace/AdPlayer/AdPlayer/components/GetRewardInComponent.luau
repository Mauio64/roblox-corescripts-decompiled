local AdPlayer = script:FindFirstAncestor("AdPlayer")

if not require(AdPlayer.Flags).GetEnableLuaRewardTimerUI() then
	return nil
end

local AdPlayerParent = AdPlayer.Parent
local React = require(AdPlayerParent.React)
local useLocalization = require(AdPlayerParent.Localization).Hooks.useLocalization
local Foundation = require(AdPlayerParent.Foundation)
local ReactOtter = require(AdPlayerParent.ReactOtter)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local View = Foundation.View
local FoundationImage = Foundation.Image
local RadialProgressComponent = require(AdPlayer.components.RadialProgressComponent)
local t1 = {
	getRewardIn = "Features.OnDemandAds.Get_Reward_In",
	rewardEarned = "Features.OnDemandAds.Reward_Earned"
}

local function linearEaseOptions(n1: number) -- line: 37
	return {
		duration = n1,
		easingStyle = Enum.EasingStyle.Linear
	}
end

return function(t2: {[any]: any}) -- line: 44
	-- upvalues: React (copy), ReactOtter (copy), useTokens (copy), useLocalization (copy), t1 (copy), View (copy), FoundationImage (copy), FoundationText (copy), RadialProgressComponent (copy)
	local v16 = React.useRef(nil)
	local v17, v18 = React.useState(0)
	local v19, v20 = ReactOtter.useAnimatedBinding(0)
	local v21, v22 = ReactOtter.useAnimatedBinding(0)
	local v23 = React.useRef(nil)
	local v24, v25 = React.useState(0)
	local v26, v27 = ReactOtter.useAnimatedBinding(1)
	local v28, v29 = ReactOtter.useAnimatedBinding(0)
	local v30 = useTokens()
	local v31 = useLocalization(t1)
	local v32, v33 = ReactOtter.useAnimatedBinding(0)
	local v34, v35 = ReactOtter.useAnimatedBinding(1)
	local v36, v37 = ReactOtter.useAnimatedBinding(0)
	local v38, v39 = ReactOtter.useAnimatedBinding(0)
	local v40, v41 = React.useState(true)
	local v42, _ = React.useBinding(1)

	React.useEffect(function() -- line: 64
		-- upvalues: v40 (copy), v39 (copy), ReactOtter (copy)
		if v40 then
			v39(ReactOtter.instant(0))

			return
		end

		local u44 = false

		task.delay(3, function() -- line: 71
			-- upvalues: u44 (ref), v39 (copy), ReactOtter (copy)
			if not u44 then
				v39(ReactOtter.ease(1))
			end
		end)

		return function() -- line: 77
			-- upvalues: u44 (ref)
			u44 = true
		end
	end, { v40 })
	React.useEffect(function() -- line: 82
		-- upvalues: v16 (copy), v18 (copy), v23 (copy), v25 (copy)
		local current = v16.current

		if current then
			v18(current.TextBounds.X)
		end

		local current2 = v23.current

		if current2 then
			v25(current2.TextBounds.X)
		end
	end, {})
	React.useEffect(function() -- line: 94
		-- upvalues: v40 (copy), v33 (copy), ReactOtter (copy), v17 (copy), v24 (copy)
		if v40 then
			v33(ReactOtter.instant(24 + v17 + 8 + 20))

			return
		end

		v33(ReactOtter.ease(24 + v24 + 8 + 20 - 4, {
			duration = 0.4,
			easingStyle = Enum.EasingStyle.Linear
		}))
	end, {
		v40,
		v17,
		v24
	})
	React.useEffect(function() -- line: 114
		-- upvalues: v40 (copy), v20 (copy), ReactOtter (copy), v22 (copy), v27 (copy), v29 (copy), v37 (copy), v35 (copy)
		local u47 = false

		if v40 then
			v20(ReactOtter.instant(0))
			v22(ReactOtter.instant(0))
			v27(ReactOtter.instant(1))
			v29(ReactOtter.instant(28))
			v37(ReactOtter.instant(0))
			v35(ReactOtter.instant(1))
		else
			v22(ReactOtter.ease(24, {
				duration = 0.4,
				easingStyle = Enum.EasingStyle.Linear
			}))
			v29(ReactOtter.ease(0, {
				duration = 0.4,
				easingStyle = Enum.EasingStyle.Linear
			}))
			v37(ReactOtter.ease(1, {
				duration = 0.1,
				easingStyle = Enum.EasingStyle.Linear
			}))
			task.delay(0.1, function() -- line: 130
				-- upvalues: u47 (ref), v20 (copy), ReactOtter (copy), v27 (copy)
				if not u47 then
					v20(ReactOtter.ease(1, {
						duration = 0.1,
						easingStyle = Enum.EasingStyle.Linear
					}))
					v27(ReactOtter.ease(0, {
						duration = 0.1,
						easingStyle = Enum.EasingStyle.Linear
					}))
				end
			end)
			task.delay(0.4, function() -- line: 137
				-- upvalues: u47 (ref), v35 (copy), ReactOtter (copy)
				if not u47 then
					v35(ReactOtter.ease(0, {
						duration = 0.1,
						easingStyle = Enum.EasingStyle.Linear
					}))
				end
			end)
		end

		return function() -- line: 144
			-- upvalues: u47 (ref)
			u47 = true
		end
	end, { v40 })

	return React.createElement(View, {
		tag = "padding-y-xsmall padding-x-medium bg-over-media-300 radius-small clip",
		Size = v32:map(function(p1) -- line: 151
			return UDim2.fromOffset(p1, 32)
		end),
		GroupTransparency = v38,
		Visible = v17 > 0
	}, {
		checkIcon = React.createElement(FoundationImage, {
			tag = "size-500 anchor-center-left",
			Image = "rbxassetid://125702125855534",
			LayoutOrder = 1,
			imageStyle = {
				Transparency = v34
			},
			Position = UDim2.new(0, -4, 0.5, 0),
			Visible = t2.rewardWaitAlpha:map(function(p2) -- line: 165
				-- upvalues: v41 (copy)
				v41(p2 < 1)

				return p2 == 1
			end)
		}),
		getRewardInLabel = React.createElement(FoundationText, {
			tag = "text-label-medium text-align-x-left text-align-y-center",
			Text = v31.getRewardIn,
			Size = UDim2.new(0, v17, 1, 0),
			Position = v21:map(function(p3) -- line: 174
				return UDim2.new(0, p3, 0, 0)
			end),
			textStyle = {
				Color3 = v30.Color.ActionEmphasis.Foreground.Color3,
				Transparency = v19
			},
			ref = v16
		}),
		rewardEarnedLabel = React.createElement(FoundationText, {
			tag = "text-label-medium text-align-x-right text-align-y-center anchor-top-right",
			Text = v31.rewardEarned,
			Size = UDim2.new(0, v24, 1, 0),
			Position = v28:map(function(p4) -- line: 187
				return UDim2.new(1, -p4, 0, 0)
			end),
			textStyle = {
				Color3 = v30.Color.ActionEmphasis.Foreground.Color3,
				Transparency = v26
			},
			ref = v23
		}),
		progressContainer = React.createElement(View, {
			tag = "radius-circle bg-over-media-200 size-500 anchor-center-right position-center-right",
			GroupTransparency = v36
		}, {
			progressBackground = React.createElement(RadialProgressComponent, {
				thickness = 2,
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				alpha = v42,
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				ImageColor3 = v30.Color.Content.Muted.Color3,
				Visible = t2.rewardWaitAlpha:map(function(p5) -- line: 208
					return p5 < 1
				end)
			}, {
				radialProgress = React.createElement(RadialProgressComponent, {
					thickness = 2,
					BackgroundTransparency = 1,
					alpha = t2.rewardWaitAlpha,
					Size = UDim2.fromScale(1, 1),
					ImageColor3 = v30.Color.Extended.White.White_0.Color3
				}, {
					timerLabel = React.createElement(FoundationText, {
						tag = "size-full-300 anchor-center-center position-center-center content-emphasis text-caption-small text-align-x-center text-align-y-center",
						TextScaled = true,
						Text = t2.rewardWaitAlpha:map(function(p6) -- line: 221
							-- upvalues: t2 (copy)
							return (tostring((math.ceil(t2.rewardWaitTime - t2.rewardWaitTime * p6))))
						end)
					})
				})
			})
		})
	})
end
