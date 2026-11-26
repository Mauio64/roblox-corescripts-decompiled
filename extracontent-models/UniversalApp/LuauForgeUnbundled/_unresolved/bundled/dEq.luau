local module = require("@luauforge/bundled/dEr")

local v5 = {}

function v5.new()
	return {
		communityId = "",
		name = "",
		description = "",
		visibility = module.Private
	}
end

function v5.mock(options)
	local v6 = options or {}

	local v7 = v5.new()
	v7.communityId = v6.communityId or "abcd" .. tostring(math.random(1000, 9999))
	v7.name = v6.name or "my community"
	v7.description = v6.description or "description of the community"
	v7.visibility = v6.visibility or module.Public

	return v7
end

function v5.fromJsonData(data)
	local v6 = v5.new()
	v6.communityId = data.communityId
	v6.name = data.name
	v6.description = data.description
	v6.visibility = data.visibility
	return v6
end

return v5
