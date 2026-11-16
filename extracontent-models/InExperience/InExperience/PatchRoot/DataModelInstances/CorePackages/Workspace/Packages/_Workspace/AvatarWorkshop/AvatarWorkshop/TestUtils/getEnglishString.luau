local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local InExperienceLocales = require(parent.InExperienceLocales)
local enus = InExperienceLocales.Localization.new("en-us")

local function getEnglishString(p: string)
	return enus:Format(p)
end

return getEnglishString
