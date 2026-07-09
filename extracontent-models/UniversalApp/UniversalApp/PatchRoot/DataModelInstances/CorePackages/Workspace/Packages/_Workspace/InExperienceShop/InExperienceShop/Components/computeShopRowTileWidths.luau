return {
	SHOP_ITEM_MEDIA_HEIGHT_SCALE = 0.85,
	MEDIA_HEIGHT_SCALE_FALLBACK = 0.425,
	computeShopRowTileWidths = function(n1: number, n2: number, n3: number, b1: boolean) -- line: 21
		if n1 <= 0 or n3 <= 0 then
			return {
				shopWidth = 0,
				featuredRobuxWidth = if not b1 then nil else 0
			}
		end

		local v5 = (n1 - (n3 - 1) * n2) / n3

		return {
			shopWidth = v5,
			featuredRobuxWidth = if not b1 then nil else v5 * 2 + n2
		}
	end,
	computeRobuxPackageMediaHeightScale = function(n4: number, n5: number) -- line: 44
		if n4 <= 0 then
			return 0.425
		end

		local v8 = n4 * 2 + n5

		if v8 <= 0 then
			return 0.425
		end

		return n4 * 0.85 / v8
	end
}
