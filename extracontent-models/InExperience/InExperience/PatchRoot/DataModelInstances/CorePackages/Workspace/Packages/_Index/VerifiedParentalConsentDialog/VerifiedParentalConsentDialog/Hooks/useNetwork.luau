local VerifiedParentalConsentDialog = script:FindFirstAncestor("VerifiedParentalConsentDialog")
local parent = VerifiedParentalConsentDialog.Parent
local React = require(parent.React)

local NetworkContext = require(VerifiedParentalConsentDialog.Hooks.NetworkContext)

local function useNetwork()
	return React.useContext(NetworkContext)
end

return useNetwork
