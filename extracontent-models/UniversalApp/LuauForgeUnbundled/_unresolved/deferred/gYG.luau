local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local module = require("@luauforge/deferred/gOh")

return function(p2)
	local navigation = p2.navigation
	local success, result = pcall(module, navigation)
	local v5 = {}

	if success then
		if typeof(result) == "table" then
			v5 = result
		else
			logging.warn("[AX] getMainStackNavigationOptions: getActiveChildNavigationOptionsSafely returned non-table " .. `({typeof(result)}); using default options.`)
		end
	else
		logging.warn(`[AX] getMainStackNavigationOptions: getActiveChildNavigationOptionsSafely threw: {tostring(result)}`)
	end

	return {
		overlayTransparency = 1,
		absorbInput = false,
		backButtonAction = v5.backButtonAction
	}
end
