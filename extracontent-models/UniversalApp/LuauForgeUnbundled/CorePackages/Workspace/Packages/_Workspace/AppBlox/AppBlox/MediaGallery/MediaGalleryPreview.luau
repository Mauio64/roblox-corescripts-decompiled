local RunService = game:GetService("RunService")

local eventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/ReactUtils").EventConnection
local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Otter")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local images = UIBlox.App.ImageSet.Images
local getIconSize = UIBlox.App.ImageSet.getIconSize
local withStyle = UIBlox.Core.Style.withStyle

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")

local ThumbnailButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/ThumbnailButton")
local calcMediaGallerySizesFromHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/calcMediaGallerySizesFromHeight")
local calcMediaGallerySizesFromWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/calcMediaGallerySizesFromWidth")
local getShowItems = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/getShowItems")

local iconSize2 = getIconSize(iconSize.Medium)

local v5 = { frequency = 4, dampingRatio = 1 }

local extended = Roact.Component:extend("MediaGalleryPreview")

extended.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	size = t.optional(t.UDim2),
	fullWidth = t.optional(t.boolean),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	items = t.array(t.strictInterface({
		imageId = t.string,
		isYouTubeVideo = t.optional(t.boolean)
	})),
	numberOfThumbnails = t.optional(t.integer),
	onPreviewActivated = t.optional(t.callback),
	onThumbnailActivated = t.optional(t.callback),
	onVideoPlayActivated = t.optional(t.callback)
})

extended.defaultProps = {
	size = UDim2.fromScale(1, 1),
	numberOfThumbnails = 5,
	fullWidth = false
}

function extended.getDerivedStateFromProps(p2, p3)
	if p3.items == p2.items and p3.numberOfThumbnails == p2.numberOfThumbnails then
		return
	end

	local v6, v7, v8 = getShowItems(p2)
	return {
		items = p2.items,
		numberOfThumbnails = p2.numberOfThumbnails,
		itemsToShow = v6,
		youTubeVideoItemsSize = v7,
		imageItemsSize = v8,
		animationOn = v8 > 1,
		animatedIndex = v7 + 1,
		selectedIndex = v7 + 1
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

	local binding, v6 = Roact.createBinding(UDim2.fromScale(1, 1))
	self.contentSize = binding
	self.updateContentSize = v6
	local binding2, v7 = Roact.createBinding(UDim2.fromScale(1, 0.5))
	self.previewSize = binding2
	self.updatePreviewSize = v7
	local binding3, v8 = Roact.createBinding(UDim2.fromScale(1, 0.5))
	self.paginationSize = binding3
	self.updatePaginationSize = v8
	local binding4, v9 = Roact.createBinding(UDim2.fromScale(0, 0))
	self.thumbnailSize = binding4
	self.updateThumbnailSize = v9

	local binding5, v10 = Roact.createBinding(Vector2.new(0, 0))
	self.canvasPosition = binding5
	self.updateCanvasPosition = v10
	local binding6, v11 = Roact.createBinding(0)
	self.progress = binding6
	self.updateProgress = v11
	local binding7, v12 = Roact.createBinding(0)
	self.previewTransparency = binding7
	self.updatePreviewTransparency = v12

	function self.onResize(p2)
		self:updateSizes(p2)
		self.updateCanvasPosition(Vector2.new(self:getCanvasPositionX(), 0))
	end

	function self.onMouseLeave(p2, p3)
		if p3.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		self.resetAnimation()
		self:setState(function(p4)
			local selectedIndex = p4.selectedIndex
			local nextFocusIndex = self.getNextFocusIndex(selectedIndex)

			return {
				animationOn = p4.imageItemsSize > 1,
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

	function self.onMouseEnterPagination(p2, p3)
		if p3.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		self:setState(function(p4)
			if p4.showArrows then
				return
			end

			return { showArrows = true }
		end)
	end

	function self.onMouseLeavePagination(p2, p3)
		if p3.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		self:setState(function(p4)
			if p4.showArrows then
				return { showArrows = false }
			end
		end)
	end

	function self.onCycleLeftActivated()
		if self.scrolling then
			return
		end

		local v13 = math.max(self.state.focusIndex - 1, 1)

		self.resetAnimation()
		self:setState({ animationOn = false, focusIndex = v13 })
	end

	function self.onCycleRightActivated()
		if self.scrolling then
			return
		end

		local v13 = #self.props.items
		local v14 = math.min(self.state.focusIndex + 1, v13)

		self.resetAnimation()
		self:setState({ animationOn = false, focusIndex = v14 })
	end

	function self.onItemActivated(p2)
		local isYouTubeVideo = self.state.itemsToShow[p2].isYouTubeVideo
		local selectedIndex = self.state.selectedIndex

		self.resetAnimation()
		local v15 = if not (isYouTubeVideo or not p2) then p2 else nil
		self:setState({ animationOn = false, selectedIndex = v15 })

		if isYouTubeVideo then
			self.onVideoPlayActivated(p2)
		end

		if self.props.onThumbnailActivated then
			self.props.onThumbnailActivated(selectedIndex, p2)
		end
	end

	function self.onItemPlayActivated(p2)
		self.resetAnimation()
		self:setState({ animationOn = false })

		self.onVideoPlayActivated(p2)
	end

	function self.onVideoPlayActivated(p2)
		if self.props.onVideoPlayActivated then
			local originalIndex = self.state.itemsToShow[p2].originalIndex

			self.props.onVideoPlayActivated(originalIndex)
		end
	end

	function self.getNextFocusIndex(p2)
		local focusIndex = self.state.focusIndex
		local numberOfThumbnails = self.props.numberOfThumbnails

		if p2 < focusIndex then
			return p2
		end

		if focusIndex + numberOfThumbnails <= p2 then
			return p2 - numberOfThumbnails + 1
		end

		return focusIndex
	end

	function self.resetAnimation()
		self.animationTime = 0
		self.updateProgress(0)
		self.updatePreviewTransparency(0)
	end

	function self.renderSteppedCallback(p2)
		self.animationTime += p2
		local v13 = self.animationTime - 4.5

		if self.animationTime > 5 then
			self.animationTime = 0
			self.updateProgress(0)

			local animatedIndex = self.state.animatedIndex
			local youTubeVideoItemsSize = self.state.youTubeVideoItemsSize
			local imageItemsSize = self.state.imageItemsSize
			local v14 = (animatedIndex - youTubeVideoItemsSize) % imageItemsSize + 1 + youTubeVideoItemsSize

			self:setState({
				animatedIndex = v14,
				selectedIndex = v14,
				focusIndex = self.getNextFocusIndex(v14)
			})
		else
			self.updateProgress(self.animationTime / 5)

			if v13 > 0 then
				self.updatePreviewTransparency(v13 / 0.5)
			end
		end
	end

	function self.scrollMotorOnStep(p2)
		self.updateCanvasPosition(Vector2.new(p2, 0))
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
	local v6 = count > 1 and not animationOn
	local v7

	if animationOn then
		v7 = (selectedIndex - youTubeVideoItemsSize) % imageItemsSize + 1 + youTubeVideoItemsSize or nil
	else
		v7 = nil
	end

	local v8 = numberOfThumbnails < count
	local v9 = focusIndex <= 1
	local v10 = focusIndex + numberOfThumbnails > #itemsToShow

	return withStyle(function(p2)
		local createElement = Roact.createElement
		local v12 = {
			LayoutOrder = layoutOrder,
			Size = size,
			AnchorPoint = anchorPoint,
			Position = position,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[Roact.Change.AbsoluteSize] = self.onResize,
			[Roact.Event.InputEnded] = v6 and self.onMouseLeave or nil
		}

		local createElement2 = Roact.createElement
		local v15 = {
			Size = self.contentSize,
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		}

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
		local v17 = {
			LayoutOrder = 1,
			Size = self.previewSize,
			BackgroundTransparency = 1
		}

		local v19 = if animationOn then Roact.createElement("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			Image = v7 and itemsToShow[v7].imageId,
			BackgroundTransparency = 1,
			ZIndex = -1
		}, {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
		}) or nil else nil
		children.Preview = createElement3("Frame", v17, {
			AnimationLabel = v19,
			Button = Roact.createElement("ImageButton", {
				Size = UDim2.fromScale(1, 1),
				Image = itemsToShow[selectedIndex].imageId,
				ImageTransparency = self.previewTransparency,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				ZIndex = 1,
				[Roact.Event.Activated] = self.onPreviewActivated
			}, {
				Corner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				})
			})
		})

		children.Pagination = Roact.createElement("Frame", {
			LayoutOrder = 2,
			Size = self.paginationSize,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[Roact.Event.InputBegan] = v8 and self.onMouseEnterPagination or nil,
			[Roact.Event.InputEnded] = v8 and self.onMouseLeavePagination or nil
		}, {
			LeftArrow = showArrows and Roact.createElement(iconButton, {
				size = UDim2.new(0, iconSize2, 1, 0),
				anchorPoint = Vector2.new(0, 0.5),
				position = UDim2.fromScale(0, 0.5),
				icon = images["icons/actions/cycleLeft"],
				isDisabled = v9,
				onActivated = self.onCycleLeftActivated
			}) or nil,
			Scroller = self:renderScroller(p2),
			RightArrow = showArrows and Roact.createElement(iconButton, {
				size = UDim2.new(0, iconSize2, 1, 0),
				anchorPoint = Vector2.new(1, 0.5),
				position = UDim2.fromScale(1, 0.5),
				icon = images["icons/actions/cycleRight"],
				isDisabled = v10,
				onActivated = self.onCycleRightActivated
			}) or nil
		})
		return createElement("Frame", v12, {
			Content = createElement2("Frame", v15, children),
			EventConnection = animationOn and Roact.createElement(eventConnection, {
				event = RunService.RenderStepped,
				callback = self.renderSteppedCallback
			}) or nil
		})
	end)
end

function extended:renderScroller(p2)
	return Roact.createElement("ScrollingFrame", {
		Size = UDim2.new(1, -iconSize2 * 2, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ClipsDescendants = true,
		ScrollingDirection = Enum.ScrollingDirection.X,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		CanvasPosition = self.canvasPosition,
		Selectable = false
	}, self:renderThumbnails(p2))
end

function extended:renderThumbnails(p2)
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

	for i, v6 in ipairs(self.state.itemsToShow) do
		local v7 = i == selectedIndex
		local v8 = animationOn and i == animatedIndex
		local v9 = v6.imageId and v6.imageId ~= ""

		local v10 = "item" .. i
		local createElement = Roact.createElement
		local v12 = {
			LayoutOrder = i,
			Size = self.thumbnailSize,
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		}

		local createElement2 = Roact.createElement
		local v14 = {
			itemKey = i,
			imageId = v6.imageId,
			isVideo = v6.isYouTubeVideo,
			isSelected = v7,
			onActivated = 0,
			onPlayActivated = 0,
			useScaledPlayButton = true
		}

		local v15 = if v9 then self.onItemActivated or nil else nil
		v14.onActivated = v15
		local v16 = if v6.isYouTubeVideo then self.onItemPlayActivated or nil else nil
		v14.onPlayActivated = v16
		local children2 = { Thumbnail = createElement2(ThumbnailButton, v14), TimerBar = 0 }

		local v17 = if v8 then self:renderTimerBar(p2) or nil else nil
		children2.TimerBar = v17
		children[v10] = createElement("Frame", v12, children2)
	end

	return children
end

function extended:renderTimerBar(p3)
	local uiDefault = p3.Theme.UIDefault
	local secondaryContent = p3.Theme.SecondaryContent

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
				Size = self.progress:map(function(p4)
					return UDim2.fromScale(p4, 1)
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
						Corner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8)
						})
					}
				)
			})
		})
	})
end

function extended:didUpdate(p2, p3)
	if self.state.focusIndex ~= p3.focusIndex then
		self:scrollToNewIndex()
	end

	if self.state.selectedIndex ~= p3.selectedIndex then
		self.updatePreviewTransparency(0)
	end
end

function extended:updateSizes(p2)
	local x = p2.AbsoluteSize.X
	local y = p2.AbsoluteSize.Y
	local numberOfThumbnails = self.props.numberOfThumbnails

	local v6 = calcMediaGallerySizesFromWidth(x, numberOfThumbnails, self.props.fullWidth)

	if y < v6.contentSize.Y.Offset then
		v6 = calcMediaGallerySizesFromHeight(y, numberOfThumbnails, self.props.fullWidth)
	end

	self.updateContentSize(v6.contentSize)
	self.updatePreviewSize(v6.previewSize)
	self.updatePaginationSize(v6.paginationSize)
	self.updateThumbnailSize(v6.thumbnailSize)
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
	self.scrollMotor:setGoal(Otter.spring(canvasPositionX, v5))
	self.scrolling = true
end

return extended
