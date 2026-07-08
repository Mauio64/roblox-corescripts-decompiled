local Parent = script:FindFirstAncestor("PlaceInfoRodux").Parent
local GenerateStringId = require(Parent.AppCommonLib).GenerateStringId
local PlaceInfoModel = require(script.Parent.PlaceInfoModel)
local t1 = {
	mock = function() -- line: 11
		-- upvalues: PlaceInfoModel (copy), GenerateStringId (copy)
		local v5 = PlaceInfoModel.new()

		v5.builder = "builder"
		v5.builderId = GenerateStringId()
		v5.description = "description"
		v5.imageToken = GenerateStringId()
		v5.isPlayable = true
		v5.name = "name"
		v5.placeId = GenerateStringId()
		v5.price = 0
		v5.reasonProhibited = nil
		v5.universeId = GenerateStringId()
		v5.universeRootPlaceId = GenerateStringId()
		v5.url = "url"

		return v5
	end
}

setmetatable(t1, {
	__index = PlaceInfoModel
})

return t1
