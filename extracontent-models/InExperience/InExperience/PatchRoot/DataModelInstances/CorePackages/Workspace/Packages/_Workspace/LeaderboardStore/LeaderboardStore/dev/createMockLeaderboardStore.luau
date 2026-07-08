local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)
local createSignalMap = require(ParentParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap

require(ParentParent.LeaderboardStoreTypes)

local function createMockLeaderboardStore() -- line: 19
	-- upvalues: Signals (copy), createSignalMap (copy)
	return function() -- line: 20
		-- upvalues: Signals (copy), createSignalMap (copy)
		Instance.new("Team").Name = "Neutral"

		local Team = Instance.new("Team")

		Team.Name = "Team 1"

		local Team2 = Instance.new("Team")

		Team2.Name = "Team 2"

		local t1 = {
			Name = "player1",
			Team = Team,
			UserId = math.random(1, 1234567890),
			leaderstats = {
				stat1 = {
					Value = 100
				},
				stat2 = {
					Value = 200
				}
			}
		}
		local t2 = {
			order = Signals.createSignal(1),
			stats = createSignalMap()
		}

		t2.stats.setData("stat1", Signals.createSignal(t1.leaderstats.stat1.Value), false)
		t2.stats.setData("stat2", Signals.createSignal(t1.leaderstats.stat2.Value), false)

		local t3 = {
			Name = "player2",
			Team = Team,
			UserId = math.random(1, 1234567890),
			leaderstats = {
				stat1 = {
					Value = 30
				},
				stat2 = {
					Value = 40
				}
			}
		}
		local t4 = {
			order = Signals.createSignal(2),
			stats = createSignalMap()
		}

		t4.stats.setData("stat1", Signals.createSignal(t3.leaderstats.stat1.Value), false)
		t4.stats.setData("stat2", Signals.createSignal(t3.leaderstats.stat2.Value), false)

		local t5 = {
			Name = "player3",
			Team = Team2,
			UserId = math.random(1, 1234567890),
			leaderstats = {
				stat1 = {
					Value = 500
				},
				stat2 = {
					Value = 600
				}
			}
		}
		local t6 = {
			order = Signals.createSignal(1),
			stats = createSignalMap()
		}

		t6.stats.setData("stat1", Signals.createSignal(t5.leaderstats.stat1.Value), false)
		t6.stats.setData("stat2", Signals.createSignal(t5.leaderstats.stat2.Value), false)

		local t7 = {
			Name = "player4",
			Team = Team2,
			UserId = math.random(1, 1234567890),
			leaderstats = {
				stat1 = {
					Value = 70
				},
				stat2 = {
					Value = 80
				}
			}
		}
		local t8 = {
			order = Signals.createSignal(2),
			stats = createSignalMap()
		}

		t8.stats.setData("stat1", Signals.createSignal(t7.leaderstats.stat1.Value), false)
		t8.stats.setData("stat2", Signals.createSignal(t7.leaderstats.stat2.Value), false)

		local t9 = {
			Name = "player5",
			UserId = math.random(1, 1234567890),
			leaderstats = {
				stat1 = {
					Value = 90
				},
				stat2 = {
					Value = 100
				}
			}
		}
		local t10 = {
			order = Signals.createSignal(1),
			stats = createSignalMap()
		}

		t10.stats.setData("stat1", Signals.createSignal(t9.leaderstats.stat1.Value), false)
		t10.stats.setData("stat2", Signals.createSignal(t9.leaderstats.stat2.Value), false)

		local u18 = createSignalMap()

		u18.setData(t1, t2, false)
		u18.setData(t3, t4, false)
		u18.setData(t5, t6, false)
		u18.setData(t7, t8, false)
		u18.setData(t9, t10, false)

		local u19 = createSignalMap()
		local u20 = createSignalMap()

		u20.setData("Neutral", {
			name = Signals.createSignal("Neutral"),
			color = Signals.createSignal(Color3.fromRGB(0, 0, 0)),
			order = Signals.createSignal(1),
			stats = createSignalMap(),
			players = createSignalMap()
		}, false)

		local v21 = u20.getData("Neutral", false)

		v21.players.setData(t9, t9.UserId, false)
		v21.stats.setData("stat1", Signals.createSignal(t9.leaderstats.stat1.Value), false)
		v21.stats.setData("stat2", Signals.createSignal(t9.leaderstats.stat2.Value), false)
		u20.setData(Team, {
			name = Signals.createSignal("Team 1"),
			color = Signals.createSignal(Color3.fromRGB(255, 0, 0)),
			order = Signals.createSignal(2),
			stats = createSignalMap(),
			players = createSignalMap()
		}, false)

		local v22 = u20.getData(Team, false)

		v22.players.setData(t1, t1.UserId, false)
		v22.players.setData(t3, t3.UserId, false)
		v22.stats.setData("stat1", Signals.createSignal(t1.leaderstats.stat1.Value + t3.leaderstats.stat1.Value), false)
		v22.stats.setData("stat2", Signals.createSignal(t1.leaderstats.stat2.Value + t3.leaderstats.stat2.Value), false)
		u20.setData(Team2, {
			name = Signals.createSignal("Team 2"),
			color = Signals.createSignal(Color3.fromRGB(0, 255, 0)),
			order = Signals.createSignal(3),
			stats = createSignalMap(),
			players = createSignalMap()
		}, false)

		local v23 = u20.getData(Team2, false)

		v23.players.setData(t5, t5.UserId, false)
		v23.players.setData(t7, t7.UserId, false)
		v23.stats.setData("stat1", Signals.createSignal(t5.leaderstats.stat1.Value + t7.leaderstats.stat1.Value), false)
		v23.stats.setData("stat2", Signals.createSignal(t5.leaderstats.stat2.Value + t7.leaderstats.stat2.Value), false)

		local u24 = createSignalMap()

		u24.setData("Neutral", u20.getData("Neutral", false), false)
		u24.setData(Team, u20.getData(Team, false), false)
		u24.setData(Team2, u20.getData(Team2, false), false)

		return {
			getGameStatsList = function() -- line: 207
				-- upvalues: u19 (ref)
				return u19
			end,
			getTeamList = function() -- line: 210
				-- upvalues: u24 (ref)
				return u24
			end,
			getTeamPlayerList = function(p1, _) -- line: 213
				-- upvalues: u20 (ref)
				return u20.getData(p1, false).players
			end,
			getPlayerEntry = function(p3) -- line: 217
				-- upvalues: u18 (ref)
				return (u18.getData(p3, false))
			end,
			cleanUp = function() -- line: 220
				-- upvalues: u19 (ref), u24 (ref), u20 (ref), u18 (ref)
				u19 = nil
				u24 = nil
				u20 = nil
				u18 = nil
			end
		}
	end
end

return createMockLeaderboardStore
