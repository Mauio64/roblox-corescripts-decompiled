local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePioneerLandingPageLayout = SharedFlags.FFlagEnablePioneerLandingPageLayout
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local AuthAnalytics = require(parent.AuthAnalytics)
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local OpenExternalBrowser = require(AuthCommon.Thunks.OpenExternalBrowser)
local TransitionAnimation = require(AuthCommon.Enums.TransitionAnimation)

local function useOpenDisclaimerLinks(data)
	local v = useDispatch()
	local v2 = useRoactService(AppLinking)
	local v3 = useAppPolicy(function(p)
		return p.shouldUseExternalBrowserForDisclaimerLinks()
	end)
	local v4

	if FFlagEnablePioneerLandingPageLayout then
		if data then
			v4 = data.disableExternalLinks == true
		else
			v4 = false
		end
	else
		v4 = nil
	end

	local function openLink(detail: string, p)
		if v3 and not v4 then
			OpenExternalBrowser(v2, detail)
			return
		end

		local v5 = { name = AppPage.GenericWebPage, detail = detail, extraProps = 0 }

		local extraProps = {
			title = (not p or p.title == nil) and "" or p.title,
			transitionAnimation = 0
		}
		local transitionAnimation

		if p and p.transitionAnimation ~= nil then
			transitionAnimation = p.transitionAnimation
		else
			transitionAnimation = TransitionAnimation.SlideInFromRight
		end

		extraProps.transitionAnimation = transitionAnimation
		v5.extraProps = extraProps

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			v(NavigateDown(v5))
		end
	end

	local useCallback = React.useCallback
	local v5

	if FFlagEnablePioneerLandingPageLayout then
		v5 = v4
	end

	local openLink2 = useCallback(openLink, { v3, v2, v, v5 })
	local ctx

	if data then
		ctx = data.ctx
	else
		ctx = nil
	end

	local state

	if data then
		state = data.state
	else
		state = nil
	end

	local origin

	if data then
		origin = data.origin
	else
		origin = nil
	end

	local openTerms = React.useCallback(function()
		if ctx then
			authFormInteraction(ctx, EventStreamConstants.Field.TermsOfService, state, origin)
		end

		openLink2(urlBuilder.static.about.terms())
	end, { openLink2, ctx, state, origin })

	local openPrivacy = React.useCallback(function()
		if ctx then
			authFormInteraction(ctx, EventStreamConstants.Field.PrivacyPolicy, state, origin)
		end

		openLink2(urlBuilder.static.about.privacy())
	end, { openLink2, ctx, state, origin })

	return React.useMemo(function()
		return { openTerms = openTerms, openPrivacy = openPrivacy, openLink = openLink2 }
	end, { openTerms, openPrivacy, openLink2 })
end

return useOpenDisclaimerLinks
