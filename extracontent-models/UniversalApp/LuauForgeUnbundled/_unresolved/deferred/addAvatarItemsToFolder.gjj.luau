local module = require("@luauforge/deferred/gjb")
require("@luauforge/deferred/gjc")

require("@luauforge/deferred/giX")
local module2 = require("@luauforge/deferred/gjd")
local module3 = require("@luauforge/deferred/gjf")

local fetch = module.fetch
local asPromise = module.asPromise

local function addAvatarItemsToFolder(p2, p3, p4)
	return asPromise((fetch({
		method = "POST",
		url = module2.folderItemsUrl(p2),
		analyticsKey = "avatar-folders.add-items",
		body = { itemIds = p3 },
		network = p4,
		decode = function(p5)
			return module3(p5)
		end
	})))
end

return addAvatarItemsToFolder
