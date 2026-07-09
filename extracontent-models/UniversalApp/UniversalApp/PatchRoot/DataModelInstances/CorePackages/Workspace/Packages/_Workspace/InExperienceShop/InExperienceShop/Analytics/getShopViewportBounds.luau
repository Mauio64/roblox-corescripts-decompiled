local GuiService = game:GetService("GuiService")

local function getShopViewportBounds(vector2: Vector2) -- line: 8
	-- upvalues: GuiService (copy)
	local TopbarInset = GuiService.TopbarInset
	local _, v7 = GuiService:GetGuiInset()

	return {
		min = Vector2.new(0, TopbarInset.Max.Y),
		max = Vector2.new(vector2.X, vector2.Y - v7.Y)
	}
end
local function getScrollClipBounds(p1) -- line: 25
	while p1 do
		if p1:IsA("ScrollingFrame") then
			local AbsolutePosition = p1.AbsolutePosition
			local AbsoluteSize = p1.AbsoluteSize

			return {
				min = AbsolutePosition,
				max = AbsolutePosition + AbsoluteSize
			}
		end

		p1 = p1.Parent
	end

	return nil
end

return {
	getShopViewportBounds = getShopViewportBounds,
	getShopImpressionsViewportBounds = function(vector2: Vector2, p2) -- line: 44
		-- upvalues: getShopViewportBounds (copy), getScrollClipBounds (copy)
		local v15 = getShopViewportBounds(vector2)

		if p2 == nil then
			return v15
		end

		local v16 = getScrollClipBounds(p2)

		if v16 == nil then
			return v15
		end

		return {
			min = v15.min:Max(v16.min),
			max = v15.max:Min(v16.max)
		}
	end,
	intersectViewPortBounds = function(t1: {[any]: any}, t2: {[any]: any}) -- line: 18
		return {
			min = t1.min:Max(t2.min),
			max = t1.max:Min(t2.max)
		}
	end,
	getScrollClipBounds = getScrollClipBounds
}
