local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent
local React = require(parent.React)
local GameDetail = require(parent.GameDetail)
local OpenGameDetails = GameDetail.OpenGameDetails
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled
local FFlagLuaAppStableNavigateToGameDetails = require(GameTile.Flags.FFlagLuaAppStableNavigateToGameDetails)

local function useNavigateToGameDetails()
	local v = useDispatch()
	local current2 = useNavigation()
	local v2

	if FFlagLuaAppSduiEdpEnabled then
		v2 = useRoactService(RoactNetworking)
	else
		v2 = nil
	end

	if FFlagLuaAppStableNavigateToGameDetails then
		local ref = React.useRef(current2)
		ref.current = current2
		local useCallback = React.useCallback
		local function fn(p: string, p2)
			local current = ref.current
			local v3

			if FFlagLuaAppSduiEdpEnabled then
				v3 = v2
			end

			v(OpenGameDetails(p, current, p2, v3))
		end

		local v3

		if FFlagLuaAppSduiEdpEnabled then
			v3 = v2
		end

		return useCallback(fn, { v, v3 })
	else
		local useCallback = React.useCallback
		local function fn(p: string, p2)
			local v3

			if FFlagLuaAppSduiEdpEnabled then
				v3 = v2
			end

			v(OpenGameDetails(p, current2, p2, v3))
		end

		local v3

		if FFlagLuaAppSduiEdpEnabled then
			v3 = v2
		end

		return (useCallback(fn, { v, current2, v3 }))
	end
end

return useNavigateToGameDetails
