local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Checkbox = Foundation.Checkbox
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local View = Foundation.View
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(CoreScriptsPlayerFeedback.CaptureTypes)
local getCaptureKey = require(CoreScriptsPlayerFeedback.Utils.getCaptureKey)

local memo = React.memo(function(props)
	local capture = props.capture
	local v = capture.CaptureType == Enum.CaptureType.Video
	local isDisabled = props.isDisabled == true

	local onActivated = React.useCallback(function()
		if not isDisabled then
			props.onToggle()
		end
	end, { isDisabled, props.onToggle })

	local v2 = React.useCallback(function()
		props.onPreview()
	end, { props.onPreview })

	local createElement = React.createElement
	local v3 = {
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Image = "",
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 1),
		[React.Event.Activated] = v2
	}
	local disabledOverlay

	if isDisabled then
		disabledOverlay = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 3
		})
	end

	local preview

	if not v then
		preview = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ImageContent = Content.fromObject(capture),
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1
		})
	end

	return createElement("ImageButton", v3, {
		DisabledOverlay = disabledOverlay,
		Preview = preview,
		CheckboxOverlay = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 2 },
			{
				Checkbox = React.createElement(Checkbox, {
					AnchorPoint = Vector2.new(1, 0),
					isChecked = props.isSelected,
					label = "",
					onActivated = onActivated,
					Position = UDim2.new(1, -4, 0, 4)
				})
			}
		)
	})
end)

return (React.memo(function(props)
	local count = 0

	for _, selectedKey in props.selectedKeys do
		if selectedKey then
			count += 1
		end
	end

	local v = props.maxSelections <= count

	local v2 = useLocalization({
		selectionHint = {
			"CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Captures.Picker.NumSelected",
			count = tostring(count),
			max = tostring(props.maxSelections)
		},
		loading = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Captures.Loading",
		empty = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Captures.Empty"
	})

	local children = {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 2)
		}),
		UIGridLayout = React.createElement("UIGridLayout", {
			CellPadding = UDim2.new(0, 4, 0, 4),
			CellSize = UDim2.new(1 / 3, -3, 0, 100),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for k, capture in props.captures do
		local captureKey = getCaptureKey(capture)
		local isSelected = props.selectedKeys[captureKey] == true

		children[captureKey] = React.createElement(memo, {
			capture = capture,
			isSelected = isSelected,
			isDisabled = v and not isSelected,
			onToggle = function()
				props.onToggle(capture)
			end,
			onPreview = function()
				props.onPreview(capture)
			end,
			LayoutOrder = k
		})
	end

	local createElement = React.createElement
	local v3 = { tag = "col gap-small size-full-0 auto-y", Size = UDim2.new(1, 0, 0, 360) }
	local v4 = {
		Hint = React.createElement(Text, {
			Text = v2.selectionHint,
			tag = "size-full-0 auto-y text-caption-small text-wrap text-align-x-right content-muted",
			LayoutOrder = 1
		}),
		Scroll = 0
	}

	local createElement2 = React.createElement
	local v5 = {
		tag = "fill size-full-0",
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = ScrollBarVisibility.Auto
		},
		onCanvasPositionChanged = function(data)
			if not props.hasMore or props.isLoading then
				return
			end

			local y = data.AbsoluteCanvasSize.Y
			local y2 = data.AbsoluteWindowSize.Y

			if y <= y2 then
				return
			end

			if y - y2 - data.CanvasPosition.Y <= 20 then
				props.onLoadMore()
			end
		end,
		LayoutOrder = 2
	}

	local createElement3 = React.createElement
	local v6 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -12, 0, 0)
	}
	local grid

	if props.isLoading and #props.captures == 0 then
		grid = React.createElement(Text, {
			Text = v2.loading,
			tag = "size-full-0 auto-y text-body-medium text-align-x-center content-muted"
		})
	elseif #props.captures == 0 then
		grid = React.createElement(Text, {
			Text = v2.empty,
			tag = "size-full-0 auto-y text-body-medium text-align-x-center content-muted"
		})
	else
		grid = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0)
			},
			children
		)
	end

	v4.Scroll = createElement2(ScrollView, v5, {
		Content = createElement3("Frame", v6, { Grid = grid })
	})
	return createElement(View, v3, v4)
end))
