local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local v13 = Roact.PureComponent:extend("OutfitIncompletePrompt")

v13.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	navigationCallback = t.callback,
	navigation = t.table,
	focusController = t.optional(t.table),
	defaultChildRef = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback)
})

function closePrompt(p1) -- line: 43
	-- upvalues: NavigationUtils (copy)
	NavigationUtils.closeOverlay(p1)
end
function v13.init(p2) -- line: 47
	function p2.onStay() -- line: 48
		-- upvalues: p2 (copy)
		closePrompt(p2.props.navigation)
	end
	function p2.onLeave() -- line: 52
		-- upvalues: p2 (copy)
		closePrompt(p2.props.navigation)
		p2.props.navigationCallback()
	end
end
function v13.renderAlertLocalized(p3, p4) -- line: 58
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return Roact.createElement(InteractiveAlert, {
		title = p4.outfitIncompleteTitle,
		bodyText = p4.outfitIncompleteBody,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p3.onLeave,
						text = p4.leave
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p3.onStay,
						text = p4.stay
					}
				}
			}
		},
		screenSize = p3.props.screenSize,
		defaultChildRef = p3.props.defaultChildRef
	})
end
function v13.render(p5) -- line: 85
	-- upvalues: withLocalization (copy)
	return withLocalization({
		outfitIncompleteTitle = "Feature.Avatar.Title.OutfitIncomplete",
		outfitIncompleteBody = "Feature.Avatar.Label.OutfitIncomplete",
		leave = "Feature.Chat.Action.Leave",
		stay = "Feature.Chat.Action.Stay"
	})(function(p6) -- line: 91
		-- upvalues: p5 (copy)
		return p5:renderAlertLocalized(p6)
	end)
end

return (withMappedNavigationParams((withOverlayFocusHandling((RoactRodux.connect(function(p7, _) -- line: 96
	return {
		screenSize = p7.ScreenSize
	}
end, nil)(v13))))))
