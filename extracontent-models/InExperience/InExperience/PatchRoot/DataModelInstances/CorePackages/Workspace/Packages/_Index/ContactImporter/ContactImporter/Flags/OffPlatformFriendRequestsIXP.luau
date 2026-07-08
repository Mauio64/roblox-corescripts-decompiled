game:DefineFastInt("OffPlatformFriendRequestsRolloutEnabled", 0)

local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local ContactImporterParent = ContactImporter.Parent
local setupIsRolloutEnabledForUser = dependencies.SocialLibraries.ReleaseHelpers.setupIsRolloutEnabledForUser
local getFStringSocialFriendsLayer = dependencies.getFStringSocialFriendsLayer
local useUserExperiment = dependencies.useUserExperiment
local getFStringOffPlatformIXPName = require(script.Parent.getFStringOffPlatformIXPName)
local IXPVariants = require(ContactImporter.Common.IXPVariants)
local v9 = getFStringOffPlatformIXPName()
local FFlagContactImporterIXPCleanup = require(ContactImporterParent.SharedFlags).FFlagContactImporterIXPCleanup

local function v11(p1) -- line: 34
	-- upvalues: getFStringSocialFriendsLayer (copy), v9 (copy)
	local v17 = if not p1 then nil else p1[getFStringSocialFriendsLayer()]
	local v18 = nil

	if v17 then
		v18 = v17[v9]
	end

	return v18
end

local v12 = setupIsRolloutEnabledForUser(function() -- line: 21
	return game:GetFastInt("OffPlatformFriendRequestsRolloutEnabled")
end)

local function v13(p2) -- line: 40
	-- upvalues: getFStringSocialFriendsLayer (copy), v9 (copy), IXPVariants (copy), v12 (copy)
	local v20 = if not p2 then nil else p2[getFStringSocialFriendsLayer()]
	local v21 = nil

	if v20 then
		v21 = v20[v9]
	end

	local v22 = false

	if v21 then
		v22 = v21 == IXPVariants.INVITES_ONLY or v21 == IXPVariants.BLENDED
	end

	return v22 or v12()
end

if FFlagContactImporterIXPCleanup then
	return nil
end

return {
	experimentOrRolloutEnabled = v13,
	IXPVariants = IXPVariants,
	useOffPlatformFriendRequestsVariant = function() -- line: 51
		-- upvalues: useUserExperiment (copy), getFStringSocialFriendsLayer (copy), v11 (copy)
		return useUserExperiment({ getFStringSocialFriendsLayer() }, v11)
	end,
	useOffPlatformFriendRequestsEnabled = function() -- line: 57
		-- upvalues: useUserExperiment (copy), getFStringSocialFriendsLayer (copy), v13 (copy)
		return useUserExperiment({ getFStringSocialFriendsLayer() }, v13)
	end,
	getExperimentVariant = v11,
	isRolloutEnabled = function(p3) -- line: 72
		-- upvalues: getFStringSocialFriendsLayer (copy), v9 (copy), IXPVariants (copy), v12 (copy)
		local v24 = if not p3 then nil else p3[getFStringSocialFriendsLayer()]
		local v25 = nil

		if v24 then
			v25 = v24[v9]
		end

		local v26 = false

		if v25 then
			v26 = v25 == IXPVariants.INVITES_ONLY or v25 == IXPVariants.BLENDED
		end

		if v26 or v12() then
			return IXPVariants.BLENDED
		end

		return IXPVariants.CONTROL
	end
}
