local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Foundation = require(CorePackages.Packages.Foundation)

local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module = require("@luauforge/bundled/hHb")
local module2 = require("@luauforge/bundled/fBP")
local module3 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

local module4 = require("@luauforge/bundled/hHd")
local module5 = require("@luauforge/bundled/eda")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module6 = require("@luauforge/bundled/edC")

local module7 = require("@luauforge/bundled/hHe")
local module8 = require("@luauforge/bundled/hHh")
local module9 = require("@luauforge/bundled/hHj")
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local extended = Roact.PureComponent:extend("MoreLogOut")
local module10 = require("@luauforge/bundled/fBW")

local module11 = require("@luauforge/bundled/hHk")

local module12 = require("@luauforge/bundled/hHl")
local module13 = require("@luauforge/bundled/fAU")

local module14 = require("@luauforge/bundled/hHm")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local IXPService = game:GetService("IXPService")
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local SwitchServerTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SwitchServer/SwitchServer/Telemetry/SwitchServerTelemetry")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local telemetryConfigs = require("@luauforge/bundled/fsz").TelemetryConfigs
local module16 = require("@luauforge/bundled/dYU")

local sendMoreLegacyAndFlyoutItemClickEvent = require("@luauforge/bundled/fsS").Utils.sendMoreLegacyAndFlyoutItemClickEvent

local module17 = require("@luauforge/bundled/hHo")

local module18 = require("@luauforge/bundled/hHp")

local consoleDisconnect = if module18 then require("@game/CorePackages/Workspace/Packages/AuthCommon").Thunks.ConsoleDisconnect else nil

local getFFlagUIBloxUseFoundationButton = require("@game/CorePackages/Workspace/Packages/SharedFlags").UIBlox.GetFFlagUIBloxUseFoundationButton

local isFlyoutSidePanelEnabled = require("@luauforge/bundled/dHD").FlyoutSidePanelIXP.isFlyoutSidePanelEnabled
local fFlagSendLogOutClickTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSendLogOutClickTelemetry

extended.defaultProps = {
	layoutOrder = 1,
	isPhoneLogoutUpsellEnabled = false,
	isForceEmailUpsellForPasswordlessUsersEnabled = false,
	shouldShowPhoneUpsell = false,
	shouldDisableEmailUpsell = false
}

local strictInterface = t.strictInterface
local v6 = if isFlyoutSidePanelEnabled() then t.optional(t.integer) else t.integer
local v7 = if isFlyoutSidePanelEnabled() then t.optional(t.integer) else t.integer
local v8 = if isFlyoutSidePanelEnabled() then t.optional(t.string) else nil
local v9 = if isFlyoutSidePanelEnabled() then t.optional(t.string) else nil
local v5 = {
	buttonHeight = v6,
	buttonMaxWidth = v7,
	foundationButtonType = v8,
	foundationButtonSize = v9,
	item = t.table,
	layoutOrder = t.optional(t.integer),
	position = t.optional(t.UDim2),
	navigateDown = t.callback,
	logout = t.callback,
	showEmailBeforeLogout = t.callback,
	showPhoneBeforeLogout = t.callback,
	logoutWithoutShowConfirmation = t.callback,
	consoleDisconnect = 0,
	guiService = 0,
	networkImpl = 0,
	willActivate = 0,
	showDisconnectButton = 0,
	isPhoneLogoutUpsellEnabled = 0,
	isForceEmailUpsellForPasswordlessUsersEnabled = 0,
	shouldShowPhoneUpsell = 0,
	shouldDisableEmailUpsell = 0,
	appPolicy = 0,
	eventIngest = 0
}
local v10 = if module18 then t.callback else nil
v5.consoleDisconnect = v10
v5.guiService = t.union(t.Instance, t.table)
v5.networkImpl = t.callback
v5.willActivate = t.optional(t.callback)
v5.showDisconnectButton = t.boolean
v5.isPhoneLogoutUpsellEnabled = t.boolean
v5.isForceEmailUpsellForPasswordlessUsersEnabled = t.boolean
v5.shouldShowPhoneUpsell = t.boolean
v5.shouldDisableEmailUpsell = t.boolean
v5.appPolicy = t.table
local v11 = if fFlagSendLogOutClickTelemetry then t.any else nil
v5.eventIngest = v11
extended.validateProps = strictInterface(v5)

function extended:init()
	local guiService = self.props.guiService
	local item = self.props.item
	local networkImpl = self.props.networkImpl

	function self.navigateDown()
		self.props.navigateDown({ name = item.context.page })
	end

	function self.showEmailVerificationOrLogout()
		if module9() and not self.props.shouldDisableEmailUpsell then
			self.props.showEmailBeforeLogout(networkImpl, guiService, module, self.props.appPolicy)
		else
			self.props.logout(networkImpl, guiService, module)
		end
	end

	function self.showPhoneVerificationOrLogout()
		self.props.showPhoneBeforeLogout(networkImpl, guiService, module)
	end

	self.state = { hasNoPassword = false }

	function self.onActivated()
		default:logRobloxTelemetryCounter(telemetryConfigs.LogoutButtonClickedConfig, 1)

		if fFlagSendLogOutClickTelemetry then
			if isFlyoutSidePanelEnabled() then
				sendMoreLegacyAndFlyoutItemClickEvent(self.props.eventIngest, self.props.item.itemType)
			else
				SwitchServerTelemetry.sendLogOutButtonClick({ itemType = self.props.item.itemType })
			end
		end

		if self.props.willActivate then
			self.props.willActivate()
		end

		if module18 and self.props.showDisconnectButton then
			self.props.consoleDisconnect(networkImpl, guiService, module)
		elseif
			module12
			and (module14 or self.props.isForceEmailUpsellForPasswordlessUsersEnabled)
			and self.state.hasNoPassword
		then
			IXPService:LogUserLayerExposure(appUserLayers.LogoutLayer)
			self.showEmailVerificationOrLogout()
		else
			if not self.props.shouldShowPhoneUpsell then
				self.showEmailVerificationOrLogout()

				return
			end

			IXPService:LogUserLayerExposure(appUserLayers.LogoutLayer)
			local isPhoneLogoutUpsellEnabled = self.props.isPhoneLogoutUpsellEnabled

			if module11() or isPhoneLogoutUpsellEnabled then
				self.showPhoneVerificationOrLogout()
			else
				self.showEmailVerificationOrLogout()
			end
		end
	end
end

function extended.didMount(object)
	if module12 then
		module13(object.props.networkImpl):andThen(function(p2)
			object:setState({
				hasNoPassword = p2.responseBody.valid == false
			})
		end, function() end)
	end
end

function extended.render(p2)
	local buttonHeight = p2.props.buttonHeight
	local buttonMaxWidth = p2.props.buttonMaxWidth
	local item = p2.props.item
	local layoutOrder = p2.props.layoutOrder
	local position = p2.props.position

	return module6({ logOutText = item.textKey })(function(p3)
		if isFlyoutSidePanelEnabled() and p2.props.foundationButtonType then
			return (Roact.createElement(Foundation.Button, {
				text = p3.logOutText,
				variant = p2.props.foundationButtonType,
				LayoutOrder = layoutOrder,
				onActivated = p2.onActivated,
				isDisabled = false,
				size = p2.props.foundationButtonSize,
				width = UDim.new(1, 0)
			}))
		end

		local createElement = Roact.createElement
		local v13 = {
			BackgroundTransparency = 1,
			Position = position,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, buttonHeight)
		}
		local v14 = {
			UIListLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			LogOutButtonFrame = 0
		}

		local createElement2 = Roact.createElement
		local v16 = { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }
		local v17 = {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(buttonMaxWidth, buttonHeight)
			}),
			LogOutButton = 0
		}

		local v18 = if p2.props.showDisconnectButton then Roact.createElement(module17) else Roact.createElement(button, {
			buttonType = buttonType.Secondary,
			isDisabled = false,
			isLoading = false,
			onActivated = p2.onActivated,
			size = UDim2.new(
				1,
				0,
				getFFlagUIBloxUseFoundationButton() and 0 or 1,
				not getFFlagUIBloxUseFoundationButton() and 0 or buttonHeight
			),
			text = p3.logOutText
		})
		v17.LogOutButton = v18
		v14.LogOutButtonFrame = createElement2("Frame", v16, v17)
		return (createElement("Frame", v13, v14))
	end)
end

local v12 = RoactRodux.connect(function(p2, p3) end, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module3(p2))
			end
		end,
		showEmailBeforeLogout = function(p2, p3, p4, p5)
			callback(module7(p2, p3, p5)):andThen(function()
				callback(module4(function()
					callback(module2(p2, p3, module10.MoreLogOut))
				end, p4))
			end, function() end)
		end,
		showPhoneBeforeLogout = function(p2, p3, p4)
			callback(module8(p2, p3)):andThen(function()
				callback(module4(function()
					callback(module2(p2, p3, module10.MoreLogOut))
				end, p4))
			end, function() end)
		end,
		logout = function(p2, p3, p4)
			callback(module4(function()
				callback(module2(p2, p3, module10.MoreLogOut))
			end, p4))
		end,
		logoutWithoutShowConfirmation = function(p2, p3)
			callback(module2(p2, p3, module10.MoreLogOut))
		end,
		consoleDisconnect = module18 and function(p2, p3, p4)
			callback(module4(function()
				callback(consoleDisconnect(p2, p3, module2))
			end, p4))
		end or nil
	}
end)(extended)

local v13 = roactAppPolicy.connect(function(data, p2)
	return {
		showDisconnectButton = data.getShowDisconnectButton(),
		shouldShowPhoneUpsell = data.getShouldShowPhoneUpsell(),
		shouldDisableEmailUpsell = data.getDisableLogOutEmailUpsell(),
		appPolicy = data
	}
end)(v12)

local v14 = RoactAppExperiment.connectUserLayer({ appUserLayers.LogoutLayer }, function(p2, p3)
	local v15 = p2[appUserLayers.LogoutLayer] or {}
	return {
		isPhoneLogoutUpsellEnabled = v15.IsPhoneLogoutUpsellEnabled,
		isForceEmailUpsellForPasswordlessUsersEnabled = v15.IsForceEmailUpsellForPasswordlessUsersEnabled
	}
end)(v13)

local connect = roactServices.connect

if not fFlagSendLogOutClickTelemetry then
	module16 = nil
end

return connect({
	guiService = appGuiService,
	networkImpl = module5,
	eventIngest = module16
})(v14)
