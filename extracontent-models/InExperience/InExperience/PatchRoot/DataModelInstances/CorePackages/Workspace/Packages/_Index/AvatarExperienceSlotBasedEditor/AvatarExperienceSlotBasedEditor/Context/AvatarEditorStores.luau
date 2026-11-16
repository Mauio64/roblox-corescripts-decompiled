local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
require(script.Parent.Parent.Stores.createAvatarEditorStores)

local React = require(parent.React)

return (React.createContext(nil))
