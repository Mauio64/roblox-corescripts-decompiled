local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

return {
	useGameInfo = function(p2)
		local v5 = if p2 ~= nil then tostring(p2) else nil
		local v6 = React.useMemo(function()
			return Signals.createComputed(function(p3)
				if v5 == nil then
					return nil
				end

				return DataHydration.Game.getGameInfoStore(p3).getAndFetchGameInfo(v5).data(p3)
			end)
		end, { v5 })

		return SignalsReact.useSignalState(v6)
	end,
	isGameInfoReady = function(p2): boolean
		return p2 ~= nil and not p2.isUnavailable
	end,
	getGameInfoName = function(p2)
		if p2 == nil or p2.isUnavailable or typeof(p2.name) ~= "string" or p2.name == "" then
			return nil
		end

		return p2.name
	end,
	isTitleDescriptionReady = function(p2): boolean
		return (if p2 ~= nil and not p2.isUnavailable and typeof(p2.name) == "string" and p2.name ~= "" then p2.name else nil) ~= nil
	end
}
