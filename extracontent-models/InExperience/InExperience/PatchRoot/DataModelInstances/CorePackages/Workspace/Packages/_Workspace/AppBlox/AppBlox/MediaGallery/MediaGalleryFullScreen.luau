local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AppBlox").Parent
local EventConnection = require(Parent.ReactUtils).EventConnection
local Roact = require(Parent.Roact)
local t = require(Parent.t)
local UIBlox = require(Parent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Core.Style.withStyle
local ThumbnailButton = require(script.Parent.ThumbnailButton)
local getShowItems = require(script.Parent.getShowItems)
local v12 = Roact.Component:extend("MediaGalleryFullScreen")

v12.validateProps = t.strictInterface({
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
v12.defaultProps = {
	showIndex = 1,
	size = UDim2.fromScale(1, 1)
}

function v12.getDerivedStateFromProps(p1, p2) -- line: 53
	-- upvalues: getShowItems (copy)
	local t1 = nil

	if p2.items ~= p1.items then
		local v17 = getShowItems(p1)

		t1 = {
			items = p1.items,
			itemsToShow = v17,
			showArrows = #v17 > 1,
			focusIndex = math.min(p2.focusIndex or 1, #v17)
		}
	end

	if p2.showIndex ~= p1.showIndex then
		t1 = t1 or {}
		t1.showIndex = p1.showIndex
		t1.focusIndex = math.min(p1.showIndex, #p1.items)
	end

	return t1
end
function v12.init(p3) -- line: 76
	-- upvalues: Roact (copy)
	p3.state = {
		items = nil,
		itemsToShow = nil,
		showArrows = true,
		focusIndex = 1,
		showIndex = 1
	}

	local v19, v20 = Roact.createBinding(UDim2.fromScale(1, 1))

	p3.itemFrameSize = v19
	p3.updateItemFrameSize = v20

	local v21, v22 = Roact.createBinding(UDim2.new(0, 96, 1, 0))

	p3.arrowButtonSize = v21
	p3.updateArrowButtonSize = v22

	local v23, v24 = Roact.createBinding(UDim2.new(0.5, 0, 0.5, 0))

	p3.leftArrowPosition = v23
	p3.updateLeftArrowPosition = v24

	local v25, v26 = Roact.createBinding(UDim2.new(0.5, 0, 0.5, 0))

	p3.rightArrowPosition = v25
	p3.updateRightArrowPosition = v26

	function p3.onResize(p4) -- line: 90
		-- upvalues: p3 (copy)
		local AbsoluteSizeX = p4.AbsoluteSize.X
		local AbsoluteSizeY = p4.AbsoluteSize.Y
		local v50 = math.floor(AbsoluteSizeY * 1.7777777777777777)

		if AbsoluteSizeX < v50 then
			v50 = AbsoluteSizeX
			AbsoluteSizeY = math.floor(v50 / 1.7777777777777777)
		end

		p3.updateItemFrameSize(UDim2.new(0, v50, 0, AbsoluteSizeY))
	end
	function p3.onImageResize(p5) -- line: 104
		-- upvalues: p3 (copy)
		local AbsoluteSizeX = p5.AbsoluteSize.X
		local AbsoluteSizeY = p5.AbsoluteSize.Y

		p3.updateLeftArrowPosition(UDim2.new(0.5, -AbsoluteSizeX / 2, 0.5, 0))
		p3.updateRightArrowPosition(UDim2.new(0.5, AbsoluteSizeX / 2, 0.5, 0))
		p3.updateArrowButtonSize(UDim2.new(0, 96, 0, AbsoluteSizeY))
	end
	function p3.onUserInputBegan(p6) -- line: 113
		-- upvalues: p3 (copy)
		if p6.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local focusIndex = p3.state.focusIndex
		local v56 = #p3.props.items

		if p6.KeyCode == Enum.KeyCode.Left and focusIndex > 1 then
			p3.showPreviousItem()

			return
		end

		if p6.KeyCode == Enum.KeyCode.Right and focusIndex < v56 then
			p3.showNextItem()
		end
	end
	function p3.showPreviousItem() -- line: 128
		-- upvalues: p3 (copy)
		local v57 = p3.state.focusIndex - 1

		if v57 < 1 then
			v57 = 1
		end

		p3:setState({
			focusIndex = v57
		})
	end
	function p3.showNextItem() -- line: 139
		-- upvalues: p3 (copy)
		local v58 = #p3.props.items
		local v59 = p3.state.focusIndex + 1

		if v58 < v59 then
			v59 = v58
		end

		p3:setState({
			focusIndex = v59
		})
	end
	function p3.cycleNext() -- line: 151
		-- upvalues: p3 (copy)
		local v60 = #p3.props.items
		local v61 = p3.state.focusIndex + 1

		if v60 < v61 then
			v61 = 1
		end

		p3:setState({
			focusIndex = v61
		})
	end
	function p3.onVideoPlayActivated(p7) -- line: 163
		-- upvalues: p3 (copy)
		if p3.props.onVideoPlayActivated then
			local originalIndex = p3.state.itemsToShow[p7].originalIndex

			p3.props.onVideoPlayActivated(originalIndex)
		end
	end
end

local function renderArrowButton(_, p9, p10, p11, p12, p13, p14) -- line: 172
	-- upvalues: Roact (copy), IconButton (copy), Images (copy)
	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ZIndex = 100,
		Size = p13,
		AnchorPoint = p11,
		Position = p12
	}, {
		ArrowButton = Roact.createElement(IconButton, {
			showBackground = true,
			backgroundTransparency = 1,
			size = UDim2.fromScale(1, 1),
			icon = Images[p9],
			isDisabled = p10,
			onActivated = p14
		})
	})
end

function v12.render(p15) -- line: 192
	-- upvalues: withStyle (copy)
	return withStyle(function(p16) -- line: 193
		-- upvalues: p15 (copy)
		return p15:renderWithProvider(p16)
	end)
end
function v12.renderWithProvider(p17, p18) -- line: 198
	-- upvalues: Roact (copy), renderArrowButton (copy), ThumbnailButton (copy), EventConnection (copy), UserInputService (copy)
	local layoutOrder = p17.props.layoutOrder
	local anchorPoint = p17.props.anchorPoint
	local position = p17.props.position
	local size = p17.props.size
	local itemsToShow = p17.state.itemsToShow
	local showArrows = p17.state.showArrows
	local focusIndex = p17.state.focusIndex
	local v44 = itemsToShow[focusIndex]
	local v45 = focusIndex <= 1
	local v46 = focusIndex >= #itemsToShow

	return Roact.createElement("Frame", {
		LayoutOrder = layoutOrder,
		Size = size,
		AnchorPoint = anchorPoint,
		Position = position,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = p17.onResize
	}, {
		LeftArrow = if not showArrows then nil else renderArrowButton(p18, "icons/actions/cycleLeft", v45, Vector2.new(1, 0.5), p17.leftArrowPosition, p17.arrowButtonSize, p17.showPreviousItem),
		FullScreenItemFrame = Roact.createElement("Frame", {
			Size = UDim2.new(1, -192, 1, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			[Roact.Change.AbsoluteSize] = p17.onImageResize
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1.7777777777777777
			}),
			Item = Roact.createElement(ThumbnailButton, {
				userInteractionEnabled = true,
				itemKey = focusIndex,
				imageId = v44.imageId,
				isVideo = v44.isYouTubeVideo,
				onActivated = p17.cycleNext,
				onPlayActivated = v44.isYouTubeVideo and p17.onVideoPlayActivated or nil
			})
		}),
		RightArrow = if not showArrows then nil else renderArrowButton(p18, "icons/actions/cycleRight", v46, Vector2.new(0, 0.5), p17.rightArrowPosition, p17.arrowButtonSize, p17.showNextItem),
		EventConnection = showArrows and Roact.createElement(EventConnection, {
			event = UserInputService.InputBegan,
			callback = p17.onUserInputBegan
		}) or nil
	})
end

return v12
