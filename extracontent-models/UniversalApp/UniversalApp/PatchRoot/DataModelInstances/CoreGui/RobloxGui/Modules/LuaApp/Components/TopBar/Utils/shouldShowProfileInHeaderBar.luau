local CorePackages = game:GetService("CorePackages")
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage

return function(p1, p2, p3, p4) -- line: 10
	-- upvalues: AppPage (copy), FormFactor (copy)
	return p1 == AppPage.Home and (p2 ~= AppPage.GamesList and (p3 == FormFactor.COMPACT and not p4))
end
