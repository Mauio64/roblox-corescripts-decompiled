local TransferLocaleFormat = {}

function TransferLocaleFormat.substituteAmount(value: string, p: string)
	local v, _ = string.gsub(value, "{amount}", (tostring(p)))
	return v
end

function TransferLocaleFormat.substituteReceiverNotAllowed(value: string, p: string)
	local v = tostring(p)
	local v2, _ = string.gsub(value, "{userName}", v)
	local v3, _ = string.gsub(v2, "{username}", v)
	return v3
end

function TransferLocaleFormat.substituteUsername(value: string, p: string)
	local v, _ = string.gsub(value, "{username}", (tostring(p)))
	return v
end

function TransferLocaleFormat.substituteMinAmount(value: string, p: string)
	local v, _ = string.gsub(value, "{minAmount}", (tostring(p)))
	return v
end

function TransferLocaleFormat.substituteMaxAmount(value: string, p: string)
	local v, _ = string.gsub(value, "{maxAmount}", (tostring(p)))
	return v
end

return TransferLocaleFormat
