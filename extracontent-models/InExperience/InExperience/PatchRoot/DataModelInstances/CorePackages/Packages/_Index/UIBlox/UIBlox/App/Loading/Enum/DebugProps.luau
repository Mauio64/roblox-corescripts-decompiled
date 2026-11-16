local parent = script.Parent.Parent.Parent.Parent.Parent
local enumerate = require(parent.enumerate)

return enumerate("debugProps", { "forceLoading", "forceFailed" })
