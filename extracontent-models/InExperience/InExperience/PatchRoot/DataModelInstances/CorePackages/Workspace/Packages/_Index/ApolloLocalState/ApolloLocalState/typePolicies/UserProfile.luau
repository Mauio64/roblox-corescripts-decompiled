local parent = script:FindFirstAncestor("ApolloLocalState").Parent
local Cryo = require(parent.Cryo)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserProfileMergeCachedNames = SharedFlags2.FFlagUserProfileMergeCachedNames
local makeDefaultReadPolicy = require(script.Parent.utils.makeDefaultReadPolicy)

local function mergeNames(_, p, p2)
	if p and p.platformName ~= nil and p2 and p2.platformName == nil then
		return Cryo.Dictionary.join(p2, { platformName = p.platformName })
	end

	return p2
end

local function mergeAllNames(_, p, p2)
	if p and p2 then
		return Cryo.Dictionary.join(p, p2)
	end

	return p2
end

if not FFlagUserProfilePlatformProfile then
	mergeNames = nil
end

if FFlagUserProfileMergeCachedNames then
	mergeNames = mergeAllNames
end

local read

if not FFlagUserProfilePlatformProfile then
	read = makeDefaultReadPolicy("")
end

return {
	fields = {
		platformProfileId = { read = read },
		names = { merge = mergeNames }
	}
}
