local parent = script.Parent.Parent

local Signals = require(parent.Signals)

local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local createSignalMap = CoreScriptsRoactCommon.Utilities.createSignalMap

require(script.Parent.LeaderboardStoreTypes)

local function createTeamStore(data, _)
	local v = {}

	local signalMap = createSignalMap()
	local signalMap2 = createSignalMap()

	local v2 = {}
	local getName, getColor, getOrder

	if data == "Neutral" then
		local v3
		getName, v3 = Signals.createSignal("Neutral")
		local v4
		getColor, v4 = Signals.createSignal(BrickColor.White().Color)
		local v5
		getOrder, v5 = Signals.createSignal(1000)
	else
		local v3
		getName, v3 = Signals.createSignal(data.Name)
		local v4
		getColor, v4 = Signals.createSignal(data.TeamColor.Color)
		local v5
		getOrder, v5 = Signals.createSignal(data.ChildOrder)

		v.teamPropChanged = data.Changed:Connect(function(p: string)
			if p == "Name" then
				v3(data.Name)
			elseif p == "TeamColor" then
				v4(data.TeamColor.Color)
			elseif p == "ChildOrder" then
				v5(data.ChildOrder)
			end
		end)
	end

	local function updateStat(k: string, callback) -- 1 equivalent call inferred from this helper
		local computed = Signals.createComputed(function(p)
			local v3 = nil
			local allData = signalMap2.getAllData(p)

			if typeof(allData) ~= "table" then
				return v3
			end

			for k2, _ in pairs(allData) do
				local v4 = callback(k2, k, p)

				if not (v4 and type(v4) == "number") then
					continue
				end

				if v3 then
					v3 += v4
				else
					v3 = v4
				end
			end

			return v3
		end)

		signalMap.setData(k, computed, false)

		v2[k] = callback
	end

	local function updateAllStats() -- 2 equivalent calls inferred from this helper
		for k, v3 in pairs(v2) do
			updateStat(k, v3) -- inferred equivalent call
		end
	end

	local function removeStat(p: string)
		signalMap.removeData(p, false)

		v2[p] = nil
	end

	local function addPlayer(p)
		signalMap2.setData(p, p.UserId, false)
		updateAllStats() -- inferred equivalent call
	end

	local function removePlayer(p)
		signalMap2.removeData(p, false)
		updateAllStats() -- inferred equivalent call
	end

	local function destroy()
		for _, connection in pairs(v) do
			if connection.Disconnect then
				connection:Disconnect()
			end
		end

		v = {}
		v2 = {}
	end

	return {
		getName = getName,
		getColor = getColor,
		getOrder = getOrder,
		getStats = signalMap,
		getPlayers = signalMap2,
		updateStat = updateStat,
		removeStat = removeStat,
		addPlayer = addPlayer,
		removePlayer = removePlayer,
		destroy = destroy
	}
end

return createTeamStore
