local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("AppBlox").Parent
local EventConnection = require(Parent.ReactUtils).EventConnection
local Otter = require(Parent.Otter)
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local getIconSize = UIBlox.App.ImageSet.getIconSize
local withStyle = UIBlox.Core.Style.withStyle
local t = require(Parent.t)
local ThumbnailButton = require(script.Parent.ThumbnailButton)
local calcMediaGallerySizesFromHeight = require(script.Parent.calcMediaGallerySizesFromHeight)
local calcMediaGallerySizesFromWidth = require(script.Parent.calcMediaGallerySizesFromWidth)
local getShowItems = require(script.Parent.getShowItems)
local v17 = getIconSize(IconSize.Medium)
local t1 = {
	frequency = 4,
	dampingRatio = 1
}
local v19 = Roact.Component:extend("MediaGalleryPreview")

v19.validateProps = t.strictInterface({
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
v19.defaultProps = {
	numberOfThumbnails = 5,
	fullWidth = false,
	size = UDim2.fromScale(1, 1)
}

function v19.getDerivedStateFromProps(p1, p2) -- line: 77
	-- upvalues: getShowItems (copy)
	if p2.items == p1.items and p2.numberOfThumbnails == p1.numberOfThumbnails then
		return
	end

	local v22, v23, v24 = getShowItems(p1)

	return {
		items = p1.items,
		numberOfThumbnails = p1.numberOfThumbnails,
		itemsToShow = v22,
		youTubeVideoItemsSize = v23,
		imageItemsSize = v24,
		animationOn = v24 > 1,
		animatedIndex = v23 + 1,
		selectedIndex = v23 + 1
	}
end
function v19.init(p3) -- line: 95
	-- upvalues: Otter (copy), Roact (copy)
	p3.state = {
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
	p3.animationTime = 0
	p3.scrolling = false
	p3.scrollMotor = Otter.createSingleMotor(0)

	local v26, v27 = Roact.createBinding(UDim2.fromScale(1, 1))

	p3.contentSize = v26
	p3.updateContentSize = v27

	local v28, v29 = Roact.createBinding(UDim2.fromScale(1, 0.5))

	p3.previewSize = v28
	p3.updatePreviewSize = v29

	local v30, v31 = Roact.createBinding(UDim2.fromScale(1, 0.5))

	p3.paginationSize = v30
	p3.updatePaginationSize = v31

	local v32, v33 = Roact.createBinding(UDim2.fromScale(0, 0))

	p3.thumbnailSize = v32
	p3.updateThumbnailSize = v33

	local v34, v35 = Roact.createBinding(Vector2.new(0, 0))

	p3.canvasPosition = v34
	p3.updateCanvasPosition = v35

	local v36, v37 = Roact.createBinding(0)

	p3.progress = v36
	p3.updateProgress = v37

	local v38, v39 = Roact.createBinding(0)

	p3.previewTransparency = v38
	p3.updatePreviewTransparency = v39

	function p3.onResize(p4) -- line: 122
		-- upvalues: p3 (copy)
		p3:updateSizes(p4)
		p3.updateCanvasPosition(Vector2.new(p3:getCanvasPositionX(), 0))
	end
	function p3.onMouseLeave(_, p6) -- line: 127
		-- upvalues: p3 (copy)
		if p6.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		p3.resetAnimation()
		p3:setState(function(p7) -- line: 133
			-- upvalues: p3 (copy)
			local selectedIndex = p7.selectedIndex
			local v123 = p3.getNextFocusIndex(selectedIndex)

			return {
				animationOn = p7.imageItemsSize > 1,
				animatedIndex = selectedIndex,
				focusIndex = v123
			}
		end)
	end
	function p3.onPreviewActivated() -- line: 145
		-- upvalues: p3 (copy)
		p3.resetAnimation()
		p3:setState({
			animationOn = false
		})

		if p3.props.onPreviewActivated then
			local originalIndex = p3.state.itemsToShow[p3.state.selectedIndex].originalIndex

			p3.props.onPreviewActivated(originalIndex)
		end
	end
	function p3.onMouseEnterPagination(_, p9) -- line: 160
		-- upvalues: p3 (copy)
		if p9.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		p3:setState(function(p10) -- line: 165
			if p10.showArrows then
				return
			end

			return {
				showArrows = true
			}
		end)
	end
	function p3.onMouseLeavePagination(_, p12) -- line: 176
		-- upvalues: p3 (copy)
		if p12.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		p3:setState(function(p13) -- line: 181
			if not p13.showArrows then
				return
			end

			return {
				showArrows = false
			}
		end)
	end
	function p3.onCycleLeftActivated() -- line: 192
		-- upvalues: p3 (copy)
		if p3.scrolling then
			return
		end

		local v99 = math.max(p3.state.focusIndex - 1, 1)

		p3.resetAnimation()
		p3:setState({
			animationOn = false,
			focusIndex = v99
		})
	end
	function p3.onCycleRightActivated() -- line: 206
		-- upvalues: p3 (copy)
		if p3.scrolling then
			return
		end

		local v100 = #p3.props.items
		local v101 = math.min(p3.state.focusIndex + 1, v100)

		p3.resetAnimation()
		p3:setState({
			animationOn = false,
			focusIndex = v101
		})
	end
	function p3.onItemActivated(p14) -- line: 221
		-- upvalues: p3 (copy)
		local isYouTubeVideo = p3.state.itemsToShow[p14].isYouTubeVideo
		local selectedIndex = p3.state.selectedIndex

		p3.resetAnimation()
		p3:setState({
			animationOn = false,
			selectedIndex = not isYouTubeVideo and p14 or nil
		})

		if isYouTubeVideo then
			p3.onVideoPlayActivated(p14)
		end

		if p3.props.onThumbnailActivated then
			p3.props.onThumbnailActivated(selectedIndex, p14)
		end
	end
	function p3.onItemPlayActivated(p15) -- line: 241
		-- upvalues: p3 (copy)
		p3.resetAnimation()
		p3:setState({
			animationOn = false
		})
		p3.onVideoPlayActivated(p15)
	end
	function p3.onVideoPlayActivated(p16) -- line: 250
		-- upvalues: p3 (copy)
		if p3.props.onVideoPlayActivated then
			local originalIndex = p3.state.itemsToShow[p16].originalIndex

			p3.props.onVideoPlayActivated(originalIndex)
		end
	end
	function p3.getNextFocusIndex(p17) -- line: 259
		-- upvalues: p3 (copy)
		local focusIndex = p3.state.focusIndex
		local numberOfThumbnails = p3.props.numberOfThumbnails

		if p17 < focusIndex then
			return p17
		end

		if p17 >= focusIndex + numberOfThumbnails then
			return p17 - numberOfThumbnails + 1
		end

		return focusIndex
	end
	function p3.resetAnimation() -- line: 274
		-- upvalues: p3 (copy)
		p3.animationTime = 0
		p3.updateProgress(0)
		p3.updatePreviewTransparency(0)
	end
	function p3.renderSteppedCallback(p18) -- line: 280
		-- upvalues: p3 (copy)
		p3.animationTime = p3.animationTime + p18

		local v112 = p3.animationTime - 4.5

		if p3.animationTime > 5 then
			p3.animationTime = 0
			p3.updateProgress(0)

			local animatedIndex = p3.state.animatedIndex
			local youTubeVideoItemsSize = p3.state.youTubeVideoItemsSize
			local imageItemsSize = p3.state.imageItemsSize
			local v116 = (animatedIndex - youTubeVideoItemsSize) % imageItemsSize + 1 + youTubeVideoItemsSize
			local v117 = p3.getNextFocusIndex(v116)

			p3:setState({
				animatedIndex = v116,
				selectedIndex = v116,
				focusIndex = v117
			})

			return
		end

		p3.updateProgress(p3.animationTime / 5)

		if v112 > 0 then
			p3.updatePreviewTransparency(v112 / 0.5)
		end
	end
	function p3.scrollMotorOnStep(p19) -- line: 310
		-- upvalues: p3 (copy)
		p3.updateCanvasPosition(Vector2.new(p19, 0))
	end
	function p3.scrollMotorOnComplete() -- line: 314
		-- upvalues: p3 (copy)
		p3.scrolling = false
	end

	p3.scrollMotor:onStep(p3.scrollMotorOnStep)
	p3.scrollMotor:onComplete(p3.scrollMotorOnComplete)
end
function v19.render(p20) -- line: 322
	-- upvalues: withStyle (copy), Roact (copy), IconButton (copy), v17 (copy), Images (copy), EventConnection (copy), RunService (copy)
	local layoutOrder = p20.props.layoutOrder
	local anchorPoint = p20.props.anchorPoint
	local position = p20.props.position
	local size = p20.props.size
	local numberOfThumbnails = p20.props.numberOfThumbnails
	local v46 = #p20.props.items
	local itemsToShow = p20.state.itemsToShow
	local showArrows = p20.state.showArrows
	local focusIndex = p20.state.focusIndex
	local selectedIndex = p20.state.selectedIndex
	local animationOn = p20.state.animationOn
	local youTubeVideoItemsSize = p20.state.youTubeVideoItemsSize
	local imageItemsSize = p20.state.imageItemsSize
	local v54 = v46 > 1 and not animationOn
	local v55 = animationOn and (selectedIndex - youTubeVideoItemsSize) % imageItemsSize + 1 + youTubeVideoItemsSize or nil
	local v56 = numberOfThumbnails < v46
	local v57 = focusIndex <= 1
	local v58 = focusIndex + numberOfThumbnails > #itemsToShow

	return withStyle(function(p21) -- line: 346
		-- upvalues: Roact (copy), layoutOrder (copy), size (copy), anchorPoint (copy), position (copy), p20 (copy), v54 (copy), animationOn (copy), v55 (copy), itemsToShow (copy), selectedIndex (copy), v56 (copy), showArrows (copy), IconButton (copy), v17 (copy), Images (copy), v57 (copy), v58 (copy), EventConnection (copy), RunService (copy)
		return Roact.createElement("Frame", {
			LayoutOrder = layoutOrder,
			Size = size,
			AnchorPoint = anchorPoint,
			Position = position,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[Roact.Change.AbsoluteSize] = p20.onResize,
			[Roact.Event.InputEnded] = v54 and p20.onMouseLeave or nil
		}, {
			Content = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = p20.contentSize
			}, {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 24)
				}),
				Preview = Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = p20.previewSize
				}, {
					AnimationLabel = animationOn and Roact.createElement("ImageLabel", {
						BackgroundTransparency = 1,
						ZIndex = -1,
						Size = UDim2.fromScale(1, 1),
						Image = v55 and itemsToShow[v55].imageId
					}, {
						Corner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8)
						})
					}) or nil,
					Button = Roact.createElement("ImageButton", {
						Size = UDim2.fromScale(1, 1),
						Image = itemsToShow[selectedIndex].imageId,
						ImageTransparency = p20.previewTransparency,
						BackgroundTransparency = 1,
						AutoButtonColor = false,
						ZIndex = 1,
						[Roact.Event.Activated] = p20.onPreviewActivated
					}, {
						Corner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8)
						})
					})
				}),
				Pagination = Roact.createElement("Frame", {
					LayoutOrder = 2,
					Size = p20.paginationSize,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					[Roact.Event.InputBegan] = v56 and p20.onMouseEnterPagination or nil,
					[Roact.Event.InputEnded] = v56 and p20.onMouseLeavePagination or nil
				}, {
					LeftArrow = showArrows and Roact.createElement(IconButton, {
						size = UDim2.new(0, v17, 1, 0),
						anchorPoint = Vector2.new(0, 0.5),
						position = UDim2.fromScale(0, 0.5),
						icon = Images["icons/actions/cycleLeft"],
						isDisabled = v57,
						onActivated = p20.onCycleLeftActivated
					}) or nil,
					Scroller = p20:renderScroller(p21),
					RightArrow = showArrows and Roact.createElement(IconButton, {
						size = UDim2.new(0, v17, 1, 0),
						anchorPoint = Vector2.new(1, 0.5),
						position = UDim2.fromScale(1, 0.5),
						icon = Images["icons/actions/cycleRight"],
						isDisabled = v58,
						onActivated = p20.onCycleRightActivated
					}) or nil
				})
			}),
			EventConnection = animationOn and Roact.createElement(EventConnection, {
				event = RunService.RenderStepped,
				callback = p20.renderSteppedCallback
			}) or nil
		})
	end)
end
function v19.renderScroller(p22, p23) -- line: 432
	-- upvalues: Roact (copy), v17 (copy)
	return Roact.createElement("ScrollingFrame", {
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ClipsDescendants = true,
		Selectable = false,
		Size = UDim2.new(1, -v17 * 2, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		ScrollingDirection = Enum.ScrollingDirection.X,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		CanvasPosition = p22.canvasPosition
	}, p22:renderThumbnails(p23))
end
function v19.renderThumbnails(p24, p25) -- line: 447
	-- upvalues: Roact (copy), ThumbnailButton (copy)
	local selectedIndex = p24.state.selectedIndex
	local animationOn = p24.state.animationOn
	local animatedIndex = p24.state.animatedIndex
	local t2 = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		})
	}

	for i, v in ipairs(p24.state.itemsToShow) do
		local v69 = i == selectedIndex
		local v70 = animationOn and i == animatedIndex
		local v71 = v.imageId and v.imageId ~= ""

		t2["item" .. i] = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = i,
			Size = p24.thumbnailSize
		}, {
			Thumbnail = Roact.createElement(ThumbnailButton, {
				useScaledPlayButton = true,
				itemKey = i,
				imageId = v.imageId,
				isVideo = v.isYouTubeVideo,
				isSelected = v69,
				onActivated = v71 and p24.onItemActivated or nil,
				onPlayActivated = v.isYouTubeVideo and p24.onItemPlayActivated or nil
			}),
			TimerBar = v70 and p24:renderTimerBar(p25) or nil
		})
	end

	return t2
end
function v19.renderTimerBar(p26, p27) -- line: 488
	-- upvalues: Roact (copy)
	local UIDefault = p27.Theme.UIDefault
	local SecondaryContent = p27.Theme.SecondaryContent

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 100,
		Size = UDim2.new(1, 0, 0, 2),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1)
	}, {
		Background = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = p26.thumbnailSize,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			BackgroundColor3 = UIDefault.Color,
			BackgroundTransparency = UIDefault.Transparency
		}, {
			Corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			Progress = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Size = p26.progress:map(function(p28) -- line: 513
					return UDim2.fromScale(p28, 1)
				end)
			}, {
				Foreground = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = p26.thumbnailSize,
					BackgroundColor3 = SecondaryContent.Color,
					BackgroundTransparency = SecondaryContent.Transparency
				}, {
					Corner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					})
				})
			})
		})
	})
end
function v19.didUpdate(p29, _, p31) -- line: 535
	if p29.state.focusIndex ~= p31.focusIndex then
		p29:scrollToNewIndex()
	end

	if p29.state.selectedIndex ~= p31.selectedIndex then
		p29.updatePreviewTransparency(0)
	end
end
function v19.updateSizes(p32, p33) -- line: 545
	-- upvalues: calcMediaGallerySizesFromWidth (copy), calcMediaGallerySizesFromHeight (copy)
	local AbsoluteSizeX = p33.AbsoluteSize.X
	local AbsoluteSizeY = p33.AbsoluteSize.Y
	local numberOfThumbnails = p32.props.numberOfThumbnails
	local v84 = calcMediaGallerySizesFromWidth(AbsoluteSizeX, numberOfThumbnails, p32.props.fullWidth)

	if AbsoluteSizeY < v84.contentSize.Y.Offset then
		v84 = calcMediaGallerySizesFromHeight(AbsoluteSizeY, numberOfThumbnails, p32.props.fullWidth)
	end

	p32.updateContentSize(v84.contentSize)
	p32.updatePreviewSize(v84.previewSize)
	p32.updatePaginationSize(v84.paginationSize)
	p32.updateThumbnailSize(v84.thumbnailSize)
end
function v19.getCanvasPositionX(p34) -- line: 561
	local focusIndex = p34.state.focusIndex
	local XOffset = p34.thumbnailSize:getValue().X.Offset

	return (focusIndex - 1) * (XOffset + 12)
end
function v19.scrollToNewIndex(p35) -- line: 567
	-- upvalues: Otter (copy), t1 (copy)
	local X = p35.canvasPosition:getValue().X
	local v90 = p35:getCanvasPositionX()

	p35.scrollMotor:setGoal(Otter.instant(X))
	p35.scrollMotor:setGoal(Otter.spring(v90, t1))
	p35.scrolling = true
end

return v19
