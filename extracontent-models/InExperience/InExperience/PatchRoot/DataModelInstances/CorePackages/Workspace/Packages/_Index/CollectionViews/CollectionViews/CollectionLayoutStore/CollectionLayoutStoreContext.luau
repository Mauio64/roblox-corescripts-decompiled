local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local React = require(parent.React)

require(CollectionViews.CollectionViewTypes)

return React.createContext(nil)
