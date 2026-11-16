local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local UserGameSettings = UserSettings():GetService("UserGameSettings")
local UserInputService = game:GetService("UserInputService")

require(parent2.AppCommonLib)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local RobloxAppHooks = require(parent2.RobloxAppHooks)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSignal = RoactUtils.Hooks.useSignal

local CaptureType = require(parent.Enums.CaptureType)
local CarouselItem = require(parent.Components.CapturesCarousel.CarouselItem)
local CarouselNavArrow = require(parent.Components.CapturesCarousel.CarouselNavArrow)
local CarouselScrolled = require(parent.Thunks.CarouselScrolled)
local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local getClosestItemToCenter = require(parent.Utils.getClosestItemToCenter)
require(parent.Types)
local useAnalytics = require(parent.Analytics.useAnalytics)
local useCarouselController = require(parent.Hooks.useCarouselController)

local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local function getMargins(vector2: Vector2, vector2_2: Vector2)
	local x = (vector2_2 - vector2).X

	if x % 2 == 0 then
		local halfX = x / 2
		return halfX, halfX
	end

	local v = math.floor(x / 2)
	return v + 1, v
end

local function getTouchScrollingEnabled() -- 1 equivalent call inferred from this helper
	local platform = UserInputService:GetPlatform()
	local v = platform == Enum.Platform.IOS or platform == Enum.Platform.Android
	local touchEnabled = UserInputService.TouchEnabled
	local reducedMotion = UserGameSettings.ReducedMotion
	return v and touchEnabled and not reducedMotion
end

return function(props)
	local v = useAnalytics()
	local v2 = useDispatch()
	local v3 = useScreenSize()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(0)

	local v4 = useSelector(function(p)
		return p[Constants.RoduxKey].Captures
	end)

	local v5 = useSelector(function(p)
		return p[Constants.RoduxKey].Carousel.SelectedCaptureIndex
	end)

	local state3, setState3 = React.useState(v5)

	local v6 = v3.X / v3.Y > 1 and 0.15 or 0.075

	local v7 = math.clamp(math.floor(v3.X * v6), 50, 200)
	local imagePadding = math.floor(v7 * 0.2)

	local maxHeight = props.maxHeight
	local v8 = v3.X - v7 * 2

	local vector2 = Vector2.new(math.floor(v8), (math.floor(maxHeight)))
	local v9 = vector2.X * #v4
	local x = (v3 - vector2).X
	local v10, v11

	if x % 2 == 0 then
		v10 = x / 2
		v11 = v10
	else
		v11 = math.floor(x / 2)
		v10 = v11 + 1
	end

	local v12 = useCarouselController(vector2, v5, (React.useCallback(function(p: number)
		if p < 1 or #v4 < p then
			return
		end

		local left = p < v5 and Constants.CarouselDirection.Left or Constants.CarouselDirection.Right
		v.fireEvent(EventNames.CapturesCarouselScrolled, { direction = left })

		v2(CarouselScrolled(p))
	end, { v4, v5 })))

	local carouselRef = v12.carouselRef
	local carouselInputBegan = v12.carouselInputBegan
	local carouselInputEnded = v12.carouselInputEnded
	local deleteSelectedItem = v12.deleteSelectedItem
	local selectedItemFadeOutBinding = v12.selectedItemFadeOutBinding
	local postDeletionItemBinding = v12.postDeletionItemBinding
	local selectedItemRef = v12.selectedItemRef
	local setIsNavigationLocked = v12.setIsNavigationLocked
	local v13 = state3 > 1
	local v14 = state3 < #v4
	local v15

	if v13 or v14 then
		v15 = not props.isDisabled
	else
		v15 = v14
	end

	React.useEffect(function()
		setIsNavigationLocked(not v15)
	end, { v15, setIsNavigationLocked })

	local v16 = React.useCallback(function(p)
		deleteSelectedItem(p)
	end, { deleteSelectedItem })
	useSignal(props.deleteItemSignal, v16)

	local v17 = React.useCallback(function(p)
		local closestItemToCenter = getClosestItemToCenter(vector2, p)

		if closestItemToCenter ~= state3 then
			setState3(closestItemToCenter)
		end
	end, { vector2, state3, setState3 })

	local onMuteCallback = React.useCallback(function()
		v.fireEvent(EventNames.CapturesCarouselVideoMuteButtonActivated)
	end, {})

	local onExpandCallback = React.useCallback(function(p)
		setState(not state)
		setState2(p)

		if state then
			v.fireEvent(EventNames.CapturesCarouselVideoShrank)
		else
			v.fireEvent(EventNames.CapturesCarouselVideoExpanded)
		end
	end, { state })

	local v18 = React.useCallback(function(capture, itemIndex: number)
		if state3 + 3 < itemIndex or itemIndex < state3 - 3 then
			return nil
		end

		local v18

		if itemIndex == state3 - 1 then
			v18 = true
		elseif state3 == 1 then
			v18 = itemIndex == 2
		else
			v18 = false
		end

		local createElement = React.createElement
		local fadeOutBinding

		if itemIndex == v5 then
			fadeOutBinding = selectedItemFadeOutBinding
		end

		local transitionBinding

		if itemIndex == v5 then
			transitionBinding = selectedItemFadeOutBinding
		elseif v18 then
			transitionBinding = postDeletionItemBinding
		end

		local v19 = {
			capture = capture,
			fadeOutBinding = fadeOutBinding,
			transitionBinding = transitionBinding,
			imagePadding = imagePadding,
			isDisabled = 0,
			isSelected = 0,
			itemIndex = 0,
			itemSize = 0,
			onExpandCallback = 0,
			onMuteCallback = 0,
			unfocusedSizeMultiplier = 0.8
		}
		local isDisabled

		if FFlagUseRbxstorageInGallery then
			isDisabled = props.isDisabled and v5 == itemIndex
		end

		v19.isDisabled = isDisabled

		v19.isSelected = v5 == itemIndex
		v19.itemIndex = itemIndex
		v19.itemSize = vector2
		v19.onExpandCallback = onExpandCallback
		v19.onMuteCallback = onMuteCallback
		return createElement(CarouselItem, v19)
	end, {
		vector2,
		state3,
		imagePadding,
		props.isDisabled,
		onExpandCallback,
		onMuteCallback,
		postDeletionItemBinding,
		v5,
		selectedItemFadeOutBinding
	})

	local v19 = React.useMemo(function()
		local children = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		}

		for k, v19 in v4 do
			local v20

			if FFlagEnableCapturesGalleryRetrievalCoreScript then
				v20 = tostring(v19.CaptureTime.UnixTimestampMillis)
			elseif FFlagUseRbxstorageInGallery and v19.type == CaptureType.Video then
				v20 = v19.thumbnailKey
			else
				v20 = v19.contentId
			end

			local createElement = React.createElement
			local v21 = {
				BackgroundTransparency = 1,
				LayoutOrder = k,
				Size = UDim2.fromOffset(vector2.X, vector2.Y),
				ref = 0,
				ZIndex = 0
			}
			local ref

			if k == v5 then
				ref = selectedItemRef
			end

			v21.ref = ref
			v21.ZIndex = state and state2 == k and 2 or 1
			children[v20] = createElement("Frame", v21, { Item = v18(v19, k) })
		end

		return children
	end, { v4, vector2, state2, state, v18, v5 })

	local v20 = math.floor(vector2.Y * 0.8)

	local createElement = React.createElement
	local v21 = {
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, props.maxHeight),
		ZIndex = props.ZIndex
	}

	local createElement2 = React.createElement
	local v22 = {}
	v22.BackgroundTransparency = 1
	v22.CanvasSize = UDim2.new(0, v9, 1, 0)
	v22.ClipsDescendants = false
	v22.Position = UDim2.fromOffset(v10, 0)
	v22.ScrollBarThickness = 0
	v22.ScrollingDirection = Enum.ScrollingDirection.X
	local scrollingEnabled = not state

	if scrollingEnabled then
		if v15 then
			scrollingEnabled = getTouchScrollingEnabled() -- inferred equivalent call
		else
			scrollingEnabled = v15
		end
	end

	v22.ScrollingEnabled = scrollingEnabled
	v22.Size = UDim2.fromOffset(vector2.X, vector2.Y)
	v22[React.Change.CanvasPosition] = v17
	v22[React.Event.InputBegan] = carouselInputBegan
	v22[React.Event.InputEnded] = carouselInputEnded
	v22.ref = carouselRef
	return createElement("Frame", v21, {
		AnimatedCarousel = createElement2("ScrollingFrame", v22, v19),
		LeftArrow = not state and v13 and React.createElement(CarouselNavArrow, {
			direction = Constants.CarouselDirection.Left,
			isDisabled = props.isDisabled,
			Size = UDim2.fromOffset(v10 - imagePadding, v20),
			ZIndex = 2
		}),
		RightArrow = not state and v14 and React.createElement(CarouselNavArrow, {
			direction = Constants.CarouselDirection.Right,
			isDisabled = props.isDisabled,
			Size = UDim2.fromOffset(v11 - imagePadding, v20),
			ZIndex = 2
		})
	})
end
