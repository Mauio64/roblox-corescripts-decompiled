local function getMarketplaceUnifiedAssetType(p2)
	if p2 == nil then
		return nil
	end

	return (tonumber(p2))
end

return getMarketplaceUnifiedAssetType
