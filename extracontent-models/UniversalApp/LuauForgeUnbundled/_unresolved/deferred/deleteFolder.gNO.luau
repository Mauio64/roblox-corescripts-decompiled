local module = require("@luauforge/deferred/gNH")
require("@luauforge/deferred/gNI")

local module2 = require("@luauforge/deferred/gNJ")

local fetch = module.fetch
local asPromise = module.asPromise

local function deleteFolder(p2, p3)
	return asPromise((fetch({
		method = "DELETE",
		url = module2.folderUrl(p2),
		analyticsKey = "avatar-folders.delete",
		network = p3,
		decode = function(p4): boolean
			return true
		end
	})))
end

return deleteFolder
