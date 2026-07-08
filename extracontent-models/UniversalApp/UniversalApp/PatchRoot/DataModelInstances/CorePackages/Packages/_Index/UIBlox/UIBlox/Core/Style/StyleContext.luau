local ParentParent = script.Parent.Parent.Parent

require(ParentParent.App.Style.StyleTypes)

local ParentParentParent = ParentParent.Parent

return require(ParentParentParent.Roact).createContext(nil)
