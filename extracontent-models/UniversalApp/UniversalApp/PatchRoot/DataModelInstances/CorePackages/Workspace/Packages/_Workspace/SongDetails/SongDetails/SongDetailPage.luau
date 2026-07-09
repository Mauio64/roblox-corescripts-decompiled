local HttpService = game:GetService("HttpService")
local SongDetails = script:FindFirstAncestor("SongDetails")
local SongDetailsParent = SongDetails.Parent
local React = require(SongDetailsParent.React)
local RetrievalStatus = require(SongDetailsParent.Http).Enum.RetrievalStatus
local Foundation = require(SongDetailsParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Cryo = require(SongDetailsParent.Cryo)
local RoactUtils = require(SongDetailsParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local createNextOrder = require(SongDetailsParent.ReactUtils).createNextOrder
local DetailsPageComponents = require(SongDetailsParent.DetailsPageComponents)
local DetailsDescription = DetailsPageComponents.DetailsDescription
local DetailsInfoTable = DetailsPageComponents.DetailsInfoTable
local SongDetailRodux = require(SongDetailsParent.SongDetailRodux)
local useFetchSongDetail = SongDetailRodux.useFetchSongDetail
local useFetchArtistSongs = SongDetailRodux.useFetchArtistSongs
local useFetchSongExperiences = SongDetailRodux.useFetchSongExperiences
local UIBlox = require(SongDetailsParent.UIBlox)
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local NavigateBack = require(SongDetailsParent.NavigationRodux).Thunks.NavigateBack
local FFlagSignalsNavP3Dispatch = require(SongDetailsParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v25 = if not FFlagSignalsNavP3Dispatch then nil else require(SongDetailsParent.RobloxAppNavigation).NavigationCommands
local usePageSideMargin = require(SongDetailsParent.CollectionViews).usePageSideMargin
local FFlagEnableTopSongsSort = require(SongDetailsParent.SharedFlags).FFlagEnableTopSongsSort
local AppBlox = require(SongDetailsParent.AppBlox)
local ContentPosition = AppBlox.ContentPosition
local DetailsPageTemplate = AppBlox.DetailsPageTemplate
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local useDeviceType = require(SongDetailsParent.RobloxAppHooks).useDeviceType
local useLocalization = require(SongDetailsParent.Localization).Hooks.useLocalization
local useSongInfoTableData = require(SongDetails.Hooks.useSongInfoTableData)
local SongCollectionCarousel = require(SongDetails.SongCollectionCarousel)
local SongExperiencesCollectionCarousel = require(SongDetails.SongExperiencesCollectionCarousel)
local useSongTileData = require(SongDetailsParent.SongInfosRodux).useSongTileData
local AppPage = require(SongDetailsParent.RobloxAppEnums).AppPage
local useAssetFavoriting = require(SongDetailsParent.AssetFavorites).useAssetFavoriting
local Songbird = require(SongDetailsParent.Songbird)
local AudioPlayer = Songbird.AudioPlayer
local AudioPlayerActions = Songbird.AudioPlayerActions
local useNavigationFocus = require(SongDetailsParent.Navigation).useNavigationFocus
local FFlagSongCarouselPropUpdate = require(SongDetailsParent.SharedFlags).FFlagSongCarouselPropUpdate
local FFlagSongEdpCarouselIxp = require(SongDetailsParent.SharedFlags).FFlagSongEdpCarouselIxp
local FFlagUpdateSongCarouselClipDefault = require(SongDetailsParent.SharedFlags).FFlagUpdateSongCarouselClipDefault
local FFlagLuaAppFixSDPLayout = require(SongDetailsParent.SharedFlags).FFlagLuaAppFixSDPLayout
local v48 = game:DefineFastFlag("SongDetailFallbackAudio", false)

local function getCombinedLoadingStatus(t1: {[any]: any}, s1: string?) -- line: 116
	-- upvalues: RetrievalStatus (copy)
	for _, v53 in t1 do
		if v53 == RetrievalStatus.NotStarted then
			return RetrievalStatus.NotStarted
		end
	end

	for _, v55 in t1 do
		if v55 == RetrievalStatus.Fetching then
			return RetrievalStatus.Fetching
		end
	end

	return s1 or RetrievalStatus.NotStarted
end

return function(t2: {[any]: any}) -- line: 130
	-- upvalues: FFlagEnableTopSongsSort (copy), useDispatch (copy), createNextOrder (copy), FFlagLuaAppFixSDPLayout (copy), useTokens (copy), React (copy), usePageSideMargin (copy), useNavigationFocus (copy), useSongTileData (copy), useFetchSongDetail (copy), useFetchSongExperiences (copy), useSongInfoTableData (copy), useFetchArtistSongs (copy), Cryo (copy), useAssetFavoriting (copy), useLocalization (copy), useSelector (copy), useDeviceType (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), NavigateBack (copy), v48 (copy), Foundation (copy), AudioPlayer (copy), HttpService (copy), ContentPosition (copy), AudioPlayerActions (copy), DetailsDescription (copy), RetrievalStatus2 (copy), SongExperiencesCollectionCarousel (copy), AppPage (copy), SongCollectionCarousel (copy), FFlagSongCarouselPropUpdate (copy), FFlagSongEdpCarouselIxp (copy), FFlagUpdateSongCarouselClipDefault (copy), DetailsInfoTable (copy), FullscreenPageWithSafeArea (copy), DetailsPageTemplate (copy), RetrievalStatus (copy), LoadingStateContainer (copy), getCombinedLoadingStatus (copy)
	assert(FFlagEnableTopSongsSort, "Song Sort is not enabled")

	local v57 = useDispatch()
	local v58 = createNextOrder()
	local v59 = if not FFlagLuaAppFixSDPLayout then nil else useTokens()
	local v60 = React.useRef(nil)
	local v61 = usePageSideMargin(v60.current)
	local v62 = useNavigationFocus()
	local v63 = (t2.navigation and (not not t2.navigation.state and t2.navigation.state.params) or {}).songId or nil
	local num = tonumber(v63)
	local v65 = useSongTileData(v63)
	local v66 = useFetchSongDetail(v63)
	local songDetail = v66.songDetail
	local v68 = useFetchSongExperiences(v63)
	local v69 = useSongInfoTableData(songDetail)
	local v70 = v69 and v69.rows or nil
	local v71 = useFetchArtistSongs(v63)
	local v72 = Cryo.List.filter(v71.artistSongIds, function(p1) -- line: 153
		-- upvalues: v63 (copy)
		return p1 ~= v63
	end)
	local v73 = useAssetFavoriting(if not num then {} else { num })
	local v74 = not not num and v73.getByAssetId(num)
	local v75 = useLocalization({
		descriptionTitle = "Feature.SongDetails.Body.DescriptionTitle",
		reportAudio = "Feature.SongDetails.Action.ReportAudio",
		songsByArtistTitle = {
			"Feature.SongDetails.Label.SongsBy",
			artistName = songDetail and songDetail.artistName or ""
		},
		experiencesFeaturingTrackTitle = {
			"Feature.SongDetails.Label.ExperiencesFeaturingTrack",
			trackName = songDetail and songDetail.name or ""
		}
	})
	local v76 = useSelector(function(p2) -- line: 173
		return p2.ScreenSize
	end)
	local v77 = not not v76 and (v76.X >= 850 or false)
	local v78 = useDeviceType()
	local v79 = React.useCallback(function() -- line: 182
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v25 (copy), v57 (copy), NavigateBack (copy)
		if FFlagSignalsNavP3Dispatch then
			v25.back()

			return
		end

		v57(NavigateBack())
	end, { v57 })
	local v80 = React.useCallback(function() -- line: 190
		-- upvalues: num (copy), v73 (copy)
		if num then
			v73.toggleFavorite(num)
		end
	end, {
		v73.toggleFavorite,
		num
	})
	local v81 = React.useMemo(function() -- line: 197
		-- upvalues: v65 (copy), v74 (copy), v48 (copy), songDetail (copy)
		if v65.song then
			return {
				assetId = v65.song.assetId,
				isLiked = v74,
				title = v65.song.title,
				artist = v65.song.artist,
				thumbnailAssetId = v65.song.albumArtAssetId,
				thumbnail = v65.thumbnail,
				isPrivate = v65.song.isPrivate or false
			}
		end

		if v48 and songDetail then
			return {
				isPrivate = false,
				assetId = songDetail.assetId,
				isLiked = v74,
				title = songDetail.name,
				artist = songDetail.artistName,
				thumbnail = v65.thumbnail
			}
		end

		return nil
	end, {
		v65.song,
		v65.thumbnail,
		v74,
		if not v48 then nil else songDetail
	})
	local v82 = React.useCallback(function() -- line: 228
		-- upvalues: v81 (copy), React (copy), Foundation (copy), AudioPlayer (copy), v62 (copy)
		if not v81 then
			return nil
		end

		return React.createElement(Foundation.View, {
			tag = "row align-x-center",
			Size = UDim2.new(1, 0, 0, 500)
		}, {
			MusicPlayer = React.createElement(AudioPlayer, {
				analyticsSource = "song-details",
				audio = v81,
				isNavigationFocus = v62
			})
		})
	end, {
		v81,
		v62
	})
	local v83 = React.useCallback(function() -- line: 246
		-- upvalues: v63 (copy), songDetail (copy), HttpService (copy), v65 (copy), v76 (copy), v81 (copy), v58 (copy), ContentPosition (copy), React (copy), AudioPlayerActions (copy), v80 (copy), DetailsDescription (copy), RetrievalStatus2 (copy), v66 (copy), v75 (copy), v68 (copy), SongExperiencesCollectionCarousel (copy), AppPage (copy), v72 (copy), SongCollectionCarousel (copy), FFlagSongCarouselPropUpdate (copy), FFlagSongEdpCarouselIxp (copy), FFlagUpdateSongCarouselClipDefault (copy), v70 (copy), DetailsInfoTable (copy), FullscreenPageWithSafeArea (copy), DetailsPageTemplate (copy), v77 (copy), v82 (copy), v60 (copy), v78 (copy), v79 (copy), v61 (copy), FFlagLuaAppFixSDPLayout (copy), v59 (copy)
		if not v63 or not songDetail then
			return nil
		end

		local v87 = tostring(v63) .. tostring(HttpService:GenerateGUID())
		local name = songDetail.name
		local artistName = songDetail.artistName
		local thumbnail = v65.thumbnail
		local v91 = (not v76 or not (v76.X > 850)) and 0 or 12
		local v92 = if not v76 or not (v76.X > 850) then nil else 4
		local v93 = if not v76 or not (v76.X > 850) then nil else 4
		local t3 = {
			Actions = if not v81 then nil else {
				portraitLayoutOrder = v58(),
				landscapeLayoutOrder = v58(),
				landscapePosition = ContentPosition.Left,
				renderComponent = function() -- line: 275
					-- upvalues: React (copy), AudioPlayerActions (copy), v81 (copy), v80 (copy)
					return React.createElement(AudioPlayerActions, {
						analyticsSource = "song-details",
						audio = v81,
						onLike = v80,
						onUnlike = v80
					})
				end
			},
			DetailsDescription = if not songDetail.description or not (#songDetail.description > 0) then nil else {
				portraitLayoutOrder = v58(),
				landscapeLayoutOrder = v58(),
				landscapePosition = ContentPosition.Left,
				renderComponent = function() -- line: 290
					-- upvalues: React (copy), DetailsDescription (copy), RetrievalStatus2 (copy), v66 (copy), songDetail (copy), v75 (copy)
					return React.createElement(DetailsDescription, {
						LayoutOrder = 1,
						dataStatus = RetrievalStatus2.fromRawValue(v66.fetchStatus),
						descriptionText = songDetail.description,
						titleText = v75.descriptionTitle
					})
				end
			},
			SongExperiencesCarousel = if not v68.songExperiences or not (#v68.songExperiences > 0) then nil else {
				portraitLayoutOrder = v58(),
				landscapeLayoutOrder = v58(),
				landscapePosition = ContentPosition.Left,
				renderComponent = function() -- line: 306
					-- upvalues: React (copy), SongExperiencesCollectionCarousel (copy), v68 (copy), v93 (copy), v75 (copy), v87 (copy), v63 (copy), AppPage (copy)
					return React.createElement(SongExperiencesCollectionCarousel, {
						fractionalItemAmount = 0,
						sideMargin = 0,
						layoutOrder = 2,
						items = v68.songExperiences,
						numColumns = v93,
						title = v75.experiencesFeaturingTrackTitle,
						impressionsTag = "SongDetails_" .. "SongExperience" .. v87,
						songId = v63,
						pageContext = AppPage.SongDetail
					})
				end
			},
			ArtistSongsCarousel = if not (#v72 > 0) then nil else {
				portraitLayoutOrder = v58(),
				landscapeLayoutOrder = v58(),
				landscapePosition = ContentPosition.Left,
				renderComponent = function() -- line: 328
					-- upvalues: React (copy), SongCollectionCarousel (copy), v72 (copy), v75 (copy), v87 (copy), v92 (copy), FFlagSongCarouselPropUpdate (copy), AppPage (copy), v63 (copy), FFlagSongEdpCarouselIxp (copy), FFlagUpdateSongCarouselClipDefault (copy)
					return React.createElement(SongCollectionCarousel, {
						fractionalItemAmount = 0,
						songIds = v72,
						title = v75.songsByArtistTitle,
						impressionsTag = "SongDetails_" .. "ArtistSong" .. v87,
						numColumns = v92,
						collectionOrder = if not FFlagSongCarouselPropUpdate then nil else 3,
						layoutOrder = not FFlagSongCarouselPropUpdate and 3 or nil,
						pageContext = AppPage.SongDetail,
						referralId = v63,
						clipsDescendants = FFlagSongEdpCarouselIxp and true or (not not FFlagUpdateSongCarouselClipDefault or nil)
					})
				end
			},
			DetailsInfoTable = if not v70 or not (#v70 > 0) then nil else {
				portraitLayoutOrder = v58(),
				landscapeLayoutOrder = v58(),
				landscapePosition = ContentPosition.Left,
				renderComponent = function() -- line: 354
					-- upvalues: React (copy), DetailsInfoTable (copy), v91 (copy), v70 (copy)
					return React.createElement(DetailsInfoTable, {
						dividerStartOffset = 0,
						horizontalPadding = v91,
						rows = v70
					})
				end
			}
		}

		return React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundTransparency = 1
		}, {
			DetailsPageTemplate = React.createElement(DetailsPageTemplate, {
				gradientHeight = 320,
				dualPanelBreakpoint = 1e999,
				headerBarBackgroundHeight = 80,
				maxContentWidth = 850,
				startingOffsetPosition = 500,
				backgroundImageTransparency = 1,
				disableBackgroundAspectRatio = true,
				bannerImageUrl = if not v77 then nil else `rbxthumb://type=Asset&id={ v63 }&w=1440&h=456`,
				renderCustomHeader = v82,
				componentList = t3,
				containerRef = v60,
				deviceType = v78,
				onClose = v79,
				sideMargin = v61,
				subTitleText = artistName,
				thumbnailImageUrl = thumbnail,
				titleText = name,
				backgroundFrameSize = UDim2.new(1, 0, 0, 580),
				bodyContainerSafeAreaSize = if not FFlagLuaAppFixSDPLayout then nil else UDim2.fromScale(1, 1),
				backgroundImageSize = if not FFlagLuaAppFixSDPLayout then nil else UDim2.fromScale(1, 1),
				headerPadding = if not FFlagLuaAppFixSDPLayout or not v59 then nil else 500 * v59.Stroke.Standard
			})
		})
	end, {
		v72,
		v78,
		v57,
		v75.descriptionTitle,
		v75.experiencesFeaturingTrackTitle,
		v75.songsByArtistTitle,
		v79,
		v76,
		v61,
		songDetail,
		v66.fetchStatus,
		v68.songExperiences,
		v65.thumbnail,
		v63,
		v70,
		v82
	})
	local v84 = React.useCallback(function() -- line: 427
		-- upvalues: v66 (copy), RetrievalStatus (copy), v71 (copy), v68 (copy)
		if v66.fetchStatus == RetrievalStatus.Failed then
			v66.refetchSongDetail()
		end

		if v71.fetchStatus == RetrievalStatus.Failed then
			v71.refetchArtistSongs()
		end

		if v68.fetchStatus == RetrievalStatus.Failed then
			v68.refetchSongExperiences()
		end
	end, {
		v66.refetchSongDetail,
		v71.refetchArtistSongs,
		v68.refetchSongExperiences
	})

	if not v63 then
		return nil
	end

	return React.createElement(LoadingStateContainer, {
		dataStatus = RetrievalStatus2.fromRawValue((getCombinedLoadingStatus({
			v66.fetchStatus,
			v71.fetchStatus,
			v68.fetchStatus
		}, v66.fetchStatus))),
		onRetry = v84,
		renderOnLoaded = v83
	})
end
