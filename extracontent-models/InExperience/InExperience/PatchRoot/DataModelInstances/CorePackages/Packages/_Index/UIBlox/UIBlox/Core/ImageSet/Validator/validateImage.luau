local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)
local validateImageSetData = require(scriptParent.validateImageSetData)

return t.union(t.string, validateImageSetData)
