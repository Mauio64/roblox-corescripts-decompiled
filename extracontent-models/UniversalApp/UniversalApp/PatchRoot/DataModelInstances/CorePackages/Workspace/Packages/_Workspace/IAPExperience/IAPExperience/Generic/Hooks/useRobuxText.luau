local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local formatNumber = require(ParentParent.Utility.formatNumber)
local LocalizationService = game:GetService("LocalizationService")
local Foundation = require(ParentParentParent.Foundation)
local Enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText

function useRobuxText(n1: number?) -- line: 10
	-- upvalues: React (copy), formatNumber (copy), LocalizationService (copy), getIconRichText (copy), Enums (copy)
	return (React.useMemo(function() -- line: 11
		-- upvalues: formatNumber (copy), LocalizationService (copy), n1 (copy), getIconRichText (copy), Enums (copy)
		local v10 = formatNumber(LocalizationService.RobloxLocaleId, n1 or 0)

		return `{ getIconRichText(Enums.IconName.Robux) } { v10 }`
	end, {
		n1,
		LocalizationService.RobloxLocaleId
	}))
end

return useRobuxText
