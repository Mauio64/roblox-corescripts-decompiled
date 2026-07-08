local assetSource = require(script.Parent.assetSource)

require(script.Parent.types)

local default = assetSource.default
local t1 = {}

local function loadBackgroundAsset(n1: number) -- line: 14
	-- upvalues: t1 (ref), default (copy)
	local v6 = t1[n1]

	if v6 then
		return v6
	end

	local v7 = default(n1):catch(function(p1) -- line: 20
		-- upvalues: t1 (ref), n1 (copy)
		t1[n1] = nil
		error(p1)
	end)

	t1[n1] = v7

	return v7
end

return {
	load = loadBackgroundAsset,
	clearCache = function() -- line: 28
		-- upvalues: t1 (ref)
		t1 = {}
	end
}
