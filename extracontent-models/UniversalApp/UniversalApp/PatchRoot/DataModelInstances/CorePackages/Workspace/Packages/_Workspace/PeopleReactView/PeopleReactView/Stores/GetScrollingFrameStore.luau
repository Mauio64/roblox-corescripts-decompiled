local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local Signals = require(Parent.Signals)
local createScrollingFrameStore = require(script.createScrollingFrameStore)

return Signals.createComputed(createScrollingFrameStore)
