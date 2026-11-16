local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CollectionViews")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/MomentsStoreTypes")

local MomentTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/MomentTile")
local MomentsCarouselMediaProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/MomentsCarouselMediaProvider")
local getVisibleTileRange = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/getVisibleTileRange")
local isPlayableVideoMoment = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/isPlayableVideoMoment")
local useDynamicSizeMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useDynamicSizeMargin")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local fFlagProfileMomentSceneOutfitPoster = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileMomentSceneOutfitPoster

local collectionCarousel = CollectionViews.CollectionCarousel
local useNavigationFocus = Navigation.useNavigationFocus
local useTokens = Foundation.Hooks.useTokens

local function MomentsCarousel(props)
	local moments = props.moments
	local v5 = useTokens()
	local v6 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v7 = useNavigationFocus()
	local v8, v9 = useDynamicSizeMargin()
	local state, setState = React.useState(0)

	local state2, setState2 = React.useState(1)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local v10 = v6 and 4 or 3
	local v11 = not v6 and 0.2 or nil
	local onTileImpression = props.onTileImpression

	local ref4 = React.useRef({})

	local ref5 = React.useRef(nil)

	local v12 = React.useMemo(function(): boolean
		for k, moment in moments do
			local v13

			if fFlagProfileMomentSceneOutfitPoster then
				v13 = isPlayableVideoMoment(moment)
			else
				v13 = moment.metadata.captureType == Enum.CaptureType.Video
			end

			if v13 then
				return true
			end
		end

		return false
	end, { moments })

	local moment = moments[state2]
	local v13

	if fFlagProfileMomentSceneOutfitPoster then
		v13 = not (moment == nil) and isPlayableVideoMoment(moment)
	else
		v13 = not (moment == nil) and moment.metadata.captureType == Enum.CaptureType.Video
	end

	local v14 = React.useCallback(function(p2)
		setState(p2)
		return p2 * 1.5 + 48
	end, {})

	local v15 = React.useCallback(function()
		if onTileImpression == nil or state <= 0 then
			return
		end

		local current = ref.current
		local v17, v18 = getVisibleTileRange(
			current == nil and 0 or current.CanvasPosition.X,
			state,
			12,
			v10,
			v11,
			#moments
		)

		for i = v17, v18 do
			if ref4.current[i] then
				continue
			end

			ref4.current[i] = true
			onTileImpression(i)
		end
	end, {
		onTileImpression,
		state,
		v10,
		v11,
		#moments
	})

	React.useEffect(function()
		if ref5.current ~= moments then
			ref5.current = moments
			ref4.current = {}
		end

		v15()
	end, { moments, v15 })

	local v16 = React.useCallback(function()
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

			local v17 = state + 12
			setState2((math.clamp(math.round(current.CanvasPosition.X / v17) + 1, 1, #moments)))

			v15()
		end)
	end, { state, #moments, v15 })

	React.useEffect(function()
		return function()
			if ref2.current ~= nil then
				task.cancel(ref2.current)
				ref2.current = nil
			end
		end
	end, {})

	local v17 = React.useCallback(function(p2, p3, p4)
		return React.createElement(MomentTile, {
			moment = p2,
			layoutOrder = p3,
			itemSize = p4,
			isActive = v7 and p3 == state2,
			onActivated = function()
				local current = ref3.current

				if current ~= nil then
					current.release()
				end

				props.onSelectMoment(p3)
			end
		}), p2.momentId
	end, { v7, state2, props.onSelectMoment })

	local element = React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, state * 1.5 + 48),
		[React.Change.AbsoluteSize] = v9
	}, {
		CollectionCarousel = React.createElement(collectionCarousel, {
			LayoutOrder = 1,
			title = "Moments",
			items = moments,
			renderItem = v17,
			getItemHeight = v14,
			scrollingFrameRef = ref,
			onChangeCanvasPosition = v16,
			numColumns = v10,
			fractionalItemAmount = v11,
			columnGap = 12,
			sideMargin = v8,
			onActivateHeader = props.onActivateHeader
		})
	})

	if v7 and v12 then
		return React.createElement(MomentsCarouselMediaProvider, {
			moments = moments,
			activeIndex = state2,
			playbackActive = v13,
			mediaCornerRadius = v5.Radius.Large,
			handoffRef = ref3
		}, { Carousel = element })
	end

	return element
end

return MomentsCarousel
