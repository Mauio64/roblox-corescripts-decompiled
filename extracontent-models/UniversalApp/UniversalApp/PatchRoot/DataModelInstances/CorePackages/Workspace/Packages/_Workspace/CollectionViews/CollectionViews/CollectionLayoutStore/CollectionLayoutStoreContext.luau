local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)

require(CollectionViews.CollectionViewTypes)

return React.createContext(nil)
