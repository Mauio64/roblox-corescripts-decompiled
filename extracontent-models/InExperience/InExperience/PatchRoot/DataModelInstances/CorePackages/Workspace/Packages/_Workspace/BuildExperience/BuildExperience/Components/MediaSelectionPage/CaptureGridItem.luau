local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local FFlagBuildExperienceChatImageAttachments = require(BuildExperience.Flags.FFlagBuildExperienceChatImageAttachments)

local Checkbox = Foundation.Checkbox
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local function getCaptureContent(capture) -- 2 equivalent calls inferred from this helper
	if typeof(capture) == "Object" then
		return Content.fromObject(capture)
	end

	return Content.none
end

local function CaptureGridItem(props)
	local v = useTokens()

	local onActivated = React.useCallback(function()
		props.onActivated(props.capture)
	end, { props.capture, props.onActivated })

	if FFlagBuildExperienceChatImageAttachments then
		local imageContent

		if props.imageContentEnabled == false then
			imageContent = Content.none
		else
			imageContent = getCaptureContent(props.capture) -- inferred equivalent call
		end

		local createElement = React.createElement
		local v2 = {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Image = "",
			ImageContent = imageContent,
			LayoutOrder = props.LayoutOrder,
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1),
			[React.Event.Activated] = onActivated,
			[React.Tag] = props.testId == nil and "bg-shift-200" or `bg-shift-200 data-testid={props.testId}`
		}

		local v3 = {
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

		v3.SelectedStroke = selectedStroke
		local selectionOverlay

		if props.isSelected then
			selectionOverlay = React.createElement(View, {
				tag = "size-full padding-small",
				ZIndex = 3
			}, {
				SelectedIndicator = React.createElement(Checkbox, {
					AnchorPoint = Vector2.new(1, 0),
					isChecked = true,
					label = "",
					onActivated = function()
						onActivated()
					end,
					Position = UDim2.fromScale(1, 0),
					size = Foundation.Enums.InputSize.Small
				})
			})
		end

		v3.SelectionOverlay = selectionOverlay
		return createElement("ImageButton", v2, v3)
	else
		local createElement = React.createElement
		local v2 = {
			onActivated = onActivated,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			stroke = props.isSelected and {
				Color = v.Color.Content.Emphasis.Color3,
				Thickness = v.Stroke.Thick,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			} or nil,
			tag = "size-full"
		}

		local v3 = {
			CaptureThumbnail = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ImageContent = getCaptureContent(props.capture), -- inferred equivalent call
				ScaleType = Enum.ScaleType.Crop,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 1
			}),
			SelectionOverlay = 0
		}
		local selectionOverlay

		if props.isSelected then
			selectionOverlay = React.createElement(View, {
				tag = "size-full padding-small",
				ZIndex = 3
			}, {
				SelectedIndicator = React.createElement(Checkbox, {
					AnchorPoint = Vector2.new(1, 0),
					isChecked = true,
					label = "",
					onActivated = function()
						onActivated()
					end,
					Position = UDim2.fromScale(1, 0),
					size = Foundation.Enums.InputSize.Small
				})
			})
		end

		v3.SelectionOverlay = selectionOverlay
		return createElement(View, v2, v3)
	end
end

if FFlagBuildExperienceChatImageAttachments then
	return (React.memo(CaptureGridItem))
end

return CaptureGridItem
