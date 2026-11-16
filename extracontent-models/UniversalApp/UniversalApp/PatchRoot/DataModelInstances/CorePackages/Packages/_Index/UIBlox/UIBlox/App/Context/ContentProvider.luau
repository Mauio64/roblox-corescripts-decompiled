local ContentProvider = game:GetService("ContentProvider")

local parent = script.Parent.Parent.Parent.Parent
local Roact = require(parent.Roact)

return Roact.createContext(ContentProvider)
