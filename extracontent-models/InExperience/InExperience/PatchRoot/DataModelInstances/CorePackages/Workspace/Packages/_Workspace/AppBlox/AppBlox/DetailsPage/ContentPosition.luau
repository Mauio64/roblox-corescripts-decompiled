local parent = script:FindFirstAncestor("AppBlox").Parent
local enumerate = require(parent.enumerate)

return enumerate("ContentPosition", { "Left", "Right" })
