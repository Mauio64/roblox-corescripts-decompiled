local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local SocialCommon = require(ParentParentParent.SocialCommon)
local UIBlox = require(ParentParentParent.UIBlox)
local ReactUtils = require(ParentParentParent.ReactUtils)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local InputUtilities = SocialCommon.Utils.InputUtilities
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEventConnection = ReactUtils.useEventConnection
local useStyle = UIBlox.Core.Style.useStyle
local CarouselNavigated = require(ParentParent.Thunks.CarouselNavigated)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local v20 = Images["icons/actions/cycleLeft"]
local v21 = Images["icons/actions/cycleRight"]

return function(t1: {[any]: any}) -- line: 39
	-- upvalues: useAnalytics (copy), useDispatch (copy), useStyle (copy), React (copy), Constants (copy), v20 (copy), v21 (copy), InputUtilities (copy), EventNames (copy), CarouselNavigated (copy), RunService (copy), useEventConnection (copy), UserInputService (copy), ImageSetLabel (copy)
	local v23 = useAnalytics()
	local v24 = useDispatch()
	local v25 = useStyle()
	local v26 = React.useRef(nil)
	local v27 = t1.direction == Constants.CarouselDirection.Left
	local v28 = if not v27 then Vector2.new(1, 0.5) else Vector2.new(0, 0.5)
	local v29 = if not v27 then v21 else v20
	local v30 = if not v27 then UDim2.fromScale(1, 0.5) else UDim2.fromScale(0, 0.5)

	React.useEffect(function() -- line: 52
		-- upvalues: v26 (copy)
		return function() -- line: 53
			-- upvalues: v26 (copy)
			if v26.current then
				v26.current:Disconnect()
				v26.current = nil
			end
		end
	end, {})
	React.useEffect(function() -- line: 61
		-- upvalues: t1 (copy), v26 (copy)
		if t1.isDisabled and v26.current then
			v26.current:Disconnect()
			v26.current = nil
		end
	end, { t1.isDisabled })

	local v31 = React.useCallback(function(_, p2) -- line: 68
		-- upvalues: t1 (copy), InputUtilities (copy), v26 (copy), v23 (copy), EventNames (copy), v24 (copy), CarouselNavigated (copy), RunService (copy)
		if t1.isDisabled then
			return
		end

		if p2.UserInputState ~= Enum.UserInputState.Begin then
			return
		end

		if not InputUtilities.isActivationInput(p2) then
			return
		end

		if v26.current then
			v26.current:Disconnect()
			v26.current = nil
		end

		v23.fireEvent(EventNames.CapturesCarouselNavigated, {
			direction = t1.direction
		})
		v24(CarouselNavigated(t1.direction))

		local timestamp = tick()
		local v36 = timestamp

		v26.current = RunService.RenderStepped:Connect(function(_) -- line: 94
			-- upvalues: v36 (copy), timestamp (ref), v23 (copy), EventNames (copy), t1 (copy), v24 (copy), CarouselNavigated (copy)
			if math.max(0.5 / (tick() - v36), 0.15) < tick() - timestamp then
				v23.fireEvent(EventNames.CapturesCarouselNavigated, {
					direction = t1.direction
				})
				v24(CarouselNavigated(t1.direction))
				timestamp = tick()
			end
		end)
	end, { t1.isDisabled })
	local v32 = React.useCallback(function(_, p5) -- line: 108
		-- upvalues: InputUtilities (copy), v26 (copy)
		if InputUtilities.isActivationInput(p5) and v26.current then
			v26.current:Disconnect()
			v26.current = nil
		end
	end, {})

	useEventConnection(UserInputService.InputEnded, function(p6) -- line: 117
		-- upvalues: InputUtilities (copy), v26 (copy)
		if InputUtilities.isActivationInput(p6) and v26.current then
			v26.current:Disconnect()
			v26.current = nil
		end
	end)

	return React.createElement("TextButton", {
		AnchorPoint = v28,
		BackgroundTransparency = 1,
		Position = v30,
		Size = t1.Size,
		Text = "",
		ZIndex = t1.ZIndex,
		Visible = not t1.isDisabled,
		[React.Event.InputBegan] = v31,
		[React.Event.InputEnded] = v32
	}, {
		Arrow = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = v29,
			ImageColor3 = v25.Theme.IconEmphasis.Color,
			ImageTransparency = v25.Theme.IconEmphasis.Transparency,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(36, 36)
		})
	})
end
