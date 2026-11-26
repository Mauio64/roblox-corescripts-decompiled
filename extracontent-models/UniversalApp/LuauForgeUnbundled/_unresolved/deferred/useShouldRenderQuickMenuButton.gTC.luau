local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local useLastInputMethod = require("@luauforge/bundled/ehL").useLastInputMethod

local function useShouldRenderQuickMenuButton(): boolean
	local v5 = useLastInputMethod() == "Gamepad"

	if isVRAppBuild() or not v5 then
		return false
	end

	return true
end

return useShouldRenderQuickMenuButton
