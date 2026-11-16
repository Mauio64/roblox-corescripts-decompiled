local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local formatNumber = require(parent.Utility.formatNumber)
local LocalizationService = game:GetService("LocalizationService")
local Foundation = require(parent2.Foundation)
local Enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText

function useRobuxText(value: number?)
	return (React.useMemo(function()
		local v = formatNumber(LocalizationService.RobloxLocaleId, value or 0)
		return `{getIconRichText(Enums.IconName.Robux)} {v}`
	end, { value, LocalizationService.RobloxLocaleId }))
end

return useRobuxText
