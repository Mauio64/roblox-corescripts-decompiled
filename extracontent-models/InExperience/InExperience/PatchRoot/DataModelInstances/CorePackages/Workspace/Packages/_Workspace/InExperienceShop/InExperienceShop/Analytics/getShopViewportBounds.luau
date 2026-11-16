local GuiService = game:GetService("GuiService")

local function getShopViewportBounds(vector2: Vector2)
	local topbarInset = GuiService.TopbarInset
	local _, v = GuiService:GetGuiInset()

	return {
		min = Vector2.new(0, topbarInset.Max.Y),
		max = Vector2.new(vector2.X, vector2.Y - v.Y)
	}
end

local function intersectViewPortBounds(shopViewportBounds, scrollClipBounds) -- 1 equivalent call inferred from this helper
	return {
		min = shopViewportBounds.min:Max(scrollClipBounds.min),
		max = shopViewportBounds.max:Min(scrollClipBounds.max)
	}
end

local function getScrollClipBounds(scrollingFrame)
	while scrollingFrame do
		if scrollingFrame:IsA("ScrollingFrame") then
			local absolutePosition = scrollingFrame.AbsolutePosition
			return {
				min = absolutePosition,
				max = absolutePosition + scrollingFrame.AbsoluteSize
			}
		end

		scrollingFrame = scrollingFrame.Parent
	end

	return nil
end

return {
	getShopViewportBounds = getShopViewportBounds,
	getShopImpressionsViewportBounds = function(vector2: Vector2, p)
		local shopViewportBounds = getShopViewportBounds(vector2)

		if p == nil then
			return shopViewportBounds
		end

		local scrollClipBounds = getScrollClipBounds(p)

		if scrollClipBounds == nil then
			return shopViewportBounds
		end

		return intersectViewPortBounds(shopViewportBounds, scrollClipBounds) -- inferred equivalent call
	end,
	intersectViewPortBounds = intersectViewPortBounds,
	getScrollClipBounds = getScrollClipBounds
}
