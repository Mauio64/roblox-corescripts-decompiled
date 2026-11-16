local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent.Parent

local t = require(parent2.t)

local validateImageSetData = require(parent.validateImageSetData)

return t.union(t.string, validateImageSetData)
