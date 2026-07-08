local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

game:GetService("RunService")

local t = require(CorePackages.Packages.t)
local v4 = t.strictInterface({
	eraseTimeout = t.number,
	testHarness = t.optional(t.strictInterface({
		players = t.union(t.instanceOf("Players"), t.interface({
			GetPlayers = t.callback,
			GetPlayerByUserId = t.callback,
			PlayerAdded = t.RBXScriptSignal,
			PlayerRemoving = t.RBXScriptSignal
		})),
		wait = t.callback
	}))
})
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 50
	-- upvalues: v4 (copy), Players (copy), t1 (copy)
	assert(v4(t2))

	local v7 = if t2.testHarness ~= nil then t2.testHarness.players else Players
	local v8 = if t2.testHarness ~= nil then t2.testHarness.wait else wait

	return (setmetatable({
		_playerCounter = 1,
		_eraseTimeout = t2.eraseTimeout,
		_trackedPii = {},
		_disambiguationIdentifiers = {},
		_waitFn = v8,
		_players = v7
	}, t1))
end
function t1._addPlayerToEraseMap(t3: {[any]: any}, p1) -- line: 75
	local v11 = t3._disambiguationIdentifiers[p1.UserId]

	if v11 == nil then
		v11 = t3._playerCounter
		t3._disambiguationIdentifiers[p1.UserId] = t3._playerCounter
		t3._playerCounter = t3._playerCounter + 1
	end

	t3._trackedPii[tostring(p1.UserId)] = string.format("UserId(%d)", v11)
	t3._trackedPii[tostring(p1.Name)] = string.format("UserName(%d)", v11)
	t3._trackedPii[tostring(p1.DisplayName)] = string.format("DisplayName(%d)", v11)
end
function t1._removePlayerFromEraseMap(t4: {[any]: any}, p2) -- line: 88
	t4._trackedPii[tostring(p2.UserId)] = nil
	t4._trackedPii[tostring(p2.Name)] = nil
	t4._trackedPii[tostring(p2.DisplayName)] = nil
end
function t1.startTracking(p3) -- line: 94
	for _, player in ipairs(p3._players:GetPlayers()) do
		p3:_addPlayerToEraseMap(player)
	end

	p3._playerAddedConnection = p3._players.PlayerAdded:Connect(function(player) -- line: 99
		-- upvalues: p3 (copy)
		p3:_addPlayerToEraseMap(player)
	end)
	p3._playerRemovingConnection = p3._players.PlayerRemoving:Connect(function(player) -- line: 103
		-- upvalues: p3 (copy)
		p3._waitFn(p3._eraseTimeout)

		if p3._players:GetPlayerByUserId(player.UserId) == nil then
			p3:_removePlayerFromEraseMap(player)
		end
	end)
end
function t1.stopTracking(p4) -- line: 116
	p4._playerAddedConnection:Disconnect()
	p4._playerRemovingConnection:Disconnect()
end
function t1.cleanPii(t5: {[any]: any}, s1: string) -- line: 121
	for k, v in pairs(t5._trackedPii) do
		s1 = string.gsub(s1, k, v)
	end

	return s1
end

return t1
