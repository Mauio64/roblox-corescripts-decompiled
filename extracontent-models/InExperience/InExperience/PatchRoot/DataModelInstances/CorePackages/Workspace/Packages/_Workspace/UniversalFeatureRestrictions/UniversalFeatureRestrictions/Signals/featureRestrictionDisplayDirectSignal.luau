local parent = script:FindFirstAncestor("UniversalFeatureRestrictions").Parent

local AppCommonLib = require(parent.AppCommonLib)
return (AppCommonLib.Signal.new())
