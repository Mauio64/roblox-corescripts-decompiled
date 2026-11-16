local parent = script:FindFirstAncestor("SocialCommon").Parent
local Promise = require(parent.Promise)
local Cryo = require(parent.Cryo)

require(parent.LuauPolyfill)

local function hydrateEmptyIdsHelper(data)
	local ids = data.ids
	local selector = data.selector
	local hydrate = data.hydrate

	if not ids then
		return Promise.resolve()
	end

	local filtered = Cryo.List.filter(ids, function(p): boolean
		return selector(p) == nil
	end)

	if #filtered > 0 then
		return (hydrate(filtered))
	end

	return (Promise.resolve())
end

return hydrateEmptyIdsHelper
