local module = require("@luauforge/deferred/gNH")
require("@luauforge/deferred/gNI")

require("@luauforge/deferred/gND")
local module2 = require("@luauforge/deferred/gNJ")
local module3 = require("@luauforge/deferred/gNL")

local fetch = module.fetch
local asPromise = module.asPromise

local function removeAvatarItemsFromFolder(p2, p3, p4)
	return asPromise((fetch({
		method = "POST",
		url = module2.folderItemsRemoveUrl(p2),
		analyticsKey = "avatar-folders.remove-items",
		body = { itemIds = p3 },
		network = p4,
		decode = function(p5)
			return module3(p5)
		end
	})))
end

return removeAvatarItemsFromFolder
