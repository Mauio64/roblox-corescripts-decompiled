local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local text = dependencies.Text

return function(p: string, p2, p3: number)
	return text.GetTextHeight(p, p2, p3)
end
