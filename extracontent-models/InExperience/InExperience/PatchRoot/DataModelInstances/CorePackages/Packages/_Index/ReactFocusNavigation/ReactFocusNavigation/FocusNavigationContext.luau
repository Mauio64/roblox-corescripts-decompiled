local ParentParent = script.Parent.Parent

require(ParentParent.FocusNavigation)

return require(ParentParent.React).createContext(nil)
