local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

require(CorePackages.Packages.t)

local maybeAssert = require(RobloxGui.Modules.VoiceChat.Helpers.maybeAssert)

return makeActionCreator(script.Name, function(p1) -- line: 11
	-- upvalues: maybeAssert (copy)
	maybeAssert(tonumber(p1) ~= nil)

	return {
		userId = tostring(p1)
	}
end)
