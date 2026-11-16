local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildAdsNotificationRouting = SharedFlags.FFlagBuildAdsNotificationRouting
local SignalsReact = require(parent.SignalsReact)
local GetAdsCampaignDeepLinkStore = require(BuildExperience.Stores.GetAdsCampaignDeepLinkStore)
local AdCampaignEligibility = require(parent.DataHydration.AdCampaignEligibility)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

local function useAdsCampaignDeepLink(data)
	local requestStore = data.requestStore or GetAdsCampaignDeepLinkStore(false)
	local eligibilityStore = data.eligibilityStore or AdCampaignEligibility.getAdCampaignEligibilityStore(false)
	local sendEvent = data.sendEvent or sendBuildExperienceEvent
	local v = React.useMemo(function()
		return requestStore.createChat()
	end, { requestStore })
	local scopeRevision = SignalsReact.useSignalState(v.getScopeRevision)
	local ref = React.useRef(data.onOpen)
	ref.current = data.onOpen

	React.useEffect(function()
		if FFlagBuildAdsNotificationRouting then
			v.updateScope(data.universeId, data.sessionId, data.isPageVisible, data.canPresent)
		else
			v.updateScope(data.universeId, data.sessionId, data.isPageVisible)
		end
	end, { v, data.universeId, data.sessionId, data.isPageVisible, data.canPresent })

	React.useEffect(function()
		return v.connect(eligibilityStore, sendEvent, function(p)
			return ref.current(p)
		end)
	end, { v, eligibilityStore, sendEvent })

	return React.useMemo(function()
		return {
			scopeRevision = scopeRevision,
			clearPresentedRequest = v.clearPresentedRequest,
			getPresentedRequestId = v.getPresentedRequestId,
			startCreate = v.startCreate,
			finishCreate = v.finishCreate
		}
	end, { v, scopeRevision })
end

return useAdsCampaignDeepLink
