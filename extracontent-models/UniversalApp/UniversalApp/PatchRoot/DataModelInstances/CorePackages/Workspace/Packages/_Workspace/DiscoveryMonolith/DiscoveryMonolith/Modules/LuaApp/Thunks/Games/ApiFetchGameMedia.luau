local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local PerformFetch = require(DiscoveryMonolithParent.Http).PerformFetch
local Modules = DiscoveryMonolith.Modules
local GameMediaEntry = require(Modules.LuaApp.Models.GamesApi.GameMediaEntry)
local GamesGetMedia = require(Modules.LuaApp.Http.Requests.GamesApi.GamesGetMedia)
local UpdateGameMedia = require(Modules.LuaApp.Actions.Games.UpdateGameMedia)

return {
	KeyMapper = function(p1) -- line: 12
		return "luaapp.gamesapi.gamemedia." .. p1
	end,
	Fetch = function(p2, p3) -- line: 18
		-- upvalues: PerformFetch (copy), GamesGetMedia (copy), GameMediaEntry (copy), UpdateGameMedia (copy)
		assert(typeof(p3) == "string", "universeId should be a string")
		assert(#p3 > 0, "universeId should not be empty")

		local v11 = "luaapp.gamesapi.gamemedia." .. p3

		return PerformFetch.Single(v11, function(p4) -- line: 24
			-- upvalues: GamesGetMedia (copy), p2 (copy), p3 (copy), GameMediaEntry (copy), UpdateGameMedia (copy)
			return GamesGetMedia(p2, p3):andThen(function(p5) -- line: 25
				-- upvalues: GameMediaEntry (copy), p4 (copy), UpdateGameMedia (copy), p3 (copy)
				assert(typeof(p5.responseBody.data) == "table", "Malformed response from server, missing 'data' object")

				local t1 = {}

				for _, v in ipairs(p5.responseBody.data) do
					table.insert(t1, (GameMediaEntry.fromJsonData(v)))
				end

				if #t1 > 0 then
					p4:dispatch(UpdateGameMedia(p3, t1))
				end

				return t1
			end)
		end)
	end,
	GetFetchingStatus = function(p6, p7) -- line: 43
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p6, "luaapp.gamesapi.gamemedia." .. p7)
	end
}
