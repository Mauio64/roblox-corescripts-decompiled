local TransferBenefitSource = { Free = "Free", RobloxSubscription = "RobloxSubscription" }

local v = { TransferBenefitSource.RobloxSubscription, TransferBenefitSource.Free }

local v2 = {
	robloxsubscription = TransferBenefitSource.RobloxSubscription,
	free = TransferBenefitSource.Free
}

function TransferBenefitSource.fromValue(value)
	if type(value) == "number" then
		return v[value]
	end

	if type(value) == "string" then
		return v2[string.lower(value)]
	end

	return nil
end

return TransferBenefitSource
