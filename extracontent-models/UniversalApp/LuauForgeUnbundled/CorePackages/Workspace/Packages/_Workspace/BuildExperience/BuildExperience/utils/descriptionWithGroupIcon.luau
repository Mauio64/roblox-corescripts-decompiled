local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local escapeRichText = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/escapeRichText")

local iconName = Foundation.Enums.IconName
local iconRichText = Foundation.Utility.getIconRichText(iconName.TwoPeople)

local function descriptionWithGroupIcon(p2, p3, p4)
	if not p3 then
		return p2
	end

	if not p2 then
		p2 = if p4 ~= nil then escapeRichText(p4) else nil
	end

	if p2 == nil then
		return iconRichText
	end

	return `{iconRichText} {p2}`
end

return descriptionWithGroupIcon
