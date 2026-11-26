local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactUtils").Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppHooks").useRoactService
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").useAppPolicy

local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactServiceTags").AppLinking
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/NavigationRodux").Thunks.NavigateDown
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags")
local fFlagEnablePioneerLandingPageLayout = SharedFlags.FFlagEnablePioneerLandingPageLayout
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppNavigation").NavigationCommands else nil

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").AppPage
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder
local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AuthAnalytics")
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local eventStreamConstants = AuthAnalytics.EventStreamConstants
local OpenExternalBrowser = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/OpenExternalBrowser")
local TransitionAnimation = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/TransitionAnimation")

local function useOpenDisclaimerLinks(data)
	local v5 = useDispatch()
	local v6 = useRoactService(appLinking)
	local v7 = useAppPolicy(function(p2)
		return p2.shouldUseExternalBrowserForDisclaimerLinks()
	end)
	local v8

	if fFlagEnablePioneerLandingPageLayout then
		v8 = if data then data.disableExternalLinks == true else false
	else
		v8 = nil
	end

	local function openLink(p2, p3)
		if v7 and not v8 then
			OpenExternalBrowser(v6, p2)
			return
		end

		local v9 = { name = appPage.GenericWebPage, detail = p2, extraProps = 0 }

		local v10 = {
			title = (not p3 or p3.title == nil) and "" or p3.title,
			transitionAnimation = 0
		}
		local v11 = if p3 and p3.transitionAnimation ~= nil then p3.transitionAnimation else TransitionAnimation.SlideInFromRight
		v10.transitionAnimation = v11
		v9.extraProps = v10

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			v5(navigateDown(v9))
		end
	end

	local v11 = React.useCallback(openLink, {
		v7,
		v6,
		v5,
		if fFlagEnablePioneerLandingPageLayout then v8 else nil
	})

	local ctx = if data then data.ctx else nil
	local state = if data then data.state else nil
	local origin = if data then data.origin else nil

	local v12 = React.useCallback(function()
		if ctx then
			authFormInteraction(ctx, eventStreamConstants.Field.TermsOfService, state, origin)
		end

		v11(urlBuilder.static.about.terms())
	end, { v11, ctx, state, origin })

	local v13 = React.useCallback(function()
		if ctx then
			authFormInteraction(ctx, eventStreamConstants.Field.PrivacyPolicy, state, origin)
		end

		v11(urlBuilder.static.about.privacy())
	end, { v11, ctx, state, origin })

	return React.useMemo(function()
		return { openTerms = v12, openPrivacy = v13, openLink = v11 }
	end, { v12, v13, v11 })
end

return useOpenDisclaimerLinks
