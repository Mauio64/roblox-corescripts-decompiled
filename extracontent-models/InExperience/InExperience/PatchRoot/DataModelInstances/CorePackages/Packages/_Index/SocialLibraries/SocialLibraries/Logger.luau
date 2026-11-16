local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
return (dependencies.Lumberyak.Logger.new(nil, script:GetFullName() .. ":SocialLibraries"))
