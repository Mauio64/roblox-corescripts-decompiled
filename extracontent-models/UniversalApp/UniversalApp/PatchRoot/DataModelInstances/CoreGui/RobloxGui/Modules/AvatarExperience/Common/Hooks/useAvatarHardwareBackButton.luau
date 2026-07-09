local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AndroidBackButtonConnection = require(Modules.LuaApp.Navigation.AndroidBackButtonConnection)
local isAvatarRouteVisible = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Utils.isAvatarRouteVisible)

local function useAvatarHardwareBackButton(t1: {[any]: any}) -- line: 31
	-- upvalues: React (copy), AndroidBackButtonConnection (copy), isAvatarRouteVisible (copy)
	local navigation = t1.navigation
	local avatarRoute = t1.avatarRoute
	local onBack = t1.onBack
	local v12 = t1.enabled ~= false
	local current = React.useRef(AndroidBackButtonConnection()).current
	local v14 = v12 and isAvatarRouteVisible({
		navigation = navigation,
		avatarRoute = avatarRoute
	})

	React.useEffect(function() -- line: 40
		-- upvalues: v14 (copy), current (copy), onBack (copy)
		if v14 then
			current.connect(onBack)
		end

		return function() -- line: 44
			-- upvalues: current (copy)
			current.disconnect()
		end
	end, {
		v14,
		onBack,
		current
	})
end

return useAvatarHardwareBackButton
