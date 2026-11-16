local GuiService = game:GetService("GuiService")

local v = {
	[Enum.NormalId.Front] = CFrame.identity,
	[Enum.NormalId.Left] = CFrame.fromEulerAngles(0, 1.5707963267948966, 0),
	[Enum.NormalId.Back] = CFrame.fromEulerAngles(0, 3.141592653589793, 0),
	[Enum.NormalId.Right] = CFrame.fromEulerAngles(0, -1.5707963267948966, 0),
	[Enum.NormalId.Top] = CFrame.fromEulerAnglesYXZ(1.5707963267948966, -1.5707963267948966, 0),
	[Enum.NormalId.Bottom] = CFrame.fromEulerAnglesYXZ(-1.5707963267948966, -1.5707963267948966, 0)
}

local function guiPositionToScreenPosition(instance, vector2: Vector2, object)
	local v2 = vector2 / instance.AbsoluteSize

	if instance:IsA("ScreenGui") then
		return vector2
	end

	if instance:IsA("BillboardGui") then
		local screenSpaceBounds = instance:GetScreenSpaceBounds()

		if screenSpaceBounds then
			return screenSpaceBounds.Min + v2 * Vector2.new(screenSpaceBounds.Width, screenSpaceBounds.Height) + GuiService:GetInsetArea(Enum.ScreenInsets.None).Min
		end

		return nil
	else
		if not instance:IsA("SurfaceGui") then
			return nil
		end

		local adornee = instance.Adornee or instance.Parent

		if not (adornee and adornee:IsA("BasePart")) then
			return nil
		end

		local cframe = v[instance.Face]

		local worldToScreenPoint, v3 = object:WorldToScreenPoint(adornee.CFrame * cframe * ((cframe:Inverse() * adornee.Size):Abs() * Vector3.new(0.5 - v2.X, 0.5 - v2.Y, -0.5)))

		if v3 then
			return Vector2.new(worldToScreenPoint.X, worldToScreenPoint.Y)
		end

		return nil
	end
end

return guiPositionToScreenPosition
