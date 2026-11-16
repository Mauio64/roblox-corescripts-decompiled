local CorePackages = game:GetService("CorePackages")
local parent = script.Parent.Parent
local Constants = require(parent.Constants)
require(parent.Services.Analytics)
require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)

return function(p, p2: string?, p3: string?, price2: number?)
	if not p2 then
		return { price = price2 }
	end

	local itemSubType, price

	if p3 == Constants.ItemType.Bundle then
		local v = p.bundles and p.bundles[p2]

		if not v then
			return { price = price2 }
		end

		itemSubType = v.bundleType
		price = tonumber(v.price)
	else
		local v = p.assets and p.assets[p2]

		if not v then
			return { price = price2 }
		end

		itemSubType = v.assetTypeId
		price = tonumber(v.price)
	end

	if itemSubType == nil or itemSubType == "" then
		itemSubType = nil
	end

	return {
		itemSubType = itemSubType,
		price = price2 or price
	}
end
