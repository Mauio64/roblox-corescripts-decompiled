local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent
local React = require(parent.React)
local HttpRequest = require(parent.HttpRequest)
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local SignalsReact = require(parent.SignalsReact)
local Constants = require(AvatarExperienceProfilePictureEditor.Constants)
require(AvatarExperienceProfilePictureEditor.Shared.parseCloseupCameraConfig)
require(AvatarExperienceProfilePictureEditor.Common.Enums)
local userAvatarConfigurationsApi = require(AvatarExperienceProfilePictureEditor.Api.userAvatarConfigurationsApi)
local userAvatarConfigurationsCache = require(AvatarExperienceProfilePictureEditor.Api.userAvatarConfigurationsCache)

local ProfileRefreshSignal = ProfilePlatformCommon.Signals.ProfileRefreshSignal
local useSignalState = SignalsReact.useSignalState

local v = {
	distanceScale = Constants.DefaultDistanceScale,
	yRotDeg = Constants.DefaultYRotDeg,
	fieldOfViewDeg = Constants.DefaultFieldOfViewDeg,
	emoteAssetId = nil
}

local config = HttpRequest.config({
	requestFunction = function(p: string, p2, p3)
		return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end
})

local function useUserAvatarConfigurations(current: string?, p)
	local v2 = not p or p.listenToProfileRefreshSignal ~= false
	local v3

	if p then
		v3 = p.selectionTypes
	else
		v3 = userAvatarConfigurationsApi.DEFAULT_SELECTION_TYPES
	end

	local current2 = useSignalState(ProfileRefreshSignal.getProfileRefreshSignal)
	local state, setState = React.useState(0)
	local ref = React.useRef(0)

	React.useEffect(function()
		if not v2 then
			return
		end

		if current2 > ref.current then
			ref.current = current2
			setState(function(p2)
				return p2 + 1
			end)
		end
	end, { v2, current2 })

	local state2, setState2 = React.useState(v)
	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(true)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(state)

	React.useEffect(function()
		local flag = false

		if current == nil then
			ref2.current = false
			ref3.current = nil
			ref4.current = state
			setState2(v)
			setState3(nil)
			setState4(false)
		else
			if ref3.current ~= current then
				ref2.current = false
				ref3.current = current
				setState2(v)
				setState3(nil)
			end

			if ref4.current ~= state then
				userAvatarConfigurationsCache.invalidate(current)
				ref4.current = state
			end

			if not ref2.current then
				setState4(true)
			end

			userAvatarConfigurationsCache.fetchCached(config, current, v3):andThen(function(p2)
				if flag then
					return
				end

				setState2(p2.parsed.closeupCameraConfig)
				setState3(p2.parsed.profileFrameAssetId)
				ref2.current = true
				setState4(false)
			end):catch(function(_)
				if flag then
					return
				end

				ref2.current = true
				setState4(false)
			end)

			return function()
				flag = true
			end
		end
	end, { current, state, v3 })

	return state2, state3, state4
end

return useUserAvatarConfigurations
