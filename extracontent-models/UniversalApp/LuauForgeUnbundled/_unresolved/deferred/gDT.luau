local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

require("@game/CorePackages/Workspace/Packages/AppBlox")
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
require("@luauforge/bundled/gDL")

local gameDetailsEvents = require("@luauforge/bundled/dtb").Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents
local mediaGallerySwiped = gameDetailsEvents.MediaGallerySwiped
local mediaGalleryMediaChanged = gameDetailsEvents.MediaGalleryMediaChanged

local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService

local module = require("@luauforge/deferred/gDN")

local fFlagLuaAppEdpMediaGalleryRedesignIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignIxp

local fFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreviewIxp

local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview

local fFlagLuaAppEdpMediaGalleryRedesignTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignTelemetry

local fFlagLuaAppAddUniverseIdToGameDetailsEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddUniverseIdToGameDetailsEvents

local function MediaGallerySnappingFull(props)
	local v5 = useTokens()
	local v6 = useRoactService(appEventIngestService)

	local surface_0 = v5.Color.Surface.Surface_0

	local v7, v8 = React.useBinding(UDim2.fromOffset(0, 0))

	local function fn(p2)
		local x = p2.AbsoluteSize.X
		local v9 = p2.AbsoluteSize.Y

		local v10 = math.floor(v9 * (16 / 9))

		if x < v10 then
			v9 = math.floor(x / (16 / 9))
			v10 = x
		end

		v8(UDim2.fromOffset(v10, v9))
	end

	local v9

	if not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		local useCallback = React.useCallback
		local function fn2()
			if props.rootPlaceId then
				mediaGallerySwiped(
					v6,
					"MediaGallerySnappingFull",
					props.rootPlaceId,
					fFlagLuaAppAddUniverseIdToGameDetailsEvents and {
						universeId = props.universeId
					} or nil
				)
			end
		end
		local rootPlaceId = props.rootPlaceId

		local v11 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
		v9 = useCallback(fn2, { rootPlaceId, v6, v11 })
	end

	local v10

	if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		local useCallback = React.useCallback
		local function fn2(p2, p3, p4)
			if props.rootPlaceId then
				local rootPlaceId = props.rootPlaceId

				local v15 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
				mediaGalleryMediaChanged(v6, "MediaGallerySnappingFull", rootPlaceId, {
					imageAssetId = p2,
					videoAssetId = p3,
					autoAdvance = p4,
					universeId = v15
				})
			end
		end
		local rootPlaceId = props.rootPlaceId

		local v12 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
		v10 = useCallback(fn2, { rootPlaceId, v6, v12 })
	end

	local createElement = React.createElement
	local v12 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = surface_0.Color3,
		BackgroundTransparency = surface_0.Transparency,
		BorderSizePixel = 0,
		[React.Change.AbsoluteSize] = fn
	}

	local createElement2 = React.createElement
	local v15 = {
		Size = v7,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 0
	}

	local createElement3 = React.createElement
	local v18 = {
		items = props.items,
		itemPadding = 0,
		borderRadius = UDim.new(0, 0),
		onVideoPlayActivated = props.onVideoPlayActivated,
		onSwipe = 0,
		onMediaGalleryMediaChanged = 0,
		startIndex = 0,
		clipsNonCurrentItems = true,
		isFullscreen = true,
		onFullscreenToggleButtonActivated = 0,
		videoPlaybackCoordinator = 0,
		videoAnalytics = 0,
		universeId = 0,
		mediaGalleryRedesignEnabledIxp = 0,
		mediaGalleryVideoPreviewEnabledIxp = 0
	}

	if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		v9 = nil
	end

	v18.onSwipe = v9

	if not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		v10 = nil
	end

	v18.onMediaGalleryMediaChanged = v10

	v18.startIndex = props.startIndex

	v18.onFullscreenToggleButtonActivated = props.exitFullscreen

	local v19 = if fFlagLuaAppEdpMediaGalleryVideoPreview then props.videoPlaybackCoordinator else nil
	v18.videoPlaybackCoordinator = v19

	local v20 = if fFlagLuaAppEdpMediaGalleryVideoPreview then props.videoAnalytics else nil
	v18.videoAnalytics = v20
	v18.universeId = props.universeId

	local v21 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then props.mediaGalleryRedesignEnabledIxp else nil
	v18.mediaGalleryRedesignEnabledIxp = v21

	local v22 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then props.mediaGalleryVideoPreviewEnabledIxp else nil
	v18.mediaGalleryVideoPreviewEnabledIxp = v22
	return createElement("Frame", v12, {
		FullscreenMediaGallery = createElement2("Frame", v15, {
			MediaGallery = createElement3(module, v18)
		})
	})
end

return React.memo(MediaGallerySnappingFull)
