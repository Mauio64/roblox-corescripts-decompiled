local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

return function(p2, p3, p4, p5): boolean
	return p2 == appPage.Home and p3 ~= appPage.GamesList and p4 == formFactor.COMPACT and not p5
end
