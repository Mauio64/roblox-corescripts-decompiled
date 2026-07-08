local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local Text = require(SocialLibraries.dependencies).Text

require(script.Parent.StyleTypes)

return function(s1: string, p1, n1: number) -- line: 6
	-- upvalues: Text (copy)
	return Text.GetTextHeight(s1, p1, n1)
end
