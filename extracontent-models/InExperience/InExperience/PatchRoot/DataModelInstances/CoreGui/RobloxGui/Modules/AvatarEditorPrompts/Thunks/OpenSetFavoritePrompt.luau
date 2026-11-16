local AvatarEditorService = game:GetService("AvatarEditorService")
local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")

local Promise = require(CorePackages.Packages.Promise)

local parent = script.Parent.Parent
local OpenPrompt = require(parent.Actions.OpenPrompt)

local PromptType = require(parent.PromptType)

return function(itemId, itemType, shouldFavorite)
	return function(object)
		return Promise.new(function(callback, callback2)
			local v

			if itemType == Enum.AvatarItemType.Asset then
				v = Enum.InfoType.Asset
			else
				v = Enum.InfoType.Bundle
			end

			local success, result = pcall(function()
				return MarketplaceService:GetProductInfoAsync(itemId, v)
			end)

			if success then
				object:dispatch(OpenPrompt(PromptType.SetFavorite, {
					itemId = itemId,
					itemName = result.Name,
					itemType = itemType,
					shouldFavorite = shouldFavorite
				}))

				callback()
			else
				AvatarEditorService:SignalSetFavoriteFailed()

				callback2()
			end
		end)
	end
end
