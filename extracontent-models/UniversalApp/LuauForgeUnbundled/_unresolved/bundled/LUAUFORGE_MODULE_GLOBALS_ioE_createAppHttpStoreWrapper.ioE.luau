local module = require("@luauforge/bundled/ggg")
local statusCodes = require("@game/CorePackages/Workspace/Packages/Http").StatusCodes

local module2 = require("@luauforge/bundled/ilT")
local module3 = require("@luauforge/bundled/ilU")

local instance = module.Instance

function LUAUFORGE_MODULE_GLOBALS_ioE_createAppHttpStoreWrapper(object, p2, p3)
	return instance._create({
		[statusCodes.UNAUTHORIZED] = function(p4)
			object:dispatch(module3(p2, p4))
		end,
		[statusCodes.FORBIDDEN] = function(p4)
			object:dispatch(module2(p2, p3, p4.config.Url))
		end
	})
end

return LUAUFORGE_MODULE_GLOBALS_ioE_createAppHttpStoreWrapper
