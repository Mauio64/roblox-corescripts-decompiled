local module = require("@luauforge/bundled/dAx")
local receivedUserPresence = require("@luauforge/bundled/ciE").Actions.ReceivedUserPresence
local module2 = require("@luauforge/bundled/dAy")
local module3 = require("@luauforge/bundled/dAz")

local module4 = require("@luauforge/bundled/dzz")

return function(options, p2)
	local v5 = options or {}

	if p2.type == module2.name then
		return module4.JoinDictionaries(v5, { allFriendsIsFetching = true })
	end

	if p2.type == module.name then
		return module4.JoinDictionaries(v5, { allFriendsIsFetching = false })
	end

	if p2.type == module3.name then
		local v6 = v5[p2.userId] or {}
		return module4.JoinDictionaries(v5, {
			[p2.userId] = module4.JoinDictionaries(v6, { presenceIsFetching = true })
		})
	else
		local v6 = p2.type == receivedUserPresence.name and v5[p2.userId]

		if not v6 then
			return v5
		end

		return module4.JoinDictionaries(v5, {
			[p2.userId] = module4.JoinDictionaries(v6, { presenceIsFetching = false })
		})
	end
end
