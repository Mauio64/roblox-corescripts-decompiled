local parent = script.Parent.Parent.Parent

require(parent.App.Style.StyleTypes)
local parent2 = parent.Parent
local Roact = require(parent2.Roact)

return Roact.createContext(nil)
