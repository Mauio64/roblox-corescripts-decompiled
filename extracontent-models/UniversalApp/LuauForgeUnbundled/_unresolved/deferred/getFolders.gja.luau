local module = require("@luauforge/deferred/gjb")
require("@luauforge/deferred/gjc")

require("@luauforge/deferred/giX")
local module2 = require("@luauforge/deferred/gjd")
local module3 = require("@luauforge/deferred/gjf")

local fetch = module.fetch
local asPromise = module.asPromise

local function getFolders(p2)
	return asPromise((fetch({
		method = "GET",
		url = module2.foldersUrl(),
		analyticsKey = "avatar-folders.get",
		network = p2,
		decode = function(p3)
			local result = {}

			if p3 ~= nil and p3.folders ~= nil then
				for k, folder in p3.folders do
					table.insert(result, module3(folder))
				end
			end

			return result
		end
	})))
end

return getFolders
