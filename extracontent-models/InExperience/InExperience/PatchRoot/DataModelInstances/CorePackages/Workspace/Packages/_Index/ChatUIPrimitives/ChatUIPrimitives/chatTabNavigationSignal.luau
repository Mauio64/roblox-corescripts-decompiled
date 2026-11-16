local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local AppCommonLib = require(parent.AppCommonLib)

return (AppCommonLib.Signal.new())
