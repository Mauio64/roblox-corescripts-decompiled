local array = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloLocalState/LuauPolyfill").Array

return function(options, options2)
	local v5 = options or {}
	local v6 = options2 or {}

	if #v6 == 0 then
		return v5
	end

	if #v5 == 0 then
		return v6
	end

	return array.concat(table.clone(v5), v6)
end
