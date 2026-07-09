local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiDataBinderTransformUtils = require(SduiCoreSystem.ClientBinding.SduiDataBinderTransformUtils)
local snakeToCamel = SduiDataBinderTransformUtils.snakeToCamel
local protobufTimestampToLocalTimeString = SduiDataBinderTransformUtils.protobufTimestampToLocalTimeString
local t1 = {
	DataStatus = {
		Ready = "Ready",
		NotReady = "NotReady",
		Failed = "Failed"
	}
}

return {
	createDataHydrationMock = function(t2: {[any]: any}?) -- line: 30
		-- upvalues: t1 (copy)
		local t3 = {
			Badges = t2 and t2.Badges or {
				getBadgeInfoStore = function() -- line: 46
					return {
						getBadgeInfo = function() -- line: 48
							return {
								data = function() -- line: 50
									return nil
								end,
								status = function() -- line: 53
									return "NotReady"
								end
							}
						end,
						getBadgeInfos = function() -- line: 58
							return {}
						end,
						clear = function() -- line: 61
						end,
						dispose = function() -- line: 62
						end
					}
				end
			},
			Game = t2 and t2.Game or nil,
			SocialLink = t2 and t2.SocialLink or nil,
			MarketplaceCatalogCategory = t2 and t2.MarketplaceCatalogCategory or {
				getMarketplaceCatalogCategoryStore = function() -- line: 69
					return {
						getMarketplaceCatalogCategory = function() -- line: 71
							return {
								data = function() -- line: 73
									return nil
								end,
								status = function() -- line: 76
									return "NotReady"
								end
							}
						end,
						getMarketplaceCatalogCategories = function() -- line: 81
							return {}
						end,
						updateMarketplaceCatalogCategories = function() -- line: 84
						end,
						updateMarketplaceCatalogCategory = function() -- line: 85
						end,
						clear = function() -- line: 86
						end,
						dispose = function() -- line: 87
						end
					}
				end
			},
			MarketplaceCatalogSort = t2 and t2.MarketplaceCatalogSort or {
				getMarketplaceCatalogSortStore = function() -- line: 92
					return {
						getMarketplaceCatalogSort = function() -- line: 94
							return {
								data = function() -- line: 96
									return nil
								end,
								status = function() -- line: 99
									return "NotReady"
								end
							}
						end,
						getMarketplaceCatalogSorts = function() -- line: 104
							return {}
						end,
						updateMarketplaceCatalogSorts = function() -- line: 107
						end,
						updateMarketplaceCatalogSort = function() -- line: 108
						end,
						clear = function() -- line: 109
						end,
						dispose = function() -- line: 110
						end
					}
				end
			},
			Song = t2 and t2.Song or nil,
			MarketplaceAsset = t2 and t2.MarketplaceAsset or nil,
			MarketplaceBundle = t2 and t2.MarketplaceBundle or nil,
			MarketplaceLook = t2 and t2.MarketplaceLook or nil,
			MediaAsset = t2 and t2.MediaAsset or nil,
			UserProfile = t2 and t2.UserProfile or nil,
			DataHydrationTypes = t1
		}

		if t2 and t2.extraFields then
			for v8, v9 in t2.extraFields do
				t3[v8] = v9
			end
		end

		return t3
	end,
	createSduiDataBinderTransformUtilsMock = function() -- line: 137
		-- upvalues: snakeToCamel (copy), protobufTimestampToLocalTimeString (copy)
		return {
			snakeToCamel = snakeToCamel,
			protobufTimestampToLocalTimeString = protobufTimestampToLocalTimeString
		}
	end,
	snakeToCamel = snakeToCamel,
	protobufTimestampToLocalTimeString = protobufTimestampToLocalTimeString,
	DataHydrationTypesMock = t1
}
