local function isValidStat(instance)
	return instance:IsA("StringValue")
		or instance:IsA("IntValue")
		or instance:IsA("BoolValue")
		or instance:IsA("NumberValue")
		or instance:IsA("DoubleConstrainedValue")
		or instance:IsA("IntConstrainedValue")
end

return isValidStat
