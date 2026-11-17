local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Checkbox = Foundation.Checkbox
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local function getCaptureContent(capture) -- 1 equivalent call inferred from this helper
	if typeof(capture) == "Object" then
		return Content.fromObject(capture)
	end

	return Content.none
end

local function CaptureGridItem(props)
	local v = useTokens()

	local v2 = React.useCallback(function()
		props.onActivated(props.capture)
	end, { props.capture, props.onActivated })
	local imageContent

	if props.imageContentEnabled == false then
		imageContent = Content.none
	else
		imageContent = getCaptureContent(props.capture) -- inferred equivalent call
	end

	local createElement = React.createElement
	local v3 = {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Image = "",
		ImageContent = imageContent,
		LayoutOrder = props.LayoutOrder,
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1),
		[React.Event.Activated] = v2,
		[React.Tag] = props.testId == nil and "bg-shift-200" or `bg-shift-200 data-testid={props.testId}`
	}

	local v4 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v.Size.Size_200) }),
		SelectedStroke = 0,
		SelectionOverlay = 0
	}
	local selectedStroke

	if props.isSelected then
		selectedStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner,
			Color = v.Color.Content.Emphasis.Color3,
			Thickness = v.Stroke.Thick
		})
	end

	v4.SelectedStroke = selectedStroke
	local selectionOverlay

	if props.isSelected then
		selectionOverlay = React.createElement(View, { tag = "size-full padding-small", ZIndex = 3 }, {
			SelectedIndicator = React.createElement(Checkbox, {
				AnchorPoint = Vector2.new(1, 0),
				isChecked = true,
				label = "",
				onActivated = function()
					v2()
				end,
				Position = UDim2.fromScale(1, 0),
				size = Foundation.Enums.InputSize.Small
			})
		})
	end

	v4.SelectionOverlay = selectionOverlay
	return createElement("ImageButton", v3, v4)
end

return React.memo(CaptureGridItem)
