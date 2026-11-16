local parent = script:FindFirstAncestor("ExpChat").Parent
local AppCommonLib = require(parent.AppCommonLib)

return (AppCommonLib.Signal.new())
