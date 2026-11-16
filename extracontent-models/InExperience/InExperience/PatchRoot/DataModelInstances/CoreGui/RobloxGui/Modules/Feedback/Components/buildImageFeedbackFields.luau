local function parseAsset(value: string?) -- 2 equivalent calls inferred from this helper
	if value == nil then
		return nil, ""
	end

	local v = string.match(value, "rbxassetid://(%d+)")

	if v == nil then
		return nil, ""
	end

	return v, string.match(value, "version=(%d+)") or ""
end

return function(p: number, value: string?, value2: string?)
	local asset, v = parseAsset(value) -- inferred equivalent call

	if asset == nil then
		return nil
	end

	local asset2, v2 = parseAsset(value2) -- inferred equivalent call
	local translation = asset2 == nil and "" or asset2 .. "#" .. v2

	return {
		identifier = p .. "#" .. asset .. "#" .. v,
		source = asset .. "#" .. v,
		translation = translation
	}
end
