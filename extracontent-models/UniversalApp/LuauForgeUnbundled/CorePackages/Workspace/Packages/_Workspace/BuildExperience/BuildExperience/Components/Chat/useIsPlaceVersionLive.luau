local PlaceVersionHistory = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PlaceVersionHistory")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local function useIsPlaceVersionLive(p2, p3): boolean
	local placeVersionHistoryStore = PlaceVersionHistory.getPlaceVersionHistoryStore()

	if p3 == nil then
		p2 = nil
	end

	local v5 = React.useMemo(function()
		if p2 == nil then
			return (Signals.createSignal(nil))
		end

		return placeVersionHistoryStore.getLiveVersion(p2).data
	end, { p2, placeVersionHistoryStore })
	local v6 = SignalsReact.useSignalState(v5)

	React.useEffect(function()
		if p2 ~= nil then
			placeVersionHistoryStore.fetchLiveVersion(p2)
		end
	end, { p2, placeVersionHistoryStore })

	local placeVersion = if v6 ~= nil then v6.placeVersion else nil
	return p3 ~= nil and placeVersion ~= nil and tonumber(placeVersion.version) == p3
end

return useIsPlaceVersionLive
