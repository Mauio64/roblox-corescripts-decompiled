local Parent = script:FindFirstAncestor("TrustedContacts").Parent
local FStringCanAccessTrustedContactsAmpFeature = require(Parent.SharedFlags).FStringCanAccessTrustedContactsAmpFeature
local FStringCanAccessTrustedContactsAmpNameSpace = require(Parent.SharedFlags).FStringCanAccessTrustedContactsAmpNameSpace

return {
	featureName = FStringCanAccessTrustedContactsAmpFeature,
	nameSpace = FStringCanAccessTrustedContactsAmpNameSpace
}
