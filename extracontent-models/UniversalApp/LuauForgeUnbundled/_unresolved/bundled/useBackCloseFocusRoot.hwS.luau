local module = require("@luauforge/bundled/hwl")
local module2 = require("@luauforge/bundled/hwn")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")
local module4 = require("@luauforge/bundled/hwp")

local useFocusRoot = module.useFocusRoot
local focusNavigableSurfaceIdentifierEnum = module.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum
local useMostRecentOrDefaultFocusBehavior = module4.useMostRecentOrDefaultFocusBehavior

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useBackCloseFocusRoot(callback)
	local v5 = React.useMemo(function()
		local v6 = {}
		v6[focusNavigationEventNameEnum.NavigateBack] = {
			handler = module2.onRelease(function(object)
				callback()
				object:cancel()
			end)
		}

		return v6
	end, { callback })

	local v7, v8 = useMostRecentOrDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		eventMap = navigateBacks,
		eventHandlers = v5,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false
	})))
	return v8
end

return useBackCloseFocusRoot
