local module = require("@luauforge/deferred/eil")

local entityTypes = require("@luauforge/deferred/eiw").Analytics.Enums.EntityTypes

local module2 = require("@luauforge/deferred/eiy")
local module3 = require("@luauforge/deferred/eiD")

local v5 = require("@luauforge/deferred/eiI").Presence.PresenceStore.get()

local v6 = { skipFetch = true }

return function(p2, p3, p4)
	local v7 = module3()

	return module.useCallback(function(list)
		local v8 = ""
		local v9 = ""
		local v10 = ""
		local v11 = ""
		local v12 = ""
		local v13 = ""
		local v14 = ""

		for i, item in ipairs(list) do
			local v15 = p2[item]

			if not v15 then
				continue
			end

			local data = v5.GetPresenceByUserId(tostring(v15.id), v6).data(false)
			local userPresenceType = data and data.userPresenceType

			local v16 = v15.type == "Contact"
			v8 ..= (v15.id or v15.entityId or "") .. ","
			v9 ..= item .. ","
			v10 ..= (v15.rank or "") .. ","
			v11 ..= (v15.contextProps and v15.contextProps.contextType or "") .. ","
			v12 ..= (not v16 and "" or entityTypes.Contact) .. ","
			v13 ..= math.floor((item - 1) / p3) + 1 .. ","
			v14 ..= (userPresenceType and tostring(userPresenceType) or "") .. ","
		end

		v7(module2.UserTileImpression, {
			namespace = p4,
			targetUserId = v8,
			absolutePosition = v9,
			rank = v10,
			contextType = v11,
			entityType = v12,
			rowInSort = v13,
			presence = v14
		})
	end, { v7, p2, p3, p4 })
end
