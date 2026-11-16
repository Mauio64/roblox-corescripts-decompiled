local parent = script:FindFirstAncestor("AuthCommon").Parent

local AppCommonLib = require(parent.AppCommonLib)
return AppCommonLib.Signal.new()
