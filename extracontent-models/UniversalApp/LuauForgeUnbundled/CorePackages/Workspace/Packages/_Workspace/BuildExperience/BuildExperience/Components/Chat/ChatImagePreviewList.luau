local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local progress = Foundation.Progress
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local progressShape = Foundation.Enums.ProgressShape
local progressSize = Foundation.Enums.ProgressSize

local function ChatImagePreviewList(props)
	local v5 = Foundation.Hooks.useTokens()

	local testId = props.testId or "ChatImagePreviewList"
	local children = {}

	for k, image in props.images do
		local v6 = image.uploadStatus == "uploading"
		local v7 = image.uploadStatus == "failed"
		local formatted = `Image-{k}`
		local createElement = React.createElement
		local v9 = {
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Image = typeof(image.capture) == "Object" and "" or image.uri or ""
		}
		local v10 = if typeof(image.capture) == "Object" then Content.fromObject(image.capture) else nil
		v9.ImageContent = v10
		v9.LayoutOrder = k
		v9.ScaleType = Enum.ScaleType.Crop
		v9.Size = UDim2.fromOffset(v5.Size.Size_2400, v5.Size.Size_2400)
		v9[React.Tag] = `data-testid={testId}.Image.{k}`
		local v11 = {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v5.Size.Size_200)
			}),
			FailedStroke = 0,
			Progress = 0,
			Error = 0,
			Retry = 0,
			Remove = 0
		}

		local v12 = if v7 then React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v5.Color.System.Alert.Color3,
			Thickness = v5.Stroke.Thick
		}) else nil
		v11.FailedStroke = v12

		local v13 = if v6 then React.createElement(progress, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			shape = progressShape.Circle,
			size = progressSize.Medium,
			ZIndex = 2,
			testId = `{testId}.Progress.{k}`
		}) else nil
		v11.Progress = v13

		local v14 = if v7 then React.createElement(icon, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			name = iconName.TriangleExclamation,
			Position = UDim2.fromScale(0.5, 0.5),
			size = iconSize.Medium,
			style = v5.Color.System.Alert,
			tag = "auto-xy",
			ZIndex = 2,
			testId = `{testId}.Error.{k}`
		}) else nil
		v11.Error = v14
		local v15

		if v7 and props.onRetry ~= nil then
			v15 = React.createElement(iconButton, {
				icon = iconName.ArrowSpinClockwise,
				isCircular = true,
				onActivated = function()
					props.onRetry(k)
				end,
				Position = UDim2.new(0, 4, 1, -4),
				AnchorPoint = Vector2.new(0, 1),
				size = inputSize.Small,
				variant = buttonVariant.OverMedia,
				ZIndex = 3,
				testId = `{testId}.Retry.{k}`
			})
		end

		v11.Retry = v15
		local v16

		if props.onRemove ~= nil then
			v16 = React.createElement(iconButton, {
				AnchorPoint = Vector2.new(1, 0),
				icon = iconName.X,
				isCircular = true,
				onActivated = function()
					props.onRemove(k)
				end,
				Position = UDim2.new(1, -4, 0, 4),
				size = inputSize.Small,
				variant = buttonVariant.OverMedia,
				ZIndex = 2,
				testId = `{testId}.Remove.{k}`
			})
		end

		v11.Remove = v16
		children[formatted] = createElement("ImageLabel", v9, v11)
	end

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["row wrap gap-small size-full-0 auto-y"] = true,
			["align-x-right"] = props.alignRight == true
		},
		testId = testId
	}, {
		Images = React.createElement(React.Fragment, nil, children)
	})
end

return React.memo(ChatImagePreviewList)
