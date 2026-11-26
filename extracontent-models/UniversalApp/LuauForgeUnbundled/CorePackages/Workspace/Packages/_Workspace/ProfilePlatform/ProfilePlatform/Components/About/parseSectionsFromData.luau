local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local Sections = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/About/Sections")

local v5 = {
	Description = "description",
	SocialLinks = "socialLinks",
	NameHistory = "nameHistory",
	JoinDateTime = "joinDateTime"
}
local v6 = {
	["description"] = Sections.AboutDescription,
	socialLinks = Sections.SocialLinks,
	nameHistory = Sections.NameHistory,
	joinDateTime = Sections.JoinYear
}

local v7 = { "description", "socialLinks", "nameHistory", "joinDateTime" }

local v8 = { "description" }

return function(p2, p3, p4)
	local v9 = if p3 == Enums.ProfileTypes.Contact then v8 else v7

	local children = {}

	for i, v10 in ipairs(v9) do
		local v11 = v6[v10]
		local v12 = p2[v10]

		if v11 then
			table.insert(children, React.createElement(v11, {
				layoutOrder = i,
				[v10] = v12,
				name = p4
			}))
		end
	end

	return children
end
