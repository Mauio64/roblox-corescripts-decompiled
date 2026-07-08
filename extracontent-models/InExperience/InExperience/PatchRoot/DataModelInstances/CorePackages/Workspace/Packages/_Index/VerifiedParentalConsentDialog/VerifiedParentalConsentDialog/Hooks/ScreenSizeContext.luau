local Parent = script:FindFirstAncestor("VerifiedParentalConsentDialog").Parent

return require(Parent.React).createContext(Vector2.new(0, 0))
