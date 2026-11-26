local CorePackages = game:GetService("CorePackages")

local GuiService = game:GetService("GuiService")

local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection

local module = require("@luauforge/deferred/gJH")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local module2 = require("@luauforge/bundled/gRA")
local module3 = require("@luauforge/deferred/gTt")
local module4 = require("@luauforge/bundled/fvR")

local module5 = require("@luauforge/deferred/gJK")

local module6 = require("@luauforge/deferred/gVn")
local module7 = require("@luauforge/bundled/dQS")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
require("@luauforge/bundled/dKT")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local fFlagAXFixOrientationInputBlocking = SharedFlags.FFlagAXFixOrientationInputBlocking
local fFlagAndroidTVExitWithB = SharedFlags.FFlagAndroidTVExitWithB
local fFlagQRCodePageVisualRefresh = SharedFlags.FFlagQRCodePageVisualRefresh

local androidTVExitButtonManager = require("@luauforge/bundled/dFB").AndroidTVExitButtonManager

local extended = Roact.PureComponent:extend("AvatarBackground")

extended.defaultProps = { playEmote = true, isVisible = true, isTopBarVisible = true }

local strictInterface = t.strictInterface
local v5 = {
	title = t.optional(t.string),
	playEmote = t.optional(t.boolean),
	isVisible = t.optional(t.boolean),
	renderContent = t.optional(t.callback),
	isTopBarSecondary = t.optional(t.boolean),
	isTopBarVisible = t.optional(t.boolean),
	hideAvatarBackground = 0,
	deviceOrientation = 0,
	currentCharacter = 0,
	setPlayEmoteInBackground = 0,
	navigateBackInAppRoute = 0,
	avatarRoute = 0,
	detail = 0,
	navigation = 0
}
local v6 = if fFlagQRCodePageVisualRefresh then t.optional(t.boolean) else nil
v5.hideAvatarBackground = v6

v5.deviceOrientation = t.string
v5.currentCharacter = t.Instance

v5.setPlayEmoteInBackground = t.callback
v5.navigateBackInAppRoute = t.callback

v5.avatarRoute = t.optional(t.table)
v5.detail = t.optional(t.string)
v5.navigation = t.table
extended.validateProps = strictInterface(v5)

function extended:init()
	self.tvExitDisconnect = nil

	function self.backButtonPressed()
		self.props.navigateBackInAppRoute(true)
	end

	self.backButton = module4.makeBackButton(self.backButtonPressed)

	function self.renderContent()
		if not self.props.renderContent then
			return nil
		end

		local currentCharacter = self.props.currentCharacter
		return self.props.renderContent({ character = currentCharacter })
	end
end

function extended:renderTopBarWithLocalized()
	if self.props.title then
		return withLocalization({ title = self.props.title })(function(p2)
			return self:renderTopBar(p2.title)
		end)
	end

	return self:renderTopBar("")
end

function extended:renderTopBar(p3)
	return Roact.createElement(module4.Container, {
		tag = compositionTags.ContentRegion.Header,
		sideMarginOverride = 0,
		isSecondary = self.props.isTopBarSecondary,
		titleText = p3,
		transparentBackground = true,
		leftItem = self.backButton
	})
end

function extended:renderAvatarExperienceView(p2)
	local createElement = Roact.createElement
	local v9 = if p2 then self:renderTopBarWithLocalized() or nil else nil
	return createElement(
		module3,
		{
			topBar = v9,
			bottomBarEnabled = false,
			isSceneFullView = true,
			isUIFullView = false
		},
		{
			ExternalNavigationHandler = Roact.createElement(module6, {
				navigation = self.props.navigation
			})
		}
	)
end

function extended:renderMainView()
	if self.props.deviceOrientation == deviceOrientationMode.Portrait then
		if fFlagAXFixOrientationInputBlocking then
			return Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
				{
					AEView = self:renderAvatarExperienceView(self.props.isTopBarVisible)
				}
			)
		end

		return self:renderAvatarExperienceView(self.props.isTopBarVisible)
	else
		local createElement = Roact.createElement
		local v8 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }

		local v10 = if self.props.isTopBarVisible then self:renderTopBarWithLocalized() else nil
		return createElement("Frame", v8, {
			TopBar = v10,
			AEView = self:renderAvatarExperienceView(false)
		})
	end
end

function extended:render()
	return Roact.createElement(
		focusable.Frame,
		{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
		{
			BackButtonConnection = Roact.createElement(externalEventConnection, {
				event = GuiService.ShowLeaveConfirmation,
				callback = self.backButtonPressed
			}),
			NavigationEventsLogger = Roact.createElement(module5, {
				pageName = "AvatarBackground"
			}),
			Mainview = self:renderMainView(),
			Content = self.renderContent()
		}
	)
end

function extended.didUpdate(p2, p3)
	if p2.props.playEmote ~= p3.playEmote then
		p2.props.setPlayEmoteInBackground(p2.props.playEmote)
	end
end

function extended:willUnmount()
	if fFlagAndroidTVExitWithB and self.tvExitDisconnect then
		self.tvExitDisconnect()
		self.tvExitDisconnect = nil
	end
end

function extended:didMount()
	if fFlagAndroidTVExitWithB then
		self.tvExitDisconnect = androidTVExitButtonManager.register(function()
			self:backButtonPressed()
		end)
	end

	self.props.setPlayEmoteInBackground(self.props.playEmote)
end

local function mapStateToProps(p2)
	return {
		deviceOrientation = p2.DeviceOrientation,
		currentCharacter = p2.AvatarExperience.AvatarScene.Character.CurrentCharacter
	}
end

local function mapDispatchToProps(callback)
	return {
		setPlayEmoteInBackground = function(p2)
			callback(module7(p2))
		end,
		navigateBackInAppRoute = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back(p2)
			else
				callback(RobloxAppToastsRodux(p2))
			end
		end
	}
end

return module2((module((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)))))
