local omniFeedService = require("@luauforge/bundled/dAZ").OmniFeedService

local module = require("@luauforge/bundled/ihP")

local function makeOmniFeedService()
	local omniFeedService2 = omniFeedService.get()
	omniFeedService2:initialize(module)
	return omniFeedService2
end

return makeOmniFeedService
