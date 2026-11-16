local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local CapturesCommon = require(parent2.CapturesCommon)
local Foundation = require(parent2.Foundation)
local React = require(parent2.React)

local Checkbox = Foundation.Checkbox
local View = Foundation.View

local getCropSize = CapturesCommon.Utils.getCropSize
local getFitSize = CapturesCommon.Utils.getFitSize

local FFlagCapturePromptItemUseFit = require(parent.Flags.FFlagCapturePromptItemUseFit)

return function(props)
	local state, setState = React.useState(Vector2.new(0, 0))
	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(Vector2.new(0, 0))

	local onActivated = React.useCallback(function()
		props.updateSelected(not props.isSelected)
	end, { props.isSelected, props.updateSelected })

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize)
	end, {})

	local v = React.useCallback(function(current)
		ref.current = current
		setState2(current.Resolution)
	end, {})

	React.useEffect(function()
		return function()
			if ref.current then
				ref.current.Video = ""
			end
		end
	end, {})
	local v2

	if typeof(props.content) == "Content" and props.content.Object ~= nil then
		v2 = props.content.Object:IsA("VideoCapture")
	else
		v2 = false
	end

	local createElement = React.createElement
	local checkboxOverlay

	if props.showCheckbox then
		checkboxOverlay = React.createElement(View, {
			tag = "size-full padding-small",
			onActivated = onActivated,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			ZIndex = 2
		}, {
			Checkbox = React.createElement(Checkbox, {
				AnchorPoint = Vector2.new(1, 0),
				isChecked = props.isSelected,
				label = "",
				onActivated = onActivated,
				Position = UDim2.fromScale(1, 0)
			})
		})
	end

	local image

	if not v2 then
		local createElement2 = React.createElement
		local v3 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			ImageContent = props.content,
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = 0,
			Size = 0
		}
		local scaleType

		if FFlagCapturePromptItemUseFit then
			scaleType = Enum.ScaleType.Fit
		else
			scaleType = Enum.ScaleType.Crop
		end

		v3.ScaleType = scaleType
		v3.Size = UDim2.fromScale(1, 1)
		image = createElement2("ImageLabel", v3)
	end

	local video

	if v2 then
		local createElement2 = React.createElement
		local v3 = {
			["AnchorPoint"] = nil,
			["AnchorPoint"] = nil,
			["AnchorPoint"] = nil,
			["AnchorPoint"] = nil,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Looped = true,
			Playing = true,
			Position = UDim2.fromScale(0.5, 0.5)
		}
		local size

		if FFlagCapturePromptItemUseFit then
			size = getFitSize(state, state2)
		else
			size = getCropSize(state, state2)
		end

		v3.Size = size

		v3.VideoContent = props.content
		v3.Volume = 0
		v3[React.Event.Loaded] = v
		video = createElement2("VideoFrame", v3)
	end

	return createElement(View, {
		tag = "clip size-full",
		onAbsoluteSizeChanged = onAbsoluteSizeChanged
	}, {
		CheckboxOverlay = checkboxOverlay,
		Image = image,
		Video = video
	})
end
