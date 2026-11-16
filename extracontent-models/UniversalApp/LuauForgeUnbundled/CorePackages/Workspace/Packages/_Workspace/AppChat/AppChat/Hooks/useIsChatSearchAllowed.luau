local module = require("@luauforge/bundled/gsb")
local useIsChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatEnabled")

return function()
	local v5 = module(function(p2)
		return p2.getChatHeaderSearch()
	end)

	local v6 = useIsChatEnabled()

	return v5 and v6 or false
end
