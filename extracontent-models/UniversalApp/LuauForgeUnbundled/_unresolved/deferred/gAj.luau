local module = require("@luauforge/deferred/gAk")

local module2 = require("@luauforge/deferred/gAl")

local v5 = {}

v5.validateViolation = module.interface({
	evidence = module.interface({
		type = module.literal("platform"),
		elements = module.table,
		displayMeta = module.optional(module.interface({
			lowercaseKey = module.match(".+"),
			capitalizedKey = module.match(".+"),
			icon = module.match(".+")
		}))
	}),
	abuseTypeTranslationKeys = module.table,
	uid = module.match(".+")
})

local interface = module.interface({
	type = module.literal("image"),
	labelKey = module.match(".+"),
	url = module.match(".+"),
	altLabelKey = module.optional(module.match(".+"))
})

local interface2 = module.interface({
	type = module.literal("timestamp"),
	labelKey = module.match(".+"),
	unix = module.numberMin(1)
})
local v6

if module2 then
	v6 = module.intersection(module.interface({
		type = module.literal("text"),
		labelKey = module.match(".+"),
		text = module.optional(module.match(".+")),
		textKey = module.optional(module.match(".+")),
		textKeyParameters = module.optional(module.table)
	}), function(data): (boolean, string)
		if data.text or data.textKey then
			if data.textKeyParameters and not data.textKey then
				return false, "textKeyParameters requires textKey to be present"
			end

			return true, ""
		end

		return false, "textElement must have at least one of 'text' or 'textKey'"
	end)
else
	v6 = module.interface({
		type = module.literal("text"),
		text = module.match(".+"),
		labelKey = module.match(".+")
	})
end

v5.checkElementIsVisible = module.union(v6)

v5.checkElementIsValid = module.union(v6, interface2, interface)

function v5.filterForVisibleElements(items)
	local result = {}

	for k, item in items do
		if not (v5.checkElementIsValid(item) and v5.checkElementIsVisible(item)) then
			continue
		end

		table.insert(result, item)
	end

	return result
end

function v5.isVisibleInView(p2): boolean
	if v5.validateViolation(p2) and #p2.evidence.elements ~= 0 then
		return #v5.filterForVisibleElements(p2.evidence.elements) > 0
	end

	return false
end

return v5
