local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")

local ShopErrorDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/InExperienceShop/Components/ShopErrorDialog")

local module3 = require("@luauforge/bundled/hxS")

local function PurchaseWarningDialogContainer(p2)
	local v5 = module3(p2)
	return React.createElement(ShopErrorDialog, v5)
end

return PurchaseWarningDialogContainer
