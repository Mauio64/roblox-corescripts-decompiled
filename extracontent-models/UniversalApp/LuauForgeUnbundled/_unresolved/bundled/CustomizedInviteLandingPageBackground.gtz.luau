local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local landingPageConstants = require("@luauforge/bundled/gru").Constants.LandingPageConstants

local Otter = require(CorePackages.Packages.Otter)

local useScreenSize = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useScreenSize

local function CustomizedInviteLandingPageBackground(p2)
	local backgroundAnimation = landingPageConstants.CustomizedLandingPage.BackgroundAnimation
	local v5 = useScreenSize()

	local v6, v7 = React.useBinding(backgroundAnimation.RIGHT_EDGE)
	local v8, v9 = React.useBinding(Otter.createSingleMotor(backgroundAnimation.RIGHT_EDGE))

	local v10, v11 = React.useBinding(backgroundAnimation.OPAQUE)

	local v12, v13 = React.useBinding(Otter.createSingleMotor(backgroundAnimation.OPAQUE))

	v8:getValue():onStep(function(p3)
		v7(p3)
	end)
	v8:getValue():onComplete(function(p3)
		if p3 == backgroundAnimation.LEFT_EDGE then
			v12:getValue():setGoal(backgroundAnimation.OTTER_FADE_OUT)
		else
			v8:getValue():setGoal(backgroundAnimation.OTTER_SCROLL_LEFT)
		end
	end)

	v12:getValue():onStep(function(p3)
		v11(p3)
	end)

	v12:getValue():onComplete(function(p3)
		if p3 == backgroundAnimation.TRANSPARENT then
			v8:getValue():setGoal(backgroundAnimation.OTTER_INSTANT_RIGHT)
			v12:getValue():setGoal(backgroundAnimation.OTTER_INSTANT_IN)
		end
	end)

	React.useEffect(function()
		v8:getValue():setGoal(backgroundAnimation.OTTER_SCROLL_LEFT)
	end, {})

	local v14 = math.max(v5.X, v5.Y)

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		{
			BackgroundImage = React.createElement("ImageLabel", {
				Image = p2.backgroundImage,
				Size = UDim2.new(1, 0, 1, 0),
				Position = v6:map(function(p3)
					return UDim2.new(p3, 0, 0.5, 0)
				end),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Crop,
				ImageTransparency = v10:map(function(p3)
					return p3
				end),
				BackgroundTransparency = v10:map(function(p3)
					return p3
				end),
				ZIndex = 2
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MinSize = Vector2.new(v14, v14)
				}),
				UIGradient = React.createElement(
					"UIGradient",
					landingPageConstants.CustomizedLandingPage.BackgroundGradient
				)
			}),
			FadeBackgroundImage = React.createElement("ImageLabel", {
				Image = p2.backgroundImage,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = 1
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MinSize = Vector2.new(v14, v14)
				}),
				UIGradient = React.createElement(
					"UIGradient",
					landingPageConstants.CustomizedLandingPage.BackgroundGradient
				)
			})
		}
	)
end

return CustomizedInviteLandingPageBackground
