local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)
require(script.Parent.multiGetProductInfo)

local shopItemMapping = require(script.Parent.shopItemMapping)
local makeRequestKey = shopItemMapping.makeRequestKey
local toShopItem = shopItemMapping.toShopItem
local GamePass = Enum.InfoType.GamePass

return {
	appendBonusItemRequests = function(t1: {[any]: any}, t2: {[any]: any}) -- line: 20
		-- upvalues: makeRequestKey (copy), GamePass (copy)
		local t3 = {}

		for _, v in ipairs(t1) do
			t3[makeRequestKey(v.id, v.infoType)] = true
		end

		for _, v in ipairs(t2) do
			local robuxPackages = v.robuxPackages

			if robuxPackages ~= nil then
				for _, v15 in robuxPackages do
					local bonusItem = v15.bonusItem

					if bonusItem ~= nil and bonusItem.type == "GamePass" then
						local v17 = makeRequestKey(bonusItem.id, GamePass)

						if not t3[v17] then
							t3[v17] = true
							table.insert(t1, {
								id = bonusItem.id,
								infoType = GamePass
							})
						end
					end
				end
			end
		end

		return t1
	end,
	mergeBonusItemDetailsIntoSections = function(t4: {[any]: any}, t5: {[any]: any}) -- line: 57
		-- upvalues: makeRequestKey (copy), GamePass (copy), toShopItem (copy)
		local t6 = {}

		for _, v in ipairs(t5) do
			t6[makeRequestKey(v.request.id, v.request.infoType)] = v
		end

		local t7 = table.create(#t4)

		for i, v in ipairs(t4) do
			local robuxPackages = v.robuxPackages

			if robuxPackages == nil or #robuxPackages == 0 then
				t7[i] = v
			else
				local t8 = nil

				for i2, v2 in ipairs(robuxPackages) do
					local bonusItem = v2.bonusItem

					if bonusItem == nil then
						if t8 ~= nil then
							t8[i2] = v2
						end
					else
						local v31 = t6[makeRequestKey(bonusItem.id, GamePass)]

						if v31 == nil or not v31.ok then
							if t8 ~= nil then
								t8[i2] = v2
							end
						else
							if t8 == nil then
								t8 = table.create(#robuxPackages)

								for i3 = 1, i2 - 1 do
									t8[i3] = robuxPackages[i3]
								end
							end

							t8[i2] = {
								id = v2.id,
								robuxAmount = v2.robuxAmount,
								currencyAmountStr = v2.currencyAmountStr,
								robuxImage = v2.robuxImage,
								productId = v2.productId,
								mobileProductId = v2.mobileProductId,
								bonusItem = v2.bonusItem,
								bonusItemDetails = toShopItem(v31.value, "GamePass", bonusItem.id),
								isPrimaryRobuxPackage = v2.isPrimaryRobuxPackage
							}
						end
					end
				end

				if t8 == nil then
					t7[i] = v
				else
					for i4 = #t8 + 1, #robuxPackages do
						t8[i4] = robuxPackages[i4]
					end

					t7[i] = {
						id = v.id,
						name = v.name,
						items = v.items,
						paymentSessionId = v.paymentSessionId,
						robuxPackages = t8
					}
				end
			end
		end

		return t7
	end
}
