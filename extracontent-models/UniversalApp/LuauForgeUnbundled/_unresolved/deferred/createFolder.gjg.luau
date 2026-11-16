local module = require("@luauforge/deferred/gjb")
require("@luauforge/deferred/gjc")

require("@luauforge/deferred/giX")
local module2 = require("@luauforge/deferred/gjd")
local module3 = require("@luauforge/deferred/gjf")

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
