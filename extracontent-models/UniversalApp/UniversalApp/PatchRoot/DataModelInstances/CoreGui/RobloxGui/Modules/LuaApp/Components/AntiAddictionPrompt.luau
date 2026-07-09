local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Constants = require(Modules.LuaApp.Constants)
local withLocalization = require(Modules.LuaApp.withLocalization)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local AppUserInputService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppUserInputService
local ScreenGuiWithBlurControl = require(Modules.LuaApp.Components.ScreenGuiWithBlurControl)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local AppPage = require(Modules.LuaApp.AppPage)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v19 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local SetScreenGuiBlur = require(Modules.LuaApp.Actions.SetScreenGuiBlur)
local v22 = Roact.PureComponent:extend("AntiAddictionPrompt")

function v22.init(p1) -- line: 36
	local guiService = p1.props.guiService
	local networking = p1.props.networking

	p1.state = {
		screenSize = Vector2.new(0, 0)
	}

	function p1.changeScreenSize(p2) -- line: 44
		-- upvalues: p1 (copy)
		if p1.state.screenSize ~= p2.AbsoluteSize then
			p1:setState({
				screenSize = p2.AbsoluteSize
			})
		end
	end
	function p1.OkCallback(...) -- line: 52
		-- upvalues: p1 (copy)
		if p1.props.okCallback then
			p1.props.okCallback(...)
		end
	end
	function p1.LogoutCallback() -- line: 58
		-- upvalues: p1 (copy), networking (copy), guiService (copy)
		p1.props.logout(networking, guiService)

		if p1.props.logoutCallback then
			p1.props.logoutCallback()
		end
	end
end
function v22.render(p3) -- line: 67
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy), ScreenGuiWithBlurControl (copy), Constants (copy), withLocalization (copy)
	local message = p3.props.message
	local lockOut = p3.props.lockOut
	local v30 = lockOut and p3.LogoutCallback or p3.OkCallback
	local FocusedTextBox = p3.props.userInputService:GetFocusedTextBox()

	if FocusedTextBox then
		FocusedTextBox:ReleaseFocus()
	end

	local function v32(p4) -- line: 77
		-- upvalues: Roact (copy), InteractiveAlert (copy), message (copy), ButtonType (copy), v30 (copy), p3 (copy), ScreenGuiWithBlurControl (copy), Constants (copy), lockOut (copy)
		local v38 = Roact.createElement(InteractiveAlert, {
			title = p4.alertTitle,
			bodyText = message,
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v30,
						text = p4.buttonText
					}
				}}
			},
			screenSize = p3.state.screenSize
		})
		local v39 = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Active = true,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new()
		}, {
			AlertWindow = v38
		})

		return Roact.createElement(ScreenGuiWithBlurControl, {
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = Constants.DisplayOrder.AntiAddictionPrompt,
			OnTopOfCoreBlur = lockOut
		}, {
			Overlay = v39
		})
	end

	return withLocalization({
		alertTitle = "CommonUI.Messages.Label.Alert",
		buttonText = not lockOut and "CommonUI.Messages.Action.OK" or "Application.Logout.Action.Logout"
	})(function(p5) -- line: 115
		-- upvalues: v32 (copy)
		return v32(p5)
	end)
end
function v22.didMount(p6) -- line: 120
	if p6.props.lockOut then
		p6.props.setScreenGuiBlur(true)
	end
end
function v22.willUnmount(p7) -- line: 128
	if p7.props.lockOut then
		p7.props.setScreenGuiBlur(false)
	end
end

local v23 = RoactRodux.connect(nil, function(p8) -- line: 136
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), NavigateDown (copy), SetScreenGuiBlur (copy), Constants (copy), Logout (copy), luaLogoutReasonNames (copy)
	return {
		openLogoutPage = function() -- line: 138
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), p8 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.LogoutConfirmation
			}

			if FFlagSignalsNavP3Dispatch then
				v19.down(v19.fromLegacyPage(t1))

				return
			end

			p8(NavigateDown(t1))
		end,
		setScreenGuiBlur = function(p9) -- line: 146
			-- upvalues: p8 (copy), SetScreenGuiBlur (copy), Constants (copy)
			p8(SetScreenGuiBlur("AntiAddictionPrompt", p9, Constants.DisplayOrder.AntiAddictionPrompt))
		end,
		logout = function(p10, p11) -- line: 149
			-- upvalues: p8 (copy), Logout (copy), luaLogoutReasonNames (copy)
			p8(Logout(p10, p11, luaLogoutReasonNames.AntiAddiction))
		end
	}
end)(v22)

return (RoactServices.connect({
	guiService = AppGuiService,
	userInputService = AppUserInputService,
	networking = RoactNetworking
})(v23))
