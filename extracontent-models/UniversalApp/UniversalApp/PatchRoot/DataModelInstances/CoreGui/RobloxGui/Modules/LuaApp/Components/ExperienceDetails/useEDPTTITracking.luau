local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local TimeToInteractiveTracker = require(CorePackages.Workspace.Packages.TimeToInteractiveTracker).TimeToInteractiveTracker
local v4 = if not TimeToInteractiveTracker.Hooks then nil else TimeToInteractiveTracker.Hooks.useTTIRenderAndMountedTracking
local FetchGamePlayButtonData = require(CorePackages.Workspace.Packages.GamePlayButton).FetchGamePlayButtonData
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local GameDetailTelemetry = require(CorePackages.Workspace.Packages.GameDetailTelemetry)
local EDPTTIConstants = GameDetailTelemetry.EDPTTIConstants
local EDPTTIManager = GameDetailTelemetry.EDPTTIManager
local useAssetFetchStatus = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useAssetFetchStatus
local MediaCarouselImageStatus = require(script.Parent.useFirstMediaCarouselImageUri).MediaCarouselImageStatus
local EDP_TTI_EVENT_NAME = EDPTTIConstants.EDP_TTI_EVENT_NAME

local function useEDPTTITracking(s1: string, s2: string?, p1) -- line: 26
	-- upvalues: React (copy), EDPTTIManager (copy), v4 (copy), EDP_TTI_EVENT_NAME (copy), useSelector (copy), FetchGamePlayButtonData (copy), MediaCarouselImageStatus (copy), useAssetFetchStatus (copy)
	local v17 = React.useRef(false)

	if not v17.current then
		v17.current = true
		EDPTTIManager.startTracking("Untracked")
		EDPTTIManager.setImplementation(s1)
	end

	if v4 then
		v4(EDP_TTI_EVENT_NAME)
	end

	local v18 = useSelector(function(p2) -- line: 42
		-- upvalues: s2 (copy), FetchGamePlayButtonData (copy)
		if s2 then
			return FetchGamePlayButtonData.IsLoading(p2, s2)
		end

		return true
	end)

	React.useEffect(function() -- line: 49
		-- upvalues: v18 (copy), s2 (copy), EDPTTIManager (copy)
		if not v18 and s2 then
			EDPTTIManager.trackFunctionallyReady()
		end
	end, {
		v18,
		s2
	})

	local url = p1.url
	local v20 = p1.status == MediaCarouselImageStatus.NotFound
	local v21 = useAssetFetchStatus(url) == Enum.AssetFetchStatus.Success or v20

	React.useEffect(function() -- line: 60
		-- upvalues: v18 (copy), v21 (copy), s2 (copy), EDPTTIManager (copy), v20 (copy)
		if not v18 and (v21 and s2) then
			EDPTTIManager.trackSurfaceReady({
				mediaImageFound = not v20
			})
		end
	end, {
		v18,
		v21,
		v20,
		s2
	})
end

return useEDPTTITracking
