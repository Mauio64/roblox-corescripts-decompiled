local parent = script:FindFirstAncestor("InterventionShared").Parent
local AppCommonLib = require(parent.AppCommonLib)
return (AppCommonLib.Signal.new())
