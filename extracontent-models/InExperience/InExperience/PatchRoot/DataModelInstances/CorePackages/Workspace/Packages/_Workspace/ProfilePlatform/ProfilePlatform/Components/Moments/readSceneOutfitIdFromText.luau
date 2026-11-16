local function readSceneOutfitIdFromText(value: string)
	local v = tonumber((string.match(value, "name=\"Name\">outfitId</string><int64 name=\"Value\">(%d+)</int64>")))

	if type(v) == "number" and not (v <= 0) and v % 1 == 0 then
		return v
	end

	return nil
end

return readSceneOutfitIdFromText
