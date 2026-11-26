local CorePackages = game:GetService("CorePackages")

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local Roact = require(CorePackages.Packages.Roact)
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local module2 = require("@luauforge/bundled/egx")
local module3 = require("@luauforge/bundled/ehB")
local module4 = require("@luauforge/bundled/dFu")

local module5 = require("@luauforge/bundled/ggi")
local module6 = require("@luauforge/bundled/ggp")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module7 = require("@luauforge/bundled/fvN")
local module8 = require("@luauforge/deferred/hYo")
local module9 = require("@luauforge/deferred/hYp")
local module10 = require("@luauforge/deferred/hYq")

local extended = Roact.PureComponent:extend("VngContactInfoFormWebviewPopup")
local Foundation = require(CorePackages.Packages.Foundation)
local loading = Foundation.Loading

local module11 = require("@luauforge/deferred/hYr")

local getFFlagUseUpdatedVNGAgreementsWorkflow = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagUseUpdatedVNGAgreementsWorkflow
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

function extended.didMount(p2)
	local networking = p2.props.networking
	local guiService = p2.props.guiService
	local logout = p2.props.logout
	local exit = p2.props.exit

	module8(networking):andThen(function(p3)
		local formUrl = p3.responseBody.formUrl

		if formUrl then
			p2.props.openWebView(formUrl, "", networking, logout, guiService, exit)
		else
			exit()
		end
	end, function(p3)
		logout(networking, guiService)
	end)
end

function LUAUFORGE_MODULE_GLOBALS_hYn_windowClosedCallback(callback, object, p2, callback2)
	module9(p2):andThen(function(p3)
		if p3.responseBody.completed == false then
			callback(p2, object)
			return
		end

		object:BroadcastNotification("", module7.RESTART_LUA_APP)
		callback2()
	end, function()
		callback(p2, object)
	end)
end

function extended.render(p2)
	if getFFlagUseUpdatedVNGAgreementsWorkflow() then
		return Roact.createElement(module10, {})
	end

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, p2.props.screenSize.Y),
			BackgroundTransparency = 0,
			BorderSizePixel = 0
		},
		{
			Layout = Roact.createElement(loading, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
		}
	)
end

local v5 = useSheetNavigation.connect(function(p2)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		logout = function(p2, p3)
			callback(module5(p2, p3, module6.PartnerFormNotComplete))
		end,
		openWebView = function(p2, p3, p4, p5, p6, p7)
			local v6 = {
				name = module4.GenericWebPage,
				detail = p2,
				extraProps = {
					title = p3,
					onClose = function()
						LUAUFORGE_MODULE_GLOBALS_hYn_windowClosedCallback(p5, p6, p4, p7)
					end
				}
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(module3(v6))
			end
		end,
		exit = function()
			callback(module11())
		end
	}
end)(extended)

return (roactServices.connect({ guiService = appGuiService, networking = module2 })(v5))
