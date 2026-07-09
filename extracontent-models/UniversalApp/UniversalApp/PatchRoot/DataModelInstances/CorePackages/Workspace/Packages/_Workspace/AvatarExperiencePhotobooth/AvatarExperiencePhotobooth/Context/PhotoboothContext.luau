local Parent = script:FindFirstAncestor("AvatarExperiencePhotobooth").Parent

require(script.Parent.Parent.Stores.createPhotoboothStore)

return (require(Parent.React).createContext(nil))
