local parent = script.Parent.Parent

local parent2 = parent.Parent

local Signals = require(parent2.Signals)

local CoreScriptsRoactCommon = require(parent2.CoreScriptsRoactCommon)
local createSignalMap = CoreScriptsRoactCommon.Utilities.createSignalMap

require(parent.LeaderboardStoreTypes)

local function createMockLeaderboardStore()
	return function()
		local team = Instance.new("Team")
		team.Name = "Neutral"
		local team1 = Instance.new("Team")
		team1.Name = "Team 1"
		local team2 = Instance.new("Team")
		team2.Name = "Team 2"

		local player1 = {
			Name = "player1",
			Team = team1,
			UserId = math.random(1, 1234567890),
			leaderstats = {
				stat1 = { Value = 100 },
				stat2 = { Value = 200 }
			}
		}

		local v = { order = Signals.createSignal(1), stats = createSignalMap() }

		v.stats.setData("stat1", Signals.createSignal(player1.leaderstats.stat1.Value), false)
		v.stats.setData("stat2", Signals.createSignal(player1.leaderstats.stat2.Value), false)

		local player2 = {
			Name = "player2",
			Team = team1,
			UserId = math.random(1, 1234567890),
			leaderstats = {
				stat1 = { Value = 30 },
				stat2 = { Value = 40 }
			}
		}

		local v2 = { order = Signals.createSignal(2), stats = createSignalMap() }

		v2.stats.setData("stat1", Signals.createSignal(player2.leaderstats.stat1.Value), false)
		v2.stats.setData("stat2", Signals.createSignal(player2.leaderstats.stat2.Value), false)

		local player3 = {
			Name = "player3",
			Team = team2,
			UserId = math.random(1, 1234567890),
			leaderstats = {
				stat1 = { Value = 500 },
				stat2 = { Value = 600 }
			}
		}

		local v3 = { order = Signals.createSignal(1), stats = createSignalMap() }

		v3.stats.setData("stat1", Signals.createSignal(player3.leaderstats.stat1.Value), false)
		v3.stats.setData("stat2", Signals.createSignal(player3.leaderstats.stat2.Value), false)

		local player4 = {
			Name = "player4",
			Team = team2,
			UserId = math.random(1, 1234567890),
			leaderstats = {
				stat1 = { Value = 70 },
				stat2 = { Value = 80 }
			}
		}

		local v4 = { order = Signals.createSignal(2), stats = createSignalMap() }

		v4.stats.setData("stat1", Signals.createSignal(player4.leaderstats.stat1.Value), false)
		v4.stats.setData("stat2", Signals.createSignal(player4.leaderstats.stat2.Value), false)

		local player5 = {
			Name = "player5",
			UserId = math.random(1, 1234567890),
			leaderstats = {
				stat1 = { Value = 90 },
				stat2 = { Value = 100 }
			}
		}

		local v5 = { order = Signals.createSignal(1), stats = createSignalMap() }

		v5.stats.setData("stat1", Signals.createSignal(player5.leaderstats.stat1.Value), false)
		v5.stats.setData("stat2", Signals.createSignal(player5.leaderstats.stat2.Value), false)

		local signalMap = createSignalMap()

		signalMap.setData(player1, v, false)
		signalMap.setData(player2, v2, false)
		signalMap.setData(player3, v3, false)
		signalMap.setData(player4, v4, false)
		signalMap.setData(player5, v5, false)

		local signalMap2 = createSignalMap()

		local signalMap3 = createSignalMap()
		signalMap3.setData("Neutral", {
			name = Signals.createSignal("Neutral"),
			color = Signals.createSignal(Color3.fromRGB(0, 0, 0)),
			order = Signals.createSignal(1),
			stats = createSignalMap(),
			players = createSignalMap()
		}, false)

		local data = signalMap3.getData("Neutral", false)
		data.players.setData(player5, player5.UserId, false)
		data.stats.setData("stat1", Signals.createSignal(player5.leaderstats.stat1.Value), false)
		data.stats.setData("stat2", Signals.createSignal(player5.leaderstats.stat2.Value), false)

		signalMap3.setData(team1, {
			name = Signals.createSignal("Team 1"),
			color = Signals.createSignal(Color3.fromRGB(255, 0, 0)),
			order = Signals.createSignal(2),
			stats = createSignalMap(),
			players = createSignalMap()
		}, false)

		local data2 = signalMap3.getData(team1, false)
		data2.players.setData(player1, player1.UserId, false)
		data2.players.setData(player2, player2.UserId, false)
		data2.stats.setData(
			"stat1",
			Signals.createSignal(player1.leaderstats.stat1.Value + player2.leaderstats.stat1.Value),
			false
		)

		data2.stats.setData(
			"stat2",
			Signals.createSignal(player1.leaderstats.stat2.Value + player2.leaderstats.stat2.Value),
			false
		)

		signalMap3.setData(team2, {
			name = Signals.createSignal("Team 2"),
			color = Signals.createSignal(Color3.fromRGB(0, 255, 0)),
			order = Signals.createSignal(3),
			stats = createSignalMap(),
			players = createSignalMap()
		}, false)

		local data3 = signalMap3.getData(team2, false)
		data3.players.setData(player3, player3.UserId, false)
		data3.players.setData(player4, player4.UserId, false)
		data3.stats.setData(
			"stat1",
			Signals.createSignal(player3.leaderstats.stat1.Value + player4.leaderstats.stat1.Value),
			false
		)

		data3.stats.setData(
			"stat2",
			Signals.createSignal(player3.leaderstats.stat2.Value + player4.leaderstats.stat2.Value),
			false
		)

		local signalMap4 = createSignalMap()
		signalMap4.setData("Neutral", signalMap3.getData("Neutral", false), false)
		signalMap4.setData(team1, signalMap3.getData(team1, false), false)
		signalMap4.setData(team2, signalMap3.getData(team2, false), false)

		return {
			getGameStatsList = function()
				return signalMap2
			end,
			getTeamList = function()
				return signalMap4
			end,
			getTeamPlayerList = function(p, _)
				return signalMap3.getData(p, false).players
			end,
			getPlayerEntry = function(p)
				return (signalMap.getData(p, false))
			end,
			cleanUp = function()
				signalMap2 = nil
				signalMap4 = nil
				signalMap3 = nil
				signalMap = nil
			end
		}
	end
end

return createMockLeaderboardStore
