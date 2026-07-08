local Parent = script:FindFirstAncestor("SocialCommon").Parent
local Promise = require(Parent.Promise)
local Cryo = require(Parent.Cryo)

require(Parent.LuauPolyfill)

local function hydrateEmptyIdsHelper(t1: {[any]: any}) -- line: 18
	-- upvalues: Promise (copy), Cryo (copy)
	local ids = t1.ids
	local selector = t1.selector
	local hydrate = t1.hydrate

	if not ids then
		return Promise.resolve()
	end

	local v9 = Cryo.List.filter(ids, function(p1) -- line: 27
		-- upvalues: selector (copy)
		return selector(p1) == nil
	end)

	if #v9 > 0 then
		return (hydrate(v9))
	end

	return (Promise.resolve())
end

return hydrateEmptyIdsHelper
