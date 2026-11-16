local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(BuildExperience.Chat.chatTypes)

local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Progress = Foundation.Progress
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize

local function ChatImagePreviewList(props)
	local v = Foundation.Hooks.useTokens()

	local testId = props.testId or "ChatImagePreviewList"
	local children = {}

	for k, image in props.images do
		local v2 = image.uploadStatus == "uploading"
		local v3 = image.uploadStatus == "failed"
		local formatted = `Image-{k}`
		local createElement = React.createElement
		local v4 = {
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
		local imageContent

		if typeof(image.capture) == "Object" then
			imageContent = Content.fromObject(image.capture)
		end

		v4.ImageContent = imageContent
		v4.LayoutOrder = k
		v4.ScaleType = Enum.ScaleType.Crop
		v4.Size = UDim2.fromOffset(v.Size.Size_2400, v.Size.Size_2400)
		v4[React.Tag] = `data-testid={testId}.Image.{k}`
		local v5 = {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v.Size.Size_200) }),
			FailedStroke = 0,
			Progress = 0,
			Error = 0,
			Retry = 0,
			Remove = 0
		}
		local failedStroke

		if v3 then
			failedStroke = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = v.Color.System.Alert.Color3,
				Thickness = v.Stroke.Thick
			})
		end

		v5.FailedStroke = failedStroke
		local progress

		if v2 then
			progress = React.createElement(Progress, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				shape = ProgressShape.Circle,
				size = ProgressSize.Medium,
				ZIndex = 2,
				testId = `{testId}.Progress.{k}`
			})
		end

		v5.Progress = progress
		local err

		if v3 then
			err = React.createElement(Icon, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				name = IconName.TriangleExclamation,
				Position = UDim2.fromScale(0.5, 0.5),
				size = IconSize.Medium,
				style = v.Color.System.Alert,
				tag = "auto-xy",
				ZIndex = 2,
				testId = `{testId}.Error.{k}`
			})
		end

		v5.Error = err
		local retry

		if v3 and props.onRetry ~= nil then
			retry = React.createElement(IconButton, {
				icon = IconName.ArrowSpinClockwise,
				isCircular = true,
				onActivated = function()
					props.onRetry(k)
				end,
				Position = UDim2.new(0, 4, 1, -4),
				AnchorPoint = Vector2.new(0, 1),
				size = InputSize.Small,
				variant = ButtonVariant.OverMedia,
				ZIndex = 3,
				testId = `{testId}.Retry.{k}`
			})
		end

		v5.Retry = retry
		local remove

		if props.onRemove ~= nil then
			remove = React.createElement(IconButton, {
				AnchorPoint = Vector2.new(1, 0),
				icon = IconName.X,
				isCircular = true,
				onActivated = function()
					props.onRemove(k)
				end,
				Position = UDim2.new(1, -4, 0, 4),
				size = InputSize.Small,
				variant = ButtonVariant.OverMedia,
				ZIndex = 2,
				testId = `{testId}.Remove.{k}`
			})
		end

		v5.Remove = remove
		children[formatted] = createElement("ImageLabel", v4, v5)
	end

	return React.createElement(View, {
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
