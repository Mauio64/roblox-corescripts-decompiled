local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/gEe")

local retrievalStatus = require("@luauforge/deferred/gEr").Enum.RetrievalStatus

local module2 = require("@luauforge/deferred/gEs")
local useTokens = module2.Hooks.useTokens

local module3 = require("@luauforge/deferred/gEt")

local module4 = require("@luauforge/deferred/gEu")
local useDispatch = module4.Hooks.RoactRodux.useDispatch
local useSelector = module4.Hooks.RoactRodux.useSelector

local createNextOrder = require("@luauforge/deferred/gEv").createNextOrder

local module5 = require("@luauforge/deferred/gEw")
local detailsDescription = module5.DetailsDescription
local detailsInfoTable = module5.DetailsInfoTable

local module6 = require("@luauforge/deferred/gEF")
local useFetchSongDetail = module6.useFetchSongDetail
local useFetchArtistSongs = module6.useFetchArtistSongs
local useFetchSongExperiences = module6.useFetchSongExperiences

local module7 = require("@luauforge/deferred/gEl")
local loadingStateContainer = module7.App.Container.LoadingStateContainer
local retrievalStatus2 = module7.App.Loading.Enum.RetrievalStatus

local navigateBack = require("@luauforge/deferred/gEG").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/gEo").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/gEH").NavigationCommands else nil

local usePageSideMargin = require("@luauforge/deferred/gEf").usePageSideMargin
local fFlagEnableTopSongsSort = require("@luauforge/deferred/gEo").FFlagEnableTopSongsSort

local module8 = require("@luauforge/deferred/gEI")
local contentPosition = module8.ContentPosition
local detailsPageTemplate = module8.DetailsPageTemplate
local fullscreenPageWithSafeArea = module8.FullscreenPageWithSafeArea

local useDeviceType = require("@luauforge/deferred/gEg").useDeviceType

local useLocalization = require("@luauforge/deferred/gEJ").Hooks.useLocalization

local module9 = require("@luauforge/deferred/gEK")
local module10 = require("@luauforge/deferred/gEd")
local module11 = require("@luauforge/deferred/gEN")

local useSongTileData = require("@luauforge/deferred/gEQ").useSongTileData

local appPage = require("@luauforge/deferred/gER").AppPage
local useAssetFavoriting = require("@luauforge/deferred/gES").useAssetFavoriting

local module12 = require("@luauforge/deferred/gET")
local audioPlayer = module12.AudioPlayer
local audioPlayerActions = module12.AudioPlayerActions

local useNavigationFocus = require("@luauforge/deferred/gEU").useNavigationFocus

local fFlagSongCarouselPropUpdate = require("@luauforge/deferred/gEo").FFlagSongCarouselPropUpdate
local fFlagSongEdpCarouselIxp = require("@luauforge/deferred/gEo").FFlagSongEdpCarouselIxp
local fFlagUpdateSongCarouselClipDefault = require("@luauforge/deferred/gEo").FFlagUpdateSongCarouselClipDefault
local fFlagLuaAppFixSDPLayout = require("@luauforge/deferred/gEo").FFlagLuaAppFixSDPLayout

local function getCombinedLoadingStatus(items, fetchStatus)
	for k, item in items do
		if item == retrievalStatus.NotStarted then
			return retrievalStatus.NotStarted
		end
	end

	for k, item in items do
		if item == retrievalStatus.Fetching then
			return retrievalStatus.Fetching
		end
	end

	return fetchStatus or retrievalStatus.NotStarted
end

return function(p2)
	assert(fFlagEnableTopSongsSort, "Song Sort is not enabled")
	local v5 = useDispatch()

	local nextOrder = createNextOrder()
	local v6 = if fFlagLuaAppFixSDPLayout then useTokens() else nil

	local ref = module.useRef(nil)
	local v7 = usePageSideMargin(ref.current)
	local v8 = useNavigationFocus()

	local songId = (p2.navigation and p2.navigation.state and p2.navigation.state.params or {}).songId
		or nil
	local v9 = tonumber(songId)

	local v10 = useSongTileData(songId)

	local v11 = useFetchSongDetail(songId)
	local songDetail = v11.songDetail
	local v12 = useFetchSongExperiences(songId)
	local v13 = module9(songDetail)
	local rows = v13 and v13.rows or nil
	local v14 = useFetchArtistSongs(songId)
	local filtered = module3.List.filter(v14.artistSongIds, function(p3): boolean
		return p3 ~= songId
	end)

	local v15 = useAssetFavoriting(v9 and { v9 } or {})
	local v16 = if v9 then v15.getByAssetId(v9) else false

	local v17 = useLocalization({
		descriptionTitle = "Feature.SongDetails.Body.DescriptionTitle",
		songsByArtistTitle = {
			"Feature.SongDetails.Label.SongsBy",
			artistName = songDetail and songDetail.artistName or ""
		},
		experiencesFeaturingTrackTitle = {
			"Feature.SongDetails.Label.ExperiencesFeaturingTrack",
			trackName = songDetail and songDetail.name or ""
		},
		reportAudio = "Feature.SongDetails.Action.ReportAudio"
	})

	local v18 = useSelector(function(p3)
		return p3.ScreenSize
	end)

	local v19 = v18 and v18.X >= 850 and true or false

	local v20 = useDeviceType()

	local v21 = module.useCallback(function()
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			v5(navigateBack())
		end
	end, { v5 })

	local v22 = module.useCallback(function()
		if v9 then
			v15.toggleFavorite(v9)
		end
	end, { v15.toggleFavorite, v9 })

	local v23 = module.useMemo(function()
		if v10.song then
			return {
				assetId = v10.song.assetId,
				isLiked = v16,
				title = v10.song.title,
				artist = v10.song.artist,
				thumbnailAssetId = v10.song.albumArtAssetId,
				thumbnail = v10.thumbnail,
				isPrivate = v10.song.isPrivate or false
			}
		end

		if songDetail then
			return {
				assetId = songDetail.assetId,
				isLiked = v16,
				title = songDetail.name,
				artist = songDetail.artistName,
				thumbnail = v10.thumbnail,
				isPrivate = false
			}
		end

		return nil
	end, { v10.song, v10.thumbnail, v16, songDetail })

	local v24 = module.useCallback(function()
		if v23 then
			return module.createElement(
				module2.View,
				{ tag = "row align-x-center", Size = UDim2.new(1, 0, 0, 500) },
				{
					MusicPlayer = module.createElement(audioPlayer, {
						audio = v23,
						isNavigationFocus = v8,
						analyticsSource = "song-details"
					})
				}
			)
		end

		return nil
	end, { v23, v8 })

	local v25 = module.useCallback(function()
		if not (songId and songDetail) then
			return nil
		end

		local v26 = tostring(songId) .. tostring(HttpService:GenerateGUID())
		local name = songDetail.name
		local artistName = songDetail.artistName
		local thumbnail = v10.thumbnail

		local v27 = v18 and v18.X > 850 and 12 or 0

		local v28 = v18 and v18.X > 850 and 4 or nil

		local v29 = v18 and v18.X > 850 and 4 or nil

		local v30 = {
			Actions = v23 and {
				portraitLayoutOrder = nextOrder(),
				landscapeLayoutOrder = nextOrder(),
				landscapePosition = contentPosition.Left,
				renderComponent = function()
					return module.createElement(audioPlayerActions, {
						audio = v23,
						onLike = v22,
						onUnlike = v22,
						analyticsSource = "song-details"
					})
				end
			} or nil,
			DetailsDescription = songDetail.description and #songDetail.description > 0 and {
				portraitLayoutOrder = nextOrder(),
				landscapeLayoutOrder = nextOrder(),
				landscapePosition = contentPosition.Left,
				renderComponent = function()
					return module.createElement(detailsDescription, {
						dataStatus = retrievalStatus2.fromRawValue(v11.fetchStatus),
						descriptionText = songDetail.description,
						LayoutOrder = 1,
						titleText = v17.descriptionTitle
					})
				end
			} or nil,
			SongExperiencesCarousel = v12.songExperiences and #v12.songExperiences > 0 and {
				portraitLayoutOrder = nextOrder(),
				landscapeLayoutOrder = nextOrder(),
				landscapePosition = contentPosition.Left,
				renderComponent = function()
					return module.createElement(module11, {
						fractionalItemAmount = 0,
						items = v12.songExperiences,
						numColumns = v29,
						sideMargin = 0,
						title = v17.experiencesFeaturingTrackTitle,
						impressionsTag = "SongDetails_" .. "SongExperience" .. v26,
						songId = songId,
						layoutOrder = 2,
						pageContext = appPage.SongDetail
					})
				end
			} or nil,
			ArtistSongsCarousel = #filtered > 0 and {
				portraitLayoutOrder = nextOrder(),
				landscapeLayoutOrder = nextOrder(),
				landscapePosition = contentPosition.Left,
				renderComponent = function()
					return module.createElement(module10, {
						songIds = filtered,
						title = v17.songsByArtistTitle,
						impressionsTag = "SongDetails_" .. "ArtistSong" .. v26,
						numColumns = v28,
						fractionalItemAmount = 0,
						collectionOrder = fFlagSongCarouselPropUpdate and 3 or nil,
						layoutOrder = not fFlagSongCarouselPropUpdate and 3 or nil,
						pageContext = appPage.SongDetail,
						referralId = songId,
						clipsDescendants = (fFlagSongEdpCarouselIxp or fFlagUpdateSongCarouselClipDefault) and true or nil
					})
				end
			} or nil,
			DetailsInfoTable = rows and #rows > 0 and {
				portraitLayoutOrder = nextOrder(),
				landscapeLayoutOrder = nextOrder(),
				landscapePosition = contentPosition.Left,
				renderComponent = function()
					return module.createElement(detailsInfoTable, {
						dividerStartOffset = 0,
						horizontalPadding = v27,
						rows = rows
					})
				end
			} or nil
		}

		local createElement = module.createElement

		local createElement2 = module.createElement

		local v36 = if v19 then `rbxthumb://type=Asset&id={songId}&w=1440&h=456` else nil
		local v35 = {
			bannerImageUrl = v36,
			renderCustomHeader = v24,
			componentList = v30,
			containerRef = ref,
			deviceType = v20,
			gradientHeight = 320,
			dualPanelBreakpoint = 1e999,
			headerBarBackgroundHeight = 80,
			maxContentWidth = 850,
			onClose = v21,
			sideMargin = v7,
			startingOffsetPosition = 500,
			subTitleText = artistName,
			thumbnailImageUrl = thumbnail,
			titleText = name,
			backgroundFrameSize = UDim2.new(1, 0, 0, 580),
			backgroundImageTransparency = 1,
			disableBackgroundAspectRatio = true,
			bodyContainerSafeAreaSize = 0,
			backgroundImageSize = 0,
			headerPadding = 0
		}

		local v37 = if fFlagLuaAppFixSDPLayout then UDim2.fromScale(1, 1) else nil
		v35.bodyContainerSafeAreaSize = v37
		local v38 = if fFlagLuaAppFixSDPLayout then UDim2.fromScale(1, 1) else nil
		v35.backgroundImageSize = v38

		local v39 = if fFlagLuaAppFixSDPLayout and v6 then 500 * v6.Stroke.Standard else nil
		v35.headerPadding = v39
		return createElement(
			fullscreenPageWithSafeArea,
			{ includeStatusBar = true, BackgroundTransparency = 1 },
			{
				DetailsPageTemplate = createElement2(detailsPageTemplate, v35)
			}
		)
	end, {
		filtered,
		v20,
		v5,
		v17.descriptionTitle,
		v17.experiencesFeaturingTrackTitle,
		v17.songsByArtistTitle,
		v21,
		v18,
		v7,
		songDetail,
		v11.fetchStatus,
		v12.songExperiences,
		v10.thumbnail,
		songId,
		rows,
		v24
	})

	local v26 = module.useCallback(function()
		if v11.fetchStatus == retrievalStatus.Failed then
			v11.refetchSongDetail()
		end

		if v14.fetchStatus == retrievalStatus.Failed then
			v14.refetchArtistSongs()
		end

		if v12.fetchStatus == retrievalStatus.Failed then
			v12.refetchSongExperiences()
		end
	end, { v11.refetchSongDetail, v14.refetchArtistSongs, v12.refetchSongExperiences })

	if songId then
		return module.createElement(loadingStateContainer, {
			dataStatus = retrievalStatus2.fromRawValue(getCombinedLoadingStatus(
				{ v11.fetchStatus, v14.fetchStatus, v12.fetchStatus },
				v11.fetchStatus
			)),
			onRetry = v26,
			renderOnLoaded = v25
		})
	end

	return nil
end
