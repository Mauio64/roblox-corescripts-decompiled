local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloLocalState/Cryo")
local fFlagUserProfilePlatformProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloLocalState/SharedFlags").FFlagUserProfilePlatformProfile
local fFlagUserProfileMergeCachedNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloLocalState/SharedFlags").FFlagUserProfileMergeCachedNames
local makeDefaultReadPolicy = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/typePolicies/utils/makeDefaultReadPolicy")

local function mergeNames(p2, p3, p4)
	if p3 and p3.platformName ~= nil and p4 and p4.platformName == nil then
		return Cryo.Dictionary.join(p4, { platformName = p3.platformName })
	end

	return p4
end

local function mergeAllNames(p2, p3, p4)
	if p3 and p4 then
		return Cryo.Dictionary.join(p3, p4)
	end

	return p4
end

if not fFlagUserProfilePlatformProfile then
	mergeNames = nil
end

if fFlagUserProfileMergeCachedNames then
	mergeNames = mergeAllNames
end

local v8 = if not fFlagUserProfilePlatformProfile then makeDefaultReadPolicy("") else nil
return {
	fields = {
		platformProfileId = { read = v8 },
		names = { merge = mergeNames }
	}
}
