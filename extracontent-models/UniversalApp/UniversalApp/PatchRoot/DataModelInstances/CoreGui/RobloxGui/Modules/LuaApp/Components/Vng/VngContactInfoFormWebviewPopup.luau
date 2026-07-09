local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local AppPage = require(Modules.LuaApp.AppPage)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local StartVngVerificationForm = require(Modules.LuaApp.Http.Requests.StartVngVerificationForm)
local ValidateVngVerificationFormStatus = require(Modules.LuaApp.Http.Requests.ValidateVngVerificationFormStatus)
local VngComplianceLoadingPopup = require(Modules.LuaApp.Components.Vng.VngComplianceLoadingPopup)
local v16 = Roact.PureComponent:extend("VngContactInfoFormWebviewPopup")
local Loading = require(CorePackages.Packages.Foundation).Loading
local CloseVngContactInfoFormWebviewPopup = require(Modules.LuaApp.Thunks.CloseVngContactInfoFormWebviewPopup)
local GetFFlagUseUpdatedVNGAgreementsWorkflow = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagUseUpdatedVNGAgreementsWorkflow
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v21 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

function v16.didMount(p1) -- line: 31
	-- upvalues: StartVngVerificationForm (copy)
	local networking = p1.props.networking
	local guiService = p1.props.guiService
	local logout = p1.props.logout
	local exit = p1.props.exit

	StartVngVerificationForm(networking):andThen(function(p2) -- line: 37
		-- upvalues: exit (copy), p1 (copy), networking (copy), logout (copy), guiService (copy)
		local formUrl = p2.responseBody.formUrl

		if not formUrl then
			exit()

			return
		end

		p1.props.openWebView(formUrl, "", networking, logout, guiService, exit)
	end, function(_) -- line: 44
		-- upvalues: logout (copy), networking (copy), guiService (copy)
		logout(networking, guiService)
	end)
end
function windowClosedCallback(p4, p5, p6, p7) -- line: 49
	-- upvalues: ValidateVngVerificationFormStatus (copy), NotificationType (copy)
	ValidateVngVerificationFormStatus(p6):andThen(function(p8) -- line: 50
		-- upvalues: p4 (copy), p6 (copy), p5 (copy), NotificationType (copy), p7 (copy)
		if p8.responseBody.completed == false then
			p4(p6, p5)

			return
		end

		p5:BroadcastNotification("", NotificationType.RESTART_LUA_APP)
		p7()
	end, function() -- line: 57
		-- upvalues: p4 (copy), p6 (copy), p5 (copy)
		p4(p6, p5)
	end)
end
function v16.render(p9) -- line: 62
	-- upvalues: GetFFlagUseUpdatedVNGAgreementsWorkflow (copy), Roact (copy), VngComplianceLoadingPopup (copy), Loading (copy)
	if GetFFlagUseUpdatedVNGAgreementsWorkflow() then
		return Roact.createElement(VngComplianceLoadingPopup, {})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, p9.props.screenSize.Y)
	}, {
		Layout = Roact.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
	})
end

local v22 = RoactRodux.connect(function(p10) -- line: 79
	return {
		screenSize = p10.ScreenSize
	}
end, function(p11) -- line: 83
	-- upvalues: Logout (copy), luaLogoutReasonNames (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateDown (copy), CloseVngContactInfoFormWebviewPopup (copy)
	return {
		logout = function(p12, p13) -- line: 85
			-- upvalues: p11 (copy), Logout (copy), luaLogoutReasonNames (copy)
			p11(Logout(p12, p13, luaLogoutReasonNames.PartnerFormNotComplete))
		end,
		openWebView = function(p14, p15, p16, p17, p18, p19) -- line: 88
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), p11 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.GenericWebPage,
				detail = p14,
				extraProps = {
					title = p15,
					onClose = function() -- line: 94
						-- upvalues: p17 (copy), p18 (copy), p16 (copy), p19 (copy)
						windowClosedCallback(p17, p18, p16, p19)
					end
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v21.down(v21.fromLegacyPage(t1))

				return
			end

			p11(NavigateDown(t1))
		end,
		exit = function() -- line: 105
			-- upvalues: p11 (copy), CloseVngContactInfoFormWebviewPopup (copy)
			p11(CloseVngContactInfoFormWebviewPopup())
		end
	}
end)(v16)

return (RoactServices.connect({
	guiService = AppGuiService,
	networking = RoactNetworking
})(v22))
