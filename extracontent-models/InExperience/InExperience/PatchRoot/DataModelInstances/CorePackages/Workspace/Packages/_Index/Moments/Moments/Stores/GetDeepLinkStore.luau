local createDeepLinkStore = require(script.createDeepLinkStore)
local u2 = nil

local function getDeepLinkStore() -- line: 6
	-- upvalues: u2 (ref), createDeepLinkStore (copy)
	if u2 == nil then
		u2 = createDeepLinkStore()
	end

	return u2
end

return getDeepLinkStore
