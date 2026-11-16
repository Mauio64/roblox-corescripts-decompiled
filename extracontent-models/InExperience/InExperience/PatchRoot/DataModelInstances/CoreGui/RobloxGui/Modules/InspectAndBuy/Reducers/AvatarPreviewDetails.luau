local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetAvatarPreviewDetails = require(parent.Actions.SetAvatarPreviewDetails)
local UpdateBulkPuchaseResults = require(parent.Actions.UpdateBulkPuchaseResults)
local AvatarExperienceModel = require(CorePackages.Workspace.Packages.AvatarExperienceModel)
require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local FFlagAXEnableFetchAvatarPreview = require(parent.Flags.FFlagAXEnableFetchAvatarPreview)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAXEnableInspectAndBuyBulkPurchase = SharedFlags.FFlagAXEnableInspectAndBuyBulkPurchase

return Rodux.createReducer({}, {
	[UpdateBulkPuchaseResults.name] = FFlagAXEnableInspectAndBuyBulkPurchase and function(p, p2)
		local robuxSpent = p2.result.RobuxSpent
		local totalPrice = p.totalPrice - robuxSpent
		return Cryo.Dictionary.join(p, { totalPrice = totalPrice })
	end or nil,
	[SetAvatarPreviewDetails.name] = FFlagAXEnableFetchAvatarPreview and function(p, p2)
		local items = {}
		local totalPrice, totalValue

		if p2.avatarPreviewDetails and p2.avatarPreviewDetails.look then
			local look = p2.avatarPreviewDetails.look

			totalPrice = look.totalPrice
			totalValue = look.totalValue

			if look.items then
				items = Cryo.List.map(look.items, function(data)
					local v = {
						id = tostring(data.id),
						itemType = 0,
						noPriceStatus = 0,
						quantityOwned = 0
					}
					local itemType

					if data.itemType == ItemTypeEnum.Asset then
						itemType = ItemTypeEnum.Asset
					else
						itemType = ItemTypeEnum.Bundle
					end

					v.itemType = itemType
					v.noPriceStatus = data.noPriceStatus
					v.quantityOwned = data.quantityOwned
					return v
				end)
			end
		end

		return Cryo.Dictionary.join(p, {
			totalPrice = totalPrice,
			totalValue = totalValue,
			items = items
		})
	end or nil
})
