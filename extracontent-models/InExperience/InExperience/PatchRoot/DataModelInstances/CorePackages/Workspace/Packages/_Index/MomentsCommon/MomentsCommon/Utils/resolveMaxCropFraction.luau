local function isLandscape(vector2: Vector2): boolean -- 2 equivalent calls inferred from this helper
	return vector2.X > vector2.Y
end

local function resolveMaxCropFraction(vector2: Vector2, vector2_2: Vector2?, p: number, flag: boolean)
	if vector2_2 == nil or vector2.X == 0 or vector2.Y == 0 then
		return 0
	end

	local landscape = isLandscape(vector2_2) -- inferred equivalent call

	if landscape ~= isLandscape(vector2) or landscape and not flag then -- inferred equivalent call
		return 0
	end

	return p
end

return resolveMaxCropFraction
