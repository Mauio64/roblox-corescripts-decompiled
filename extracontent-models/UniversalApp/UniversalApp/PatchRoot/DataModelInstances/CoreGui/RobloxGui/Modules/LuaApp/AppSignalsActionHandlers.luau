local CorePackages = game:GetService("CorePackages")
local ActionHandlers = require(CorePackages.Workspace.Packages.SignalsMiddleware).ActionHandlers
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local v4 = ActionHandlers.create()

if SharedFlags.FFlagEnableSignalsForLocalUserId then
	require(CorePackages.Workspace.Packages.UserLib).Handlers.registerLocalUserIdSignalsActionHandlers(v4)
end

if SharedFlags.FFlagSduiExperienceDetailsSupport then
	require(CorePackages.Workspace.Packages.DiscoverySignalsActionHandlers).registerDiscoverySignalsActionHandlers(v4)
end

return v4
