local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator
local t = require(CorePackages.Packages.t)
local maybeAssert = require(RobloxGui.Modules.VoiceChat.Helpers.maybeAssert)

return makeActionCreator(script.Name, function(p1, p2) -- line: 9
	-- upvalues: maybeAssert (copy), t (copy)
	maybeAssert(tonumber(p1) ~= nil)
	maybeAssert(t.string(p2))

	return {
		userId = tostring(p1),
		newState = p2
	}
end)
