local module = require("@luauforge/bundled/dzz")

local module2 = require("@luauforge/bundled/dzA")
local module3 = require("@luauforge/bundled/dzC")

local module4 = require("@luauforge/bundled/dzD")

return function(p2, data)
	local v5 = p2 or { topBarHeight = module4.TOP_BAR_SIZE, statusBarHeight = 0 }

	assert(v5, "")

	if data.type == module2.name then
		if v5.topBarHeight == data.topBarHeight then
			return v5
		end

		local v6 = { topBarHeight = data.topBarHeight }

		return (module.JoinDictionaries(v5, v6))
	end

	if data.type == module3.name then
		local v6 = { statusBarHeight = data.statusBarHeight }

		v5 = module.JoinDictionaries(v5, v6)
	end

	return v5
end
