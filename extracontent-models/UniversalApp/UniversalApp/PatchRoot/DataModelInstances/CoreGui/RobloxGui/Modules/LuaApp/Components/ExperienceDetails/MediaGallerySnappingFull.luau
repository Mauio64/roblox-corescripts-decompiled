local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens

require(CorePackages.Workspace.Packages.AppBlox)

local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService

require(CorePackages.Workspace.Packages.VideoUtils)

local GameDetailsEvents = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents
local MediaGallerySwiped = GameDetailsEvents.MediaGallerySwiped
local MediaGalleryMediaChanged = GameDetailsEvents.MediaGalleryMediaChanged
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local MediaGallerySnapping = require(Modules.LuaApp.Components.ExperienceDetails.MediaGallerySnapping)
local FFlagLuaAppEdpMediaGalleryRedesignIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignIxp
local FFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreviewIxp
local FFlagLuaAppEdpMediaGalleryVideoPreview = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local FFlagLuaAppEdpMediaGalleryRedesignTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignTelemetry
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddUniverseIdToGameDetailsEvents

local function MediaGallerySnappingFull(t1: {[any]: any}) -- line: 52
	-- upvalues: useTokens (copy), useRoactService (copy), AppEventIngestService (copy), React (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), MediaGallerySwiped (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), MediaGalleryMediaChanged (copy), MediaGallerySnapping (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy)
	local v18 = useTokens()
	local v19 = useRoactService(AppEventIngestService)
	local Surface_0 = v18.Color.Surface.Surface_0
	local v21, v22 = React.useBinding(UDim2.fromOffset(0, 0))
	local v23 = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then React.useCallback(function() -- line: 77
		-- upvalues: t1 (copy), MediaGallerySwiped (copy), v19 (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy)
		if t1.rootPlaceId then
			MediaGallerySwiped(v19, "MediaGallerySnappingFull", t1.rootPlaceId, if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else {
				universeId = t1.universeId
			})
		end
	end, {
		t1.rootPlaceId,
		v19,
		if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
	}) else nil
	local v24 = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else React.useCallback(function(p1, p2, p3) -- line: 97
		-- upvalues: t1 (copy), MediaGalleryMediaChanged (copy), v19 (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy)
		if t1.rootPlaceId then
			MediaGalleryMediaChanged(v19, "MediaGallerySnappingFull", t1.rootPlaceId, {
				imageAssetId = p1,
				videoAssetId = p2,
				autoAdvance = p3,
				universeId = if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
			})
		end
	end, {
		t1.rootPlaceId,
		v19,
		if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
	})

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Surface_0.Color3,
		BackgroundTransparency = Surface_0.Transparency,
		BorderSizePixel = 0,
		[React.Change.AbsoluteSize] = function(p4) -- line: 60
			-- upvalues: v22 (copy)
			local AbsoluteSizeX = p4.AbsoluteSize.X
			local AbsoluteSizeY = p4.AbsoluteSize.Y
			local v28 = math.floor(AbsoluteSizeY * 1.7777777777777777)

			if AbsoluteSizeX < v28 then
				v28 = AbsoluteSizeX
				AbsoluteSizeY = math.floor(v28 / 1.7777777777777777)
			end

			v22(UDim2.fromOffset(v28, AbsoluteSizeY))
		end
	}, {
		FullscreenMediaGallery = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 0,
			Size = v21,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		}, {
			MediaGallery = React.createElement(MediaGallerySnapping, {
				itemPadding = 0,
				clipsNonCurrentItems = true,
				isFullscreen = true,
				items = t1.items,
				borderRadius = UDim.new(0, 0),
				onVideoPlayActivated = t1.onVideoPlayActivated,
				onSwipe = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then v23 else nil,
				onMediaGalleryMediaChanged = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else v24,
				startIndex = t1.startIndex,
				onFullscreenToggleButtonActivated = t1.exitFullscreen,
				videoPlaybackCoordinator = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else t1.videoPlaybackCoordinator,
				videoAnalytics = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else t1.videoAnalytics,
				universeId = t1.universeId,
				mediaGalleryRedesignEnabledIxp = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else t1.mediaGalleryRedesignEnabledIxp,
				mediaGalleryVideoPreviewEnabledIxp = if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else t1.mediaGalleryVideoPreviewEnabledIxp
			})
		})
	})
end

return React.memo(MediaGallerySnappingFull)
