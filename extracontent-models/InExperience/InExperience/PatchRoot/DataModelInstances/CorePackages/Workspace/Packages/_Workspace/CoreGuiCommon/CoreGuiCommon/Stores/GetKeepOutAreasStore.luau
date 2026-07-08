local Parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(Parent.Signals)
local createKeepOutAreasStore = require(script.createKeepOutAreasStore)

return Signals.createComputed(createKeepOutAreasStore)
