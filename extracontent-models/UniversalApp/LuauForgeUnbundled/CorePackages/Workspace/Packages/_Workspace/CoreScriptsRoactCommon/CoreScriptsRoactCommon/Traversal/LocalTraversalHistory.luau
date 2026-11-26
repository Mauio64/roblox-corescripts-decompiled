local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local engineFeature = game:GetEngineFeature("UseTeleportedPlacesBackHistory2")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Signals")

local Flags = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/Flags")
local fFlagUseLocalTraversalHistory = Flags.FFlagUseLocalTraversalHistory
local fFlagUseTeleportTraversalHistory = Flags.FFlagUseTeleportTraversalHistory

local class = {}
class.__index = class

function class.new(p2)
	local v5 = {}
	v5._connections = {}
	v5._historyKey = ""
	v5._history = {}
	local signal, v6 = Signals.createSignal({})
	v5._historySignal = signal
	v5._setHistorySignal = v6

	if p2 == nil or p2 == "" then
		return (setmetatable(v5, class))
	end

	local function initLocalHistory()
		v5._historyKey = "TraversalHistory" .. p2
		local item = MemStorageService:GetItem(v5._historyKey)

		if item and item ~= "" then
			local jsonDecode = HttpService:JSONDecode(item)

			if typeof(jsonDecode) == "table" then
				v5._history = jsonDecode
			end
		end

		table.insert(v5._history, 1, {
			universeId = tostring(game.GameId),
			placeId = tostring(game.PlaceId)
		})

		MemStorageService:SetItem(v5._historyKey, HttpService:JSONEncode(v5._history))
		v5._setHistorySignal(v5._history)
	end
	table.insert(v5._connections, game.Loaded:Connect(function()
		initLocalHistory()
	end))

	return (setmetatable(v5, class))
end

function class:addHistoryEntry(p3)
	table.insert(self._history, 1, p3)
	self._setHistorySignal(self._history)
end

function class:addHistoryEntries(p2)
	self._history = Cryo.List.join(p2, self._history)
	self._setHistorySignal(self._history)
end

local function getNMostRecent(list, p2)
	if p2 == nil then
		return list
	end

	local result = {}

	for i = 1, p2 do
		table.insert(result, list[i])
	end

	return result
end

function class:getHistory(p3)
	local history = self._history

	if p3 == nil then
		return history
	end

	local result = {}

	for i = 1, p3 do
		table.insert(result, history[i])
	end

	return result
end

function class:getUniverseHistorySignal(p3)
	return Signals.createComputed(function(p4)
		local historySignal = self._historySignal(p4)
		local v5 = p3
		local v6

		if v5 == nil then
			v6 = historySignal
		else
			v6 = {}

			for i = 1, v5 do
				table.insert(v6, historySignal[i])
			end
		end

		local universeIds = {}

		for k, v7 in v6 do
			table.insert(universeIds, v7.universeId)
		end

		return universeIds
	end)
end

function class:getUniverseHistory(p3)
	local universeIds = {}

	if fFlagUseTeleportTraversalHistory and engineFeature then
		local teleportedUniversesBackHistory = TeleportService:TeleportedUniversesBackHistory()
		local mapped = Cryo.List.map(teleportedUniversesBackHistory, tostring)

		if p3 == nil then
			return mapped
		end

		local result = {}

		for i = 1, p3 do
			table.insert(result, mapped[i])
		end

		return result
	else
		local history = self._history
		local v5

		if p3 == nil then
			v5 = history
		else
			v5 = {}

			for i = 1, p3 do
				table.insert(v5, history[i])
			end
		end

		for k, v6 in v5 do
			table.insert(universeIds, v6.universeId)
		end

		return universeIds
	end
end

function class:writeHistory()
	MemStorageService:SetItem(self._historyKey, HttpService:JSONEncode(self._history))
end

function class:disconnect()
	for k, connection in self._connections do
		connection:Disconnect()
	end

	self._connections = {}
end

local function getDefaultId()
	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

	if userId == nil or userId <= 0 then
		return "Local"
	end

	return (tostring(userId))
end

if not (fFlagUseLocalTraversalHistory or fFlagUseTeleportTraversalHistory) then
	class.default = class.new("")

	return class
end

local new = class.new
local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

class.default = new((userId == nil or userId <= 0) and "Local" or tostring(userId))
return class
