local assetSource = require(script.Parent.assetSource)
require(script.Parent.types)

local default = assetSource.default

local v = {}

local function loadBackgroundAsset(p: number)
	local v2 = v[p]

	if v2 then
		return v2
	end

	local v3 = default(p):catch(function(message)
		v[p] = nil
		error(message)
	end)
	v[p] = v3
	return v3
end

local function clearCache()
	v = {}
end

return { load = loadBackgroundAsset, clearCache = clearCache }
