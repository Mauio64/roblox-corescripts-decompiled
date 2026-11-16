local generateStringId = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/AppCommonLib").GenerateStringId

local PlaceInfoModel = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Models/PlaceInfoModel")

local v5 = {
	mock = function()
		local v6 = PlaceInfoModel.new()

		v6.builder = "builder"
		v6.builderId = generateStringId()
		v6.description = "description"
		v6.imageToken = generateStringId()
		v6.isPlayable = true
		v6.name = "name"
		v6.placeId = generateStringId()
		v6.price = 0
		v6.reasonProhibited = nil
		v6.universeId = generateStringId()
		v6.universeRootPlaceId = generateStringId()
		v6.url = "url"

		return v6
	end
}

setmetatable(v5, { __index = PlaceInfoModel })

return v5
