local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent

require(scriptParentParent.Signals)

local createSignalMap = require(scriptParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap

require(scriptParent.LeaderboardStoreTypes)

local LeaderboardStore = require(scriptParent.LeaderboardStore)

local function createLeaderboardStore(p1, p2) -- line: 22
	-- upvalues: LeaderboardStore (copy), createSignalMap (copy)
	return function() -- line: 23
		-- upvalues: p1 (copy), p2 (copy), LeaderboardStore (copy), createSignalMap (copy)
		local v8 = if not p1 then game:GetService("Teams") else p1
		local v9 = if not p2 then game:GetService("Players") else p2
		local u10 = LeaderboardStore.new(v8, v9)

		return {
			getGameStatsList = function() -- line: 30
				-- upvalues: u10 (ref), createSignalMap (copy)
				if not u10 then
					return createSignalMap()
				end

				return u10:getGameStatsList()
			end,
			getTeamList = function() -- line: 36
				-- upvalues: u10 (ref), createSignalMap (copy)
				if not u10 then
					return createSignalMap()
				end

				return u10:getTeamList()
			end,
			getTeamPlayerList = function(p3, p4) -- line: 42
				-- upvalues: u10 (ref), createSignalMap (copy)
				if not u10 then
					return createSignalMap()
				end

				return u10:getTeamPlayerList(p3, p4)
			end,
			getPlayerEntry = function(p5, p6) -- line: 48
				-- upvalues: u10 (ref)
				if not u10 then
					return nil
				end

				return (u10:getPlayerEntry(p5, p6))
			end,
			cleanUp = function() -- line: 56
				-- upvalues: u10 (ref)
				u10:destroy()
				u10 = nil
			end
		}
	end
end

return createLeaderboardStore
