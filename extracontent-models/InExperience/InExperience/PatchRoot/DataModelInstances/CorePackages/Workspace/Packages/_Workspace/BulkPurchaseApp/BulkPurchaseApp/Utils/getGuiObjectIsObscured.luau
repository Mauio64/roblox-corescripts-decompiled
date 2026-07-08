local CoreGui = game:GetService("CoreGui")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local FIntAXGuiObjectIsObscuredPadding = require(BulkPurchaseApp.Flags.FIntAXGuiObjectIsObscuredPadding)

local function getGuiObjectIsObscuredAtPosition(p1, n1: number, n2: number) -- line: 5
	-- upvalues: CoreGui (copy)
	for _, v10 in (CoreGui:GetGuiObjectsAtPosition(n1, n2)) do
		if (not v10:IsA("Frame") or v10.Active ~= false or v10.BackgroundTransparency ~= 1) and not v10:IsDescendantOf(p1) then
			if v10 == p1 then
				return false
			end

			return true
		end
	end

	return false
end
local function getGuiObjectIsObscured(p2) -- line: 21
	-- upvalues: getGuiObjectIsObscuredAtPosition (copy), FIntAXGuiObjectIsObscuredPadding (copy)
	local AbsolutePosition = p2.AbsolutePosition
	local AbsoluteSize = p2.AbsoluteSize
	local v14 = AbsolutePosition + AbsoluteSize * 0.5
	local v15 = AbsolutePosition + AbsoluteSize
	local v16 = AbsolutePosition + Vector2.new(AbsoluteSize.X, 0)
	local v17 = AbsolutePosition + Vector2.new(0, AbsoluteSize.Y)
	local v18 = AbsolutePosition + AbsoluteSize * Vector2.new(math.random(1, 9) / 10, math.random(1, 9) / 10)

	return getGuiObjectIsObscuredAtPosition(p2, v14.X, v14.Y) or (getGuiObjectIsObscuredAtPosition(p2, AbsolutePosition.X + FIntAXGuiObjectIsObscuredPadding, AbsolutePosition.Y + FIntAXGuiObjectIsObscuredPadding) or (getGuiObjectIsObscuredAtPosition(p2, v17.X + FIntAXGuiObjectIsObscuredPadding, v17.Y - FIntAXGuiObjectIsObscuredPadding) or (getGuiObjectIsObscuredAtPosition(p2, v16.X - FIntAXGuiObjectIsObscuredPadding, v16.Y + FIntAXGuiObjectIsObscuredPadding) or (getGuiObjectIsObscuredAtPosition(p2, v15.X - FIntAXGuiObjectIsObscuredPadding, v15.Y - FIntAXGuiObjectIsObscuredPadding) or getGuiObjectIsObscuredAtPosition(p2, math.floor(v18.X), (math.floor(v18.Y)))))))
end

return getGuiObjectIsObscured
