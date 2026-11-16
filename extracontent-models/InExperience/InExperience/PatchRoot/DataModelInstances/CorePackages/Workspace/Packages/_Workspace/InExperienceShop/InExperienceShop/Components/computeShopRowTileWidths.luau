local ComputeShopRowTileWidths = {}
ComputeShopRowTileWidths.SHOP_ITEM_MEDIA_HEIGHT_SCALE = 0.85
ComputeShopRowTileWidths.MEDIA_HEIGHT_SCALE_FALLBACK = 0.425

function ComputeShopRowTileWidths.computeShopRowTileWidths(p: number, p2: number, p3: number, flag: boolean)
	if p <= 0 or p3 <= 0 then
		return {
			shopWidth = 0,
			featuredRobuxWidth = flag and 0 or nil
		}
	end

	local shopWidth = (p - (p3 - 1) * p2) / p3
	local featuredRobuxWidth

	if flag then
		featuredRobuxWidth = shopWidth * 2 + p2
	end

	return { shopWidth = shopWidth, featuredRobuxWidth = featuredRobuxWidth }
end

function ComputeShopRowTileWidths.computeRobuxPackageMediaHeightScale(p: number, p2: number)
	if p <= 0 then
		return 0.425
	end

	local v = p * 2 + p2

	if v <= 0 then
		return 0.425
	end

	return p * 0.85 / v
end

return ComputeShopRowTileWidths
