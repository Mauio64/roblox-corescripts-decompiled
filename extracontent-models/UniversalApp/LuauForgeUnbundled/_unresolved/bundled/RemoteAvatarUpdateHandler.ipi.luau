local module = require("@luauforge/bundled/ipj")
local module2 = require("@luauforge/bundled/ipl")

local defineFastFlag = game:DefineFastFlag("AXUpdateAvatarOnGameLeave", false)

local function RemoteAvatarUpdateHandler(p2)
	module(p2.onUpdated)

	if defineFastFlag then
		module2(p2.onUpdated)
	end
end

return RemoteAvatarUpdateHandler
