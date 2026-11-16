local parent = script.Parent.Parent

local Dependencies = { Analytics = require(parent.Analytics), Logging = 0 }
local AppCommonLib = require(parent.AppCommonLib)
Dependencies.Logging = AppCommonLib.Logging
return Dependencies
