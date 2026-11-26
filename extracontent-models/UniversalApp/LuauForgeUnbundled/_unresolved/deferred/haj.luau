local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local module = require("@luauforge/bundled/fvN")
local module2 = require("@luauforge/deferred/hak")

local module3 = require("@luauforge/deferred/hal")
local module4 = require("@luauforge/bundled/dXh")
local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.rn.backButton")

local module5 = require("@luauforge/deferred/ham")
local module6 = require("@luauforge/bundled/dKv")
local MockAppStorageService = require("@game/CoreGui/RobloxGui/Modules/TestHelpers/MockAppStorageService")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module8 = require("@luauforge/bundled/fAe")
require("@luauforge/bundled/dKT")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagAndroidTVExitWithB = SharedFlags.FFlagAndroidTVExitWithB
local fFlagSignalsNavP3gAvatarExperience = SharedFlags.FFlagSignalsNavP3gAvatarExperience

local androidTVExitButtonManager = require("@luauforge/bundled/dFB").AndroidTVExitButtonManager
local backHandlerRegistry = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").BackHandlerRegistry

local fFlagAXFixBackgroundGenerationResultMenuNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixBackgroundGenerationResultMenuNavigation

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local extended = Roact.Component:extend("BackButtonHandler")

extended.validateProps = t.strictInterface({
	navigation = t.table,
	avatarExperienceActive = t.boolean,
	resetNavigationHistory = t.optional(t.callback),
	instantResetNavigationHistory = t.optional(t.callback),
	avatarRoute = t.optional(t.table),
	EventForTests = t.optional(t.table)
})

function extended:init()
	self.backButtonConnection = nil
	self.tvExitDisconnect = nil

	function self.onBackButtonPressed()
		if fFlagAXFixBackgroundGenerationResultMenuNavigation and backHandlerRegistry.consume() then
			return
		end

		local navigation = self.props.navigation
		local backButtonAction = self:getBackButtonAction()

		logger:info("pressed: {}", backButtonAction)

		if backButtonAction == module2.GoBack then
			local prevNavPage = self.props.avatarRoute.current.params.prevNavPage
			local prevNavHistory = self.props.avatarRoute.current.params.prevNavHistory

			if not (prevNavPage and prevNavHistory) then
				module4.closeFocusedScreen(navigation)
			elseif rawget(avatarScreen, prevNavPage) then
				navigation.navigate(prevNavPage)
			else
				self.props.resetNavigationHistory(prevNavHistory)
			end
		else
			if backButtonAction == module2.Unhandled then
				GuiService:BroadcastNotification("", module.BACK_BUTTON_NOT_CONSUMED)
				return
			end

			if backButtonAction == module2.NoOp then
				return
			end

			logger:warning("Invalid back button action: {}", backButtonAction)
		end
	end

	module3(self.onBackButtonPressed)
end

function extended:getBackButtonAction()
	return module5(self.props.navigation).backButtonAction or module2.GoBack
end

function extended.render(p2): nil
	return nil
end

function extended:didMount()
	if self.props.avatarExperienceActive then
		self:connectBackButton()
	end
end

function extended:didUpdate(p2, p3)
	if p2.avatarExperienceActive ~= self.props.avatarExperienceActive then
		if self.props.avatarExperienceActive then
			self:connectBackButton()
		else
			self:disconnectBackButton()
		end
	end
end

function extended:willUnmount()
	self:disconnectBackButton()
end

function extended:connectBackButton()
	if self.backButtonConnection then
		return
	end

	logger:info("connected")

	pcall(function()
		if self.props.EventForTests then
			self.backButtonConnection = self.props.EventForTests:Connect(self.onBackButtonPressed)
			return
		end

		self.backButtonConnection = GuiService.ShowLeaveConfirmation:Connect(self.onBackButtonPressed)
	end)

	if fFlagAndroidTVExitWithB then
		self.tvExitDisconnect = androidTVExitButtonManager.register(function()
			self:onBackButtonPressed()
		end)
	end
end

function extended:disconnectBackButton()
	logger:info("disconnected")

	if self.backButtonConnection then
		self.backButtonConnection:Disconnect()
		self.backButtonConnection = nil
	end

	if fFlagAndroidTVExitWithB and self.tvExitDisconnect then
		self.tvExitDisconnect()
		self.tvExitDisconnect = nil
	end
end

local function mapStateToProps(p2, p3)
	local v5

	if fFlagUseNavigationSelectors then
		v5 = selectors.selectCurrentLegacyPage(p2)
	else
		local history = p2.Navigation.history
		local v6 = history[#history]
		v5 = v6[#v6]
	end

	return {
		avatarExperienceActive = v5.name == avatarScreen.AvatarExperienceRoot
	}
end

local function mapDispatchToProps(callback)
	return {
		resetNavigationHistory = function(p2)
			return callback(module6(nil, p2))
		end,
		instantResetNavigationHistory = function(p2)
			return callback(MockAppStorageService(nil, p2))
		end
	}
end

local v5 = module8(extended)

local connect = RoactRodux.connect

if fFlagSignalsNavP3gAvatarExperience then
	mapStateToProps = nil
end

local v6 = connect(mapStateToProps, mapDispatchToProps)(v5)
local v7

if fFlagSignalsNavP3gAvatarExperience then
	local function BackButtonHandlerWithSignals(p2)
		local v8 = useSignalState(getLegacyNavigationStore(false).getIsCurrentPageSignal(avatarScreen.AvatarExperienceRoot))
		return React.createElement(v6, Cryo.Dictionary.union(p2, {
			avatarExperienceActive = v8
		}))
	end

	v7 = React.memo(BackButtonHandlerWithSignals)
else
	v7 = v6
end

return v7
