local SocialLibraries = script:FindFirstAncestor("SocialLibraries")

return (require(SocialLibraries.dependencies).Lumberyak.Logger.new(nil, script:GetFullName() .. ":SocialLibraries"))
