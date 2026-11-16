local parent = script.Parent

local parent2 = parent.Parent

require(parent2.Signals)

local CoreScriptsRoactCommon = require(parent2.CoreScriptsRoactCommon)
local createSignalMap = CoreScriptsRoactCommon.Utilities.createSignalMap

require(parent.LeaderboardStoreTypes)

local LeaderboardStore = require(parent.LeaderboardStore)

local function createLeaderboardStore(p, p2)
	return function()
		local v

		if p then
			v = p
		else
			v = game:GetService("Teams")
		end

		local v2

		if p2 then
			v2 = p2
		else
			v2 = game:GetService("Players")
		end

		local v3 = LeaderboardStore.new(v, v2)
		return {
			getGameStatsList = function()
				if v3 then
					return v3:getGameStatsList()
				end

				return createSignalMap()
			end,
			getTeamList = function()
				if v3 then
					return v3:getTeamList()
				end

				return createSignalMap()
			end,
			getTeamPlayerList = function(self, p3)
				if v3 then
					return v3:getTeamPlayerList(self, p3)
				end

				return createSignalMap()
			end,
			getPlayerEntry = function(self, p3)
				if v3 then
					return (v3:getPlayerEntry(self, p3))
				end

				return nil
			end,
			cleanUp = function()
				v3:destroy()
				v3 = nil
			end
		}
	end
end

return createLeaderboardStore
