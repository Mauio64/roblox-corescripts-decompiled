local module = require("@luauforge/deferred/gNH")
require("@luauforge/deferred/gNI")

require("@luauforge/deferred/gND")
local module2 = require("@luauforge/deferred/gNJ")
local module3 = require("@luauforge/deferred/gNL")

local fetch = module.fetch
local asPromise = module.asPromise

local function createFolder(p2, p3)
	return asPromise((fetch({
		method = "POST",
		url = module2.foldersUrl(),
		analyticsKey = "avatar-folders.create",
		body = { name = p2 },
		network = p3,
		legacy = true,
		decode = function(p4)
			return module3(p4)
		end
	})))
end

return createFolder
