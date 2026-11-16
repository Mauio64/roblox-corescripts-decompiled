local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local engineFeature = game:GetEngineFeature("UseTeleportedPlacesBackHistory2")

local parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

local Flags = require(script.Parent.Flags)
local FFlagUseLocalTraversalHistory = Flags.FFlagUseLocalTraversalHistory
local FFlagUseTeleportTraversalHistory = Flags.FFlagUseTeleportTraversalHistory

local LocalTraversalHistory = {}
LocalTraversalHistory.__index = LocalTraversalHistory

function LocalTraversalHistory.new(p: string?)
	local v = {}
	v._connections = {}
	v._historyKey = ""
	v._history = {}
	local signal, setHistorySignal = Signals.createSignal({})
	v._historySignal = signal
	v._setHistorySignal = setHistorySignal

	if p == nil or p == "" then
		return (setmetatable(v, LocalTraversalHistory))
	end

	local function initLocalHistory()
		v._historyKey = "TraversalHistory" .. p
		local item = MemStorageService:GetItem(v._historyKey)

		if item and item ~= "" then
			local jsonDecode = HttpService:JSONDecode(item)

			if typeof(jsonDecode) == "table" then
				v._history = jsonDecode
			end
		end

		table.insert(v._history, 1, {
			universeId = tostring(game.GameId),
			placeId = tostring(game.PlaceId)
		})

		MemStorageService:SetItem(v._historyKey, HttpService:JSONEncode(v._history))
		v._setHistorySignal(v._history)
	end
	table.insert(v._connections, game.Loaded:Connect(function()
		initLocalHistory()
	end))

	return (setmetatable(v, LocalTraversalHistory))
end

function LocalTraversalHistory:addHistoryEntry(p)
	table.insert(self._history, 1, p)
	self._setHistorySignal(self._history)
end

function LocalTraversalHistory:addHistoryEntries(p)
	self._history = Cryo.List.join(p, self._history)
	self._setHistorySignal(self._history)
end

local function getNMostRecent(list, p: number?) -- 4 equivalent calls inferred from this helper
	if p == nil then
		return list
	end

	local result = {}

	for i = 1, p do
		table.insert(result, list[i])
	end

	return result
end

function LocalTraversalHistory:getHistory(p: number?)
	return getNMostRecent(self._history, p) -- inferred equivalent call
end

function LocalTraversalHistory:getUniverseHistorySignal(p: number?)
	return Signals.createComputed(function(p2)
		local nMostRecent = getNMostRecent(self._historySignal(p2), p) -- inferred equivalent call

		local universeIds = {}

		for _, v in nMostRecent do
			table.insert(universeIds, v.universeId)
		end

		return universeIds
	end)
end

function LocalTraversalHistory:getUniverseHistory(p: number?)
	local universeIds = {}

	if FFlagUseTeleportTraversalHistory and engineFeature then
		local teleportedUniversesBackHistory = TeleportService:TeleportedUniversesBackHistory()
		return getNMostRecent(Cryo.List.map(teleportedUniversesBackHistory, tostring), p) -- inferred equivalent call
	else
		local nMostRecent = getNMostRecent(self._history, p) -- inferred equivalent call

		for _, v in nMostRecent do
			table.insert(universeIds, v.universeId)
		end

		return universeIds
	end
end

function LocalTraversalHistory:writeHistory()
	MemStorageService:SetItem(self._historyKey, HttpService:JSONEncode(self._history))
end

function LocalTraversalHistory:disconnect()
	for _, connection in self._connections do
		connection:Disconnect()
	end

	self._connections = {}
end

local function getDefaultId() -- 1 equivalent call inferred from this helper
	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

	if userId == nil or userId <= 0 then
		return "Local"
	end

	return (tostring(userId))
end

if not (FFlagUseLocalTraversalHistory or FFlagUseTeleportTraversalHistory) then
	LocalTraversalHistory.default = LocalTraversalHistory.new("")

	return LocalTraversalHistory
end

LocalTraversalHistory.default = LocalTraversalHistory.new(getDefaultId()) -- inferred equivalent call
return LocalTraversalHistory
