local parent = script:FindFirstAncestor("PeopleReactView").Parent

local Signals = require(parent.Signals)
local createScrollingFrameStore = require(script.createScrollingFrameStore)

return Signals.createComputed(createScrollingFrameStore)
