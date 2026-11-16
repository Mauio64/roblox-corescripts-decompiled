local parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(parent.React)
local GamePlayButton = require(parent.GamePlayButton)
local PlusEarlyAccessUpsellBanner = GamePlayButton.PlusEarlyAccessUpsellBanner

local function SduiPlusEarlyAccessUpsell(p)
	if p.universeId == nil then
		return nil
	end

	return React.createElement(PlusEarlyAccessUpsellBanner, {
		universeId = p.universeId,
		LayoutOrder = p.layoutOrder
	})
end

return React.memo(SduiPlusEarlyAccessUpsell)
