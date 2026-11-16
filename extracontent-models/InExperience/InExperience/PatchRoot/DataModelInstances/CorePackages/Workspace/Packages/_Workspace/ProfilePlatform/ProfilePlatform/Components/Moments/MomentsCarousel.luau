local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local CollectionViews = require(parent.CollectionViews)
local Foundation = require(parent.Foundation)
local Navigation = require(parent.Navigation)

require(parent.DataHydration.MomentsStoreTypes)

local MomentTile = require(script.Parent.MomentTile)
local MomentsCarouselMediaProvider = require(script.Parent.MomentsCarouselMediaProvider)
local getVisibleTileRange = require(script.Parent.getVisibleTileRange)
local isPlayableVideoMoment = require(script.Parent.isPlayableVideoMoment)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local Enums = require(ProfilePlatform.Common.Enums)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfileMomentSceneOutfitPoster = SharedFlags.FFlagProfileMomentSceneOutfitPoster

local CollectionCarousel = CollectionViews.CollectionCarousel
local useNavigationFocus = Navigation.useNavigationFocus
local useTokens = Foundation.Hooks.useTokens

local function MomentsCarousel(props)
	local moments = props.moments
	local v = useTokens()
	local v2 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v3 = useNavigationFocus()
	local sideMargin, v4 = useDynamicSizeMargin()
	local state, setState = React.useState(0)

	local state2, setState2 = React.useState(1)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local numColumns = v2 and 4 or 3
	local fractionalItemAmount = not v2 and 0.2 or nil
	local onTileImpression = props.onTileImpression

	local ref4 = React.useRef({})

	local ref5 = React.useRef(nil)

	local v5 = React.useMemo(function(): boolean
		for _, moment in moments do
			local v5

			if FFlagProfileMomentSceneOutfitPoster then
				v5 = isPlayableVideoMoment(moment)
			else
				v5 = moment.metadata.captureType == Enum.CaptureType.Video
			end

			if v5 then
				return true
			end
		end

		return false
	end, { moments })

	local moment = moments[state2]
	local playbackActive

	if FFlagProfileMomentSceneOutfitPoster then
		if moment == nil then
			playbackActive = false
		else
			playbackActive = isPlayableVideoMoment(moment)
		end
	elseif moment == nil then
		playbackActive = false
	else
		playbackActive = moment.metadata.captureType == Enum.CaptureType.Video
	end

	local getItemHeight = React.useCallback(function(p: number)
		setState(p)
		return p * 1.5 + 48
	end, {})

	local v6 = React.useCallback(function()
		if onTileImpression == nil or state <= 0 then
			return
		end

		local current = ref.current
		local visibleTileRange, v6 = getVisibleTileRange(
			current == nil and 0 or current.CanvasPosition.X,
			state,
			12,
			numColumns,
			fractionalItemAmount,
			#moments
		)

		for i = visibleTileRange, v6 do
			if ref4.current[i] then
				continue
			end

			ref4.current[i] = true
			onTileImpression(i)
		end
	end, {
		onTileImpression,
		state,
		numColumns,
		fractionalItemAmount,
		#moments
	})

	React.useEffect(function()
		if ref5.current ~= moments then
			ref5.current = moments
			ref4.current = {}
		end

		v6()
	end, { moments, v6 })

	local onChangeCanvasPosition = React.useCallback(function()
		if ref.current == nil or state <= 0 then
			return
		end

		if ref2.current ~= nil then
			task.cancel(ref2.current)
		end

		ref2.current = task.delay(0.2, function()
			ref2.current = nil
			local current = ref.current

			if current == nil then
				return
			end

			local v7 = state + 12
			setState2((math.clamp(math.round(current.CanvasPosition.X / v7) + 1, 1, #moments)))

			v6()
		end)
	end, { state, #moments, v6 })

	React.useEffect(function()
		return function()
			if ref2.current ~= nil then
				task.cancel(ref2.current)
				ref2.current = nil
			end
		end
	end, {})

	local renderItem = React.useCallback(function(moment2, layoutOrder: number, itemSize: UDim2)
		return React.createElement(MomentTile, {
			moment = moment2,
			layoutOrder = layoutOrder,
			itemSize = itemSize,
			isActive = v3 and layoutOrder == state2,
			onActivated = function()
				local current = ref3.current

				if current ~= nil then
					current.release()
				end

				props.onSelectMoment(layoutOrder)
			end
		}), moment2.momentId
	end, { v3, state2, props.onSelectMoment })

	local element = React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, state * 1.5 + 48),
		[React.Change.AbsoluteSize] = v4
	}, {
		CollectionCarousel = React.createElement(CollectionCarousel, {
			LayoutOrder = 1,
			title = "Moments",
			items = moments,
			renderItem = renderItem,
			getItemHeight = getItemHeight,
			scrollingFrameRef = ref,
			onChangeCanvasPosition = onChangeCanvasPosition,
			numColumns = numColumns,
			fractionalItemAmount = fractionalItemAmount,
			columnGap = 12,
			sideMargin = sideMargin,
			onActivateHeader = props.onActivateHeader
		})
	})

	if v3 and v5 then
		return React.createElement(MomentsCarouselMediaProvider, {
			moments = moments,
			activeIndex = state2,
			playbackActive = playbackActive,
			mediaCornerRadius = v.Radius.Large,
			handoffRef = ref3
		}, { Carousel = element })
	end

	return element
end

return MomentsCarousel
