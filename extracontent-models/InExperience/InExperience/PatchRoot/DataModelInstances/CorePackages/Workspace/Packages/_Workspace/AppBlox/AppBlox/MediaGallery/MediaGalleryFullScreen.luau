local UserInputService = game:GetService("UserInputService")
local parent = script:FindFirstAncestor("AppBlox").Parent
local ReactUtils = require(parent.ReactUtils)
local EventConnection = ReactUtils.EventConnection
local Roact = require(parent.Roact)
local t = require(parent.t)

local UIBlox = require(parent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Core.Style.withStyle

local ThumbnailButton = require(script.Parent.ThumbnailButton)
local getShowItems = require(script.Parent.getShowItems)

local extended = Roact.Component:extend("MediaGalleryFullScreen")

extended.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	size = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	items = t.array(t.interface({ imageId = t.string, isYouTubeVideo = t.optional(t.boolean) })),
	showIndex = t.optional(t.integer),
	onVideoPlayActivated = t.optional(t.callback)
})

extended.defaultProps = { size = UDim2.fromScale(1, 1), showIndex = 1 }

function extended.getDerivedStateFromProps(p, data)
	local derivedState

	if data.items ~= p.items then
		local showItems = getShowItems(p)

		derivedState = {
			items = p.items,
			itemsToShow = showItems,
			showArrows = #showItems > 1,
			focusIndex = math.min(data.focusIndex or 1, #showItems)
		}
	end

	if data.showIndex ~= p.showIndex then
		derivedState = derivedState or {}
		derivedState.showIndex = p.showIndex
		derivedState.focusIndex = math.min(p.showIndex, #p.items)
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

	local binding, updateItemFrameSize = Roact.createBinding(UDim2.fromScale(1, 1))
	self.itemFrameSize = binding
	self.updateItemFrameSize = updateItemFrameSize
	local binding2, updateArrowButtonSize = Roact.createBinding(UDim2.new(0, 96, 1, 0))
	self.arrowButtonSize = binding2
	self.updateArrowButtonSize = updateArrowButtonSize
	local binding3, updateLeftArrowPosition = Roact.createBinding(UDim2.new(0.5, 0, 0.5, 0))
	self.leftArrowPosition = binding3
	self.updateLeftArrowPosition = updateLeftArrowPosition
	local binding4, updateRightArrowPosition = Roact.createBinding(UDim2.new(0.5, 0, 0.5, 0))
	self.rightArrowPosition = binding4
	self.updateRightArrowPosition = updateRightArrowPosition

	function self.onResize(p)
		local x = p.AbsoluteSize.X
		local v = p.AbsoluteSize.Y

		local v2 = math.floor(v * (16 / 9))

		if x < v2 then
			v = math.floor(x / (16 / 9))
			v2 = x
		end

		self.updateItemFrameSize(UDim2.new(0, v2, 0, v))
	end

	function self.onImageResize(p)
		local x = p.AbsoluteSize.X
		local y = p.AbsoluteSize.Y

		self.updateLeftArrowPosition(UDim2.new(0.5, -x / 2, 0.5, 0))
		self.updateRightArrowPosition(UDim2.new(0.5, x / 2, 0.5, 0))
		self.updateArrowButtonSize(UDim2.new(0, 96, 0, y))
	end

	function self.onUserInputBegan(p)
		if p.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local focusIndex = self.state.focusIndex
		local v = #self.props.items

		if p.KeyCode == Enum.KeyCode.Left and focusIndex > 1 then
			self.showPreviousItem()
		elseif p.KeyCode == Enum.KeyCode.Right and focusIndex < v then
			self.showNextItem()
		end
	end

	function self.showPreviousItem()
		local v = self.state.focusIndex - 1
		self:setState({
			focusIndex = v < 1 and 1 or v
		})
	end

	function self.showNextItem()
		local count = #self.props.items
		local focusIndex = self.state.focusIndex + 1

		if count < focusIndex then
			focusIndex = count
		end

		self:setState({ focusIndex = focusIndex })
	end

	function self.cycleNext()
		local v = #self.props.items
		local v2 = self.state.focusIndex + 1
		self:setState({
			focusIndex = v < v2 and 1 or v2
		})
	end

	function self.onVideoPlayActivated(p)
		if self.props.onVideoPlayActivated then
			local originalIndex = self.state.itemsToShow[p].originalIndex

			self.props.onVideoPlayActivated(originalIndex)
		end
	end
end
local function renderArrowButton(_, p, isDisabled, anchorPoint, position, arrowButtonSize, onActivated)
	return Roact.createElement("Frame", {
		Size = arrowButtonSize,
		AnchorPoint = anchorPoint,
		Position = position,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ZIndex = 100
	}, {
		ArrowButton = Roact.createElement(IconButton, {
			size = UDim2.fromScale(1, 1),
			icon = Images[p],
			showBackground = true,
			backgroundTransparency = 1,
			isDisabled = isDisabled,
			onActivated = onActivated
		})
	})
end

function extended:render()
	return withStyle(function(p)
		return self:renderWithProvider(p)
	end)
end

function extended:renderWithProvider(p)
	local layoutOrder = self.props.layoutOrder
	local anchorPoint = self.props.anchorPoint
	local position = self.props.position
	local size = self.props.size

	local itemsToShow = self.state.itemsToShow
	local showArrows = self.state.showArrows
	local focusIndex = self.state.focusIndex

	local v = itemsToShow[focusIndex]
	local isDisabled = focusIndex <= 1
	local isDisabled2 = #itemsToShow <= focusIndex

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
	local leftArrow

	if showArrows then
		leftArrow = renderArrowButton(
			p,
			"icons/actions/cycleLeft",
			isDisabled,
			Vector2.new(1, 0.5),
			self.leftArrowPosition,
			self.arrowButtonSize,
			self.showPreviousItem
		)
	end

	local createElement2 = Roact.createElement
	local onImageResizesByAbsoluteSize = {
		Size = UDim2.new(1, -192, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = self.onImageResize
	}
	local v2 = {
		UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 16 / 9
		}),
		Item = 0
	}

	local createElement3 = Roact.createElement
	local v3 = {
		itemKey = focusIndex,
		imageId = v.imageId,
		isVideo = v.isYouTubeVideo,
		userInteractionEnabled = true,
		onActivated = self.cycleNext,
		onPlayActivated = 0
	}
	local onPlayActivated

	if v.isYouTubeVideo then
		onPlayActivated = self.onVideoPlayActivated or nil
	end

	v3.onPlayActivated = onPlayActivated
	v2.Item = createElement3(ThumbnailButton, v3)
	local v4 = {
		LeftArrow = leftArrow,
		FullScreenItemFrame = createElement2("Frame", onImageResizesByAbsoluteSize, v2),
		RightArrow = 0,
		EventConnection = 0
	}
	local rightArrow

	if showArrows then
		rightArrow = renderArrowButton(
			p,
			"icons/actions/cycleRight",
			isDisabled2,
			Vector2.new(0, 0.5),
			self.rightArrowPosition,
			self.arrowButtonSize,
			self.showNextItem
		)
	end

	v4.RightArrow = rightArrow

	v4.EventConnection = showArrows
		and Roact.createElement(EventConnection, {
			event = UserInputService.InputBegan,
			callback = self.onUserInputBegan
		})
		or nil
	return createElement("Frame", onResizesByAbsoluteSize, v4)
end

return extended
