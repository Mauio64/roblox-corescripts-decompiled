local ParentParent = script.Parent.Parent
local t1 = {}

require(script.Parent.anyEntryTypes)
t1.parentEntrySlot = require(ParentParent.wry.context).Slot.new()

local context = require(ParentParent.wry.context)

t1.bindContext = context.bind
t1.noContext = context.noContext
t1.setTimeout = context.setTimeout

return t1
