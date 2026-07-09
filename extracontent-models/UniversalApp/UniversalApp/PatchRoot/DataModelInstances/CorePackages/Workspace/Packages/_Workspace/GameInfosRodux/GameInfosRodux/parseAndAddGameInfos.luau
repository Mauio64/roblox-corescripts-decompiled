local GameInfosRodux = script:FindFirstAncestor("GameInfosRodux")
local GameInfosReducer = require(GameInfosRodux.GameInfosReducer)
local AddGames = require(GameInfosRodux.AddGames)
local GameInfosRoduxParent = GameInfosRodux.Parent
local tutils = require(GameInfosRoduxParent.tutils)
local ApiFetchGameIcons = require(GameInfosRoduxParent.GameIconRodux).GameIcons.ApiFetchGameIcons

require(GameInfosRoduxParent.DiscoveryTypes)

local FFlagLuaAppReduceGameIconFetches = require(GameInfosRoduxParent.SharedFlags).FFlagLuaAppReduceGameIconFetches

local function parseAndAddGameInfos(p1, p2, p3, p4, p5: ((...any) -> ...any)?, p6: ((...any) -> ...any)?) -- line: 11
	-- upvalues: GameInfosReducer (copy), tutils (copy), FFlagLuaAppReduceGameIconFetches (copy), AddGames (copy), ApiFetchGameIcons (copy)
	local v15 = p2:getState().Personalization[GameInfosReducer.key]
	local t1 = {}
	local t2 = {}

	for _, v19 in p3 do
		p4(v19):match(function(p7) -- line: 27
			-- upvalues: tutils (copy), v15 (copy), t1 (copy), FFlagLuaAppReduceGameIconFetches (copy), p6 (copy), t2 (copy), p5 (copy), v19 (copy)
			local universeId = p7.universeId

			if not tutils.shallowEqual(p7, v15[universeId]) then
				t1[universeId] = p7

				if not FFlagLuaAppReduceGameIconFetches or not p6 or p6(universeId) then
					table.insert(t2, universeId)
				end
			end

			if p5 then
				p5(v19, p7)
			end
		end):matchError(function(p8) -- line: 46
			warn(`parseAndAddGameInfos could not parse gameInfo: { p8 }`)
		end)
	end

	if next(t1) then
		p2:dispatch(AddGames(t1))
	end

	if #t2 > 0 then
		p2:dispatch(ApiFetchGameIcons(p1, t2))
	end
end

return parseAndAddGameInfos
