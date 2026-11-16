local parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(parent.Signals)
local createKeepOutAreasStore = require(script.createKeepOutAreasStore)

return Signals.createComputed(createKeepOutAreasStore)
