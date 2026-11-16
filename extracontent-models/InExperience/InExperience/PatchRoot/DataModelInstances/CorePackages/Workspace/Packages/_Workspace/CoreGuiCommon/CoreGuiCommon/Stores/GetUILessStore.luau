local parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(parent.Signals)
local createUILessStore = require(script.createUILessStore)

return Signals.createComputed(createUILessStore)
