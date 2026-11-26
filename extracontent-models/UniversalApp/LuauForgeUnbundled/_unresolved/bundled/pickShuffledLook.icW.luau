require("@luauforge/bundled/icD")

local function pickDifferent(items, p2, object)
	local v5 = {}

	for k, item in items do
		if item ~= p2 then
			table.insert(v5, item)
		end
	end

	if #v5 == 0 then
		return p2
	end

	return v5[object:NextInteger(1, #v5)]
end

local function pickShuffledLook(p2, p3, p4)
	return {
		themeKey = pickDifferent(p3.themeKeys, p2.themeKey, p4) or p2.themeKey,
		frameAssetId = pickDifferent(p3.frameAssetIds, p2.frameAssetId, p4)
	}
end

return pickShuffledLook
