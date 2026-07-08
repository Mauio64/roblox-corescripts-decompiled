local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetAvatarPreviewDetails = require(ParentParent.Actions.SetAvatarPreviewDetails)
local UpdateBulkPuchaseResults = require(ParentParent.Actions.UpdateBulkPuchaseResults)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)

local ItemTypeEnum = AvatarExperienceCommon.Enums.ItemTypeEnum
local FFlagAXEnableFetchAvatarPreview = require(ParentParent.Flags.FFlagAXEnableFetchAvatarPreview)
local FFlagAXEnableInspectAndBuyBulkPurchase = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableInspectAndBuyBulkPurchase

return Rodux.createReducer({}, {
	[UpdateBulkPuchaseResults.name] = if not FFlagAXEnableInspectAndBuyBulkPurchase then nil else function(p1, p2) -- line: 31
		-- upvalues: Cryo (copy)
		local RobuxSpent = p2.result.RobuxSpent
		local v14 = p1.totalPrice - RobuxSpent

		return Cryo.Dictionary.join(p1, {
			totalPrice = v14
		})
	end,
	[SetAvatarPreviewDetails.name] = if not FFlagAXEnableFetchAvatarPreview then nil else function(p3, p4) -- line: 41
		-- upvalues: Cryo (copy), ItemTypeEnum (copy)
		local t1 = {}
		local totalPrice = nil
		local totalValue = nil

		if p4.avatarPreviewDetails and p4.avatarPreviewDetails.look then
			local look = p4.avatarPreviewDetails.look

			totalPrice = look.totalPrice
			totalValue = look.totalValue

			if look.items then
				t1 = Cryo.List.map(look.items, function(p5) -- line: 53
					-- upvalues: ItemTypeEnum (copy)
					return {
						id = tostring(p5.id),
						itemType = if p5.itemType ~= ItemTypeEnum.Asset then ItemTypeEnum.Bundle else ItemTypeEnum.Asset,
						noPriceStatus = p5.noPriceStatus,
						quantityOwned = p5.quantityOwned
					}
				end)
			end
		end

		return Cryo.Dictionary.join(p3, {
			totalPrice = totalPrice,
			totalValue = totalValue,
			items = t1
		})
	end
})
