local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local Logger = require(SocialLibraries.Logger)

return (Logger:new(script:GetFullName() .. ":RoactPaginator"))
