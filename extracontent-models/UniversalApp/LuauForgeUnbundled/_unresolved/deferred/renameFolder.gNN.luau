local module = require("@luauforge/deferred/gNH")
require("@luauforge/deferred/gNI")

require("@luauforge/deferred/gND")
local module2 = require("@luauforge/deferred/gNJ")
local module3 = require("@luauforge/deferred/gNL")

local fetch = module.fetch
local asPromise = module.asPromise

local function renameFolder(p2, p3, p4)
	return asPromise((fetch({
		method = "PATCH",
		url = module2.folderUrl(p2),
		analyticsKey = "avatar-folders.rename",
		body = { name = p3 },
		network = p4,
		legacy = true,
		decode = function(p5)
			return module3(p5)
		end
	})))
end

return renameFolder
