local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local BackButtonAction = require(Modules.AvatarExperience.Common.Components.RoactNavigation.BackButtonAction)
local connectFakeBackButton = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Debug.connectFakeBackButton)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local v13 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.rn.backButton")
local getActiveChildNavigationOptionsSafely = require(Modules.AvatarExperience.Common.Components.RoactNavigation.getActiveChildNavigationOptionsSafely)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local InstantResetNavigationHistory = require(Modules.LuaApp.Thunks.InstantResetNavigationHistory)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagAndroidTVExitWithB = SharedFlags.FFlagAndroidTVExitWithB
local FFlagSignalsNavP3gAvatarExperience = SharedFlags.FFlagSignalsNavP3gAvatarExperience
local AndroidTVExitButtonManager = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore).AndroidTVExitButtonManager
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v27 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local v28 = Roact.Component:extend("BackButtonHandler")

v28.validateProps = t.strictInterface({
	navigation = t.table,
	avatarExperienceActive = t.boolean,
	resetNavigationHistory = t.optional(t.callback),
	instantResetNavigationHistory = t.optional(t.callback),
	avatarRoute = t.optional(t.table),
	EventForTests = t.optional(t.table)
})

function v28.init(p1) -- line: 60
	-- upvalues: v13 (copy), BackButtonAction (copy), AvatarScreen (copy), NavigationUtils (copy), GuiService (copy), NotificationType (copy), connectFakeBackButton (copy)
	p1.backButtonConnection = nil
	p1.tvExitDisconnect = nil

	function p1.onBackButtonPressed() -- line: 65
		-- upvalues: p1 (copy), v13 (copy), BackButtonAction (copy), AvatarScreen (copy), NavigationUtils (copy), GuiService (copy), NotificationType (copy)
		local navigation = p1.props.navigation
		local v55 = p1:getBackButtonAction()

		v13:info("pressed: {}", v55)

		if v55 == BackButtonAction.GoBack then
			local prevNavPage = p1.props.avatarRoute.current.params.prevNavPage
			local prevNavHistory = p1.props.avatarRoute.current.params.prevNavHistory

			if prevNavPage and prevNavHistory then
				if rawget(AvatarScreen, prevNavPage) then
					navigation.navigate(prevNavPage)

					return
				end

				p1.props.resetNavigationHistory(prevNavHistory)

				return
			end

			NavigationUtils.closeFocusedScreen(navigation)

			return
		end

		if v55 == BackButtonAction.Unhandled then
			GuiService:BroadcastNotification("", NotificationType.BACK_BUTTON_NOT_CONSUMED)

			return
		end

		if v55 == BackButtonAction.NoOp then
			return
		end

		v13:warning("Invalid back button action: {}", v55)
	end

	connectFakeBackButton(p1.onBackButtonPressed)
end
function v28.getBackButtonAction(p2) -- line: 98
	-- upvalues: getActiveChildNavigationOptionsSafely (copy), BackButtonAction (copy)
	local navigation = p2.props.navigation

	return getActiveChildNavigationOptionsSafely(navigation).backButtonAction or BackButtonAction.GoBack
end
function v28.render(_) -- line: 104
	return nil
end
function v28.didMount(p4) -- line: 108
	if p4.props.avatarExperienceActive then
		p4:connectBackButton()
	end
end
function v28.didUpdate(p5, p6, _) -- line: 114
	if p6.avatarExperienceActive ~= p5.props.avatarExperienceActive then
		if p5.props.avatarExperienceActive then
			p5:connectBackButton()

			return
		end

		p5:disconnectBackButton()
	end
end
function v28.willUnmount(p8) -- line: 124
	p8:disconnectBackButton()
end
function v28.connectBackButton(p9) -- line: 128
	-- upvalues: v13 (copy), GuiService (copy), FFlagAndroidTVExitWithB (copy), AndroidTVExitButtonManager (copy)
	if p9.backButtonConnection then
		return
	end

	v13:info("connected")
	pcall(function() -- line: 136
		-- upvalues: p9 (copy), GuiService (copy)
		if p9.props.EventForTests then
			p9.backButtonConnection = p9.props.EventForTests:Connect(p9.onBackButtonPressed)

			return
		end

		p9.backButtonConnection = GuiService.ShowLeaveConfirmation:Connect(p9.onBackButtonPressed)
	end)

	if FFlagAndroidTVExitWithB then
		p9.tvExitDisconnect = AndroidTVExitButtonManager.register(function() -- line: 146
			-- upvalues: p9 (copy)
			p9:onBackButtonPressed()
		end)
	end
end
function v28.disconnectBackButton(p10) -- line: 152
	-- upvalues: v13 (copy), FFlagAndroidTVExitWithB (copy)
	v13:info("disconnected")

	if p10.backButtonConnection then
		p10.backButtonConnection:Disconnect()
		p10.backButtonConnection = nil
	end

	if FFlagAndroidTVExitWithB and p10.tvExitDisconnect then
		p10.tvExitDisconnect()
		p10.tvExitDisconnect = nil
	end
end

local function mapStateToProps(p11, _) -- line: 165
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreen (copy)
	local v47

	if FFlagUseNavigationSelectors then
		v47 = Selectors.selectCurrentLegacyPage(p11)
	else
		local history = p11.Navigation.history
		local v49 = history[#history]

		v47 = v49[#v49]
	end

	return {
		avatarExperienceActive = v47.name == AvatarScreen.AvatarExperienceRoot
	}
end
local function mapDispatchToProps(p13) -- line: 181
	-- upvalues: ResetNavigationHistory (copy), InstantResetNavigationHistory (copy)
	return {
		resetNavigationHistory = function(p14) -- line: 183
			-- upvalues: p13 (copy), ResetNavigationHistory (copy)
			return p13(ResetNavigationHistory(nil, p14))
		end,
		instantResetNavigationHistory = function(p15) -- line: 186
			-- upvalues: p13 (copy), InstantResetNavigationHistory (copy)
			return p13(InstantResetNavigationHistory(nil, p15))
		end
	}
end

local v31 = withAvatarRoute(v28)
local v32 = RoactRodux.connect((if not FFlagSignalsNavP3gAvatarExperience then mapStateToProps else nil), mapDispatchToProps)(v31)

if FFlagSignalsNavP3gAvatarExperience then
	local v33 = v32

	function v32(p16) -- line: 201
		-- upvalues: v27 (copy), useSignalState (copy), AvatarScreen (copy), React (copy), v33 (copy), Cryo (copy)
		local v52 = v27(false)
		local v53 = useSignalState(v52.getCurrentPage).name == AvatarScreen.AvatarExperienceRoot

		return React.createElement(v33, Cryo.Dictionary.union(p16, {
			avatarExperienceActive = v53
		}))
	end
end

return v32
