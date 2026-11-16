local parent = script.Parent.Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local v = {}

local function createDefaultPlayerIconInfo(p: number) -- 1 equivalent call inferred from this helper
	return {
		isPlaceOwner = game.CreatorType == Enum.CreatorType.User and p == game.CreatorId,
		avatarIcon = nil,
		specialGroupIcon = nil
	}
end

local function getOrCreatePlayerSignal(p: number) -- 3 equivalent calls inferred from this helper
	if not v[p] then
		local signal, setter = createSignal(createDefaultPlayerIconInfo(p)) -- inferred equivalent call
		v[p] = { getter = signal, setter = setter }
	end

	return v[p]
end

local PlayerIconInfoStore = {}

function PlayerIconInfoStore.getPlayerIconInfoReactive(p: number)
	return getOrCreatePlayerSignal(p).getter -- inferred equivalent call
end

function PlayerIconInfoStore.setPlayerIconInfo(p: number, p2)
	getOrCreatePlayerSignal(p).setter(p2) -- inferred equivalent call
end

function PlayerIconInfoStore.addPlayer(p: number)
	local _playerSignal = getOrCreatePlayerSignal(p) -- inferred equivalent call
end

function PlayerIconInfoStore.removePlayer(p: number)
	v[p] = nil
end

function PlayerIconInfoStore.cleanUp()
	v = {}
end

return PlayerIconInfoStore
