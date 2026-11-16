local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local getUniverseId = require(InExperienceSideSheet.Utils.getUniverseId)

local function useExperienceDetails()
	local universeId = getUniverseId()

	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			if not universeId then
				return { data = nil, isLoading = false }
			end

			local fetchGameInfo = DataHydration.Game.getGameInfoStore(p).getAndFetchGameInfo(universeId)

			return {
				data = fetchGameInfo.data(p),
				isLoading = fetchGameInfo.status(p) == DataHydration.DataStatus.NotReady
			}
		end)
	end, { universeId })

	local v2 = SignalsReact.useSignalState(v)
	local data = v2.data
	local name

	if data then
		name = data.name
	end

	local v3

	if data then
		v3 = data.creator
	end

	return name, v3, v2.isLoading
end

return useExperienceDetails
