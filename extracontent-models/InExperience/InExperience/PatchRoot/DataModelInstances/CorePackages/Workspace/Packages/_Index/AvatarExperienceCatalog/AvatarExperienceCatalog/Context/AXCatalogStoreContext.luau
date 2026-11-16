local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent
local React = require(parent.React)

local Stores = require(AvatarExperienceCatalog.Stores)

return React.createContext((Stores()))
