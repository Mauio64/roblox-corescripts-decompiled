local omniFeedService = require("@luauforge/bundled/dEe").OmniFeedService

local module = require("@luauforge/bundled/iqo")

local function makeOmniFeedService()
	local omniFeedService2 = omniFeedService.get()
	omniFeedService2:initialize(module)
	return omniFeedService2
end

return makeOmniFeedService
