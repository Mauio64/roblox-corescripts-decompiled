local PlaceInfoModel = {}

function PlaceInfoModel.new()
	return {}
end

function PlaceInfoModel.fromWeb(options)
	local selected = options or {}
	selected.placeId = tostring(selected.placeId)

	return selected
end

return PlaceInfoModel
