local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local openGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameDetail").OpenGameDetails
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Navigation").useNavigation
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags").RoactNetworking
local fFlagLuaAppSduiEdpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppSduiEdpEnabled
local FFlagLuaAppStableNavigateToGameDetails = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Flags/FFlagLuaAppStableNavigateToGameDetails")

local function useNavigateToGameDetails()
	local v5 = useDispatch()
	local v6 = useNavigation()

	local v7 = if fFlagLuaAppSduiEdpEnabled then useRoactService(roactNetworking) else nil

	if FFlagLuaAppStableNavigateToGameDetails then
		local ref = React.useRef(v6)
		ref.current = v6

		local function fn(p2, p3)
			v5(openGameDetails(p2, ref.current, p3, if fFlagLuaAppSduiEdpEnabled then v7 else nil))
		end

		return React.useCallback(fn, { v5, if fFlagLuaAppSduiEdpEnabled then v7 else nil })
	else
		local function fn(p2, p3)
			v5(openGameDetails(p2, v6, p3, if fFlagLuaAppSduiEdpEnabled then v7 else nil))
		end

		return (React.useCallback(fn, { v5, v6, if fFlagLuaAppSduiEdpEnabled then v7 else nil }))
	end
end

return useNavigateToGameDetails
