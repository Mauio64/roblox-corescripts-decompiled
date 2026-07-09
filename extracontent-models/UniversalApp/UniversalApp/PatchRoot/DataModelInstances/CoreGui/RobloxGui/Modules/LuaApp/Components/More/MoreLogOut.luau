local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Foundation = require(CorePackages.Packages.Foundation)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local DeprecatedDarkTheme = require(Modules.LuaApp.Themes.DeprecatedDarkTheme)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v14 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local OpenCentralOverlayForConfirmSignOut = require(Modules.LuaApp.Thunks.OpenCentralOverlayForConfirmSignOut)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local withLocalization = require(Modules.LuaApp.withLocalization)
local CheckEmailVerificationBeforeLogout = require(Modules.LuaApp.Thunks.Authentication.EmailVerification.CheckEmailVerificationBeforeLogout)
local CheckPhoneVerification = require(Modules.LuaApp.Thunks.Authentication.PhoneVerification.CheckPhoneVerification)
local GetFFlagEmailUpsellAtLogout = require(Modules.LuaApp.Flags.GetFFlagEmailUpsellAtLogout)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v24 = Roact.PureComponent:extend("MoreLogOut")
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local GetFFlagEnablePhoneVerificationLogoutUpsell = require(Modules.LuaApp.Flags.GetFFlagEnablePhoneVerificationLogoutUpsell)
local FFlagEnableForcingEmailUpsellForPasswordlessUsers = require(Modules.LuaApp.Flags.FFlagEnableForcingEmailUpsellForPasswordlessUsers)
local GetPasswordStatus = require(Modules.LuaApp.Http.Requests.GetPasswordStatus)
local FFlagForcingEmailUpsellForPasswordlessUsersBypassIXP = require(Modules.LuaApp.Flags.FFlagForcingEmailUpsellForPasswordlessUsersBypassIXP)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local IXPService = game:GetService("IXPService")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
local DisconnectButton = require(script.Parent.DisconnectButton)
local GetFFlagUIBloxUseFoundationButton = require(CorePackages.Workspace.Packages.SharedFlags).UIBlox.GetFFlagUIBloxUseFoundationButton
local isFlyoutSidePanelEnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP.isFlyoutSidePanelEnabled
local FFlagEnableVNGDUARSignupCompliance = require(Modules.LuaApp.Flags.FFlagEnableVNGDUARSignupCompliance)
local FFlagAuthSecExclusions = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAuthSecExclusions

v24.defaultProps = {
	layoutOrder = 1,
	isPhoneLogoutUpsellEnabled = false,
	isForceEmailUpsellForPasswordlessUsersEnabled = false,
	shouldShowPhoneUpsell = false,
	shouldDisableEmailUpsell = false
}
v24.validateProps = t.strictInterface({
	buttonHeight = if not isFlyoutSidePanelEnabled() then t.integer else t.optional(t.integer),
	buttonMaxWidth = if not isFlyoutSidePanelEnabled() then t.integer else t.optional(t.integer),
	foundationButtonType = if not isFlyoutSidePanelEnabled() then nil else t.optional(t.string),
	foundationButtonSize = if not isFlyoutSidePanelEnabled() then nil else t.optional(t.string),
	item = t.table,
	layoutOrder = t.optional(t.integer),
	position = t.optional(t.UDim2),
	navigateDown = t.callback,
	logout = t.callback,
	showEmailBeforeLogout = t.callback,
	showPhoneBeforeLogout = t.callback,
	logoutWithoutShowConfirmation = t.callback,
	guiService = t.union(t.Instance, t.table),
	networkImpl = t.callback,
	willActivate = t.optional(t.callback),
	showDisconnectButton = t.boolean,
	isPhoneLogoutUpsellEnabled = t.boolean,
	isForceEmailUpsellForPasswordlessUsersEnabled = t.boolean,
	shouldShowPhoneUpsell = t.boolean,
	shouldDisableEmailUpsell = t.boolean,
	appPolicy = t.table
})

function v24.init(p1) -- line: 88
	-- upvalues: GetFFlagEmailUpsellAtLogout (copy), DeprecatedDarkTheme (copy), default (copy), TelemetryConfigs (copy), FFlagEnableForcingEmailUpsellForPasswordlessUsers (copy), FFlagForcingEmailUpsellForPasswordlessUsersBypassIXP (copy), IXPService (copy), AppUserLayers (copy), GetFFlagEnablePhoneVerificationLogoutUpsell (copy)
	local guiService = p1.props.guiService
	local item = p1.props.item
	local networkImpl = p1.props.networkImpl

	function p1.navigateDown() -- line: 93
		-- upvalues: p1 (copy), item (copy)
		p1.props.navigateDown({
			name = item.context.page
		})
	end
	function p1.showEmailVerificationOrLogout() -- line: 99
		-- upvalues: GetFFlagEmailUpsellAtLogout (copy), p1 (copy), networkImpl (copy), guiService (copy), DeprecatedDarkTheme (copy)
		if GetFFlagEmailUpsellAtLogout() and not p1.props.shouldDisableEmailUpsell then
			p1.props.showEmailBeforeLogout(networkImpl, guiService, DeprecatedDarkTheme, p1.props.appPolicy)

			return
		end

		p1.props.logout(networkImpl, guiService, DeprecatedDarkTheme)
	end
	function p1.showPhoneVerificationOrLogout() -- line: 109
		-- upvalues: p1 (copy), networkImpl (copy), guiService (copy), DeprecatedDarkTheme (copy)
		p1.props.showPhoneBeforeLogout(networkImpl, guiService, DeprecatedDarkTheme)
	end

	p1.state = {
		hasNoPassword = false
	}

	function p1.onActivated() -- line: 117
		-- upvalues: default (copy), TelemetryConfigs (copy), p1 (copy), FFlagEnableForcingEmailUpsellForPasswordlessUsers (copy), FFlagForcingEmailUpsellForPasswordlessUsersBypassIXP (copy), IXPService (copy), AppUserLayers (copy), GetFFlagEnablePhoneVerificationLogoutUpsell (copy)
		default:logRobloxTelemetryCounter(TelemetryConfigs.LogoutButtonClickedConfig, 1)

		if p1.props.willActivate then
			p1.props.willActivate()
		end

		if FFlagEnableForcingEmailUpsellForPasswordlessUsers and ((FFlagForcingEmailUpsellForPasswordlessUsersBypassIXP or p1.props.isForceEmailUpsellForPasswordlessUsersEnabled) and p1.state.hasNoPassword) then
			IXPService:LogUserLayerExposure(AppUserLayers.LogoutLayer)
			p1.showEmailVerificationOrLogout()

			return
		end

		if p1.props.shouldShowPhoneUpsell then
			IXPService:LogUserLayerExposure(AppUserLayers.LogoutLayer)

			local isPhoneLogoutUpsellEnabled = p1.props.isPhoneLogoutUpsellEnabled

			if GetFFlagEnablePhoneVerificationLogoutUpsell() or isPhoneLogoutUpsellEnabled then
				p1.showPhoneVerificationOrLogout()

				return
			end

			p1.showEmailVerificationOrLogout()

			return
		end

		p1.showEmailVerificationOrLogout()
	end
end
function v24.didMount(p2) -- line: 147
	-- upvalues: FFlagEnableForcingEmailUpsellForPasswordlessUsers (copy), GetPasswordStatus (copy)
	if FFlagEnableForcingEmailUpsellForPasswordlessUsers then
		GetPasswordStatus(p2.props.networkImpl):andThen(function(p3) -- line: 149
			-- upvalues: p2 (copy)
			p2:setState({
				hasNoPassword = p3.responseBody.valid == false
			})
		end, function() -- line: 153
		end)
	end
end
function v24.render(p4) -- line: 157
	-- upvalues: withLocalization (copy), isFlyoutSidePanelEnabled (copy), Roact (copy), Foundation (copy), DisconnectButton (copy), Button (copy), ButtonType (copy), GetFFlagUIBloxUseFoundationButton (copy)
	local buttonHeight = p4.props.buttonHeight
	local buttonMaxWidth = p4.props.buttonMaxWidth
	local item = p4.props.item
	local layoutOrder = p4.props.layoutOrder
	local position = p4.props.position

	return withLocalization({
		logOutText = item.textKey
	})(function(p5) -- line: 166
		-- upvalues: isFlyoutSidePanelEnabled (copy), p4 (copy), Roact (copy), Foundation (copy), layoutOrder (copy), position (copy), buttonHeight (copy), buttonMaxWidth (copy), DisconnectButton (copy), Button (copy), ButtonType (copy), GetFFlagUIBloxUseFoundationButton (copy)
		if isFlyoutSidePanelEnabled() and p4.props.foundationButtonType then
			return (Roact.createElement(Foundation.Button, {
				isDisabled = false,
				text = p5.logOutText,
				variant = p4.props.foundationButtonType,
				LayoutOrder = layoutOrder,
				onActivated = p4.onActivated,
				size = p4.props.foundationButtonSize,
				width = UDim.new(1, 0)
			}))
		end

		return (Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = position,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, buttonHeight)
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			LogOutButtonFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(buttonMaxWidth, buttonHeight)
				}),
				LogOutButton = if not p4.props.showDisconnectButton then Roact.createElement(Button, {
					isDisabled = false,
					isLoading = false,
					buttonType = ButtonType.Secondary,
					onActivated = p4.onActivated,
					size = UDim2.new(1, 0, not GetFFlagUIBloxUseFoundationButton() and 1 or 0, not GetFFlagUIBloxUseFoundationButton() and 0 or buttonHeight),
					text = p5.logOutText
				}) else Roact.createElement(DisconnectButton)
			})
		}))
	end)
end

local v40 = RoactRodux.connect(function(_, _) -- line: 214
end, function(p8) -- line: 214
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateDown (copy), CheckEmailVerificationBeforeLogout (copy), OpenCentralOverlayForConfirmSignOut (copy), Logout (copy), luaLogoutReasonNames (copy), CheckPhoneVerification (copy)
	return {
		navigateDown = function(p9) -- line: 216
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v14 (copy), p8 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v14.down(v14.fromLegacyPage(p9))

				return
			end

			p8(NavigateDown(p9))
		end,
		showEmailBeforeLogout = function(p10, p11, p12, p13) -- line: 223
			-- upvalues: p8 (copy), CheckEmailVerificationBeforeLogout (copy), OpenCentralOverlayForConfirmSignOut (copy), Logout (copy), luaLogoutReasonNames (copy)
			p8(CheckEmailVerificationBeforeLogout(p10, p11, p13)):andThen(function() -- line: 224
				-- upvalues: p8 (copy), OpenCentralOverlayForConfirmSignOut (copy), Logout (copy), p10 (copy), p11 (copy), luaLogoutReasonNames (copy), p12 (copy)
				p8(OpenCentralOverlayForConfirmSignOut(function() -- line: 225
					-- upvalues: p8 (copy), Logout (copy), p10 (copy), p11 (copy), luaLogoutReasonNames (copy)
					p8(Logout(p10, p11, luaLogoutReasonNames.MoreLogOut))
				end, p12))
			end, function() -- line: 228
			end)
		end,
		showPhoneBeforeLogout = function(p14, p15, p16) -- line: 230
			-- upvalues: p8 (copy), CheckPhoneVerification (copy), OpenCentralOverlayForConfirmSignOut (copy), Logout (copy), luaLogoutReasonNames (copy)
			p8(CheckPhoneVerification(p14, p15)):andThen(function() -- line: 231
				-- upvalues: p8 (copy), OpenCentralOverlayForConfirmSignOut (copy), Logout (copy), p14 (copy), p15 (copy), luaLogoutReasonNames (copy), p16 (copy)
				p8(OpenCentralOverlayForConfirmSignOut(function() -- line: 232
					-- upvalues: p8 (copy), Logout (copy), p14 (copy), p15 (copy), luaLogoutReasonNames (copy)
					p8(Logout(p14, p15, luaLogoutReasonNames.MoreLogOut))
				end, p16))
			end, function() -- line: 235
			end)
		end,
		logout = function(p17, p18, p19) -- line: 237
			-- upvalues: p8 (copy), OpenCentralOverlayForConfirmSignOut (copy), Logout (copy), luaLogoutReasonNames (copy)
			p8(OpenCentralOverlayForConfirmSignOut(function() -- line: 238
				-- upvalues: p8 (copy), Logout (copy), p17 (copy), p18 (copy), luaLogoutReasonNames (copy)
				p8(Logout(p17, p18, luaLogoutReasonNames.MoreLogOut))
			end, p19))
		end,
		logoutWithoutShowConfirmation = function(p20, p21) -- line: 242
			-- upvalues: p8 (copy), Logout (copy), luaLogoutReasonNames (copy)
			p8(Logout(p20, p21, luaLogoutReasonNames.MoreLogOut))
		end
	}
end)(v24)
local v41 = RoactAppPolicy.connect(function(p22, _) -- line: 248
	-- upvalues: FFlagEnableVNGDUARSignupCompliance (copy), FFlagAuthSecExclusions (copy)
	return {
		showDisconnectButton = p22.getShowDisconnectButton(),
		shouldShowPhoneUpsell = p22.getShouldShowPhoneUpsell(),
		shouldDisableEmailUpsell = (FFlagEnableVNGDUARSignupCompliance or not not FFlagAuthSecExclusions) and p22.getDisableLogOutEmailUpsell(),
		appPolicy = p22
	}
end)(v40)
local v42 = RoactAppExperiment.connectUserLayer({ AppUserLayers.LogoutLayer }, function(p24, _) -- line: 261
	-- upvalues: AppUserLayers (copy)
	local v61 = p24[AppUserLayers.LogoutLayer] or {}

	return {
		isPhoneLogoutUpsellEnabled = v61.IsPhoneLogoutUpsellEnabled,
		isForceEmailUpsellForPasswordlessUsersEnabled = v61.IsForceEmailUpsellForPasswordlessUsersEnabled
	}
end)(v41)

return RoactServices.connect({
	guiService = AppGuiService,
	networkImpl = RoactNetworking
})(v42)
