local module = require("@luauforge/deferred/enn")
local useDispatch = require("@luauforge/deferred/eot").Hooks.RoactRodux.useDispatch
local useNavigation = require("@luauforge/deferred/eou").useNavigation
local openGameDetails = require("@luauforge/deferred/eov").OpenGameDetails
local useRoactService = require("@luauforge/deferred/eow").useRoactService
local roactNetworking = require("@luauforge/deferred/eox").RoactNetworking

local fFlagLuaAppSduiEdpEnabled = require("@luauforge/deferred/eoe").FFlagLuaAppSduiEdpEnabled

local module2 = require("@luauforge/deferred/eoy")

local function useOpenExperienceDetails()
	local v5 = useDispatch()
	local v6 = useNavigation()

	local v7 = if fFlagLuaAppSduiEdpEnabled then useRoactService(roactNetworking) else nil

	local function fn(p2)
		if p2 == nil or p2 == 0 then
			return
		end

		v5(openGameDetails(
			p2,
			v6,
			{ referralSource = module2.ReferralSource },
			if fFlagLuaAppSduiEdpEnabled then v7 else nil
		))
	end

	return module.useCallback(fn, { v5, v6, if fFlagLuaAppSduiEdpEnabled then v7 else nil })
end

return useOpenExperienceDetails
