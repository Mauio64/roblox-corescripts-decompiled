local ContactsToast = script:FindFirstAncestor("ContactsToast")
local ContactsToastParent = ContactsToast.Parent
local useUserExperiment = require(ContactsToastParent.RoactAppExperiment).useUserExperiment
local FStringSocialFriendsLayer = require(ContactsToast.Flags.FStringSocialFriendsLayer)
local FStringContactsToastButtonKey = require(ContactsToast.Flags.FStringContactsToastButtonKey)
local v6 = game:DefineFastFlag("ContactsToastExperimentEnabledv1", false)

local function v7(p1) -- line: 13
	-- upvalues: v6 (copy), FStringSocialFriendsLayer (copy), FStringContactsToastButtonKey (copy)
	if not v6 then
		return false
	end

	return (p1[FStringSocialFriendsLayer] or {})[FStringContactsToastButtonKey]
end

return {
	FFlagContactsToastExperimentEnabled = v6,
	useContactsToastVariant = function() -- line: 24
		-- upvalues: v6 (copy), useUserExperiment (copy), FStringSocialFriendsLayer (copy), v7 (copy)
		if not v6 then
			return false
		end

		return (useUserExperiment({ FStringSocialFriendsLayer }, v7))
	end
}
