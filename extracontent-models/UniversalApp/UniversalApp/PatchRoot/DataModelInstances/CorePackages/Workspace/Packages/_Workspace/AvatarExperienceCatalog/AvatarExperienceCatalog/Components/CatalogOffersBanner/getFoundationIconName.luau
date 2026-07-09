local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local IconName = require(Parent.Foundation).Enums.IconName

local function getFoundationIconName(s1: string?) -- line: 8
	-- upvalues: IconName (copy)
	if s1 then
		local v5 = IconName[s1]

		if v5 then
			return v5
		end
	end

	return IconName.TagSparkle
end

return getFoundationIconName
