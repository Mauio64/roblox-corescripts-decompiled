local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local ShareGame = Modules.Settings.Pages.ShareGame
local Constants = require(ShareGame.Constants)
local AppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).AppFeaturePolicies
local EventStream = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventStream
local LayoutProvider = require(ShareGame.Components.LayoutProvider)
local ShareGameContainer = require(ShareGame.Components.ShareGameContainer)
local v14 = Roact.PureComponent:extend("App")

local function wrapWithProviders(p1) -- line: 23
	-- upvalues: Roact (copy), LayoutProvider (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy)
	return Roact.createElement(LayoutProvider, nil, {
		PolicyProvider = Roact.createElement(RoactAppPolicy.Provider, {
			policy = { AppFeaturePolicies }
		}, p1)
	})
end

function v14.render(p2) -- line: 33
	-- upvalues: Roact (copy), ShareGameContainer (copy), Constants (copy), wrapWithProviders (copy)
	local analytics = p2.props.analytics
	local pageTarget = p2.props.pageTarget
	local v20 = nil

	if p2.props.isPageOpen then
		v20 = Roact.createElement(ShareGameContainer, {
			analytics = analytics,
			zIndex = Constants.SHARE_GAME_Z_INDEX
		})
	end

	return wrapWithProviders({ Roact.createElement(Roact.Portal, {
		target = pageTarget
	}, {
		ShareGamePageFrame = v20
	}) })
end
function v14.didMount(p3) -- line: 54
	-- upvalues: EventStream (copy), RbxAnalyticsService (copy)
	p3.eventStream = EventStream.new(RbxAnalyticsService)
end
function v14.willUnmount(p4) -- line: 58
	p4.eventStream:releaseRBXEventStream()
end

return RoactRodux.UNSTABLE_connect2(function(p5, _) -- line: 62
	return {
		isPageOpen = p5.Page.IsOpen
	}
end)(v14)
