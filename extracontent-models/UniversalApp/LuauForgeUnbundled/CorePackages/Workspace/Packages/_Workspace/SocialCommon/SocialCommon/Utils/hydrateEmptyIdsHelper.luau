local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Promise")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/LuauPolyfill")

local function hydrateEmptyIdsHelper(data)
	local ids = data.ids
	local selector = data.selector
	local hydrate = data.hydrate

	if not ids then
		return Promise.resolve()
	end

	local filtered = Cryo.List.filter(ids, function(p2): boolean
		return selector(p2) == nil
	end)

	if #filtered > 0 then
		return (hydrate(filtered))
	end

	return (Promise.resolve())
end

return hydrateEmptyIdsHelper
