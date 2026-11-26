local PolicyProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/PolicyProvider")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/Loggers").Logger

local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/UniversalAppPolicy")

PolicyProvider.Logger:setParent(logger)

return UniversalAppPolicy
