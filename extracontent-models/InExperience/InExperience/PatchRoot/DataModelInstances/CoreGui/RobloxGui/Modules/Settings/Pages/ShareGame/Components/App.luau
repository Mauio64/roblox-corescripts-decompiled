local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local Modules = CoreGui.RobloxGui.Modules

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy

local ShareGame = Modules.Settings.Pages.ShareGame
local Constants = require(ShareGame.Constants)

local UniversalAppPolicy2 = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local AppFeaturePolicies = UniversalAppPolicy2.AppFeaturePolicies
local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local EventStream = Analytics.AnalyticsReporters.EventStream

local LayoutProvider = require(ShareGame.Components.LayoutProvider)

local ShareGameContainer = require(ShareGame.Components.ShareGameContainer)

local extended = Roact.PureComponent:extend("App")

local function wrapWithProviders(p)
	return Roact.createElement(LayoutProvider, nil, {
		PolicyProvider = Roact.createElement(RoactAppPolicy.Provider, {
			policy = { AppFeaturePolicies }
		}, p)
	})
end

function extended.render(p)
	local analytics = p.props.analytics
	local pageTarget = p.props.pageTarget
	local shareGamePageFrame

	if p.props.isPageOpen then
		shareGamePageFrame = Roact.createElement(ShareGameContainer, {
			analytics = analytics,
			zIndex = Constants.SHARE_GAME_Z_INDEX
		})
	end

	return wrapWithProviders({ Roact.createElement(Roact.Portal, { target = pageTarget }, {
			ShareGamePageFrame = shareGamePageFrame
		}) })
end

function extended:didMount()
	self.eventStream = EventStream.new(RbxAnalyticsService)
end

function extended.willUnmount(p)
	p.eventStream:releaseRBXEventStream()
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { isPageOpen = p.Page.IsOpen }
end)(extended)
