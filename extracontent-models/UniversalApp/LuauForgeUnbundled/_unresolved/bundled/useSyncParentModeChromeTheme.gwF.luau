local module = require("@luauforge/bundled/gvb")

require("@luauforge/bundled/gvh")
require("@luauforge/bundled/gvc")
local module2 = require("@luauforge/bundled/gwD")
local module3 = require("@luauforge/bundled/gwE")
local module4 = require("@luauforge/bundled/gwG")
local module5 = require("@luauforge/bundled/gwI")
require("@luauforge/bundled/gwJ")

local function useSyncParentModeChromeTheme(p2, p3, p4, p5, p6, p7)
	local v5 = false

	local v6 = not (p2 or p3)

	if v6 then
		v6 = not (p4 == nil) and (p6 ~= nil or module2())
	end

	if v6 then
		if p7 ~= nil then
			p4 = p7.node
		end

		if module5 then
			v5 = not (p4.behavior == nil) and p4.behavior.parentFacing == true
		else
			v5 = module3(p4.type, p5)
		end
	end

	module.useLayoutEffect(function()
		module4(false).setIsActive(v5)
	end, { v5 })

	module.useLayoutEffect(function()
		return function()
			module4(false).setIsActive(false)
		end
	end, {})
end

return useSyncParentModeChromeTheme
