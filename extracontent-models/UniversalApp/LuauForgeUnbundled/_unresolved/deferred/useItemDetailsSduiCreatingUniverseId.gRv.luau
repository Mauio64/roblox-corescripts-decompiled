local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/React")
local module2 = require("@luauforge/deferred/gRw")
local useSignalState = require("@luauforge/deferred/gRx").useSignalState
local module3 = require("@luauforge/deferred/gRy")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceModel").Enums.ItemTypeEnum

local signal = module2.createSignal(nil)

local function useItemDetailsSduiCreatingUniverseId(p2, p3)
	return useSignalState((React.useMemo(function()
		if p2 == nil then
			return signal
		end

		if p3 == itemTypeEnum.Bundle then
			return module3.MarketplaceBundle.getMarketplaceBundleStore(false).getCreatingUniverseId(p2)
		end

		return module3.MarketplaceAsset.getMarketplaceAssetStore(false).getCreatingUniverseId(p2)
	end, { p2, p3 })))
end

return useItemDetailsSduiCreatingUniverseId
