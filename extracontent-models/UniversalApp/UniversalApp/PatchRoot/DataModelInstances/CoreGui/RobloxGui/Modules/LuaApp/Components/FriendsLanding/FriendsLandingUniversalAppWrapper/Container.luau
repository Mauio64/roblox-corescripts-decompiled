local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local FriendsLandingUniversalAppWrapper = require(script.Parent.FriendsLandingUniversalAppWrapper)
local mapStateToProps = require(script.Parent.mapStateToProps)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)
local compose = require(CorePackages.Packages.LuaSocialLibrariesDeps).SocialLibraries.config({}).RoduxTools.compose
local FriendsLandingNavigator = require(CorePackages.Workspace.Packages.FriendsLanding.FriendsLandingNavigator)
local FFlagSignalsNavP3hMisc = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3hMisc
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v15 = if not FFlagSignalsNavP3hMisc then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore

local function Container(p1) -- line: 27
	-- upvalues: Roact (copy), FriendsLandingUniversalAppWrapper (copy)
	return Roact.createElement(FriendsLandingUniversalAppWrapper, p1)
end

local u17 = compose(RoactRodux.connect(mapStateToProps, mapDispatchToProps), RoactServices.connect({
	notificationService = AppNotificationService
}))(Container)

if FFlagSignalsNavP3hMisc then
	local v18 = u17

	function u17(p2) -- line: 40
		-- upvalues: v15 (copy), useSignalState (copy), React (copy), v18 (copy), Cryo (copy)
		local v22 = v15(false)
		local v23 = useSignalState(v22.getCurrentPage)

		return React.createElement(v18, Cryo.Dictionary.union(p2, {
			currentAppPage = v23 and v23.name
		}))
	end
end

local v19 = Roact.PureComponent:extend("ClassWrapper")

function v19.render(p3) -- line: 55
	-- upvalues: Roact (copy), u17 (ref)
	return Roact.createElement(u17, p3.props)
end

v19.router = FriendsLandingNavigator.router

return v19
