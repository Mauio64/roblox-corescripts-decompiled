require("@luauforge/deferred/ent")

require("@luauforge/bundled/enl")
local module = require("@luauforge/deferred/enA")
local module2 = require("@luauforge/deferred/enJ")
local module3 = require("@luauforge/deferred/enF")

local function useAvatarChangeTileViewModel(data)
	local item = data.item
	local actor = item.actors[1]
	local v5 = module(actor) or ""
	local userId = if actor ~= nil then actor.userId else nil

	local v6 = module2(item.assetIds[1])
	local v7 = if item.count > 0 then item.count else #item.assetIds

	local v8 = module3(item.timestamp)

	if data.timestampText ~= nil then
		v8 = data.timestampText
	end

	local formatted = `{v5} has a new avatar`

	if v6 == nil then
		v6 = nil
	else
		local v9 = math.max(0, v7 - 1)

		if v9 > 0 then
			v6 = `{v6} + {v9} more`
		end
	end

	if v8 == nil then
		v8 = v6
	elseif v6 ~= nil then
		v8 = `{v6} • {v8}`
	end

	return {
		avatarUserId = userId,
		title = formatted,
		subtitle = v8,
		isUnread = data.isUnread,
		onActivated = data.onActivated,
		layoutOrder = data.layoutOrder
	}
end

return useAvatarChangeTileViewModel
