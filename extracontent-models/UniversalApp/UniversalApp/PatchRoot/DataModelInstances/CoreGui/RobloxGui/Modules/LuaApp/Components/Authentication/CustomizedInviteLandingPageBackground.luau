local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local LandingPageConstants = require(CorePackages.Workspace.Packages.LandingPage).Constants.LandingPageConstants
local Otter = require(CorePackages.Packages.Otter)
local useScreenSize = require(CorePackages.Workspace.Packages.RobloxAppHooks).useScreenSize

local function CustomizedInviteLandingPageBackground(t1: {[any]: any}) -- line: 25
	-- upvalues: LandingPageConstants (copy), useScreenSize (copy), React (copy), Otter (copy)
	local BackgroundAnimation = LandingPageConstants.CustomizedLandingPage.BackgroundAnimation
	local v9 = useScreenSize()
	local v10, v11 = React.useBinding(BackgroundAnimation.RIGHT_EDGE)
	local v12, _ = React.useBinding(Otter.createSingleMotor(BackgroundAnimation.RIGHT_EDGE))
	local v14, v15 = React.useBinding(BackgroundAnimation.OPAQUE)
	local v16, _ = React.useBinding(Otter.createSingleMotor(BackgroundAnimation.OPAQUE))

	v12:getValue():onStep(function(p1) -- line: 36
		-- upvalues: v11 (copy)
		v11(p1)
	end)
	v12:getValue():onComplete(function(p2) -- line: 40
		-- upvalues: BackgroundAnimation (copy), v16 (copy), v12 (copy)
		if p2 == BackgroundAnimation.LEFT_EDGE then
			v16:getValue():setGoal(BackgroundAnimation.OTTER_FADE_OUT)

			return
		end

		v12:getValue():setGoal(BackgroundAnimation.OTTER_SCROLL_LEFT)
	end)
	v16:getValue():onStep(function(p3) -- line: 48
		-- upvalues: v15 (copy)
		v15(p3)
	end)
	v16:getValue():onComplete(function(p4) -- line: 53
		-- upvalues: BackgroundAnimation (copy), v12 (copy), v16 (copy)
		if p4 == BackgroundAnimation.TRANSPARENT then
			v12:getValue():setGoal(BackgroundAnimation.OTTER_INSTANT_RIGHT)
			v16:getValue():setGoal(BackgroundAnimation.OTTER_INSTANT_IN)
		end
	end)
	React.useEffect(function() -- line: 60
		-- upvalues: v12 (copy), BackgroundAnimation (copy)
		v12:getValue():setGoal(BackgroundAnimation.OTTER_SCROLL_LEFT)
	end, {})

	local v18 = math.max(v9.X, v9.Y)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		BackgroundImage = React.createElement("ImageLabel", {
			BorderSizePixel = 0,
			ZIndex = 2,
			Image = t1.backgroundImage,
			Size = UDim2.new(1, 0, 1, 0),
			Position = v10:map(function(p5) -- line: 74
				return UDim2.new(p5, 0, 0.5, 0)
			end),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ScaleType = Enum.ScaleType.Crop,
			ImageTransparency = v14:map(function(p6) -- line: 80
				return p6
			end),
			BackgroundTransparency = v14:map(function(p7) -- line: 83
				return p7
			end)
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MinSize = Vector2.new(v18, v18)
			}),
			UIGradient = React.createElement("UIGradient", LandingPageConstants.CustomizedLandingPage.BackgroundGradient)
		}),
		FadeBackgroundImage = React.createElement("ImageLabel", {
			BorderSizePixel = 0,
			ZIndex = 1,
			Image = t1.backgroundImage,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ScaleType = Enum.ScaleType.Crop
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MinSize = Vector2.new(v18, v18)
			}),
			UIGradient = React.createElement("UIGradient", LandingPageConstants.CustomizedLandingPage.BackgroundGradient)
		})
	})
end

return CustomizedInviteLandingPageBackground
