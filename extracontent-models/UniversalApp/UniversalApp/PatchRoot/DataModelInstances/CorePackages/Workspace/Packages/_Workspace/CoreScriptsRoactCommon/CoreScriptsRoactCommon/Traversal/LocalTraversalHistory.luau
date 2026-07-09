local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local EngineFeature = game:GetEngineFeature("UseTeleportedPlacesBackHistory2")
local Parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent
local Cryo = require(Parent.Cryo)
local Signals = require(Parent.Signals)
local Flags = require(script.Parent.Flags)
local FFlagUseLocalTraversalHistory = Flags.FFlagUseLocalTraversalHistory
local FFlagUseTeleportTraversalHistory = Flags.FFlagUseTeleportTraversalHistory
local t1 = {}

t1.__index = t1

function t1.new(s1: string?) -- line: 51
	-- upvalues: Signals (copy), t1 (copy), MemStorageService (copy), HttpService (copy)
	local t2 = {
		_connections = {},
		_historyKey = "",
		_history = {}
	}
	local v19, v20 = Signals.createSignal({})

	t2._historySignal = v19
	t2._setHistorySignal = v20

	if s1 == nil or s1 == "" then
		return (setmetatable(t2, t1))
	end

	local function initLocalHistory() -- line: 62
		-- upvalues: t2 (copy), s1 (copy), MemStorageService (copy), HttpService (copy)
		t2._historyKey = "TraversalHistory" .. s1

		local Item = MemStorageService:GetItem(t2._historyKey)

		if Item and Item ~= "" then
			local data = HttpService:JSONDecode(Item)

			if typeof(data) == "table" then
				t2._history = data
			end
		end

		table.insert(t2._history, 1, {
			universeId = tostring(game.GameId),
			placeId = tostring(game.PlaceId)
		})
		MemStorageService:SetItem(t2._historyKey, HttpService:JSONEncode(t2._history))
		t2._setHistorySignal(t2._history)
	end

	table.insert(t2._connections, game.Loaded:Connect(function() -- line: 82
		-- upvalues: initLocalHistory (copy)
		initLocalHistory()
	end))

	return (setmetatable(t2, t1))
end
function t1.addHistoryEntry(t3: {[any]: any}, t4: {[any]: any}) -- line: 90
	table.insert(t3._history, 1, t4)
	t3._setHistorySignal(t3._history)
end
function t1.addHistoryEntries(t5: {[any]: any}, t6: {[any]: any}) -- line: 95
	-- upvalues: Cryo (copy)
	t5._history = Cryo.List.join(t6, t5._history)
	t5._setHistorySignal(t5._history)
end

local function getNMostRecent(t7: {[any]: any}, n1: number?) -- line: 101
	if n1 == nil then
		return t7
	end

	local t8 = {}

	for i = 1, n1 do
		table.insert(t8, t7[i])
	end

	return t8
end

function t1.getHistory(t9: {[any]: any}, n2: number?) -- line: 112
	local _history = t9._history

	if n2 == nil then
		return _history
	end

	local t10 = {}

	for i = 1, n2 do
		table.insert(t10, _history[i])
	end

	return t10
end
function t1.getUniverseHistorySignal(t11: {[any]: any}, n3: number?) -- line: 115
	-- upvalues: Signals (copy)
	return Signals.createComputed(function(p1) -- line: 116
		-- upvalues: t11 (copy), n3 (copy)
		local v57 = t11._historySignal(p1)
		local v58 = n3

		if v58 == nil then
		else
			local t12 = {}

			for i = 1, v58 do
				table.insert(t12, v57[i])
			end

			v57 = t12
		end

		local t13 = {}

		for _, v63 in v57 do
			table.insert(t13, v63.universeId)
		end

		return t13
	end)
end
function t1.getUniverseHistory(t14: {[any]: any}, n4: number?) -- line: 127
	-- upvalues: FFlagUseTeleportTraversalHistory (copy), EngineFeature (copy), TeleportService (copy), Cryo (copy)
	local t15 = {}

	if FFlagUseTeleportTraversalHistory and EngineFeature then
		local v40 = TeleportService:TeleportedUniversesBackHistory()
		local v41 = Cryo.List.map(v40, tostring)

		if n4 == nil then
			return v41
		end

		local t16 = {}

		for i = 1, n4 do
			table.insert(t16, v41[i])
		end

		return t16
	end

	local _history = t14._history

	if n4 == nil then
	else
		local t17 = {}

		for i = 1, n4 do
			table.insert(t17, _history[i])
		end

		_history = t17
	end

	for _, v48 in _history do
		table.insert(t15, v48.universeId)
	end

	return t15
end
function t1.writeHistory(p2) -- line: 143
	-- upvalues: MemStorageService (copy), HttpService (copy)
	MemStorageService:SetItem(p2._historyKey, HttpService:JSONEncode(p2._history))
end
function t1.disconnect(p3) -- line: 147
	for _, v52 in p3._connections do
		v52:Disconnect()
	end

	p3._connections = {}
end

local function getDefaultId() -- line: 154
	-- upvalues: Players (copy)
	local v53 = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

	if v53 == nil or v53 <= 0 then
		return "Local"
	end

	return (tostring(v53))
end

if FFlagUseLocalTraversalHistory or FFlagUseTeleportTraversalHistory then
	local new = t1.new
	local v16 = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

	t1.default = new(if v16 ~= nil and not (v16 <= 0) then tostring(v16) else "Local")

	return t1
end

t1.default = t1.new("")

return t1
