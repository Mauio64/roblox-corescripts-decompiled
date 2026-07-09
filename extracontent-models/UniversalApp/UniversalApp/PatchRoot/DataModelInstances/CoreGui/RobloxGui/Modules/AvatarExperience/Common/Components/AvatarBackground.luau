local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local AfterAvatarExperienceLoaded = require(Modules.AvatarExperience.Common.Components.AfterAvatarExperienceLoaded)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local AvatarExperienceView = require(Modules.AvatarExperience.Common.Components.AvatarExperienceView)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local NavigationEventsLogger = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local ExternalNavigationHandler = require(Modules.AvatarExperience.Common.Components.RoactNavigation.ExternalNavigationHandler)
local SetPlayEmoteInBackground = require(Modules.AvatarExperience.Common.Actions.SetPlayEmoteInBackground)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v24 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local FFlagAXMigrateAXToGlobalAutofocus = SharedFlags.FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXFixOrientationInputBlocking = SharedFlags.FFlagAXFixOrientationInputBlocking
local FFlagAndroidTVExitWithB = SharedFlags.FFlagAndroidTVExitWithB
local AndroidTVExitButtonManager = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore).AndroidTVExitButtonManager
local v29 = Roact.PureComponent:extend("AvatarBackground")

v29.defaultProps = {
	playEmote = true,
	isVisible = true,
	isTopBarVisible = true
}
v29.validateProps = t.strictInterface({
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.optional(t.table) else nil,
	title = t.optional(t.string),
	playEmote = t.optional(t.boolean),
	isVisible = t.optional(t.boolean),
	renderContent = t.optional(t.callback),
	isTopBarSecondary = t.optional(t.boolean),
	isTopBarVisible = t.optional(t.boolean),
	deviceOrientation = t.string,
	currentCharacter = t.Instance,
	setPlayEmoteInBackground = t.callback,
	navigateBackInAppRoute = t.callback,
	avatarRoute = t.optional(t.table),
	detail = t.optional(t.string),
	navigation = t.table
})

function v29.init(p1) -- line: 74
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), TopBar (copy)
	p1.focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p1.props.focusController or RoactGamepad.createFocusController() else nil
	p1.tvExitDisconnect = nil

	function p1.backButtonPressed() -- line: 82
		-- upvalues: p1 (copy)
		p1.props.navigateBackInAppRoute(true)
	end

	p1.backButton = TopBar.makeBackButton(p1.backButtonPressed)

	function p1.renderContent() -- line: 88
		-- upvalues: p1 (copy)
		if p1.props.renderContent then
			local currentCharacter = p1.props.currentCharacter

			return p1.props.renderContent({
				character = currentCharacter
			})
		end

		return nil
	end
end
function v29.renderTopBarWithLocalized(p2) -- line: 99
	-- upvalues: withLocalization (copy)
	if p2.props.title then
		return withLocalization({
			title = p2.props.title
		})(function(p3) -- line: 103
			-- upvalues: p2 (copy)
			return p2:renderTopBar(p3.title)
		end)
	end

	return p2:renderTopBar("")
end
function v29.renderTopBar(p4, p5) -- line: 110
	-- upvalues: Roact (copy), TopBar (copy)
	return Roact.createElement(TopBar.Container, {
		transparentBackground = true,
		isSecondary = p4.props.isTopBarSecondary,
		titleText = p5,
		leftItem = p4.backButton
	})
end
function v29.renderAvatarExperienceView(p6, p7) -- line: 119
	-- upvalues: Roact (copy), AvatarExperienceView (copy), ExternalNavigationHandler (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), GamepadFocusHandlerForPage (copy)
	return Roact.createElement(AvatarExperienceView, {
		bottomBarEnabled = false,
		isSceneFullView = true,
		isUIFullView = false,
		topBar = p7 and p6:renderTopBarWithLocalized() or nil
	}, {
		ExternalNavigationHandler = Roact.createElement(ExternalNavigationHandler, {
			navigation = p6.props.navigation
		}),
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(GamepadFocusHandlerForPage, {
			focusController = p6.focusController
		}) else nil
	})
end
function v29.renderMainView(p8) -- line: 137
	-- upvalues: DeviceOrientationMode (copy), Roact (copy), FFlagAXFixOrientationInputBlocking (copy)
	if p8.props.deviceOrientation ~= DeviceOrientationMode.Portrait then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			TopBar = if p8.props.isTopBarVisible then p8:renderTopBarWithLocalized() else nil,
			AEView = p8:renderAvatarExperienceView(false)
		})
	end

	if FFlagAXFixOrientationInputBlocking then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			AEView = p8:renderAvatarExperienceView(p8.props.isTopBarVisible)
		})
	end

	return p8:renderAvatarExperienceView(p8.props.isTopBarVisible)
end
function v29.render(p9) -- line: 163
	-- upvalues: Roact (copy), Focusable (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), ExternalEventConnection (copy), GuiService (copy), NavigationEventsLogger (copy)
	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p9.focusController else nil
	}, {
		BackButtonConnection = Roact.createElement(ExternalEventConnection, {
			event = GuiService.ShowLeaveConfirmation,
			callback = p9.backButtonPressed
		}),
		NavigationEventsLogger = Roact.createElement(NavigationEventsLogger, {
			pageName = "AvatarBackground"
		}),
		Mainview = p9:renderMainView(),
		Content = p9.renderContent()
	})
end
function v29.didUpdate(p10, p11) -- line: 181
	if p10.props.playEmote ~= p11.playEmote then
		p10.props.setPlayEmoteInBackground(p10.props.playEmote)
	end
end
function v29.willUnmount(p12) -- line: 190
	-- upvalues: FFlagAndroidTVExitWithB (copy)
	if FFlagAndroidTVExitWithB and p12.tvExitDisconnect then
		p12.tvExitDisconnect()
		p12.tvExitDisconnect = nil
	end
end
function v29.didMount(p13) -- line: 197
	-- upvalues: FFlagAndroidTVExitWithB (copy), AndroidTVExitButtonManager (copy)
	if FFlagAndroidTVExitWithB then
		p13.tvExitDisconnect = AndroidTVExitButtonManager.register(function() -- line: 199
			-- upvalues: p13 (copy)
			p13:backButtonPressed()
		end)
	end

	p13.props.setPlayEmoteInBackground(p13.props.playEmote)
end

local function mapStateToProps(p14) -- line: 206
	return {
		deviceOrientation = p14.DeviceOrientation,
		currentCharacter = p14.AvatarExperience.AvatarScene.Character.CurrentCharacter
	}
end
local function mapDispatchToProps(p15) -- line: 213
	-- upvalues: SetPlayEmoteInBackground (copy), FFlagSignalsNavP3Dispatch (copy), v24 (copy), NavigateBack (copy)
	return {
		setPlayEmoteInBackground = function(p16) -- line: 215
			-- upvalues: p15 (copy), SetPlayEmoteInBackground (copy)
			p15(SetPlayEmoteInBackground(p16))
		end,
		navigateBackInAppRoute = function(b1: boolean?) -- line: 218
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v24 (copy), p15 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				v24.back(b1)

				return
			end

			p15(NavigateBack(b1))
		end
	}
end

return AfterAvatarExperienceLoaded((withMappedNavigationParams((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v29)))))
