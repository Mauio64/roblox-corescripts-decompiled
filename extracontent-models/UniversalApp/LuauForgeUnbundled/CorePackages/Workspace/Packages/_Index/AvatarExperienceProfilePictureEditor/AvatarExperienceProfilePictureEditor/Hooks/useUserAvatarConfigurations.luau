local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/HttpRequest")
local ProfilePlatformCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/ProfilePlatformCommon")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SignalsReact")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/parseCloseupCameraConfig")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")
local userAvatarConfigurationsApi = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Api/userAvatarConfigurationsApi")
local userAvatarConfigurationsCache = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Api/userAvatarConfigurationsCache")

local profileRefreshSignal = ProfilePlatformCommon.Signals.ProfileRefreshSignal
local useSignalState = SignalsReact.useSignalState

local v5 = {
	distanceScale = Constants.DefaultDistanceScale,
	yRotDeg = Constants.DefaultYRotDeg,
	fieldOfViewDeg = Constants.DefaultFieldOfViewDeg,
	emoteAssetId = nil
}

local config = HttpRequest.config({
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end
})

local function useUserAvatarConfigurations(current, p2)
	local v6 = not p2 or p2.listenToProfileRefreshSignal ~= false

	local v7 = if p2 then p2.selectionTypes else userAvatarConfigurationsApi.DEFAULT_SELECTION_TYPES

	local v8 = useSignalState(profileRefreshSignal.getProfileRefreshSignal)
	local state, setState = React.useState(0)
	local ref = React.useRef(0)

	React.useEffect(function()
		if not v6 then
			return
		end

		if v8 > ref.current then
			ref.current = v8
			setState(function(p3)
				return p3 + 1
			end)
		end
	end, { v6, v8 })

	local state2, setState2 = React.useState(v5)
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
			setState2(v5)
			setState3(nil)
			setState4(false)
		else
			if ref3.current ~= current then
				ref2.current = false
				ref3.current = current
				setState2(v5)
				setState3(nil)
			end

			if ref4.current ~= state then
				userAvatarConfigurationsCache.invalidate(current)
				ref4.current = state
			end

			if not ref2.current then
				setState4(true)
			end

			userAvatarConfigurationsCache.fetchCached(config, current, v7):andThen(function(p3)
				if flag then
					return
				end

				setState2(p3.parsed.closeupCameraConfig)
				setState3(p3.parsed.profileFrameAssetId)
				ref2.current = true
				setState4(false)
			end):catch(function(p3)
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
	end, { current, state, v7 })

	return state2, state3, state4
end

return useUserAvatarConfigurations
