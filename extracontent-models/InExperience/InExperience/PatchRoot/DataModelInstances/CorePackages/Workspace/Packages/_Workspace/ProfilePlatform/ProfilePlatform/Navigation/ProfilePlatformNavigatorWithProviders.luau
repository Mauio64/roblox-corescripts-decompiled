local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SubPages = SocialLuaAnalytics.Analytics.Enums.SubPages
local initializeProfileAnalytics = require(ProfilePlatform.Analytics.initializeProfileAnalytics)
local ProfileAnalyticsContext = require(ProfilePlatform.Contexts.ProfileAnalyticsContext)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local ProfileScrollContextProvider = require(ProfilePlatform.Contexts.ProfileScrollContext.ProfileScrollContextProvider)
local HttpService = game:GetService("HttpService")
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableImpressions = SharedFlags.FFlagProfilePlatformEnableImpressions

local ProfilePlatformNavigator = require(script.Parent.ProfilePlatformNavigator)

local function fn(p)
	local ref

	if FFlagProfilePlatformEnableImpressions then
		ref = nil
	else
		ref = React.createRef()
	end

	local v = useProfileWrapperContext()
	local profileId = v.profileId
	local signal

	if FFlagProfilePlatformEnableImpressions then
		signal = AppCommonLib.Signal.new()
	else
		signal = nil
	end

	local v2 = React.useMemo(function()
		if not FFlagProfilePlatformEnableImpressions and ref.current == nil then
			ref.current = HttpService:GenerateGUID(false)
		end

		local v2 = initializeProfileAnalytics()
		local updateInfoForAllEvents = v2.updateInfoForAllEvents
		local profileSessionId

		if FFlagProfilePlatformEnableImpressions then
			profileSessionId = v.profileSessionId
		elseif v.sessionIdOverride then
			profileSessionId = v.sessionIdOverride
		else
			profileSessionId = ref.current
		end

		updateInfoForAllEvents({
			profileSessionId = profileSessionId,
			profileId = profileId,
			profileType = v.profileType,
			subpage = SubPages.PeekView
		})

		if FFlagProfilePlatformEnableImpressions then
			return (Cryo.Dictionary.join(v2, { scrollViewPositionChangedSignal = signal }))
		end

		return v2
	end, { profileId, v.sessionIdOverride })

	return React.createElement(ProfileAnalyticsContext.Provider, { value = v2 }, {
		React.createElement(ProfileScrollContextProvider, nil, { React.createElement(ProfilePlatformNavigator, p) })
	})
end

local extended = React.PureComponent:extend("ProfilePlatformNavigatorWithProviders")

function extended.render(p)
	return React.createElement(fn, p.props)
end

extended.router = ProfilePlatformNavigator.router

return extended
