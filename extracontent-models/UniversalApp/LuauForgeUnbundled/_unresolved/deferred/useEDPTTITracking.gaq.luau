local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local timeToInteractiveTracker = require("@luauforge/bundled/fvo").TimeToInteractiveTracker
local useTTIRenderAndMountedTracking

if timeToInteractiveTracker.Hooks then
	useTTIRenderAndMountedTracking = timeToInteractiveTracker.Hooks.useTTIRenderAndMountedTracking
else
	useTTIRenderAndMountedTracking = nil
end

local fetchGamePlayButtonData = require("@luauforge/bundled/fWH").FetchGamePlayButtonData
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/bundled/dHp")
local edpttiConstants = module.EDPTTIConstants
local edpttiManager = module.EDPTTIManager
local fFlagEDPTTIParityDefinitions = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEDPTTIParityDefinitions

local useAssetFetchStatus = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useAssetFetchStatus
local mediaCarouselImageStatus = require("@luauforge/deferred/gar").MediaCarouselImageStatus

local EDP_TTI_EVENT_NAME = edpttiConstants.EDP_TTI_EVENT_NAME

local function useEDPTTITracking(p2, p3, p4)
	local ref = React.useRef(false)

	if not ref.current then
		ref.current = true
		edpttiManager.startTracking("Untracked")
		edpttiManager.setImplementation(p2)
	end

	if useTTIRenderAndMountedTracking then
		useTTIRenderAndMountedTracking(EDP_TTI_EVENT_NAME)
	end

	local v5 = useSelector(function(p5)
		if p3 then
			return fetchGamePlayButtonData.IsLoading(p5, p3)
		end

		return true
	end)

	React.useEffect(function()
		if not v5 and p3 then
			edpttiManager.trackFunctionallyReady()
		end
	end, { v5, p3 })

	local url = p4.url
	local v6 = p4.status == mediaCarouselImageStatus.NotFound
	local v7 = useAssetFetchStatus(url)
	local v8 = v7 == Enum.AssetFetchStatus.Success or v6

	if fFlagEDPTTIParityDefinitions then
		local v9 = v7 == Enum.AssetFetchStatus.Failure or v7 == Enum.AssetFetchStatus.TimedOut
		v8 = v8 or v9

		React.useEffect(function()
			if v8 and p3 then
				local v10 = v6 and "none"
					or v7 == Enum.AssetFetchStatus.Success and "success_image"
					or "failed_image"

				edpttiManager.trackFirstMediaResolved(v10)
			end
		end, { v8, v6, v7, p3 })
	end

	local useEffect = React.useEffect
	local function fn()
		if not v5 and v8 and p3 then
			local v9 = if fFlagEDPTTIParityDefinitions then v7 == Enum.AssetFetchStatus.Success else not v6

			edpttiManager.trackSurfaceReady({ mediaImageFound = v9 })
		end
	end

	useEffect(fn, {
		v5,
		v8,
		v6,
		if fFlagEDPTTIParityDefinitions then v7 else nil,
		p3
	})
end

return useEDPTTITracking
