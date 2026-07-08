local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local GameDetailRoduxParent = GameDetailRodux.Parent
local ApiFetchGameIcons = require(GameDetailRoduxParent.GameIconRodux).GameIcons.ApiFetchGameIcons
local Functional = require(GameDetailRoduxParent.AppCommonLib).Functional
local GamesMultigetPlaceDetails = require(GameDetailRodux.GamesByPlaceId.GamesMultigetPlaceDetails)
local PlaceInfoModel = require(GameDetailRoduxParent.PlaceInfoRodux).Models.PlaceInfoModel
local ReceivedPlacesInfos = require(GameDetailRoduxParent.PlaceInfoRodux).Actions.ReceivedPlacesInfos
local ConvertUniverseIdToString = require(GameDetailRoduxParent.SharedFlags).ConvertUniverseIdToString

return function(p1, p2) -- line: 12
	-- upvalues: GamesMultigetPlaceDetails (copy), Functional (copy), PlaceInfoModel (copy), ConvertUniverseIdToString (copy), ReceivedPlacesInfos (copy), ApiFetchGameIcons (copy)
	return function(p3) -- line: 13
		-- upvalues: p2 (copy), GamesMultigetPlaceDetails (copy), p1 (copy), Functional (copy), PlaceInfoModel (copy), ConvertUniverseIdToString (copy), ReceivedPlacesInfos (copy), ApiFetchGameIcons (copy)
		if not p2 or #p2 == 0 then
			return
		end

		return GamesMultigetPlaceDetails(p1, p2):andThen(function(p4) -- line: 18
			-- upvalues: Functional (copy), PlaceInfoModel (copy), ConvertUniverseIdToString (copy), p3 (copy), ReceivedPlacesInfos (copy), ApiFetchGameIcons (copy), p1 (copy)
			local responseBody = p4.responseBody
			local t1 = {}
			local v15 = Functional.Map(responseBody, function(p5) -- line: 22
				-- upvalues: PlaceInfoModel (copy), ConvertUniverseIdToString (copy), t1 (copy)
				local v17 = PlaceInfoModel.fromWeb(p5)
				local v18 = ConvertUniverseIdToString(v17.universeId)

				table.insert(t1, v18)

				return v17
			end)

			p3:dispatch(ReceivedPlacesInfos(v15))

			if #t1 > 0 then
				p3:dispatch(ApiFetchGameIcons(p1, t1))
			end

			return v15
		end)
	end
end
