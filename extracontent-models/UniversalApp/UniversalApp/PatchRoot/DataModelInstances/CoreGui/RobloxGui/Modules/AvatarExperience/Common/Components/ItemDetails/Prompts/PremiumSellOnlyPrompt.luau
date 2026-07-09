local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v8 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local v15 = Roact.PureComponent:extend("PremiumSellOnlyPrompt")

function v15.init(p1) -- line: 25
	-- upvalues: NavigationUtils (copy)
	function p1.openPremiumPage() -- line: 26
		-- upvalues: p1 (copy)
		p1.closePrompt()
		p1.props.openPremiumPage()
	end
	function p1.closePrompt() -- line: 31
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v15.renderAlertLocalized(p2, p3) -- line: 36
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return Roact.createElement(InteractiveAlert, {
		title = p3.titleText,
		bodyText = p3.messageText,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p2.closePrompt,
						text = p3.cancelButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p2.openPremiumPage,
						text = p3.confirmButtonText
					}
				}
			}
		},
		screenSize = p2.props.screenSize,
		defaultChildRef = p2.props.defaultChildRef
	})
end
function v15.render(p4) -- line: 63
	-- upvalues: withLocalization (copy)
	return withLocalization({
		titleText = "Feature.Catalog.Heading.PremiumOnly",
		messageText = "Feature.Catalog.Label.SellPageUpsell",
		confirmButtonText = "Feature.Catalog.Action.Upgrade",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(p5) -- line: 69
		-- upvalues: p4 (copy)
		return p4:renderAlertLocalized(p5)
	end)
end

return (withOverlayFocusHandling((RoactRodux.connect(function(p6, _) -- line: 74
	return {
		screenSize = p6.ScreenSize
	}
end, function(p8) -- line: 78
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateDown (copy)
	return {
		openPremiumPage = function() -- line: 80
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), p8 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.BuildersClub
			}

			if FFlagSignalsNavP3Dispatch then
				v8.down(v8.fromLegacyPage(t1))

				return
			end

			return p8(NavigateDown(t1))
		end
	}
end)(v15))))
