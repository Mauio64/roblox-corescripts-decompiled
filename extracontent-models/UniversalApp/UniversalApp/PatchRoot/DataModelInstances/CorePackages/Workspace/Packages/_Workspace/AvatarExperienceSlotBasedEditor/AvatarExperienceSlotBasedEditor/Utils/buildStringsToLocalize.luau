require(script.Parent.Parent.Types)

local function buildStringsToLocalize(t1: {[any]: any}) -- line: 4
	local t2 = {}

	for _, v5 in t1 do
		t2[v5.nameTranslationKey] = v5.nameTranslationKey
	end

	return t2
end

return buildStringsToLocalize
