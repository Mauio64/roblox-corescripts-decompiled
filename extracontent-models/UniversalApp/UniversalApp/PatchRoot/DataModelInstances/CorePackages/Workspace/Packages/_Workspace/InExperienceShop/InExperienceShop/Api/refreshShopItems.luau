local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)
require(script.Parent.multiGetProductInfo)

local shopItemMapping = require(script.Parent.shopItemMapping)
local makeRequestKey = shopItemMapping.makeRequestKey
local toShopItem = shopItemMapping.toShopItem

local function refreshShopItemFromProductInfo(p1, p2) -- line: 200
	-- upvalues: toShopItem (copy)
	local v50 = toShopItem(p2, p1.itemType, (tonumber(p1.id)))

	return {
		id = p1.id,
		itemType = p1.itemType,
		isOwned = p1.isOwned,
		creator = v50.creator or p1.creator,
		universeId = p1.universeId,
		originalIndex = p1.originalIndex,
		name = v50.name,
		thumbnail = v50.thumbnail,
		price = v50.price,
		description = v50.description,
		updated = v50.updated
	}
end

return {
	infoTypeForShopItemType = function(p3) -- line: 26
		if p3 == "Product" then
			return Enum.InfoType.Product
		end

		if p3 == "GamePass" then
			return Enum.InfoType.GamePass
		end

		return nil
	end,
	buildRequestsFromSections = function(t1: {[any]: any}) -- line: 39
		-- upvalues: makeRequestKey (copy)
		local t2 = {}
		local t3 = {}

		for _, v in ipairs(t1) do
			for _, v2 in ipairs(v.items) do
				local itemType = v2.itemType
				local v15 = if itemType ~= "Product" then if itemType ~= "GamePass" then nil else Enum.InfoType.GamePass else Enum.InfoType.Product

				if v15 ~= nil then
					local num = tonumber(v2.id)

					if num ~= nil then
						local v17 = makeRequestKey(num, v15)

						if not t3[v17] then
							t3[v17] = true
							table.insert(t2, {
								id = num,
								infoType = v15
							})
						end
					end
				end
			end
		end

		return t2
	end,
	appendFailedItemRequests = function(t4: {[any]: any}, t5: {[any]: any}) -- line: 66
		-- upvalues: makeRequestKey (copy)
		local t6 = {}

		for _, v in ipairs(t4) do
			t6[makeRequestKey(v.id, v.infoType)] = true
		end

		for _, v in ipairs(t5) do
			local v25 = makeRequestKey(v.id, v.infoType)

			if not t6[v25] then
				t6[v25] = true
				table.insert(t4, {
					id = v.id,
					infoType = v.infoType
				})
			end
		end

		return t4
	end,
	refreshShopItemFromProductInfo = refreshShopItemFromProductInfo,
	mergeProductInfoIntoSections = function(t7: {[any]: any}, t8: {[any]: any}) -- line: 230
		-- upvalues: makeRequestKey (copy), refreshShopItemFromProductInfo (copy)
		local t9 = {}

		for _, v in ipairs(t8) do
			t9[makeRequestKey(v.request.id, v.request.infoType)] = v
		end

		local t10 = table.create(#t7)

		for i, v in ipairs(t7) do
			local t11 = nil

			for i2, v3 in ipairs(v.items) do
				local itemType = v3.itemType
				local v63 = if itemType ~= "Product" then if itemType ~= "GamePass" then nil else Enum.InfoType.GamePass else Enum.InfoType.Product
				local num = tonumber(v3.id)
				local v65 = nil

				if v63 ~= nil and num ~= nil then
					v65 = t9[makeRequestKey(num, v63)]
				end

				if v65 ~= nil and v65.ok then
					if t11 == nil then
						t11 = table.create(#v.items)

						for i3 = 1, i2 - 1 do
							t11[i3] = v.items[i3]
						end
					end

					t11[i2] = refreshShopItemFromProductInfo(v3, v65.value)
				elseif t11 ~= nil then
					t11[i2] = v3
				end
			end

			if t11 == nil then
				t10[i] = v
			else
				t10[i] = {
					id = v.id,
					name = v.name,
					items = t11,
					paymentSessionId = v.paymentSessionId,
					robuxPackages = v.robuxPackages
				}
			end
		end

		return t10
	end,
	insertRecoveredItemsIntoSections = function(t12: {[any]: any}, t13: {[any]: any}, t14: {[any]: any}) -- line: 108
		-- upvalues: makeRequestKey (copy), toShopItem (copy)
		local t15 = {}

		for _, v in ipairs(t13) do
			t15[makeRequestKey(v.request.id, v.request.infoType)] = v
		end

		local t16 = {}
		local t17 = {}

		for _, v in ipairs(t14) do
			local v36 = t15[makeRequestKey(v.id, v.infoType)]

			if v36 == nil or not v36.ok then
				table.insert(t17, v)
			else
				local v37 = t16[v.sectionId]

				if v37 == nil then
					v37 = {}
					t16[v.sectionId] = v37
				end

				local v38 = toShopItem(v36.value, v.itemType, v.id)

				v38.originalIndex = v.originalIndex
				table.insert(v37, v38)
			end
		end

		local t18 = table.create(#t12)

		for i, v in ipairs(t12) do
			local v42 = t16[v.id]

			if v42 == nil then
				t18[i] = v
			else
				table.sort(v42, function(p4, p5) -- line: 159
					return (p4.originalIndex or 0) < (p5.originalIndex or 0)
				end)

				local t19 = table.create(#v.items + #v42)
				local n1 = 1
				local n2 = 1

				while n1 <= #v.items or n2 <= #v42 do
					local v46 = v.items[n1]
					local v47 = v42[n2]

					if v47 == nil then
						table.insert(t19, v46)
						n1 += 1
					elseif v46 == nil then
						table.insert(t19, v47)
						n2 += 1
					elseif (v46.originalIndex or 0) <= (v47.originalIndex or 0) then
						table.insert(t19, v46)
						n1 += 1
					else
						table.insert(t19, v47)
						n2 += 1
					end
				end

				t18[i] = {
					id = v.id,
					name = v.name,
					items = t19,
					paymentSessionId = v.paymentSessionId,
					robuxPackages = v.robuxPackages
				}
			end
		end

		return t18, t17
	end
}
