local AvatarEditorService = game:GetService("AvatarEditorService")
local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")
local Promise = require(CorePackages.Packages.Promise)
local ParentParent = script.Parent.Parent
local OpenPrompt = require(ParentParent.Actions.OpenPrompt)
local PromptType = require(ParentParent.PromptType)

return function(p1, p2, p3) -- line: 12
	-- upvalues: Promise (copy), MarketplaceService (copy), OpenPrompt (copy), PromptType (copy), AvatarEditorService (copy)
	return function(p4) -- line: 13
		-- upvalues: Promise (copy), p2 (copy), MarketplaceService (copy), p1 (copy), OpenPrompt (copy), PromptType (copy), p3 (copy), AvatarEditorService (copy)
		return Promise.new(function(resolve, reject) -- line: 14
			-- upvalues: p2 (copy), MarketplaceService (copy), p1 (copy), p4 (copy), OpenPrompt (copy), PromptType (copy), p3 (copy), AvatarEditorService (copy)
			local u14 = if p2 ~= Enum.AvatarItemType.Asset then Enum.InfoType.Bundle else Enum.InfoType.Asset
			local ok, result = pcall(function() -- line: 22
				-- upvalues: MarketplaceService (copy), p1 (copy), u14 (ref)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return MarketplaceService:GetProductInfoAsync(p1, u14)
				end

				return MarketplaceService:GetProductInfo(p1, u14)
			end)

			if ok then
				p4:dispatch(OpenPrompt(PromptType.SetFavorite, {
					itemId = p1,
					itemName = result.Name,
					itemType = p2,
					shouldFavorite = p3
				}))
				resolve()
			else
				AvatarEditorService:SignalSetFavoriteFailed()
				reject()
			end
		end)
	end
end
