local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ToggleTryOnThunk = require(Modules.AvatarExperience.Common.Thunks.ToggleTryOnThunk)
local ClearTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ClearTryOns
local wrapDispatchTable = require(Modules.AvatarExperience.Common.wrapDispatchTable)
local selectNumTryOnItems = require(Modules.AvatarExperience.Catalog.Selectors.selectNumTryOnItems)
local v23 = Roact.PureComponent:extend("ResetToNewCharacterPrompt")

v23.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	numCartItems = t.number,
	clearTryOns = t.callback,
	toggleTryOn = t.callback,
	networking = t.callback,
	appAnalytics = t.table,
	catalogAnalytics = t.table,
	itemId = t.string,
	navigation = t.table,
	avatarRoute = t.table,
	focusController = t.optional(t.table),
	defaultChildRef = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback)
})

function v23.init(p1) -- line: 67
	-- upvalues: Constants (copy), NavigationUtils (copy)
	function p1.equipNewCharacter() -- line: 68
		-- upvalues: p1 (copy), Constants (copy)
		p1.props.toggleTryOn(p1.props.networking, p1.props.catalogAnalytics, Constants.ItemType.Bundle, Constants.BundleTypeIdStrings.BodyParts, p1.props.itemId, true, p1.props.avatarRoute, p1.props.navigation)
	end
	function p1.resetTryOnsAndAdd() -- line: 81
		-- upvalues: p1 (copy)
		p1.props.clearTryOns()
		p1.equipNewCharacter()
		p1.closePrompt()
	end
	function p1.keepTryOnsAndAdd() -- line: 87
		-- upvalues: p1 (copy)
		p1.equipNewCharacter()
		p1.closePrompt()
	end
	function p1.closePrompt() -- line: 92
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v23.renderAlertLocalized(p2, p3) -- line: 97
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return Roact.createElement(InteractiveAlert, {
		title = p3.resetToNewCharacterTitle,
		bodyText = p3.resetToNewCharacterBody,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p2.resetTryOnsAndAdd,
						text = p3.reset
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p2.keepTryOnsAndAdd,
						text = p3.keep
					}
				}
			}
		},
		screenSize = p2.props.screenSize,
		defaultChildRef = p2.props.defaultChildRef
	})
end
function v23.render(p4) -- line: 124
	-- upvalues: withLocalization (copy)
	return withLocalization({
		resetToNewCharacterTitle = "Feature.Avatar.Title.ResetToNewCharacter",
		resetToNewCharacterBody = "Feature.Avatar.Label.ResetToNewCharacter",
		reset = "CommonUI.Messages.Action.Reset",
		keep = "Feature.Avatar.Action.Keep"
	})(function(p5) -- line: 130
		-- upvalues: p4 (copy)
		return p4:renderAlertLocalized(p5)
	end)
end

local v24 = RoactServices.connect({
	appAnalytics = RoactAnalytics,
	catalogAnalytics = Analytics,
	networking = RoactNetworking
})(v23)

return (withMappedNavigationParams((withOverlayFocusHandling((withAvatarRoute((RoactRodux.connect(function(p6, _) -- line: 142
	-- upvalues: selectNumTryOnItems (copy)
	return {
		screenSize = p6.ScreenSize,
		numCartItems = selectNumTryOnItems(p6)
	}
end, wrapDispatchTable({
	clearTryOns = ClearTryOns,
	toggleTryOn = ToggleTryOnThunk
}))(v24))))))))
