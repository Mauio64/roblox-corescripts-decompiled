local parent = script:FindFirstAncestor("TrustedContacts").Parent

local SharedFlags = require(parent.SharedFlags)
local FStringCanAccessTrustedContactsAmpFeature = SharedFlags.FStringCanAccessTrustedContactsAmpFeature
local SharedFlags2 = require(parent.SharedFlags)
return {
	featureName = FStringCanAccessTrustedContactsAmpFeature,
	nameSpace = SharedFlags2.FStringCanAccessTrustedContactsAmpNameSpace
}
