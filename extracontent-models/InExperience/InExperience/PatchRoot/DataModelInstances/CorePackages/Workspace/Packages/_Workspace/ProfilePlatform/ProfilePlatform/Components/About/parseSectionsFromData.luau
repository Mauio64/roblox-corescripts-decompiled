local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Enums = require(ProfilePlatform.Common.Enums)

local Sections = require(script.Parent.Sections)

local _ = {
	Description = "description",
	SocialLinks = "socialLinks",
	NameHistory = "nameHistory",
	JoinDateTime = "joinDateTime"
}
local v = {
	["description"] = Sections.AboutDescription,
	socialLinks = Sections.SocialLinks,
	nameHistory = Sections.NameHistory,
	joinDateTime = Sections.JoinYear
}

local v2 = { "description", "socialLinks", "nameHistory", "joinDateTime" }

local v3 = { "description" }

return function(p, p2, name: string?)
	local v4 = if p2 == Enums.ProfileTypes.Contact then v3 else v2

	local children = {}

	for i, v5 in ipairs(v4) do
		local v6 = v[v5]
		local v7 = p[v5]

		if v6 then
			table.insert(children, React.createElement(v6, {
				layoutOrder = i,
				[v5] = v7,
				name = name
			}))
		end
	end

	return children
end
