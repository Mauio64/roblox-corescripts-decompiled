local CorePackages = game:GetService("CorePackages")
local NavigateDown = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateDown
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local t = require(CorePackages.Packages.t)
local AppPage = RobloxAppEnums.AppPage

return function(p1) -- line: 8
	-- upvalues: t (copy), NavigateDown (copy), AppPage (copy)
	assert(t.callback(p1) or t.none(p1), "")

	return NavigateDown({
		name = AppPage.Groups,
		extraProps = {
			onClose = p1
		}
	})
end
