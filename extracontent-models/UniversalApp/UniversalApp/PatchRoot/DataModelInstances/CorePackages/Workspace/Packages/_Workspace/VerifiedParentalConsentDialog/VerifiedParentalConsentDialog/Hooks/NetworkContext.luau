local Parent = script:FindFirstAncestor("VerifiedParentalConsentDialog").Parent

return require(Parent.React).createContext(nil)
