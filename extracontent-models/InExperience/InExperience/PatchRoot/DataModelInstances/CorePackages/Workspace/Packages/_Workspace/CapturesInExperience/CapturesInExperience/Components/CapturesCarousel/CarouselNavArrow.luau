local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local SocialCommon = require(parent2.SocialCommon)
local UIBlox = require(parent2.UIBlox)
local ReactUtils = require(parent2.ReactUtils)

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local InputUtilities = SocialCommon.Utils.InputUtilities

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEventConnection = ReactUtils.useEventConnection
local useStyle = UIBlox.Core.Style.useStyle

local CarouselNavigated = require(parent.Thunks.CarouselNavigated)
local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local useAnalytics = require(parent.Analytics.useAnalytics)

local iconsactionscycleLeft = Images["icons/actions/cycleLeft"]
local iconsactionscycleRight = Images["icons/actions/cycleRight"]

return function(props)
	local v = useAnalytics()
	local v2 = useDispatch()
	local v3 = useStyle()

	local ref = React.useRef(nil)

	local v4 = props.direction == Constants.CarouselDirection.Left
	local vector2

	if v4 then
		vector2 = Vector2.new(0, 0.5)
	else
		vector2 = Vector2.new(1, 0.5)
	end

	local image

	if v4 then
		image = iconsactionscycleLeft
	else
		image = iconsactionscycleRight
	end

	local udim

	if v4 then
		udim = UDim2.fromScale(0, 0.5)
	else
		udim = UDim2.fromScale(1, 0.5)
	end

	React.useEffect(function()
		return function()
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end
		end
	end, {})

	React.useEffect(function()
		if props.isDisabled and ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end
	end, { props.isDisabled })

	local v5 = React.useCallback(function(_, p)
		if
			props.isDisabled
			or p.UserInputState ~= Enum.UserInputState.Begin
			or not InputUtilities.isActivationInput(p)
		then
			return
		end

		if ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end

		v.fireEvent(EventNames.CapturesCarouselNavigated, { direction = props.direction })

		v2(CarouselNavigated(props.direction))

		local lastTime = tick()
		local v5 = lastTime

		ref.current = RunService.RenderStepped:Connect(function(_)
			if math.max(0.5 / (tick() - v5), 0.15) < tick() - lastTime then
				v.fireEvent(EventNames.CapturesCarouselNavigated, { direction = props.direction })

				v2(CarouselNavigated(props.direction))
				lastTime = tick()
			end
		end)
	end, { props.isDisabled })

	local v6 = React.useCallback(function(_, p)
		if InputUtilities.isActivationInput(p) and ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end
	end, {})

	useEventConnection(UserInputService.InputEnded, function(p)
		if InputUtilities.isActivationInput(p) and ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end
	end)

	return React.createElement("TextButton", {
		AnchorPoint = vector2,
		BackgroundTransparency = 1,
		Position = udim,
		Size = props.Size,
		Text = "",
		ZIndex = props.ZIndex,
		Visible = not props.isDisabled,
		[React.Event.InputBegan] = v5,
		[React.Event.InputEnded] = v6
	}, {
		Arrow = React.createElement(ImageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = image,
			ImageColor3 = v3.Theme.IconEmphasis.Color,
			ImageTransparency = v3.Theme.IconEmphasis.Transparency,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(36, 36)
		})
	})
end
