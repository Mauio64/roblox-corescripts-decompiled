local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local UserInputService = game:GetService("UserInputService")

require(ParentParentParent.AppCommonLib)

local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSignal = RoactUtils.Hooks.useSignal
local CaptureType = require(ParentParent.Enums.CaptureType)
local CarouselItem = require(ParentParent.Components.CapturesCarousel.CarouselItem)
local CarouselNavArrow = require(ParentParent.Components.CapturesCarousel.CarouselNavArrow)
local CarouselScrolled = require(ParentParent.Thunks.CarouselScrolled)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local getClosestItemToCenter = require(ParentParent.Utils.getClosestItemToCenter)

require(ParentParent.Types)

local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useCarouselController = require(ParentParent.Hooks.useCarouselController)
local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local function getMargins(vector2: Vector2, vector2_2: Vector2) -- line: 40
	local X = (vector2_2 - vector2).X

	if X % 2 == 0 then
		local v28 = X / 2

		return v28, v28
	end

	local v29 = math.floor(X / 2)

	return v29 + 1, v29
end
local function getTouchScrollingEnabled() -- line: 54
	-- upvalues: UserInputService (copy), UserGameSettings (copy)
	local Platform = UserInputService:GetPlatform()
	local v31 = Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android
	local TouchEnabled = UserInputService.TouchEnabled
	local ReducedMotion = UserGameSettings.ReducedMotion

	return v31 and (TouchEnabled and not ReducedMotion)
end

return function(t1: {[any]: any}) -- line: 70
	-- upvalues: useAnalytics (copy), useDispatch (copy), useScreenSize (copy), React (copy), useSelector (copy), Constants (copy), EventNames (copy), CarouselScrolled (copy), useCarouselController (copy), useSignal (copy), getClosestItemToCenter (copy), CarouselItem (copy), FFlagUseRbxstorageInGallery (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), UserInputService (copy), UserGameSettings (copy), CarouselNavArrow (copy)
	local v35 = useAnalytics()
	local v36 = useDispatch()
	local v37 = useScreenSize()
	local v38, v39 = React.useState(false)
	local v40, v41 = React.useState(0)
	local v42 = useSelector(function(p1) -- line: 77
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].Captures
	end)
	local v43 = useSelector(function(p2) -- line: 81
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].Carousel.SelectedCaptureIndex
	end)
	local v44, v45 = React.useState(v43)
	local v46 = not (v37.X / v37.Y > 1) and 0.075 or 0.15
	local v47 = math.clamp(math.floor(v37.X * v46), 50, 200)
	local v48 = math.floor(v47 * 0.2)
	local maxHeight = t1.maxHeight
	local v50 = v37.X - v47 * 2
	local vector2 = Vector2.new(math.floor(v50), (math.floor(maxHeight)))
	local v52 = vector2.X * #v42
	local X = (v37 - vector2).X
	local v54, v55

	if X % 2 == 0 then
		v54 = X / 2
		v55 = v54
	else
		v55 = math.floor(X / 2)
		v54 = v55 + 1
	end

	local v56 = React.useCallback(function(n1: number) -- line: 102
		-- upvalues: v42 (copy), v43 (copy), Constants (copy), v35 (copy), EventNames (copy), v36 (copy), CarouselScrolled (copy)
		if n1 < 1 or n1 > #v42 then
			return
		end

		local v89 = n1 < v43 and Constants.CarouselDirection.Left or Constants.CarouselDirection.Right

		v35.fireEvent(EventNames.CapturesCarouselScrolled, {
			direction = v89
		})
		v36(CarouselScrolled(n1))
	end, {
		v42,
		v43
	})
	local v57 = useCarouselController(vector2, v43, v56)
	local carouselRef = v57.carouselRef
	local carouselInputBegan = v57.carouselInputBegan
	local carouselInputEnded = v57.carouselInputEnded
	local deleteSelectedItem = v57.deleteSelectedItem
	local selectedItemFadeOutBinding = v57.selectedItemFadeOutBinding
	local postDeletionItemBinding = v57.postDeletionItemBinding
	local selectedItemRef = v57.selectedItemRef
	local setIsNavigationLocked = v57.setIsNavigationLocked
	local v66 = v44 > 1
	local v67 = v44 < #v42
	local v68 = (v66 or v67) and not t1.isDisabled

	React.useEffect(function() -- line: 130
		-- upvalues: setIsNavigationLocked (copy), v68 (copy)
		setIsNavigationLocked(not v68)
	end, {
		v68,
		setIsNavigationLocked
	})

	local v69 = React.useCallback(function(p3) -- line: 134
		-- upvalues: deleteSelectedItem (copy)
		deleteSelectedItem(p3)
	end, { deleteSelectedItem })

	useSignal(t1.deleteItemSignal, v69)

	local v70 = React.useCallback(function(p4) -- line: 139
		-- upvalues: getClosestItemToCenter (copy), vector2 (copy), v44 (copy), v45 (copy)
		local v92 = getClosestItemToCenter(vector2, p4)

		if v92 ~= v44 then
			v45(v92)
		end
	end, {
		vector2,
		v44,
		v45
	})
	local v71 = React.useCallback(function() -- line: 146
		-- upvalues: v35 (copy), EventNames (copy)
		v35.fireEvent(EventNames.CapturesCarouselVideoMuteButtonActivated)
	end, {})
	local v72 = React.useCallback(function(p5) -- line: 150
		-- upvalues: v39 (copy), v38 (copy), v41 (copy), v35 (copy), EventNames (copy)
		v39(not v38)
		v41(p5)

		if not v38 then
			v35.fireEvent(EventNames.CapturesCarouselVideoExpanded)

			return
		end

		v35.fireEvent(EventNames.CapturesCarouselVideoShrank)
	end, { v38 })
	local v73 = React.useCallback(function(p6, n2: number) -- line: 161
		-- upvalues: v44 (copy), React (copy), CarouselItem (copy), v43 (copy), selectedItemFadeOutBinding (copy), postDeletionItemBinding (copy), v48 (copy), FFlagUseRbxstorageInGallery (copy), t1 (copy), vector2 (copy), v72 (copy), v71 (copy)
		if n2 > v44 + 3 or n2 < v44 - 3 then
			return nil
		end

		local v96 = n2 == v44 - 1 or v44 == 1 and n2 == 2

		return React.createElement(CarouselItem, {
			unfocusedSizeMultiplier = 0.8,
			capture = p6,
			fadeOutBinding = if n2 ~= v43 then nil else selectedItemFadeOutBinding,
			transitionBinding = if n2 ~= v43 then if not v96 then nil else postDeletionItemBinding else selectedItemFadeOutBinding,
			imagePadding = v48,
			isDisabled = if not FFlagUseRbxstorageInGallery then nil else t1.isDisabled and n2 == v43,
			isSelected = n2 == v43,
			itemIndex = n2,
			itemSize = vector2,
			onExpandCallback = v72,
			onMuteCallback = v71
		})
	end, {
		vector2,
		v44,
		v48,
		t1.isDisabled,
		v72,
		v71,
		postDeletionItemBinding,
		v43,
		selectedItemFadeOutBinding
	})
	local v74 = React.useMemo(function() -- line: 201
		-- upvalues: React (copy), v42 (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), FFlagUseRbxstorageInGallery (copy), CaptureType (copy), vector2 (copy), v43 (copy), selectedItemRef (copy), v38 (copy), v40 (copy), v73 (copy)
		local t2 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		}

		for v98, v99 in v42 do
			t2[if not FFlagEnableCapturesGalleryRetrievalCoreScript then if not FFlagUseRbxstorageInGallery or v99.type ~= CaptureType.Video then v99.contentId else v99.thumbnailKey else tostring(v99.CaptureTime.UnixTimestampMillis)] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = v98,
				Size = UDim2.fromOffset(vector2.X, vector2.Y),
				ref = if v98 ~= v43 then nil else selectedItemRef,
				ZIndex = (not v38 or v98 ~= v40) and 1 or 2
			}, {
				Item = v73(v99, v98)
			})
		end

		return t2
	end, {
		v42,
		vector2,
		v40,
		v38,
		v73,
		v43
	})
	local v75 = math.floor(vector2.Y * 0.8)
	local createElement = React.createElement
	local t3 = {
		BackgroundTransparency = 1,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.new(1, 0, 0, t1.maxHeight),
		ZIndex = t1.ZIndex
	}
	local t4 = {}
	local createElement2 = React.createElement
	local t5 = {
		BackgroundTransparency = 1,
		CanvasSize = UDim2.new(0, v52, 1, 0),
		ClipsDescendants = false,
		Position = UDim2.fromOffset(v54, 0),
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X
	}
	local v81 = not v38

	if v81 then
		v81 = v68

		if v81 then
			local Platform = UserInputService:GetPlatform()
			local v83 = Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android
			local TouchEnabled = UserInputService.TouchEnabled
			local ReducedMotion = UserGameSettings.ReducedMotion

			v81 = v83 and (TouchEnabled and not ReducedMotion)
		end
	end

	t5.ScrollingEnabled = v81
	t5.Size = UDim2.fromOffset(vector2.X, vector2.Y)
	t5[React.Change.CanvasPosition] = v70
	t5[React.Event.InputBegan] = carouselInputBegan
	t5[React.Event.InputEnded] = carouselInputEnded
	t5.ref = carouselRef
	t4.AnimatedCarousel = createElement2("ScrollingFrame", t5, v74)
	t4.LeftArrow = not v38 and (v66 and React.createElement(CarouselNavArrow, {
		ZIndex = 2,
		direction = Constants.CarouselDirection.Left,
		isDisabled = t1.isDisabled,
		Size = UDim2.fromOffset(v54 - v48, v75)
	}))
	t4.RightArrow = not v38 and (v67 and React.createElement(CarouselNavArrow, {
		ZIndex = 2,
		direction = Constants.CarouselDirection.Right,
		isDisabled = t1.isDisabled,
		Size = UDim2.fromOffset(v55 - v48, v75)
	}))

	return createElement("Frame", t3, t4)
end
