local module = require("@luauforge/deferred/fVh")
require("@luauforge/deferred/fUR")

local function collectKidsTranslations(items, p2)
	local set = {}
	local kidsTranslations = {}

	for k, displayLabel in items do
		local v5 = module.CONTENT_BY_ABUSE_KEY[displayLabel]

		if v5 then
			displayLabel = v5.displayLabel
		end

		local v6 = p2[displayLabel]

		if not v6 or v6 == "" or set[v6] then
			continue
		end

		set[v6] = true
		table.insert(kidsTranslations, v6)
	end

	return kidsTranslations
end

return collectKidsTranslations
