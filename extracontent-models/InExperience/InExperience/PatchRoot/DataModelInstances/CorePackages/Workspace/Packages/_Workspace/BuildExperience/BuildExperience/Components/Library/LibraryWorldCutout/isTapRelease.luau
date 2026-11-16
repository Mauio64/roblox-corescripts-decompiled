local function isTapRelease(vector3: Vector3?, p): boolean
	if vector3 == nil or p == nil then
		return true
	end

	local v = p.Position - vector3
	return Vector2.new(v.X, v.Y).Magnitude <= 10
end

return isTapRelease
