local parent = script:FindFirstAncestor("ApolloLocalState").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile
local makeDefaultReadPolicy = require(script.Parent.utils.makeDefaultReadPolicy)

local fields = {
	alias = { read = makeDefaultReadPolicy("") },
	contactName = { read = makeDefaultReadPolicy("") },
	platformName = 0
}
local read

if not FFlagUserProfilePlatformProfile then
	read = makeDefaultReadPolicy("")
end

fields.platformName = { read = read }
return { fields = fields }
