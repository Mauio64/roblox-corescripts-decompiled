local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent
local SharedFlags = require(SocialTabParent.SharedFlags)
local dependencies = require(SocialTab.dependencies)
local Analytics = require(SocialTab.Analytics)
local SocialTabContext = require(SocialTab.SocialTabContext)
local compose = require(SocialTab.ContextUtils.compose)
local llama = dependencies.llama
local Roact = dependencies.Roact
local RoactRodux = dependencies.RoactRodux
local withLocalization = dependencies.withLocalization
local UniversalAppPolicy = dependencies.UniversalAppPolicy
local mapStateToProps = require(script.mapStateToProps)
local mapDispatchToProps = require(script.mapDispatchToProps)
local SocialTabPage = require(script.Parent.SocialTabPage)
local UserCarousel = require(SocialTab.UserCarousel)
local v17 = Roact.PureComponent:extend("SocialTabContainer")
local GetFFlagHideConnectPageWebViewItemsForVR = dependencies.GetFFlagHideConnectPageWebViewItemsForVR
local GetFFlagUseCommunitiesTranslation = SharedFlags.GetFFlagUseCommunitiesTranslation

v17.defaultProps = {}

function v17.init(p1) -- line: 27
	-- upvalues: GetFFlagUseCommunitiesTranslation (copy)
	p1.localization = {
		socialText = "Feature.SocialTab.Label.Connect",
		chatsText = "Feature.SocialTab.Label.Chats",
		groupsText = not GetFFlagUseCommunitiesTranslation() and "CommonUI.Features.Label.sGroups" or "Feature.SocialTab.Label.Groups"
	}
end
function v17.didMount(p2) -- line: 37
	p2.props.fetchFriendsRequestsCount()
end
function v17.render(p3) -- line: 41
	-- upvalues: withLocalization (copy), Analytics (copy), SocialTabContext (copy), Roact (copy), SocialTabPage (copy), llama (copy), UserCarousel (copy)
	return withLocalization(p3.localization)(function(p4) -- line: 42
		-- upvalues: Analytics (copy), SocialTabContext (copy), Roact (copy), SocialTabPage (copy), llama (copy), p3 (copy), UserCarousel (copy)
		return Analytics.with(function(p5) -- line: 43
			-- upvalues: SocialTabContext (copy), Roact (copy), SocialTabPage (copy), llama (copy), p3 (copy), UserCarousel (copy), p4 (copy)
			return SocialTabContext.with(function(p6) -- line: 44
				-- upvalues: Roact (copy), SocialTabPage (copy), llama (copy), p3 (copy), p5 (copy), UserCarousel (copy), p4 (copy)
				return Roact.createElement(SocialTabPage, llama.Dictionary.join(p3.props, {
					analytics = p5,
					navigateToLuaAppPages = p6.navigateToLuaAppPages,
					renderUserCarousel = UserCarousel.render,
					wideMode = p6.wideMode,
					navigatingFromSocialTabEvent = p6.setNavigatingFromSocialTabEvent,
					isLuaProfilePageEnabled = p6.isLuaProfilePageEnabled,
					luaAddFriendsPageEnabled = not not p6.luaAddFriendsPageEnabled,
					closeCentralOverlay = p6.closeCentralOverlay,
					openLearnMoreLink = p6.openLearnMoreLink,
					showToast = p6.showToast
				}, p4))
			end)
		end)
	end)
end

return compose(RoactRodux.connect(mapStateToProps, mapDispatchToProps), UniversalAppPolicy.connect(function(p7) -- line: 68
	-- upvalues: GetFFlagHideConnectPageWebViewItemsForVR (copy)
	local v24 = p7.getChatHeaderNotifications()
	local v25 = if not GetFFlagHideConnectPageWebViewItemsForVR() then nil else not p7.getWebViewSupport()

	return {
		enableDisplayNamePolicy = p7.getShowDisplayName(),
		shouldShowGroupsTilePolicy = p7.getShouldShowGroupsTile(),
		enableNotificationsPolicy = v24,
		disableWebViewSupport = v25
	}
end))(v17)
