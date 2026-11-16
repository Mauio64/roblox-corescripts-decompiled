local parent = script:FindFirstAncestor("VerifiedParentalConsentDialog").Parent
local React = require(parent.React)

return React.createContext(nil)
