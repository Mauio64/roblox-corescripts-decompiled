local parent = script:FindFirstAncestor("PlaceInfoRodux").Parent

local AppCommonLib = require(parent.AppCommonLib)
local GenerateStringId = AppCommonLib.GenerateStringId

local PlaceInfoModel = require(script.Parent.PlaceInfoModel)

local MockPlaceInfoModel = {
	mock = function()
		local v = PlaceInfoModel.new()

		v.builder = "builder"
		v.builderId = GenerateStringId()
		v.description = "description"
		v.imageToken = GenerateStringId()
		v.isPlayable = true
		v.name = "name"
		v.placeId = GenerateStringId()
		v.price = 0
		v.reasonProhibited = nil
		v.universeId = GenerateStringId()
		v.universeRootPlaceId = GenerateStringId()
		v.url = "url"

		return v
	end
}

setmetatable(MockPlaceInfoModel, { __index = PlaceInfoModel })

return MockPlaceInfoModel
