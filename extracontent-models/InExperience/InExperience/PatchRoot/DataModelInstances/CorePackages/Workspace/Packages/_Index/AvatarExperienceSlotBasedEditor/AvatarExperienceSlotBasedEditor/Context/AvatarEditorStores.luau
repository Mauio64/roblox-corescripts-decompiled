local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local createAvatarEditorStores = require(script.Parent.Parent.Stores.createAvatarEditorStores)
local FFlagAXAvatarEditorStoresContext = require(Parent.AvatarExperienceFlags).FFlagAXAvatarEditorStoresContext

return (require(Parent.React).createContext(if not FFlagAXAvatarEditorStoresContext then nil else createAvatarEditorStores()))
