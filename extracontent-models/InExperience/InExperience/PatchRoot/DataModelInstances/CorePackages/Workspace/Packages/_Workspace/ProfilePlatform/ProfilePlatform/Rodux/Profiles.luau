local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Rodux = require(ProfilePlatformParent.Rodux)
local Community = require(ProfilePlatform.Rodux.ProfileTypes.Community)
local User = require(ProfilePlatform.Rodux.ProfileTypes.User)
local Contact = require(ProfilePlatform.Rodux.ProfileTypes.Contact)

return Rodux.combineReducers({
	Community = Community,
	User = User,
	Contact = Contact
})
