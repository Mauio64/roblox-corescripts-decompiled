local function readSceneOutfitIdFromText(value)
	local v5 = tonumber((string.match(
		value,
		"name=\"Name\">outfitId</string><int64 name=\"Value\">(%d+)</int64>"
	)))

	if type(v5) == "number" and not (v5 <= 0) and v5 % 1 == 0 then
		return v5
	end

	return nil
end

return readSceneOutfitIdFromText
