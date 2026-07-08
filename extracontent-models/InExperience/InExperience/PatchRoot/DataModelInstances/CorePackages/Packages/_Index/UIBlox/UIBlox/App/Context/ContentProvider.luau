local ContentProvider = game:GetService("ContentProvider")
local ParentParent = script.Parent.Parent.Parent.Parent

return require(ParentParent.Roact).createContext(ContentProvider)
