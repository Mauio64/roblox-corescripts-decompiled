local fFlagOptionalNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/SharedFlags").FFlagOptionalNavigation

local useNavigation = require("@game/CorePackages/Packages/_Index/RoactNavigation/RoactNavigation/views/useNavigation")

local function useRouteName()
	local v5 = useNavigation()

	if fFlagOptionalNavigation and v5 == nil then
		return nil
	end

	return v5.state.routeName
end

return useRouteName
