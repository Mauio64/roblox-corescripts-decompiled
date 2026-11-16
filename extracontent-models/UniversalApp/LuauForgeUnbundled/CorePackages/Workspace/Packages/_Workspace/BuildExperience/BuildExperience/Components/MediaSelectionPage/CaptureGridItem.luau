local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local FFlagBuildExperienceChatImageAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatImageAttachments")

local checkbox = Foundation.Checkbox
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local function getCaptureContent(p2)
	if typeof(p2) == "Object" then
		return Content.fromObject(p2)
	end

	return Content.none
end

local function CaptureGridItem(props)
	local v5 = useTokens()

	local v6 = React.useCallback(function()
		props.onActivated(props.capture)
	end, { props.capture, props.onActivated })

	if FFlagBuildExperienceChatImageAttachments then
		local v7

		if props.imageContentEnabled == false then
			v7 = Content.none
		else
			local capture = props.capture
			v7 = if typeof(capture) == "Object" then Content.fromObject(capture) else Content.none
		end

		local createElement = React.createElement
		local v9 = {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Image = "",
			ImageContent = v7,
			LayoutOrder = props.LayoutOrder,
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1),
			[React.Event.Activated] = v6,
			[React.Tag] = props.testId == nil and "bg-shift-200" or `bg-shift-200 data-testid={props.testId}`
		}

		local v10 = {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v5.Size.Size_200)
			}),
			SelectedStroke = 0,
			SelectionOverlay = 0
		}

		local v11 = if props.isSelected then React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner,
			Color = v5.Color.Content.Emphasis.Color3,
			Thickness = v5.Stroke.Thick
		}) else nil
		v10.SelectedStroke = v11
		local v12

		if props.isSelected then
			v12 = React.createElement(view, {
				tag = "size-full padding-small",
				ZIndex = 3
			}, {
				SelectedIndicator = React.createElement(checkbox, {
					AnchorPoint = Vector2.new(1, 0),
					isChecked = true,
					label = "",
					onActivated = function()
						v6()
					end,
					Position = UDim2.fromScale(1, 0),
					size = Foundation.Enums.InputSize.Small
				})
			})
		end

		v10.SelectionOverlay = v12
		return createElement("ImageButton", v9, v10)
	else
		local createElement = React.createElement
		local v8 = {
			onActivated = v6,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			stroke = props.isSelected and {
				Color = v5.Color.Content.Emphasis.Color3,
				Thickness = v5.Stroke.Thick,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			} or nil,
			tag = "size-full"
		}

		local createElement2 = React.createElement

		local capture = props.capture
		local v12 = if typeof(capture) == "Object" then Content.fromObject(capture) else Content.none

		local v9 = {
			CaptureThumbnail = createElement2("ImageLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ImageContent = v12,
				ScaleType = Enum.ScaleType.Crop,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 1
			}),
			SelectionOverlay = 0
		}
		local v13

		if props.isSelected then
			v13 = React.createElement(view, {
				tag = "size-full padding-small",
				ZIndex = 3
			}, {
				SelectedIndicator = React.createElement(checkbox, {
					AnchorPoint = Vector2.new(1, 0),
					isChecked = true,
					label = "",
					onActivated = function()
						v6()
					end,
					Position = UDim2.fromScale(1, 0),
					size = Foundation.Enums.InputSize.Small
				})
			})
		end

		v9.SelectionOverlay = v13
		return createElement(view, v8, v9)
	end
end

if FFlagBuildExperienceChatImageAttachments then
	return (React.memo(CaptureGridItem))
end

return CaptureGridItem
