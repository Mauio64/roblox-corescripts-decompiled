local CountryCode = {}

function CountryCode.new()
	return {}
end

function CountryCode.fromJSON(data)
	local v = CountryCode.new()

	v.name = data.name
	v.code = data.code
	v.prefix = data.prefix
	v.localizedName = data.localizedName
	v.isDefault = data.isDefault

	return v
end

return CountryCode
