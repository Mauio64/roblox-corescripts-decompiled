local v5 = {}

function v5.new()
	return {}
end

function v5.fromJSON(data)
	local v6 = v5.new()

	v6.name = data.name
	v6.code = data.code
	v6.prefix = data.prefix
	v6.localizedName = data.localizedName
	v6.isDefault = data.isDefault

	return v6
end

return v5
