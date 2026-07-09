local GuiService = game:GetService("GuiService")
local t1 = {
	[Enum.NormalId.Front] = CFrame.identity,
	[Enum.NormalId.Left] = CFrame.fromEulerAngles(0, 1.5707963267948966, 0),
	[Enum.NormalId.Back] = CFrame.fromEulerAngles(0, 3.141592653589793, 0),
	[Enum.NormalId.Right] = CFrame.fromEulerAngles(0, -1.5707963267948966, 0),
	[Enum.NormalId.Top] = CFrame.fromEulerAnglesYXZ(1.5707963267948966, -1.5707963267948966, 0),
	[Enum.NormalId.Bottom] = CFrame.fromEulerAnglesYXZ(-1.5707963267948966, -1.5707963267948966, 0)
}

local function guiPositionToScreenPosition(p1, vector2: Vector2, p2) -- line: 21
	-- upvalues: GuiService (copy), t1 (copy)
	local v7 = vector2 / p1.AbsoluteSize

	if p1:IsA("ScreenGui") then
		return vector2
	end

	if p1:IsA("BillboardGui") then
		local ScreenSpaceBounds = p1:GetScreenSpaceBounds()

		if not ScreenSpaceBounds then
			return nil
		end

		return ScreenSpaceBounds.Min + v7 * Vector2.new(ScreenSpaceBounds.Width, ScreenSpaceBounds.Height) + GuiService:GetInsetArea(Enum.ScreenInsets.None).Min
	end

	if p1:IsA("SurfaceGui") then
		local v9 = p1.Adornee or p1.Parent

		if not v9 or not v9:IsA("BasePart") then
			return nil
		end

		local v10 = t1[p1.Face]
		local v11, v12 = p2:WorldToScreenPoint(v9.CFrame * v10 * ((v10:Inverse() * v9.Size):Abs() * Vector3.new(0.5 - v7.X, 0.5 - v7.Y, -0.5)))

		if not v12 then
			return nil
		end

		return Vector2.new(v11.X, v11.Y)
	end

	return nil
end

return guiPositionToScreenPosition
