local parent = script.Parent.Parent

local Signals = require(parent.Signals)

local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local createSignalMap = CoreScriptsRoactCommon.Utilities.createSignalMap

local createRBXEventSignal = require(script.Parent.createRBXEventSignal)
local isValidStat = require(script.Parent.isValidStat)
local getScoreValue = require(script.Parent.getScoreValue)
require(script.Parent.LeaderboardStoreTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagPlayerListFixLeaderstatsStacking = SharedFlags.FFlagPlayerListFixLeaderstatsStacking

local _ = {
	PlayerChildAdded = "PlayerChildAdded",
	PlayerChildRemoved = "PlayerChildRemoved",
	LeaderstatNameChanged = "LeaderstatNameChanged",
	StatChanged = "StatChanged",
	StatChildAdded = "StatChildAdded",
	StatChildRemoved = "StatChildRemoved"
}

local function createPlayerStore(instance, callback, callback2, callback3, callback4, callback5)
	local v = {}
	local v2 = {}

	local signal, v3 = Signals.createSignal(0)
	local signalMap = createSignalMap()
	local team = "Neutral"
	local playerEntry = { order = signal, stats = signalMap }

	local function getPlayerTeam() -- 1 equivalent call inferred from this helper
		return instance.Team or "Neutral"
	end

	local function addStatConnection(name: string, p: string, p2) -- 3 equivalent calls inferred from this helper
		if v2[name] == nil then
			v2[name] = {}
		end

		v2[name][p] = p2
	end

	local function _removeStatConnection(p: string, p2: string)
		local v4 = v2[p]

		if v4 == nil then
			return
		end

		local connection = v4[p2]

		if connection then
			if connection.Disconnect then
				connection:Disconnect()
			end

			v4[p2] = nil
		end
	end

	local function onStatAdded(child)
		local value = child.Value
		local rbxEventSignal, connection = createRBXEventSignal(child.Changed, value)
		local computed = Signals.createComputed(function(p)
			return getScoreValue(rbxEventSignal(p))
		end)

		callback(child)

		signalMap.setData(child.Name, computed, false)

		local effect = Signals.createEffect(function(p)
			computed(p)
			callback3(team, child.Name)
			callback4(team, child.Name)
		end)

		addStatConnection(child.Name, "StatChanged", { -- inferred equivalent call
			Disconnect = function()
				effect()
				connection:Disconnect()
			end
		})

		local childAddedConnection = child.ChildAdded:Connect(function()
			callback(child)
		end)
		addStatConnection(child.Name, "StatChildAdded", childAddedConnection) -- inferred equivalent call

		local childRemovedConnection = child.ChildRemoved:Connect(function()
			callback(child)
		end)
		addStatConnection(child.Name, "StatChildRemoved", childRemovedConnection) -- inferred equivalent call
	end

	local function onStatRemoved(child)
		local v4 = v2[child.Name]

		if v4 == nil then
			return
		end

		for _, connection in pairs(v4) do
			if connection.Disconnect then
				connection:Disconnect()
			end
		end

		v2[child.Name] = nil
		signalMap.removeData(child.Name, false)
		callback2(child)
	end

	local function leaderstatsAdded(instance2)
		local childAddedConnection = instance2.ChildAdded:Connect(function(child)
			if isValidStat(child) then
				onStatAdded(child)
			end
		end)
		v.leaderstatsChildAdded = childAddedConnection

		local childRemovedConnection = instance2.ChildRemoved:Connect(function(child)
			if isValidStat(child) then
				onStatRemoved(child)
			end
		end)
		v.leaderstatsChildRemoved = childRemovedConnection

		local children = instance2:GetChildren()

		for _, child in ipairs(children) do
			if isValidStat(child) then
				onStatAdded(child)
			end
		end
	end

	local function onPlayerChildAdded(child)
		local v4 = child.Name == "leaderstats"
		local v5 = child:IsA("ValueBase") or child:IsA("Folder") or child:IsA("Model")

		if not (v4 or v5) then
			return
		end

		local changedConnection = child.Changed:Connect(function(p)
			if p == "Name" and child.Name == "leaderstats" then
				leaderstatsAdded(child)
			end
		end)
		v.LeaderstatNameChanged = changedConnection

		if child.Name == "leaderstats" then
			leaderstatsAdded(child)
		end
	end

	local function onPlayerChildRemoved(child)
		if child.Name == "leaderstats" then
			local children = child:GetChildren()

			for _, child2 in ipairs(children) do
				if isValidStat(child2) then
					onStatRemoved(child2)
				end
			end

			if FFlagPlayerListFixLeaderstatsStacking then
				callback5()
			end
		end

		callback4(team)
	end

	local function connectPlayerEvents()
		local childAddedConnection = instance.ChildAdded:Connect(function(child)
			onPlayerChildAdded(child)
		end)
		v.PlayerChildAdded = childAddedConnection

		local childRemovedConnection = instance.ChildRemoved:Connect(function(child)
			onPlayerChildRemoved(child)
		end)
		v.PlayerChildRemoved = childRemovedConnection

		local leaderstats = instance:FindFirstChild("leaderstats")

		if leaderstats then
			leaderstatsAdded(leaderstats)
			return
		end

		for _, child in ipairs(instance:GetChildren()) do
			onPlayerChildAdded(child)
		end
	end

	team = getPlayerTeam() -- inferred equivalent call
	connectPlayerEvents()

	return {
		getPlayer = function()
			return instance
		end,
		getPlayerEntry = function()
			return playerEntry
		end,
		getStatValue = function(p: string, p2)
			local data = signalMap.getData(p, false)

			if data then
				return data(p2)
			end

			return nil
		end,
		getTeam = function()
			return team
		end,
		setOrder = function(p: number)
			v3(p)
		end,
		setTeam = function(p)
			team = p
		end,
		destroy = function()
			for _, v4 in pairs(v2) do
				for _, connection in pairs(v4) do
					if connection.Disconnect then
						connection:Disconnect()
					end
				end
			end

			v2 = {}

			for _, connection in pairs(v) do
				if connection.Disconnect then
					connection:Disconnect()
				end
			end

			v = {}
		end
	}
end

return createPlayerStore
