local module = require("@luauforge/bundled/hwC")
local module2 = require("@luauforge/bundled/hwU")

local pageScopeFieldPageVisit = module.PageScopeFieldPageVisit

local function capturePageVisit()
	local v5 = module2()
	local v6 = v5.get(pageScopeFieldPageVisit)
	return function(): boolean
		return v6 ~= nil and v5.get(pageScopeFieldPageVisit) == v6
	end
end

return capturePageVisit
