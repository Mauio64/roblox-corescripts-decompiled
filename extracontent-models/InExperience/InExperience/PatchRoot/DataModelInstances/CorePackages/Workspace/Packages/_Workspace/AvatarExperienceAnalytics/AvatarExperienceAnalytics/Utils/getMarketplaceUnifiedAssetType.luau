local function getMarketplaceUnifiedAssetType(p)
	if p == nil then
		return nil
	end

	return (tonumber(p))
end

return getMarketplaceUnifiedAssetType
