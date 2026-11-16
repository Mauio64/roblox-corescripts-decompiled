local parent = script:FindFirstAncestor("BuildExperience").Parent

local PlaceVersionHistory = require(parent.DataHydration.PlaceVersionHistory)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local function useIsPlaceVersionLive(p: number?, p2: number?): boolean
	local placeVersionHistoryStore = PlaceVersionHistory.getPlaceVersionHistoryStore()

	if p2 == nil then
		p = nil
	end

	local v = React.useMemo(function()
		if p == nil then
			return (Signals.createSignal(nil))
		end

		return placeVersionHistoryStore.getLiveVersion(p).data
	end, { p, placeVersionHistoryStore })
	local v2 = SignalsReact.useSignalState(v)

	React.useEffect(function()
		if p ~= nil then
			placeVersionHistoryStore.fetchLiveVersion(p)
		end
	end, { p, placeVersionHistoryStore })
	local placeVersion

	if v2 ~= nil then
		placeVersion = v2.placeVersion
	end

	return p2 ~= nil and placeVersion ~= nil and tonumber(placeVersion.version) == p2
end

return useIsPlaceVersionLive
