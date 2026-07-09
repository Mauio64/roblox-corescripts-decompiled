local Parent = script:FindFirstAncestor("CommunityLinks").Parent
local mutedError = require(Parent.Loggers).mutedError
local t = require(Parent.t)
local constants = require(script.Parent.Parent.constants)
local v5 = t.strictInterface({
	guildedServerId = t.string,
	entityType = t.string,
	entityId = t.union(t.string, t.number)
})

return function(p1, p2, p3) -- line: 15
	-- upvalues: v5 (copy), mutedError (copy), constants (copy)
	local v9, v10 = v5(p3)

	if not v9 then
		mutedError(v10)
	end

	p1:sendEventDeferred(p2, constants.EventNames.ClickCommunityLink, {
		guildedServerId = p3.guildedServerId,
		entityType = p3.entityType,
		entityId = p3.entityId
	})
end
