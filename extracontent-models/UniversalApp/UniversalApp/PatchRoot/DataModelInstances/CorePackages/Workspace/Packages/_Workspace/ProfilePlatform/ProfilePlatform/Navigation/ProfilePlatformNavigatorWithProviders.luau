local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Cryo = require(ProfilePlatformParent.Cryo)
local React = require(ProfilePlatformParent.React)
local AppCommonLib = require(ProfilePlatformParent.AppCommonLib)
local SubPages = require(ProfilePlatformParent.SocialLuaAnalytics).Analytics.Enums.SubPages
local initializeProfileAnalytics = require(ProfilePlatform.Analytics.initializeProfileAnalytics)
local ProfileAnalyticsContext = require(ProfilePlatform.Contexts.ProfileAnalyticsContext)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local ProfileScrollContextProvider = require(ProfilePlatform.Contexts.ProfileScrollContext.ProfileScrollContextProvider)
local HttpService = game:GetService("HttpService")
local FFlagProfilePlatformEnableImpressions = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableImpressions
local ProfilePlatformNavigator = require(script.Parent.ProfilePlatformNavigator)

local function v14(p1) -- line: 18
	-- upvalues: FFlagProfilePlatformEnableImpressions (copy), React (copy), useProfileWrapperContext (copy), AppCommonLib (copy), HttpService (copy), initializeProfileAnalytics (copy), SubPages (copy), Cryo (copy), ProfileAnalyticsContext (copy), ProfileScrollContextProvider (copy), ProfilePlatformNavigator (copy)
	local v17 = if not FFlagProfilePlatformEnableImpressions then React.createRef() else nil
	local v18 = useProfileWrapperContext()
	local profileId = v18.profileId
	local v20 = if not FFlagProfilePlatformEnableImpressions then nil else AppCommonLib.Signal.new()
	local v21 = React.useMemo(function() -- line: 27
		-- upvalues: FFlagProfilePlatformEnableImpressions (copy), v17 (copy), HttpService (copy), initializeProfileAnalytics (copy), v18 (copy), profileId (copy), SubPages (copy), Cryo (copy), v20 (copy)
		if not FFlagProfilePlatformEnableImpressions and v17.current == nil then
			v17.current = HttpService:GenerateGUID(false)
		end

		local v23 = initializeProfileAnalytics()

		v23.updateInfoForAllEvents({
			profileSessionId = if not FFlagProfilePlatformEnableImpressions then if not v18.sessionIdOverride then v17.current else v18.sessionIdOverride else v18.profileSessionId,
			profileId = profileId,
			profileType = v18.profileType,
			subpage = SubPages.PeekView
		})

		if FFlagProfilePlatformEnableImpressions then
			return (Cryo.Dictionary.join(v23, {
				scrollViewPositionChangedSignal = v20
			}))
		end

		return v23
	end, {
		profileId,
		v18.sessionIdOverride
	})

	return React.createElement(ProfileAnalyticsContext.Provider, {
		value = v21
	}, { React.createElement(ProfileScrollContextProvider, nil, { React.createElement(ProfilePlatformNavigator, p1) }) })
end

local v15 = React.PureComponent:extend("ProfilePlatformNavigatorWithProviders")

function v15.render(p2) -- line: 61
	-- upvalues: React (copy), v14 (copy)
	return React.createElement(v14, p2.props)
end

v15.router = ProfilePlatformNavigator.router

return v15
