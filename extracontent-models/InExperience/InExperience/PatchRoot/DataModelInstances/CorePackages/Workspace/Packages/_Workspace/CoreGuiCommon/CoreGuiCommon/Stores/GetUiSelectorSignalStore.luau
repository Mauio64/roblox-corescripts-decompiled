local Parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(Parent.Signals)
local createUiSelectorSignalStore = require(script.createUiSelectorSignalStore)

return Signals.createComputed(createUiSelectorSignalStore)
