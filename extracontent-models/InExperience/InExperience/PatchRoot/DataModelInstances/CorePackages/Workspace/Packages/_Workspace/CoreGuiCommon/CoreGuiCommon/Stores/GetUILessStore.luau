local Parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(Parent.Signals)
local createUILessStore = require(script.createUILessStore)

return Signals.createComputed(createUILessStore)
