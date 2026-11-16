local UserInputService = game:GetService("UserInputService")

local eventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/ReactUtils").EventConnection
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local iconButton = UIBlox.App.Button.IconButton
local images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Core.Style.withStyle

local ThumbnailButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/ThumbnailButton")
local getShowItems = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/getShowItems")

local extended = Roact.Component:extend("MediaGalleryFullScreen")

extended.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	size = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	items = t.array(t.interface({
		imageId = t.string,
		isYouTubeVideo = t.optional(t.boolean)
	})),
	showIndex = t.optional(t.integer),
	onVideoPlayActivated = t.optional(t.callback)
})

extended.defaultProps = { size = UDim2.fromScale(1, 1), showIndex = 1 }

function extended.getDerivedStateFromProps(p2, data)
	local derivedState

	if data.items ~= p2.items then
		local v5 = getShowItems(p2)

		derivedState = {
			items = p2.items,
			itemsToShow = v5,
			showArrows = #v5 > 1,
			focusIndex = math.min(data.focusIndex or 1, #v5)
		}
	end

	if data.showIndex ~= p2.showIndex then
		derivedState = derivedState or {}
		derivedState.showIndex = p2.showIndex
		derivedState.focusIndex = math.min(p2.showIndex, #p2.items)
	end

	return derivedState
end

function extended:init()
	self.state = {
		items = nil,
		itemsToShow = nil,
		showArrows = true,
		focusIndex = 1,
		showIndex = 1
	}

	local binding, v5 = Roact.createBinding(UDim2.fromScale(1, 1))
	self.itemFrameSize = binding
	self.updateItemFrameSize = v5
	local binding2, v6 = Roact.createBinding(UDim2.new(0, 96, 1, 0))
	self.arrowButtonSize = binding2
	self.updateArrowButtonSize = v6
	local binding3, v7 = Roact.createBinding(UDim2.new(0.5, 0, 0.5, 0))
	self.leftArrowPosition = binding3
	self.updateLeftArrowPosition = v7
	local binding4, v8 = Roact.createBinding(UDim2.new(0.5, 0, 0.5, 0))
	self.rightArrowPosition = binding4
	self.updateRightArrowPosition = v8

	function self.onResize(p2)
		local x = p2.AbsoluteSize.X
		local v9 = p2.AbsoluteSize.Y

		local v10 = math.floor(v9 * (16 / 9))

		if x < v10 then
			v9 = math.floor(x / (16 / 9))
			v10 = x
		end

		self.updateItemFrameSize(UDim2.new(0, v10, 0, v9))
	end

	function self.onImageResize(p2)
		local x = p2.AbsoluteSize.X
		local y = p2.AbsoluteSize.Y

		self.updateLeftArrowPosition(UDim2.new(0.5, -x / 2, 0.5, 0))
		self.updateRightArrowPosition(UDim2.new(0.5, x / 2, 0.5, 0))
		self.updateArrowButtonSize(UDim2.new(0, 96, 0, y))
	end

	function self.onUserInputBegan(p2)
		if p2.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local focusIndex = self.state.focusIndex
		local v9 = #self.props.items

		if p2.KeyCode == Enum.KeyCode.Left and focusIndex > 1 then
			self.showPreviousItem()
		elseif p2.KeyCode == Enum.KeyCode.Right and focusIndex < v9 then
			self.showNextItem()
		end
	end

	function self.showPreviousItem()
		local v9 = self.state.focusIndex - 1
		self:setState({
			focusIndex = v9 < 1 and 1 or v9
		})
	end

	function self.showNextItem()
		local count = #self.props.items
		local v9 = self.state.focusIndex + 1

		if count < v9 then
			v9 = count
		end

		self:setState({ focusIndex = v9 })
	end

	function self.cycleNext()
		local v9 = #self.props.items
		local v10 = self.state.focusIndex + 1
		self:setState({
			focusIndex = v9 < v10 and 1 or v10
		})
	end

	function self.onVideoPlayActivated(p2)
		if self.props.onVideoPlayActivated then
			local originalIndex = self.state.itemsToShow[p2].originalIndex

			self.props.onVideoPlayActivated(originalIndex)
		end
	end
end
local function renderArrowButton(p2, p3, p4, vector2, p5, arrowButtonSize, onActivated)
	return Roact.createElement("Frame", {
		Size = arrowButtonSize,
		AnchorPoint = vector2,
		Position = p5,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ZIndex = 100
	}, {
		ArrowButton = Roact.createElement(iconButton, {
			size = UDim2.fromScale(1, 1),
			icon = images[p3],
			showBackground = true,
			backgroundTransparency = 1,
			isDisabled = p4,
			onActivated = onActivated
		})
	})
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithProvider(p2)
	end)
end

function extended:renderWithProvider(p2)
	local layoutOrder = self.props.layoutOrder
	local anchorPoint = self.props.anchorPoint
	local position = self.props.position
	local size = self.props.size

	local itemsToShow = self.state.itemsToShow
	local showArrows = self.state.showArrows
	local focusIndex = self.state.focusIndex

	local v5 = itemsToShow[focusIndex]
	local v6 = focusIndex <= 1
	local v7 = #itemsToShow <= focusIndex

	local createElement = Roact.createElement
	local onResizesByAbsoluteSize = {
		LayoutOrder = layoutOrder,
		Size = size,
		AnchorPoint = anchorPoint,
		Position = position,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = self.onResize
	}

	local v10 = if showArrows then renderArrowButton(
		p2,
		"icons/actions/cycleLeft",
		v6,
		Vector2.new(1, 0.5),
		self.leftArrowPosition,
		self.arrowButtonSize,
		self.showPreviousItem
	) else nil

	local createElement2 = Roact.createElement
	local onImageResizesByAbsoluteSize = {
		Size = UDim2.new(1, -192, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = self.onImageResize
	}
	local v12 = {
		UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 16 / 9
		}),
		Item = 0
	}

	local createElement3 = Roact.createElement
	local v14 = {
		itemKey = focusIndex,
		imageId = v5.imageId,
		isVideo = v5.isYouTubeVideo,
		userInteractionEnabled = true,
		onActivated = self.cycleNext,
		onPlayActivated = 0
	}
	local v15 = if v5.isYouTubeVideo then self.onVideoPlayActivated or nil else nil
	v14.onPlayActivated = v15
	v12.Item = createElement3(ThumbnailButton, v14)
	local v9 = {
		LeftArrow = v10,
		FullScreenItemFrame = createElement2("Frame", onImageResizesByAbsoluteSize, v12),
		RightArrow = 0,
		EventConnection = 0
	}

	local v16 = if showArrows then renderArrowButton(
		p2,
		"icons/actions/cycleRight",
		v7,
		Vector2.new(0, 0.5),
		self.rightArrowPosition,
		self.arrowButtonSize,
		self.showNextItem
	) else nil
	v9.RightArrow = v16

	v9.EventConnection = showArrows
		and Roact.createElement(eventConnection, {
			event = UserInputService.InputBegan,
			callback = self.onUserInputBegan
		})
		or nil
	return createElement("Frame", onResizesByAbsoluteSize, v9)
end

return extended
