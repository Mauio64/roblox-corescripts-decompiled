local Parent = script:FindFirstAncestor("GameTile").Parent
local React = require(Parent.React)
local OpenGameDetails = require(Parent.GameDetail).OpenGameDetails
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(Parent.Navigation).useNavigation
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
local FFlagSduiEdpPrefetchPlayability = require(Parent.SharedFlags).FFlagSduiEdpPrefetchPlayability
local FFlagLuaAppSduiEdpEnabled = require(Parent.SharedFlags).FFlagLuaAppSduiEdpEnabled

local function useNavigateToGameDetails() -- line: 13
	-- upvalues: useDispatch (copy), useNavigation (copy), FFlagSduiEdpPrefetchPlayability (copy), FFlagLuaAppSduiEdpEnabled (copy), useRoactService (copy), RoactNetworking (copy), React (copy), OpenGameDetails (copy)
	local v11 = useDispatch()
	local v12 = useNavigation()
	local u13 = nil

	if FFlagSduiEdpPrefetchPlayability and FFlagLuaAppSduiEdpEnabled then
		u13 = useRoactService(RoactNetworking)
	end

	return (React.useCallback(function(s1: string, t1: {[any]: any}) -- line: 21
		-- upvalues: v11 (copy), OpenGameDetails (copy), v12 (copy), FFlagSduiEdpPrefetchPlayability (copy), FFlagLuaAppSduiEdpEnabled (copy), u13 (ref)
		v11(OpenGameDetails(s1, v12, t1, if not FFlagSduiEdpPrefetchPlayability or not FFlagLuaAppSduiEdpEnabled then nil else u13))
	end, {
		v11,
		v12,
		if not FFlagSduiEdpPrefetchPlayability or not FFlagLuaAppSduiEdpEnabled then nil else u13
	}))
end

return useNavigateToGameDetails
