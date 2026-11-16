local parent = script:FindFirstAncestor("BuildExperience").Parent

local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local function getGameInfoName(p) -- 1 equivalent call inferred from this helper
	if p == nil or p.isUnavailable or typeof(p.name) ~= "string" or p.name == "" then
		return nil
	end

	return p.name
end

local GameInfoUtils = {}

function GameInfoUtils.useGameInfo(p: number?)
	local v

	if p == nil then
		v = nil
	else
		v = tostring(p)
	end

	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			if v == nil then
				return nil
			end

			return DataHydration.Game.getGameInfoStore(p2).getAndFetchGameInfo(v).data(p2)
		end)
	end, { v })

	return SignalsReact.useSignalState(v2)
end

function GameInfoUtils.isGameInfoReady(p): boolean
	return p ~= nil and not p.isUnavailable
end

GameInfoUtils.getGameInfoName = getGameInfoName

function GameInfoUtils.isTitleDescriptionReady(p): boolean
	return getGameInfoName(p) ~= nil -- inferred equivalent call
end

return GameInfoUtils
