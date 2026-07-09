local VerifiedParentalConsentDialog = script:FindFirstAncestor("VerifiedParentalConsentDialog")
local VerifiedParentalConsentDialogParent = VerifiedParentalConsentDialog.Parent
local React = require(VerifiedParentalConsentDialogParent.React)
local ScreenSizeContext = require(VerifiedParentalConsentDialog.Hooks.ScreenSizeContext)

local function useScreenSize() -- line: 6
	-- upvalues: React (copy), ScreenSizeContext (copy)
	return React.useContext(ScreenSizeContext)
end

return useScreenSize
