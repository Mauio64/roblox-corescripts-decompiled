local CorePackages = game:GetService("CorePackages")
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local useLastInputMethod = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useLastInputMethod

local function useShouldRenderQuickMenuButton() -- line: 6
	-- upvalues: useLastInputMethod (copy), IsVRAppBuild (copy)
	local v5 = useLastInputMethod() == "Gamepad"

	if IsVRAppBuild() or not v5 then
		return false
	end

	return true
end

return useShouldRenderQuickMenuButton
