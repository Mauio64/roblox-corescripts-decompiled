local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Enums = require(ProfilePlatform.Common.Enums)
local Sections = require(script.Parent.Sections)
local AboutDescription = Sections.AboutDescription
local SocialLinks = Sections.SocialLinks
local NameHistory = Sections.NameHistory
local JoinYear = Sections.JoinYear
local _ = {
	Description = "description",
	SocialLinks = "socialLinks",
	NameHistory = "nameHistory",
	JoinDateTime = "joinDateTime"
}
local t1 = {
	description = AboutDescription,
	socialLinks = SocialLinks,
	nameHistory = NameHistory,
	joinDateTime = JoinYear
}
local t2 = {
	"description",
	"socialLinks",
	"nameHistory",
	"joinDateTime"
}
local t3 = { "description" }

return function(p1, p2, s1: string?) -- line: 37
	-- upvalues: Enums (copy), t3 (copy), t2 (copy), t1 (copy), React (copy)
	local v17 = if p2 ~= Enums.ProfileTypes.Contact then t2 else t3
	local t4 = {}

	for i, v in ipairs(v17) do
		local v21 = t1[v]
		local v22 = p1[v]

		if v21 then
			table.insert(t4, React.createElement(v21, {
				layoutOrder = i,
				[v] = v22,
				name = s1
			}))
		end
	end

	return t4
end
