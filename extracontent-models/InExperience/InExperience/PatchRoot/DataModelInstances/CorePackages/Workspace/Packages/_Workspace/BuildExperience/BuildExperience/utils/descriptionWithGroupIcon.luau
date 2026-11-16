local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)

local escapeRichText = require(BuildExperience.utils.escapeRichText)

local IconName = Foundation.Enums.IconName
local iconRichText = Foundation.Utility.getIconRichText(IconName.TwoPeople)

local function descriptionWithGroupIcon(p: string?, flag: boolean?, p2: string?)
	if not flag then
		return p
	end

	if not p then
		if p2 == nil then
			p = nil
		else
			p = escapeRichText(p2)
		end
	end

	if p == nil then
		return iconRichText
	end

	return `{iconRichText} {p}`
end

return descriptionWithGroupIcon
