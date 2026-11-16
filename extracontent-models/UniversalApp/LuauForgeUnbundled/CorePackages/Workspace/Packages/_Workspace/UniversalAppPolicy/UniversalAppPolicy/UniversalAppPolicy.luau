local PolicyProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/PolicyProvider")

local UniversalAppGetPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/UniversalAppGetPolicy")

return (PolicyProvider.withGetPolicyImplementation(UniversalAppGetPolicy))
