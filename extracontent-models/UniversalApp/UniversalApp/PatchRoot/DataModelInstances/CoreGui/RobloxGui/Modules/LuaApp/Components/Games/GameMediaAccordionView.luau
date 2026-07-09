local CorePackages = game:GetService("CorePackages")
local Url = require(CorePackages.Workspace.Packages.Http).Url
local Functional = require(CorePackages.Workspace.Packages.AppCommonLib).Functional
local AccordionView = require(CorePackages.Packages.UIBlox).AccordionView
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local GameMediaImageType = require(CorePackages.Workspace.Packages.DiscoveryTypes).GameMediaImageType
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local MediaAccordionExpanded = Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.MediaAccordionExpanded
local MediaAccordionCollapsed = Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.MediaAccordionCollapsed
local ApiFetchGameMedia = Modules.LuaApp.Thunks.Games.ApiFetchGameMedia
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local OpenCentralOverlayForLeaveRobloxAlert = require(Modules2.LuaApp.Thunks.OpenCentralOverlayForLeaveRobloxAlert)
local OpenYouTubeVideo = require(Modules2.LuaApp.Thunks.OpenYouTubeVideo)
local openYouTubeVideoEvent = require(CorePackages.Workspace.Packages.DiscoveryAnalytics).Events.openYouTubeVideoEvent
local GameMediaItem = require(Modules2.LuaApp.Components.Games.GameMediaItem)
local LoadableImage = require(Modules2.LuaApp.Components.LoadableImage)
local GenericIconButton = require(Modules2.LuaApp.Components.GenericIconButton)
local withTheme_DEPRECATED = require(Modules2.LuaApp.withTheme_DEPRECATED)
local FFlagMediaAccordionAndFullTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagMediaAccordionAndFullTelemetry
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddUniverseIdToGameDetailsEvents
local _ = {
	view = "view",
	play = "play"
}

local function processMediaEntry(p1, p2) -- line: 54
	-- upvalues: GameMediaImageType (copy)
	local v38

	if p1.assetTypeId == GameMediaImageType.YouTubeVideo then
		if not p2 then
			return nil
		end

		v38 = string.format("https://img.youtube.com/vi/%s/hqdefault.jpg", p1.videoHash)
	else
		v38 = "http://www.roblox.com/asset/?id=" .. tostring(p1.imageId)
	end

	return {
		mediaType = p1.assetTypeId,
		imageId = v38,
		videoTitle = p1.videoTitle,
		videoHash = p1.videoHash
	}
end
local function generateDefaultEntry(p3) -- line: 76
	-- upvalues: GameMediaImageType (copy), Url (copy)
	return {
		mediaType = GameMediaImageType.Image,
		imageId = Url:getPlaceDefaultThumbnailUrl(p3, 768, 432)
	}
end

local v31 = memoize(function(p4, p5, p6, p7, p8) -- line: 84
	-- upvalues: RetrievalStatus (copy), GameMediaImageType (copy), Url (copy), processMediaEntry (copy)
	if not p4 then
		if p7 == RetrievalStatus.Done then
			return {
				[1] = {
					mediaType = GameMediaImageType.Image,
					imageId = Url:getPlaceDefaultThumbnailUrl(p6, 768, 432)
				}
			}
		end

		return {}
	end

	local t1 = { unpack(p4, 1, p5) }
	local t2 = {}

	for _, v in ipairs(t1) do
		local v49 = processMediaEntry(v, p8)

		if v49 then
			table.insert(t2, v49)
		end
	end

	return t2
end)
local v32 = Roact.PureComponent:extend("GameMediaAccordionView")

function v32.init(p9) -- line: 113
	-- upvalues: LoadableImage (copy), Functional (copy), GameMediaImageType (copy), openYouTubeVideoEvent (copy), RetrievalStatus (copy), FFlagMediaAccordionAndFullTelemetry (copy), MediaAccordionExpanded (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), MediaAccordionCollapsed (copy)
	p9.isMounted = false
	p9.state = {
		firstImageLoaded = LoadableImage.isLoaded(p9.props.firstImageId)
	}

	function p9.performOpenYouTubeVideo(p10, p11) -- line: 122
		-- upvalues: p9 (copy)
		local guiService = p9.props.guiService
		local openYouTubeVideo = p9.props.openYouTubeVideo
		local eventIngest = p9.props.eventIngest
		local universeId = p9.props.universeId
		local videoHash = p10.videoHash
		local videoTitle = p10.videoTitle

		if videoHash and (#videoHash > 0 and videoTitle and #videoTitle > 0) then
			openYouTubeVideo(guiService, videoHash, videoTitle, p11, eventIngest, universeId, "play")
		end
	end
	function p9.logMediaItemsContainVideo(s1: string) -- line: 144
		-- upvalues: p9 (copy), Functional (copy), GameMediaImageType (copy), openYouTubeVideoEvent (copy)
		local eventIngest = p9.props.eventIngest
		local universeId = p9.props.universeId
		local v92 = p9.props.gameMediaEntries or {}
		local v93 = Functional.Filter(v92, function(p12) -- line: 149
			-- upvalues: GameMediaImageType (copy)
			return p12.mediaType == GameMediaImageType.YouTubeVideo
		end)[1]

		if v93 then
			local videoHash = v93.videoHash
			local videoTitle = v93.videoTitle

			openYouTubeVideoEvent(eventIngest, s1, videoTitle, videoHash, universeId, "view")
		end
	end
	function p9.openItem(p13) -- line: 168
		-- upvalues: GameMediaImageType (copy), p9 (copy)
		if p13.mediaType == GameMediaImageType.YouTubeVideo then
			local openLeaveRobloxAlertUIBlox = p9.props.openLeaveRobloxAlertUIBlox

			if p9.props.showYouTubeAgeAlert then
				openLeaveRobloxAlertUIBlox(function() -- line: 172
					-- upvalues: p9 (copy), p13 (copy)
					p9.performOpenYouTubeVideo(p13, "gameDetailsAccordianImage")
				end)

				return
			end

			p9.performOpenYouTubeVideo(p13, "gameDetailsAccordianImage")
		end
	end
	function p9.onImageLoaded(p14) -- line: 184
		-- upvalues: p9 (copy)
		if p14 == 1 and (p9.state.firstImageLoaded == false and p9.isMounted) then
			p9:setState({
				firstImageLoaded = true
			})
		end
	end

	if p9.props.gameMediaFetchingStatus == RetrievalStatus.Done then
		p9.logMediaItemsContainVideo("gameDetailsAccordianImage")
	end

	if FFlagMediaAccordionAndFullTelemetry then
		function p9.onAccordionExpanded() -- line: 197
			-- upvalues: p9 (copy), MediaAccordionExpanded (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy)
			if p9.props.placeId then
				MediaAccordionExpanded(p9.props.eventIngest, "GameMediaAccordionView", p9.props.placeId, if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else {
					universeId = p9.props.universeId
				})
			end
		end
		function p9.onAccordionCollapsed() -- line: 212
			-- upvalues: p9 (copy), MediaAccordionCollapsed (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy)
			if p9.props.placeId then
				MediaAccordionCollapsed(p9.props.eventIngest, "GameMediaAccordionView", p9.props.placeId, if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else {
					universeId = p9.props.universeId
				})
			end
		end
	end
end
function v32.renderItem(p15, p16, p17, p18) -- line: 229
	-- upvalues: Roact (copy), GameMediaItem (copy), GameMediaImageType (copy), Functional (copy)
	local GameMediaAccordion = p15.props.appTheme.GameMediaAccordion
	local BackgroundColor = GameMediaAccordion.Item.BackgroundColor
	local ItemBackgroundTransparency = GameMediaAccordion.Item.BackgroundTransparency
	local VideoIconColor = GameMediaAccordion.VideoIconColor
	local imageId = p16.imageId

	return Roact.createElement(GameMediaItem, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = BackgroundColor,
		BackgroundTransparency = ItemBackgroundTransparency,
		Image = imageId,
		ImageTransparency = p17,
		isVideo = p16.mediaType == GameMediaImageType.YouTubeVideo,
		videoIconColor = VideoIconColor,
		animationSettings = p18,
		onImageLoaded = function() -- line: 247
			-- upvalues: Functional (copy), p15 (copy), p16 (copy)
			local v99 = Functional.Find(p15.props.gameMediaEntries, p16)

			p15.onImageLoaded(v99)
		end,
		onActivated = function() -- line: 251
			-- upvalues: p15 (copy), p16 (copy)
			p15.openItem(p16)
		end
	})
end
function v32.render(p19) -- line: 257
	-- upvalues: Roact (copy), AccordionView (copy), GenericIconButton (copy), FFlagMediaAccordionAndFullTelemetry (copy)
	local GameMediaAccordion = p19.props.appTheme.GameMediaAccordion
	local gameMediaEntries = p19.props.gameMediaEntries
	local propsLayoutOrder = p19.props.LayoutOrder
	local width = p19.props.width
	local v65 = p19.state.firstImageLoaded and GameMediaAccordion.FakeItem.Loaded or GameMediaAccordion.FakeItem.Loading

	if #gameMediaEntries > 0 then
		return Roact.createElement(AccordionView, {
			collapseButtonSize = 44,
			maxItemsInCompactView = 3,
			items = gameMediaEntries,
			itemWidth = width,
			itemHeight = width * 0.5611940298507463,
			renderItem = function(...) -- line: 271
				-- upvalues: p19 (copy)
				return p19:renderItem(...)
			end,
			placeholderColor = v65.Color,
			placeholderBaseTransparency = v65.BaseTransparency,
			renderCollapseButton = function(p20) -- line: 277
				-- upvalues: Roact (copy), GenericIconButton (copy)
				return Roact.createElement(GenericIconButton, {
					iconImage = "LuaApp/icons/GameDetails/collapse",
					withNewThemeProvider = true,
					Size = UDim2.new(1, 0, 1, 0),
					iconSize = UDim2.new(0, 36, 0, 36),
					onActivated = p20
				})
			end,
			LayoutOrder = propsLayoutOrder,
			onExpand = if not FFlagMediaAccordionAndFullTelemetry then nil else p19.onAccordionExpanded,
			onCollapse = if not FFlagMediaAccordionAndFullTelemetry then nil else p19.onAccordionCollapsed
		})
	end

	return nil
end
function v32.didUpdate(p21, p22, _) -- line: 296
	-- upvalues: LoadableImage (copy), RetrievalStatus (copy)
	if p22.firstImageId ~= p21.props.firstImageId then
		local v69 = LoadableImage.isLoaded(p21.props.firstImageId)

		if v69 ~= p21.state.firstImageLoaded then
			p21:setState({
				firstImageLoaded = v69
			})
		end
	end

	if p22.gameMediaFetchingStatus ~= RetrievalStatus.Done and p21.props.gameMediaFetchingStatus == RetrievalStatus.Done then
		p21.logMediaItemsContainVideo("gameDetailsAccordianImage")
	end
end
function v32.didMount(p24) -- line: 314
	p24.isMounted = true
end
function v32.willUnmount(p25) -- line: 318
	p25.isMounted = false
end

local v33 = withTheme_DEPRECATED(v32)
local v34 = RoactRodux.connect(function(p26, p27) -- line: 324
	-- upvalues: ApiFetchGameMedia (copy), v31 (copy), Roact (copy)
	local showVideoThumbnails = p27.showVideoThumbnails
	local v75 = ApiFetchGameMedia.GetFetchingStatus(p26, p27.universeId)
	local v76 = v31(p26.GameMedia[p27.universeId], 10, p27.placeId, v75, showVideoThumbnails)
	local None = Roact.None

	if v76 ~= nil and v76[1] ~= nil then
		None = v76[1].imageId
	end

	return {
		gameMediaEntries = v76,
		gameMediaFetchingStatus = v75,
		firstImageId = None
	}
end, function(p28) -- line: 348
	-- upvalues: OpenCentralOverlayForLeaveRobloxAlert (copy), OpenYouTubeVideo (copy)
	return {
		openLeaveRobloxAlertUIBlox = function(p29) -- line: 350
			-- upvalues: p28 (copy), OpenCentralOverlayForLeaveRobloxAlert (copy)
			p28(OpenCentralOverlayForLeaveRobloxAlert(p29))
		end,
		openYouTubeVideo = function(p30, p31, p32, p33, p34, p35, p36) -- line: 353
			-- upvalues: p28 (copy), OpenYouTubeVideo (copy)
			return p28(OpenYouTubeVideo(p30, p31, p32, p33, p34, p35, p36))
		end
	}
end)(v33)
local v35 = RoactServices.connect({
	guiService = AppGuiService,
	eventIngest = AppEventIngestService
})(v34)

return (RoactAppPolicy.connect(function(p37, _) -- line: 382
	return {
		showYouTubeAgeAlert = p37.getShowYouTubeAgeAlert(),
		showVideoThumbnails = p37.getShowVideoThumbnails()
	}
end)(v35))
