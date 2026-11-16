local parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(parent.Signals)
local createUiSelectorSignalStore = require(script.createUiSelectorSignalStore)

return Signals.createComputed(createUiSelectorSignalStore)
