local CollectibleInstance = {}

function CollectibleInstance.new()
	return {}
end

function CollectibleInstance.fromGetCollectibleItemInstances(data)
	return {
		["collectibleInstanceId"] = data.collectibleInstanceId,
		collectibleItemId = data.collectibleItemId,
		collectibleProductId = data.collectibleProductId,
		serialNumber = data.serialNumber,
		instanceState = data.instanceState,
		saleState = data.saleState,
		price = data.price
	}
end

return CollectibleInstance
