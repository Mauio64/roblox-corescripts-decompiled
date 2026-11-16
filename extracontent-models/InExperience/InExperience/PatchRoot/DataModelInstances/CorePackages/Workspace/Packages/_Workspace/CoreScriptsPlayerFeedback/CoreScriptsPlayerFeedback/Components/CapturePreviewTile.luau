local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize

local BuilderIcons = require(parent.BuilderIcons)
local IconVariant = BuilderIcons.IconVariant

require(CoreScriptsPlayerFeedback.CaptureTypes)

return (React.memo(function(props)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local v = props.status == "uploading"
	local v2

	if props.status == "failed" then
		v2 = props.failureReason ~= Enum.UploadCaptureResult.CaptureModerated
	else
		v2 = false
	end

	local UserInputService = game:GetService("UserInputService")
	local touchEnabled = UserInputService.TouchEnabled

	local createElement = React.createElement
	local v3 = {
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		Image = "",
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(0, 80, 0, 80),
		[React.Event.MouseEnter] = function()
			setState(true)
		end,
		[React.Event.MouseLeave] = function()
			setState(false)
		end,
		[React.Event.SelectionGained] = function()
			setState2(true)
		end,
		[React.Event.SelectionLost] = function()
			setState2(false)
		end
	}
	local v4 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		FailedStroke = 0,
		Thumbnail = 0,
		UploadingOverlay = 0,
		RemoveButton = 0
	}
	local failedStroke

	if v2 then
		failedStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(220, 50, 50),
			Thickness = 1
		})
	end

	v4.FailedStroke = failedStroke

	v4.Thumbnail = React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ImageContent = Content.fromObject(props.capture),
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 1
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
	})
	local uploadingOverlay

	if v then
		uploadingOverlay = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.45,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2
		}, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			Spinner = React.createElement(Loading, {
				size = IconSize.Medium,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				ZIndex = 3
			})
		})
	end

	v4.UploadingOverlay = uploadingOverlay
	local removeButton

	if state or touchEnabled or state2 then
		removeButton = React.createElement("ImageButton", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(1, -2, 0, 2),
			Size = UDim2.new(0, 20, 0, 20),
			ZIndex = 4,
			[React.Event.Activated] = props.onRemove
		}, {
			CircleXIcon = React.createElement(Icon, {
				name = BuilderIcons.Icon.CircleX,
				size = IconSize.Medium,
				variant = IconVariant.Filled
			})
		})
	end

	v4.RemoveButton = removeButton
	return createElement("ImageButton", v3, v4)
end))
