local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local fFlagBuildAdsNotificationRouting = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildAdsNotificationRouting
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local GetAdsCampaignDeepLinkStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAdsCampaignDeepLinkStore")
local AdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignEligibility")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")

local function useAdsCampaignDeepLink(data)
	local requestStore = data.requestStore or GetAdsCampaignDeepLinkStore(false)
	local eligibilityStore = data.eligibilityStore or AdCampaignEligibility.getAdCampaignEligibilityStore(false)
	local sendEvent = data.sendEvent or sendBuildExperienceEvent
	local v5 = React.useMemo(function()
		return requestStore.createChat()
	end, { requestStore })
	local v6 = SignalsReact.useSignalState(v5.getScopeRevision)
	local ref = React.useRef(data.onOpen)
	ref.current = data.onOpen

	React.useEffect(function()
		if fFlagBuildAdsNotificationRouting then
			v5.updateScope(data.universeId, data.sessionId, data.isPageVisible, data.canPresent)
		else
			v5.updateScope(data.universeId, data.sessionId, data.isPageVisible)
		end
	end, { v5, data.universeId, data.sessionId, data.isPageVisible, data.canPresent })

	React.useEffect(function()
		return v5.connect(eligibilityStore, sendEvent, function(p2)
			return ref.current(p2)
		end)
	end, { v5, eligibilityStore, sendEvent })

	return React.useMemo(function()
		return {
			scopeRevision = v6,
			clearPresentedRequest = v5.clearPresentedRequest,
			getPresentedRequestId = v5.getPresentedRequestId,
			startCreate = v5.startCreate,
			finishCreate = v5.finishCreate
		}
	end, { v5, v6 })
end

return useAdsCampaignDeepLink
