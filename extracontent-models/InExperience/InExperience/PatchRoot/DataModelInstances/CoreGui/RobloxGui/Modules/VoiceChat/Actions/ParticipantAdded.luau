local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator
require(CorePackages.Packages.t)
local maybeAssert = require(RobloxGui.Modules.VoiceChat.Helpers.maybeAssert)

return makeActionCreator(script.Name, function(p)
	maybeAssert(tonumber(p) ~= nil)

	return { userId = tostring(p) }
end)
