local parent = script.Parent.Parent

require(script.Parent.anyEntryTypes)

local context = require(parent.wry.context)
local Context = {}

Context.parentEntrySlot = context.Slot.new()

local context2 = require(parent.wry.context)
Context.bindContext = context2.bind
Context.noContext = context2.noContext
Context.setTimeout = context2.setTimeout

return Context
