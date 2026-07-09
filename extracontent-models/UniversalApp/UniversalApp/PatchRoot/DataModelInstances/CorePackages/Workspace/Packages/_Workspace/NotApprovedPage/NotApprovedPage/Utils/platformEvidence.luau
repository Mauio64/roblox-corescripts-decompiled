local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local t = require(NotApprovedPageParent.t)
local FFlagNapPublicEvidenceTranslationKeys = require(NotApprovedPage.Flags.FFlagNapPublicEvidenceTranslationKeys)
local t1 = {
	validateViolation = t.interface({
		evidence = t.interface({
			type = t.literal("platform"),
			elements = t.table,
			displayMeta = t.optional(t.interface({
				lowercaseKey = t.match(".+"),
				capitalizedKey = t.match(".+"),
				icon = t.match(".+")
			}))
		}),
		abuseTypeTranslationKeys = t.table,
		uid = t.match(".+")
	})
}
local v6 = t.interface({
	type = t.literal("image"),
	labelKey = t.match(".+"),
	url = t.match(".+"),
	altLabelKey = t.optional(t.match(".+"))
})
local v7 = t.interface({
	type = t.literal("timestamp"),
	labelKey = t.match(".+"),
	unix = t.numberMin(1)
})
local v8 = if not FFlagNapPublicEvidenceTranslationKeys then t.interface({
	type = t.literal("text"),
	text = t.match(".+"),
	labelKey = t.match(".+")
}) else t.intersection(t.interface({
	type = t.literal("text"),
	labelKey = t.match(".+"),
	text = t.optional(t.match(".+")),
	textKey = t.optional(t.match(".+")),
	textKeyParameters = t.optional(t.table)
}), function(p1) -- line: 53
	if not p1.text and not p1.textKey then
		return false, "textElement must have at least one of 'text' or 'textKey'"
	end

	if p1.textKeyParameters and not p1.textKey then
		return false, "textKeyParameters requires textKey to be present"
	end

	return true, ""
end)

t1.checkElementIsVisible = t.union(v8)
t1.checkElementIsValid = t.union(v8, v7, v6)

function t1.filterForVisibleElements(p2) -- line: 78
	-- upvalues: t1 (copy)
	local t2 = {}

	for _, v13 in p2 do
		if t1.checkElementIsValid(v13) and t1.checkElementIsVisible(v13) then
			table.insert(t2, v13)
		end
	end

	return t2
end
function t1.isVisibleInView(p3) -- line: 90
	-- upvalues: t1 (copy)
	if not t1.validateViolation(p3) or #p3.evidence.elements == 0 then
		return false
	end

	return #t1.filterForVisibleElements(p3.evidence.elements) > 0
end

return t1
