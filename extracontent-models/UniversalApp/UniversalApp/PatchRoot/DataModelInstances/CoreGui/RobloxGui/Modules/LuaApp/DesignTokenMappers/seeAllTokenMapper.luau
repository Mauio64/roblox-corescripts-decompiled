local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.Style)
require(CorePackages.Workspace.Packages.RobloxAppHooks)

local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

local function makeSeeAllTokenMapper(p1, _) -- line: 12
	-- upvalues: UiMode (copy), FFlagEnableLeftNavOnConsole (copy)
	return {
		BackgroundTransparency = (p1.uiMode ~= UiMode.TenFoot or FFlagEnableLeftNavOnConsole) and 0 or 1
	}
end

return makeSeeAllTokenMapper
