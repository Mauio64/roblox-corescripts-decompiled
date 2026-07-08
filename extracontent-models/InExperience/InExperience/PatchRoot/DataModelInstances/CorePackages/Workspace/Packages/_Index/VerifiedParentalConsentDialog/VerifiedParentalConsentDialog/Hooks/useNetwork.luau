local VerifiedParentalConsentDialog = script:FindFirstAncestor("VerifiedParentalConsentDialog")
local VerifiedParentalConsentDialogParent = VerifiedParentalConsentDialog.Parent
local React = require(VerifiedParentalConsentDialogParent.React)
local NetworkContext = require(VerifiedParentalConsentDialog.Hooks.NetworkContext)

local function useNetwork() -- line: 7
	-- upvalues: React (copy), NetworkContext (copy)
	return React.useContext(NetworkContext)
end

return useNetwork
