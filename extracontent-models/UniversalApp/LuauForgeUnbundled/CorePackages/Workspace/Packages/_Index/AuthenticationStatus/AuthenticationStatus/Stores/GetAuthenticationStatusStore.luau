local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthenticationStatus/Signals")
local createAuthenticationStatusStore = require("@game/CorePackages/Workspace/Packages/_Index/AuthenticationStatus/AuthenticationStatus/Stores/GetAuthenticationStatusStore/createAuthenticationStatusStore")

return Signals.createComputed(createAuthenticationStatusStore)
