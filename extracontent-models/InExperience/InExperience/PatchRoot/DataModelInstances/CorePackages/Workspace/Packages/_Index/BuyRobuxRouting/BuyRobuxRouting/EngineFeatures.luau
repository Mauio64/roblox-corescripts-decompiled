local EngineFeatures = {}

function EngineFeatures.isRobloxSubscriptionReadSupported()
	return game:GetEngineFeature("ReadHasRobloxSubscriptionLua")
end

function EngineFeatures.isFirstTimePurchaseConsentStorageSupported()
	return game:GetEngineFeature("FirstTimePurchaseConsentAcknowledgedStorageKey")
end

return EngineFeatures
