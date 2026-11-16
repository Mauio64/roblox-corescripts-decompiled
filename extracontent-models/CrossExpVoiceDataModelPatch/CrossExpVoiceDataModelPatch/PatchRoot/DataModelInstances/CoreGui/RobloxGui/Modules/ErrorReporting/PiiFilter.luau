local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
game:GetService("RunService")

local t = require(CorePackages.Packages.t)

local strictInterface = t.strictInterface({
	eraseTimeout = t.number,
	testHarness = t.optional(t.strictInterface({
		players = t.union(
			t.instanceOf("Players"),
			t.interface({
				GetPlayers = t.callback,
				GetPlayerByUserId = t.callback,
				PlayerAdded = t.RBXScriptSignal,
				PlayerRemoving = t.RBXScriptSignal
			})
		),
		wait = t.callback
	}))
})

local PiiFilter = {}
PiiFilter.__index = PiiFilter

function PiiFilter.new(p)
	assert(strictInterface(p))
	local players

	if p.testHarness == nil then
		players = Players
	else
		players = p.testHarness.players
	end

	local waitFn

	if p.testHarness == nil then
		waitFn = wait
	else
		waitFn = p.testHarness.wait
	end

	return (setmetatable({
		_eraseTimeout = p.eraseTimeout,
		_trackedPii = {},
		_playerCounter = 1,
		_disambiguationIdentifiers = {},
		_waitFn = waitFn,
		_players = players
	}, PiiFilter))
end

function PiiFilter:_addPlayerToEraseMap(player)
	local v = self._disambiguationIdentifiers[player.UserId]

	if v == nil then
		v = self._playerCounter
		self._disambiguationIdentifiers[player.UserId] = self._playerCounter
		self._playerCounter += 1
	end

	self._trackedPii[tostring(player.UserId)] = string.format("UserId(%d)", v)
	self._trackedPii[tostring(player.Name)] = string.format("UserName(%d)", v)
	self._trackedPii[tostring(player.DisplayName)] = string.format("DisplayName(%d)", v)
end

function PiiFilter:_removePlayerFromEraseMap(player)
	self._trackedPii[tostring(player.UserId)] = nil
	self._trackedPii[tostring(player.Name)] = nil
	self._trackedPii[tostring(player.DisplayName)] = nil
end

function PiiFilter:startTracking()
	for _, v in ipairs(self._players:GetPlayers()) do
		self:_addPlayerToEraseMap(v)
	end

	self._playerAddedConnection = self._players.PlayerAdded:Connect(function(player)
		self:_addPlayerToEraseMap(player)
	end)

	self._playerRemovingConnection = self._players.PlayerRemoving:Connect(function(player)
		self._waitFn(self._eraseTimeout)

		if self._players:GetPlayerByUserId(player.UserId) == nil then
			self:_removePlayerFromEraseMap(player)
		end
	end)
end

function PiiFilter:stopTracking()
	self._playerAddedConnection:Disconnect()
	self._playerRemovingConnection:Disconnect()
end

function PiiFilter:cleanPii(value: string)
	for k, v in pairs(self._trackedPii) do
		value = string.gsub(value, k, v)
	end

	return value
end

return PiiFilter
