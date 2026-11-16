local RunService = game:GetService("RunService")
local parent = script:FindFirstAncestor("AppBlox").Parent
local ReactUtils = require(parent.ReactUtils)
local EventConnection = ReactUtils.EventConnection
local Otter = require(parent.Otter)
local Roact = require(parent.Roact)

local UIBlox = require(parent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local getIconSize = UIBlox.App.ImageSet.getIconSize
local withStyle = UIBlox.Core.Style.withStyle

local t = require(parent.t)

local ThumbnailButton = require(script.Parent.ThumbnailButton)
local calcMediaGallerySizesFromHeight = require(script.Parent.calcMediaGallerySizesFromHeight)
local calcMediaGallerySizesFromWidth = require(script.Parent.calcMediaGallerySizesFromWidth)
local getShowItems = require(script.Parent.getShowItems)

local iconSize = getIconSize(IconSize.Medium)

local v = { frequency = 4, dampingRatio = 1 }

local extended = Roact.Component:extend("MediaGalleryPreview")

extended.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	size = t.optional(t.UDim2),
	fullWidth = t.optional(t.boolean),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	items = t.array(t.strictInterface({ imageId = t.string, isYouTubeVideo = t.optional(t.boolean) })),
	numberOfThumbnails = t.optional(t.integer),
	onPreviewActivated = t.optional(t.callback),
	onThumbnailActivated = t.optional(t.callback),
	onVideoPlayActivated = t.optional(t.callback)
})

extended.defaultProps = { size = UDim2.fromScale(1, 1), numberOfThumbnails = 5, fullWidth = false }

function extended.getDerivedStateFromProps(p, p2)
	if p2.items == p.items and p2.numberOfThumbnails == p.numberOfThumbnails then
		return
	end

	local showItems, youTubeVideoItemsSize, imageItemsSize = getShowItems(p)
	return {
		items = p.items,
		numberOfThumbnails = p.numberOfThumbnails,
		itemsToShow = showItems,
		youTubeVideoItemsSize = youTubeVideoItemsSize,
		imageItemsSize = imageItemsSize,
		animationOn = imageItemsSize > 1,
		animatedIndex = youTubeVideoItemsSize + 1,
		selectedIndex = youTubeVideoItemsSize + 1
	}
end

function extended:init()
	self.state = {
		items = nil,
		numberOfThumbnails = 1,
		itemsToShow = nil,
		youTubeVideoItemsSize = 0,
		imageItemsSize = 0,
		animationOn = false,
		animatedIndex = 1,
		selectedIndex = 1,
		showArrows = false,
		focusIndex = 1
	}

	self.animationTime = 0
	self.scrolling = false
	self.scrollMotor = Otter.createSingleMotor(0)

	local binding, updateContentSize = Roact.createBinding(UDim2.fromScale(1, 1))
	self.contentSize = binding
	self.updateContentSize = updateContentSize
	local binding2, updatePreviewSize = Roact.createBinding(UDim2.fromScale(1, 0.5))
	self.previewSize = binding2
	self.updatePreviewSize = updatePreviewSize
	local binding3, updatePaginationSize = Roact.createBinding(UDim2.fromScale(1, 0.5))
	self.paginationSize = binding3
	self.updatePaginationSize = updatePaginationSize
	local binding4, updateThumbnailSize = Roact.createBinding(UDim2.fromScale(0, 0))
	self.thumbnailSize = binding4
	self.updateThumbnailSize = updateThumbnailSize

	local binding5, updateCanvasPosition = Roact.createBinding(Vector2.new(0, 0))
	self.canvasPosition = binding5
	self.updateCanvasPosition = updateCanvasPosition
	local binding6, updateProgress = Roact.createBinding(0)
	self.progress = binding6
	self.updateProgress = updateProgress
	local binding7, updatePreviewTransparency = Roact.createBinding(0)
	self.previewTransparency = binding7
	self.updatePreviewTransparency = updatePreviewTransparency

	function self.onResize(p)
		self:updateSizes(p)
		self.updateCanvasPosition(Vector2.new(self:getCanvasPositionX(), 0))
	end

	function self.onMouseLeave(_, p)
		if p.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		self.resetAnimation()
		self:setState(function(p2)
			local selectedIndex = p2.selectedIndex
			local nextFocusIndex = self.getNextFocusIndex(selectedIndex)

			return {
				animationOn = p2.imageItemsSize > 1,
				animatedIndex = selectedIndex,
				focusIndex = nextFocusIndex
			}
		end)
	end

	function self.onPreviewActivated()
		self.resetAnimation()
		self:setState({ animationOn = false })

		if self.props.onPreviewActivated then
			local originalIndex = self.state.itemsToShow[self.state.selectedIndex].originalIndex

			self.props.onPreviewActivated(originalIndex)
		end
	end

	function self.onMouseEnterPagination(_, p)
		if p.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		self:setState(function(p2)
			if p2.showArrows then
				return
			end

			return { showArrows = true }
		end)
	end

	function self.onMouseLeavePagination(_, p)
		if p.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		self:setState(function(p2)
			if p2.showArrows then
				return { showArrows = false }
			end
		end)
	end

	function self.onCycleLeftActivated()
		if self.scrolling then
			return
		end

		local focusIndex = math.max(self.state.focusIndex - 1, 1)

		self.resetAnimation()
		self:setState({ animationOn = false, focusIndex = focusIndex })
	end

	function self.onCycleRightActivated()
		if self.scrolling then
			return
		end

		local v2 = #self.props.items
		local focusIndex = math.min(self.state.focusIndex + 1, v2)

		self.resetAnimation()
		self:setState({ animationOn = false, focusIndex = focusIndex })
	end

	function self.onItemActivated(p)
		local isYouTubeVideo = self.state.itemsToShow[p].isYouTubeVideo
		local selectedIndex = self.state.selectedIndex

		self.resetAnimation()
		local selectedIndex2

		if not (isYouTubeVideo or not p) then
			selectedIndex2 = p
		end

		self:setState({ animationOn = false, selectedIndex = selectedIndex2 })

		if isYouTubeVideo then
			self.onVideoPlayActivated(p)
		end

		if self.props.onThumbnailActivated then
			self.props.onThumbnailActivated(selectedIndex, p)
		end
	end

	function self.onItemPlayActivated(p)
		self.resetAnimation()
		self:setState({ animationOn = false })

		self.onVideoPlayActivated(p)
	end

	function self.onVideoPlayActivated(p)
		if self.props.onVideoPlayActivated then
			local originalIndex = self.state.itemsToShow[p].originalIndex

			self.props.onVideoPlayActivated(originalIndex)
		end
	end

	function self.getNextFocusIndex(p)
		local focusIndex = self.state.focusIndex
		local numberOfThumbnails = self.props.numberOfThumbnails

		if p < focusIndex then
			return p
		end

		if focusIndex + numberOfThumbnails <= p then
			return p - numberOfThumbnails + 1
		end

		return focusIndex
	end

	function self.resetAnimation()
		self.animationTime = 0
		self.updateProgress(0)
		self.updatePreviewTransparency(0)
	end

	function self.renderSteppedCallback(p)
		self.animationTime += p
		local v2 = self.animationTime - 4.5

		if self.animationTime > 5 then
			self.animationTime = 0
			self.updateProgress(0)

			local animatedIndex = self.state.animatedIndex
			local youTubeVideoItemsSize = self.state.youTubeVideoItemsSize
			local imageItemsSize = self.state.imageItemsSize
			local v3 = (animatedIndex - youTubeVideoItemsSize) % imageItemsSize + 1 + youTubeVideoItemsSize

			self:setState({
				animatedIndex = v3,
				selectedIndex = v3,
				focusIndex = self.getNextFocusIndex(v3)
			})
		else
			self.updateProgress(self.animationTime / 5)

			if v2 > 0 then
				self.updatePreviewTransparency(v2 / 0.5)
			end
		end
	end

	function self.scrollMotorOnStep(p)
		self.updateCanvasPosition(Vector2.new(p, 0))
	end

	function self.scrollMotorOnComplete()
		self.scrolling = false
	end

	self.scrollMotor:onStep(self.scrollMotorOnStep)
	self.scrollMotor:onComplete(self.scrollMotorOnComplete)
end

function extended:render()
	local layoutOrder = self.props.layoutOrder
	local anchorPoint = self.props.anchorPoint
	local position = self.props.position
	local size = self.props.size
	local numberOfThumbnails = self.props.numberOfThumbnails
	local count = #self.props.items

	local itemsToShow = self.state.itemsToShow
	local showArrows = self.state.showArrows
	local focusIndex = self.state.focusIndex
	local selectedIndex = self.state.selectedIndex
	local animationOn = self.state.animationOn
	local youTubeVideoItemsSize = self.state.youTubeVideoItemsSize
	local imageItemsSize = self.state.imageItemsSize
	local v2

	if count > 1 then
		v2 = not animationOn
	else
		v2 = false
	end

	local v3

	if animationOn then
		v3 = (selectedIndex - youTubeVideoItemsSize) % imageItemsSize + 1 + youTubeVideoItemsSize or nil
	else
		v3 = nil
	end

	local v4 = numberOfThumbnails < count
	local isDisabled = focusIndex <= 1
	local isDisabled2 = focusIndex + numberOfThumbnails > #itemsToShow

	return withStyle(function(p)
		local createElement = Roact.createElement
		local v5 = {
			LayoutOrder = layoutOrder,
			Size = size,
			AnchorPoint = anchorPoint,
			Position = position,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[Roact.Change.AbsoluteSize] = self.onResize,
			[Roact.Event.InputEnded] = v2 and self.onMouseLeave or nil
		}

		local createElement2 = Roact.createElement
		local v6 = { Size = self.contentSize, BorderSizePixel = 0, BackgroundTransparency = 1 }

		local children = {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 24)
			}),
			Preview = 0,
			Pagination = 0
		}

		local createElement3 = Roact.createElement
		local v7 = { LayoutOrder = 1, Size = self.previewSize, BackgroundTransparency = 1 }
		local animationLabel

		if animationOn then
			animationLabel = Roact.createElement("ImageLabel", {
				Size = UDim2.fromScale(1, 1),
				Image = v3 and itemsToShow[v3].imageId,
				BackgroundTransparency = 1,
				ZIndex = -1
			}, {
				Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
			}) or nil
		end

		children.Preview = createElement3("Frame", v7, {
			AnimationLabel = animationLabel,
			Button = Roact.createElement("ImageButton", {
				Size = UDim2.fromScale(1, 1),
				Image = itemsToShow[selectedIndex].imageId,
				ImageTransparency = self.previewTransparency,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				ZIndex = 1,
				[Roact.Event.Activated] = self.onPreviewActivated
			}, {
				Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
			})
		})

		children.Pagination = Roact.createElement("Frame", {
			LayoutOrder = 2,
			Size = self.paginationSize,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[Roact.Event.InputBegan] = v4 and self.onMouseEnterPagination or nil,
			[Roact.Event.InputEnded] = v4 and self.onMouseLeavePagination or nil
		}, {
			LeftArrow = showArrows and Roact.createElement(IconButton, {
				size = UDim2.new(0, iconSize, 1, 0),
				anchorPoint = Vector2.new(0, 0.5),
				position = UDim2.fromScale(0, 0.5),
				icon = Images["icons/actions/cycleLeft"],
				isDisabled = isDisabled,
				onActivated = self.onCycleLeftActivated
			}) or nil,
			Scroller = self:renderScroller(p),
			RightArrow = showArrows and Roact.createElement(IconButton, {
				size = UDim2.new(0, iconSize, 1, 0),
				anchorPoint = Vector2.new(1, 0.5),
				position = UDim2.fromScale(1, 0.5),
				icon = Images["icons/actions/cycleRight"],
				isDisabled = isDisabled2,
				onActivated = self.onCycleRightActivated
			}) or nil
		})
		return createElement("Frame", v5, {
			Content = createElement2("Frame", v6, children),
			EventConnection = animationOn and Roact.createElement(EventConnection, {
				event = RunService.RenderStepped,
				callback = self.renderSteppedCallback
			}) or nil
		})
	end)
end

function extended:renderScroller(p)
	return Roact.createElement("ScrollingFrame", {
		Size = UDim2.new(1, -iconSize * 2, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ClipsDescendants = true,
		ScrollingDirection = Enum.ScrollingDirection.X,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		CanvasPosition = self.canvasPosition,
		Selectable = false
	}, self:renderThumbnails(p))
end

function extended:renderThumbnails(p)
	local selectedIndex = self.state.selectedIndex
	local animationOn = self.state.animationOn
	local animatedIndex = self.state.animatedIndex

	local children = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		})
	}

	for i, v2 in ipairs(self.state.itemsToShow) do
		local isSelected = i == selectedIndex
		local v3 = animationOn and i == animatedIndex
		local v4 = v2.imageId and v2.imageId ~= ""

		local v5 = "item" .. i
		local createElement = Roact.createElement
		local v6 = {
			LayoutOrder = i,
			Size = self.thumbnailSize,
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		}

		local createElement2 = Roact.createElement
		local v7 = {
			itemKey = i,
			imageId = v2.imageId,
			isVideo = v2.isYouTubeVideo,
			isSelected = isSelected,
			onActivated = 0,
			onPlayActivated = 0,
			useScaledPlayButton = true
		}
		local onActivated

		if v4 then
			onActivated = self.onItemActivated or nil
		end

		v7.onActivated = onActivated
		local onPlayActivated

		if v2.isYouTubeVideo then
			onPlayActivated = self.onItemPlayActivated or nil
		end

		v7.onPlayActivated = onPlayActivated
		local children2 = {
			Thumbnail = createElement2(ThumbnailButton, v7),
			TimerBar = 0
		}
		local timerBar

		if v3 then
			timerBar = self:renderTimerBar(p) or nil
		end

		children2.TimerBar = timerBar
		children[v5] = createElement("Frame", v6, children2)
	end

	return children
end

function extended:renderTimerBar(p)
	local uiDefault = p.Theme.UIDefault
	local secondaryContent = p.Theme.SecondaryContent

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 2),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 100
	}, {
		Background = Roact.createElement("Frame", {
			Size = self.thumbnailSize,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = uiDefault.Color,
			BackgroundTransparency = uiDefault.Transparency
		}, {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			Progress = Roact.createElement("Frame", {
				Size = self.progress:map(function(p2)
					return UDim2.fromScale(p2, 1)
				end),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ClipsDescendants = true
			}, {
				Foreground = Roact.createElement(
					"Frame",
					{
						Size = self.thumbnailSize,
						BorderSizePixel = 0,
						BackgroundColor3 = secondaryContent.Color,
						BackgroundTransparency = secondaryContent.Transparency
					},
					{
						Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
					}
				)
			})
		})
	})
end

function extended:didUpdate(_, p)
	if self.state.focusIndex ~= p.focusIndex then
		self:scrollToNewIndex()
	end

	if self.state.selectedIndex ~= p.selectedIndex then
		self.updatePreviewTransparency(0)
	end
end

function extended:updateSizes(p)
	local x = p.AbsoluteSize.X
	local y = p.AbsoluteSize.Y
	local numberOfThumbnails = self.props.numberOfThumbnails

	local v2 = calcMediaGallerySizesFromWidth(x, numberOfThumbnails, self.props.fullWidth)

	if y < v2.contentSize.Y.Offset then
		v2 = calcMediaGallerySizesFromHeight(y, numberOfThumbnails, self.props.fullWidth)
	end

	self.updateContentSize(v2.contentSize)
	self.updatePreviewSize(v2.previewSize)
	self.updatePaginationSize(v2.paginationSize)
	self.updateThumbnailSize(v2.thumbnailSize)
end

function extended:getCanvasPositionX()
	local focusIndex = self.state.focusIndex
	local offset = self.thumbnailSize:getValue().X.Offset
	return (focusIndex - 1) * (offset + 12)
end

function extended:scrollToNewIndex()
	local x = self.canvasPosition:getValue().X
	local canvasPositionX = self:getCanvasPositionX()

	self.scrollMotor:setGoal(Otter.instant(x))
	self.scrollMotor:setGoal(Otter.spring(canvasPositionX, v))
	self.scrolling = true
end

return extended
