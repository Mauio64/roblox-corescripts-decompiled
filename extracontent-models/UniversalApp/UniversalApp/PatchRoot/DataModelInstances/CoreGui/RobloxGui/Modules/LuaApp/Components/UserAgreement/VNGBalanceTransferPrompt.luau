local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v12 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local openExternalBrowser = require(Modules.LuaApp.openExternalBrowser)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local AppPage = require(Modules.LuaApp.AppPage)
local v17 = Roact.Component:extend(script.Name)

v17.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v17.init(p1) -- line: 39
	-- upvalues: openExternalBrowser (copy), UrlBuilder (copy), AppPage (copy)
	function p1.supportFormActivated(p2) -- line: 40
		-- upvalues: p1 (copy), openExternalBrowser (copy), UrlBuilder (copy), AppPage (copy)
		if p1.props.useExternalBrowserForDisclaimerLinks then
			openExternalBrowser(p1.props.linking, UrlBuilder.static.about.support())

			return
		end

		p1.props.navigateDown({
			name = AppPage.GenericWebPage,
			detail = UrlBuilder.static.about.support(),
			extraProps = {
				title = p2.support
			}
		})
	end
end
function v17.render(p3) -- line: 56
	-- upvalues: withLocalization (copy), withStyle (copy)
	return withLocalization({
		title = "CommonUI.UserAgreements.Popup.TransferCurrency.Title",
		message = "CommonUI.UserAgreements.Popup.TransferCurrency.Message",
		button = "CommonUI.UserAgreements.Popup.ContactCustomerSupport",
		support = "Feature.Moderation.Link.SupportForm"
	})(function(p4) -- line: 62
		-- upvalues: withStyle (copy), p3 (copy)
		return withStyle(function(p5) -- line: 63
			-- upvalues: p3 (copy), p4 (copy)
			return p3:renderWithProviders(p4, p5)
		end)
	end)
end
function v17.renderWithProviders(p6, p7, _) -- line: 69
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	local props = p6.props

	return Roact.createElement(InteractiveAlert, {
		anchorPoint = props.anchorPoint,
		position = props.position,
		screenSize = props.screenSize,
		title = p7.title,
		bodyText = p7.message,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = function() -- line: 83
						-- upvalues: p6 (copy), p7 (copy), props (copy)
						p6.supportFormActivated(p7)
						props.doneActivated()
					end,
					text = p7.button
				}
			}}
		}
	})
end

local v18 = RoactAppPolicy.connect(function(p9) -- line: 95
	return {
		useExternalBrowserForDisclaimerLinks = p9.shouldUseExternalBrowserForDisclaimerLinks()
	}
end)(v17)

return (RoactRodux.connect(nil, function(p10) -- line: 101
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateDown (copy)
	return {
		navigateDown = function(p11) -- line: 103
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v12 (copy), p10 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v12.down(v12.fromLegacyPage(p11))

				return
			end

			p10(NavigateDown(p11))
		end
	}
end)(v18))
