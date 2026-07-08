local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local ContactsListContainer = require(script.ContactsListContainer)
local OffPlatformFriendRequestsIXP = require(ParentParent.Flags.OffPlatformFriendRequestsIXP)
local Dash = dependencies.Dash
local Roact = dependencies.Roact
local useNavigation = dependencies.useNavigation
local FFlagContactImporterIXPCleanup = require(ParentParentParent.SharedFlags).FFlagContactImporterIXPCleanup

function ContactsList(p1) -- line: 15
	-- upvalues: useNavigation (copy), FFlagContactImporterIXPCleanup (copy), OffPlatformFriendRequestsIXP (copy), Roact (copy), ContactsListContainer (copy), Dash (copy)
	local v11 = useNavigation()
	local v12 = if not FFlagContactImporterIXPCleanup then OffPlatformFriendRequestsIXP.useOffPlatformFriendRequestsVariant() else nil

	if FFlagContactImporterIXPCleanup then
		return Roact.createElement(ContactsListContainer, Dash.join({
			navigation = v11
		}, p1 or {}))
	end

	if v12 == OffPlatformFriendRequestsIXP.IXPVariants.BLENDED or v12 == OffPlatformFriendRequestsIXP.IXPVariants.INVITES_ONLY then
		return Roact.createElement(ContactsListContainer, Dash.join({
			isPVRequired = false,
			variant = v12,
			navigation = v11
		}, p1 or {}))
	end

	return nil
end

return ContactsList
