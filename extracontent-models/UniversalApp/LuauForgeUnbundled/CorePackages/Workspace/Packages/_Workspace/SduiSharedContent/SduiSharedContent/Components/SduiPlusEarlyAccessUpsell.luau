local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local plusEarlyAccessUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/GamePlayButton").PlusEarlyAccessUpsellBanner

local function SduiPlusEarlyAccessUpsell(p2)
	if p2.universeId == nil then
		return nil
	end

	return React.createElement(plusEarlyAccessUpsellBanner, {
		universeId = p2.universeId,
		LayoutOrder = p2.layoutOrder
	})
end

return React.memo(SduiPlusEarlyAccessUpsell)
