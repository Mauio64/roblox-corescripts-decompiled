local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local NavigateDown = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local EntryPoints = require(CorePackages.Workspace.Packages.DiscoverabilityModal).Analytics.EntryPoints
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserInfoWidget = require(Modules.LuaApp.Components.Home.UserInfoWidget)
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local useNavigateToDiscoverabilityModal = require(Modules.LuaApp.Components.DiscoverabilityModal.useNavigateToDiscoverabilityModal)
local Sources = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums.Sources
local FFlagLuaAppMoveProfileIntoTopBar = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppMoveProfileIntoTopBar
local v19 = Roact.PureComponent:extend("HomeUserInfoWidget")

function v19.init(p1) -- line: 30
	-- upvalues: Sources (copy), EntryPoints (copy)
	function p1.navigateToProfile() -- line: 31
		-- upvalues: p1 (copy), Sources (copy)
		local id = p1.props.localUserModel.id

		p1.props.openProfilePeekView(id, {
			source = Sources.HomePageSelfWidget
		})
	end
	function p1.onUsernameActivated() -- line: 39
		-- upvalues: p1 (copy), EntryPoints (copy)
		if not p1.props.enableHomeProfileLink then
			return
		end

		p1.props.navigateToDiscoverabilityModal({
			isStandaloneDiscoverabilityModal = true,
			navigateOnActivated = p1.navigateToProfile,
			entryPoint = EntryPoints.HomePageProfile
		})
	end
end
function v19.render(p2) -- line: 52
	-- upvalues: FFlagLuaAppMoveProfileIntoTopBar (copy), Roact (copy), UserInfoWidget (copy)
	local localUserModel = p2.props.localUserModel
	local layoutOrder = p2.props.layoutOrder
	local sideMargin = p2.props.sideMargin
	local v29 = if not FFlagLuaAppMoveProfileIntoTopBar then nil else p2.props.shouldOnlyDisplayAvatarIcon
	local v30 = if not FFlagLuaAppMoveProfileIntoTopBar then nil else p2.props.onlyAvatarButtonRef

	if not localUserModel then
		return nil
	end

	return Roact.createElement(UserInfoWidget, {
		layoutOrder = layoutOrder,
		localUserModel = localUserModel,
		onActivated = p2.onUsernameActivated,
		sideMargin = sideMargin,
		shouldOnlyDisplayAvatarIcon = if not FFlagLuaAppMoveProfileIntoTopBar then nil else v29,
		onlyAvatarButtonRef = if not FFlagLuaAppMoveProfileIntoTopBar then nil else v30
	})
end

local v20 = memoize(function(p3, p4) -- line: 75
	return p3[p4]
end)
local v21 = RoactRodux.connect(function(p5, _) -- line: 79
	-- upvalues: v20 (copy)
	return {
		localUserModel = v20(p5.Users, p5.LocalUserId)
	}
end, function(p7) -- line: 83
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateDown (copy), OpenProfilePeekView (copy)
	return {
		navigateDown = function(p8) -- line: 85
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v11 (copy), p7 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v11.down(v11.fromLegacyPage(p8))

				return
			end

			p7(NavigateDown(p8))
		end,
		openProfilePeekView = function(p9, p10) -- line: 92
			-- upvalues: p7 (copy), OpenProfilePeekView (copy)
			p7(OpenProfilePeekView(p9, p10))
		end
	}
end)(v19)
local v22 = RoactAppPolicy.connect(function(p11, _) -- line: 98
	return {
		enableHomeProfileLink = p11.getHomePageProfileLink()
	}
end)(v21)
local u23 = RoactServices.connect({
	networking = RoactNetworking
})(v22)

function HomeUserInfoWidgetWrapper(p13) -- line: 108
	-- upvalues: useNavigateToDiscoverabilityModal (copy), Roact (copy), u23 (ref), Cryo (copy)
	local v39 = useNavigateToDiscoverabilityModal()

	return Roact.createElement(u23, Cryo.Dictionary.join({
		navigateToDiscoverabilityModal = v39
	}, p13))
end

return HomeUserInfoWidgetWrapper
