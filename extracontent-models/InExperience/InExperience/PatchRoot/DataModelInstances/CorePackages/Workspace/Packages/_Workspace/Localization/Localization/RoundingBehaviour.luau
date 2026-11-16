local parent = script:FindFirstAncestor("Localization").Parent
local enumerate = require(parent.enumerate)

return enumerate("RoundingBehaviour", { "RoundToClosest", "Truncate" })
