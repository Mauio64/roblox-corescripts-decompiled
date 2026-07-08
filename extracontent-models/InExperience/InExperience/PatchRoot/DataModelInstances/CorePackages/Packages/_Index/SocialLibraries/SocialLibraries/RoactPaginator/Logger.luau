local SocialLibraries = script:FindFirstAncestor("SocialLibraries")

return (require(SocialLibraries.Logger):new(script:GetFullName() .. ":RoactPaginator"))
