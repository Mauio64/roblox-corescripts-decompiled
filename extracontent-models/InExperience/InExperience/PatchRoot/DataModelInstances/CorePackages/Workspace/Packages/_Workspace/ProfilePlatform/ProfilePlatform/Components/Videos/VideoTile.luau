local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local CollectionViews = require(ProfilePlatformParent.CollectionViews)
local Footer = require(ProfilePlatform.Components.Videos.Footer)
local VideoPlayer = require(ProfilePlatform.Components.Videos.VideoPlayer)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local Enums = require(ProfilePlatform.Common.Enums)
local useDispatch = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local VideoPlaybackCoordinator = require(ProfilePlatformParent.VideoUtils).VideoPlaybackCoordinator
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize

local function VideoTile(t1: {[any]: any}) -- line: 44
	-- upvalues: React (copy), useProfileFormFactor (copy), Enums (copy), useLocalization (copy), TextKeys (copy), useDynamicSizeMargin (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy), VideoPlaybackCoordinator (copy), useDispatch (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy), VideoPlayer (copy), Footer (copy), CollectionCarousel (copy)
	local v23, v24 = React.useState(true)
	local v25 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v26 = useLocalization({
		title = TextKeys.Videos
	})
	local v27, v28 = React.useState(nil)
	local v29, v30 = useDynamicSizeMargin()
	local v31 = useCollectionLayoutParams(CollectionItemSize.Large, v27, true, {
		sideMargin = v29
	})
	local v32 = React.useMemo(function() -- line: 60
		-- upvalues: VideoPlaybackCoordinator (copy)
		return VideoPlaybackCoordinator.new()
	end, {})
	local v33 = React.useCallback(function() -- line: 64
		-- upvalues: v27 (copy), v31 (copy)
		return (not v27 and 300 or v27.AbsoluteSize.X) - v31.sideMargin - 60
	end, { v27 })
	local v34 = React.useCallback(function(n1: number) -- line: 70
		-- upvalues: v25 (copy), v33 (copy)
		return ((if not v25 then v33() else n1)) * 0.5625 + 32 + 8
	end, {
		v25,
		v33
	})
	local v35 = useDispatch()
	local v36, v37 = React.useState(0)
	local v38 = React.useCallback(function(p1) -- line: 79
		-- upvalues: v37 (copy)
		v37(p1)
	end, {})
	local v39 = React.useCallback(function(p2, p3) -- line: 84
		-- upvalues: v32 (copy), AppPage (copy), v36 (copy), v23 (copy), v24 (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), v35 (copy), NavigateDown (copy)
		if p2 then
			if v32 then
				v32:reset("expanding_to_fullscreen")
			end

			local t2 = {
				name = AppPage.VideoFullscreen,
				detail = p2.videoId,
				extraProps = {
					videoId = p2.videoId,
					title = p2.title,
					initialTimePosition = p3 or v36,
					isMuted = v23,
					onMuteUpdate = v24
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v10.down(v10.fromLegacyPage(t2))

				return
			end

			v35(NavigateDown(t2))
		end
	end, {
		v36,
		v32,
		v23
	})
	local v40 = React.useCallback(function(p4) -- line: 115
		if p4 then
			p4.ClipsDescendants = true
		end
	end, {})
	local v41 = React.useCallback(function(t3: {[any]: any}, n2: number, uDim2: UDim2) -- line: 122
		-- upvalues: v25 (copy), v33 (copy), v34 (copy), React (copy), VideoPlayer (copy), v39 (copy), v38 (copy), v32 (copy), Footer (copy)
		local v51 = if not v25 then UDim2.new(0, v33(), 0, v34(v33())) else uDim2

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = n2,
			Size = v51
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			VideoContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 1, -40)
			}, {
				VideoPlayer = React.createElement(VideoPlayer, {
					cornerRadius = 8,
					isFullscreen = false,
					looped = false,
					onExpandCallback = function(p5) -- line: 146
						-- upvalues: v39 (copy), t3 (copy)
						v39(t3, p5)
					end,
					onTimeUpdate = v38,
					thumbnailImage = t3.thumbnailImage,
					videoId = t3.videoId,
					videoPlaybackCoordinator = v32
				})
			}),
			PaddingBelowVideo = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 8)
			}),
			Footer = React.createElement(Footer, {
				LayoutOrder = 3,
				text = t3.title
			})
		}), t3.videoId
	end, {
		v39,
		v25,
		v33,
		v34
	})

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		ClipsDescendants = true,
		ref = v28,
		[React.Change.AbsoluteSize] = v30
	}, {
		CollectionCarousel = React.createElement(CollectionCarousel, {
			columnGap = 12,
			hideHeaderButton = true,
			LayoutOrder = 1,
			fractionalItemAmount = if not v25 then nil else 0,
			getItemHeight = v34,
			items = t1.videos or {},
			numColumns = not v25 and 1 or 3,
			onScrollingFrameRefCallback = if not v25 then nil else v40,
			renderItem = v41,
			sideMargin = v31.sideMargin,
			title = v26.title
		})
	})
end

return VideoTile
