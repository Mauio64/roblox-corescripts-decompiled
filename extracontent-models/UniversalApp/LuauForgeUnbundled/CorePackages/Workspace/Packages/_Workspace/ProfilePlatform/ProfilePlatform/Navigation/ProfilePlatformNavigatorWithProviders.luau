local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AppCommonLib")
local subPages = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics").Analytics.Enums.SubPages
local initializeProfileAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/initializeProfileAnalytics")
local ProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileAnalyticsContext")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local ProfileScrollContextProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileScrollContext/ProfileScrollContextProvider")
local HttpService = game:GetService("HttpService")
local fFlagProfilePlatformEnableImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableImpressions

local ProfilePlatformNavigator = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Navigation/ProfilePlatformNavigator")

local function fn(p2)
	local ref = if not fFlagProfilePlatformEnableImpressions then React.createRef() else nil
	local v5 = useProfileWrapperContext()
	local profileId = v5.profileId

	local signal = if fFlagProfilePlatformEnableImpressions then AppCommonLib.Signal.new() else nil

	local v6 = React.useMemo(function()
		if not fFlagProfilePlatformEnableImpressions and ref.current == nil then
			ref.current = HttpService:GenerateGUID(false)
		end

		local v7 = initializeProfileAnalytics()
		local updateInfoForAllEvents = v7.updateInfoForAllEvents
		local v9

		if fFlagProfilePlatformEnableImpressions then
			v9 = v5.profileSessionId
		else
			v9 = if v5.sessionIdOverride then v5.sessionIdOverride else ref.current
		end

		updateInfoForAllEvents({
			profileSessionId = v9,
			profileId = profileId,
			profileType = v5.profileType,
			subpage = subPages.PeekView
		})

		if fFlagProfilePlatformEnableImpressions then
			return (Cryo.Dictionary.join(v7, {
				scrollViewPositionChangedSignal = signal
			}))
		end

		return v7
	end, { profileId, v5.sessionIdOverride })

	return React.createElement(ProfileAnalyticsContext.Provider, { value = v6 }, {
		React.createElement(ProfileScrollContextProvider, nil, { React.createElement(ProfilePlatformNavigator, p2) })
	})
end

local extended = React.PureComponent:extend("ProfilePlatformNavigatorWithProviders")

function extended.render(p2)
	return React.createElement(fn, p2.props)
end

extended.router = ProfilePlatformNavigator.router

return extended
