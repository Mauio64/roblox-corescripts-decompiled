local mutedError = require("@luauforge/bundled/dBv").mutedError
local module = require("@luauforge/bundled/dBw")

local module2 = require("@luauforge/bundled/dBs")

local strictInterface = module.strictInterface({
	guildedServerId = module.string,
	entityType = module.string,
	entityId = module.union(module.string, module.number)
})

return function(object, p2, data)
	local v5, v6 = strictInterface(data)

	if not v5 then
		mutedError(v6)
	end

	object:sendEventDeferred(p2, module2.EventNames.ClickCommunityLink, {
		guildedServerId = data.guildedServerId,
		entityType = data.entityType,
		entityId = data.entityId
	})
end
