local module = require("@luauforge/bundled/hGq")

local llama = module.llama
local roduxUsers = module.RoduxUsers

local function userUpdatedFromUser(data)
	return roduxUsers.Actions.UserUpdated({
		id = data.id,
		username = data.name,
		displayName = data.displayName,
		hasVerifiedBadge = data.hasVerifiedBadge
	})
end

return function(p2, p3)
	local reduced = llama.List.reduce(p2.responseBody, function(p4, p5)
		return llama.List.reduce(p5.participants, function(p6, p7)
			local targetId = tostring(p7.targetId)

			if p6[targetId] or p3.byUserId[targetId] then
				return p6
			end

			local joined = llama.Dictionary.join(p7, { id = targetId })
			return llama.Dictionary.join(p6, {
				[targetId] = roduxUsers.Actions.UserUpdated({
					id = joined.id,
					username = joined.name,
					displayName = joined.displayName,
					hasVerifiedBadge = joined.hasVerifiedBadge
				})
			})
		end, p4)
	end, {})

	return llama.Dictionary.values(reduced)
end
