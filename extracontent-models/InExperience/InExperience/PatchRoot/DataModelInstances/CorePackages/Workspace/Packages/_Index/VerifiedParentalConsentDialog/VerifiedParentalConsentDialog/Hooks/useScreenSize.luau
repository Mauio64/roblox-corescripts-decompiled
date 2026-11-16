local VerifiedParentalConsentDialog = script:FindFirstAncestor("VerifiedParentalConsentDialog")
local parent = VerifiedParentalConsentDialog.Parent
local React = require(parent.React)
local ScreenSizeContext = require(VerifiedParentalConsentDialog.Hooks.ScreenSizeContext)

local function useScreenSize()
	return React.useContext(ScreenSizeContext)
end

return useScreenSize
