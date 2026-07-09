local SocialTab = script:FindFirstAncestor("SocialTab")
local compose = require(SocialTab.ContextUtils.compose)
local Analytics = require(SocialTab.Analytics)
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local t = dependencies.t
local RoactRodux = dependencies.RoactRodux
local UniversalAppPolicy = dependencies.UniversalAppPolicy
local mapStateToProps = require(script.mapStateToProps)
local mapDispatchToProps = require(script.mapDispatchToProps)
local SocialTabContext = require(SocialTab.SocialTabContext)
local FreezableUserCarousel = require(script.Parent.FreezableUserCarousel)
local v13 = Roact.PureComponent:extend("UserCarouselContainer")

v13.defaultProps = {
	LayoutOrder = 0,
	wideMode = false,
	navigateToLuaAppPages = nil,
	goToFriendsLanding = nil
}
v13.validateProps = t.interface({
	LayoutOrder = t.optional(t.number),
	wideMode = t.boolean,
	navigateToLuaAppPages = t.optional(t.table),
	goToFriendsLanding = t.optional(t.callback)
})

function v13.render(p1) -- line: 33
	-- upvalues: Roact (copy), FreezableUserCarousel (copy)
	return Roact.createElement(FreezableUserCarousel, p1.props)
end

return compose(SocialTabContext.connect(function(p2) -- line: 38
	return {
		isLuaProfilePageEnabled = p2.isLuaProfilePageEnabled
	}
end) or nil, RoactRodux.connect(mapStateToProps, mapDispatchToProps), Analytics.connect(function(p3) -- line: 44
	return {
		analytics = p3
	}
end), UniversalAppPolicy.connect(function(p4) -- line: 47
	return {
		enableDisplayNamePolicy = p4.getShowDisplayName(),
		enableFriendFinder = p4.getFriendFinder(),
		accountProviderName = p4.getAccountProviderName(),
		inviteFromAccountProvider = p4.shouldInviteFromAccountProvider()
	}
end))(v13)
