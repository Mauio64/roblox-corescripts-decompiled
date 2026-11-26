local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local entryPoints = require("@luauforge/bundled/cxh").Analytics.EntryPoints

local module = require("@luauforge/bundled/fAy")
local module2 = require("@luauforge/bundled/ehA")

local module3 = require("@luauforge/bundled/fAC")

local sources = require("@luauforge/bundled/ecs").Analytics.Enums.Sources

local fFlagLuaAppMoveProfileIntoTopBar = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMoveProfileIntoTopBar

local extended = Roact.PureComponent:extend("HomeUserInfoWidget")

function extended:init()
	function self.navigateToProfile()
		local id = self.props.localUserModel.id

		self.props.openProfilePeekView(id, { source = sources.HomePageSelfWidget })
	end

	function self.onUsernameActivated()
		if not self.props.enableHomeProfileLink then
			return
		end

		self.props.navigateToDiscoverabilityModal({
			isStandaloneDiscoverabilityModal = true,
			navigateOnActivated = self.navigateToProfile,
			entryPoint = entryPoints.HomePageProfile
		})
	end
end

function extended.render(p2)
	local localUserModel = p2.props.localUserModel
	local layoutOrder = p2.props.layoutOrder
	local sideMargin = p2.props.sideMargin

	local shouldOnlyDisplayAvatarIcon = if fFlagLuaAppMoveProfileIntoTopBar then p2.props.shouldOnlyDisplayAvatarIcon else nil

	local onlyAvatarButtonRef = if fFlagLuaAppMoveProfileIntoTopBar then p2.props.onlyAvatarButtonRef else nil

	if not localUserModel then
		return nil
	end

	local createElement = Roact.createElement
	local v6 = {
		layoutOrder = layoutOrder,
		localUserModel = localUserModel,
		onActivated = p2.onUsernameActivated,
		sideMargin = sideMargin,
		shouldOnlyDisplayAvatarIcon = 0,
		onlyAvatarButtonRef = 0
	}

	if not fFlagLuaAppMoveProfileIntoTopBar then
		shouldOnlyDisplayAvatarIcon = nil
	end

	v6.shouldOnlyDisplayAvatarIcon = shouldOnlyDisplayAvatarIcon

	if not fFlagLuaAppMoveProfileIntoTopBar then
		onlyAvatarButtonRef = nil
	end

	v6.onlyAvatarButtonRef = onlyAvatarButtonRef
	return createElement(module, v6)
end

local v5 = memoize(function(p2, p3)
	return p2[p3]
end)

local v6 = RoactRodux.connect(function(p2, p3)
	return { localUserModel = v5(p2.Users, p2.LocalUserId) }
end, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(navigateDown(p2))
			end
		end,
		openProfilePeekView = function(p2, p3)
			callback(module2(p2, p3))
		end
	}
end)(extended)

local v7 = roactAppPolicy.connect(function(p2, p3)
	return { enableHomeProfileLink = p2.getHomePageProfileLink() }
end)(v6)

local v8 = roactServices.connect({ networking = roactNetworking })(v7)

function LUAUFORGE_MODULE_GLOBALS_fAx_HomeUserInfoWidgetWrapper(p2)
	local v9 = module3()
	return Roact.createElement(v8, Cryo.Dictionary.join({
		navigateToDiscoverabilityModal = v9
	}, p2))
end

return LUAUFORGE_MODULE_GLOBALS_fAx_HomeUserInfoWidgetWrapper
