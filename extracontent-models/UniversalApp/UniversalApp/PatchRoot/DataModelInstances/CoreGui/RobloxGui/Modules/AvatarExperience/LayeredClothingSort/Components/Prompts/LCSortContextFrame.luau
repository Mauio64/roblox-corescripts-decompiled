local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarRefinement.Constants)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local v19 = not IsVRAppBuild() and 0 or 120
local v20 = Roact.PureComponent:extend("LCSortContextFrame")

v20.validateProps = t.strictInterface({
	navigation = t.table,
	asset = t.table,
	onUnequip = t.optional(t.callback),
	tilePositionY = t.number,
	avatarRoute = t.table,
	screenSize = t.Vector2,
	isPortrait = t.boolean,
	globalGuiInset = t.table,
	focusController = t.optional(t.table),
	defaultChildRef = t.optional(t.table)
})

function v20.init(p1) -- line: 56
	-- upvalues: Roact (copy), NavigationUtils (copy), AvatarScreen (copy)
	local v22, v23 = Roact.createBinding(UDim2.fromScale(1, 1))

	p1.contextMenuSize = v22
	p1.updateContextMenuSize = v23

	function p1.openUnequipPrompt() -- line: 59
		-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy)
		NavigationUtils.navigateToNextOverlay(p1.props.navigation, AvatarScreen.RemoveItemPrompt, {
			asset = p1.props.asset,
			onUnequip = p1.props.onUnequip
		})
	end
	function p1.closePrompt() -- line: 66
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v20.renderLocalized(p2, p3) -- line: 71
	-- upvalues: Constants (copy), IsVRAppBuild (copy), Constants2 (copy), v19 (copy), Roact (copy), ContextualMenu (copy), MenuDirection (copy)
	local closePrompt = p2.closePrompt
	local screenSize = p2.props.screenSize
	local t1 = {}

	table.insert(t1, {
		icon = nil,
		text = p3.unequip,
		onActivated = function() -- line: 80
			-- upvalues: p2 (copy)
			p2.openUnequipPrompt()
		end
	})

	local isPortrait = p2.props.isPortrait
	local v30 = if not isPortrait then Constants.LandscapeNavWidth else 0
	local v31 = if not isPortrait then Constants.LandscapeSceneWidth else 1
	local v32 = not IsVRAppBuild() and 0 or Constants2.VerticalList.Width + Constants2.Tile.ContextWidth
	local uDim2 = UDim2.new(v30, v32, 0, 0)
	local uDim2_2 = UDim2.fromScale(v31, 1)
	local v35 = p2.props.tilePositionY - p2.props.screenSize.Y + Constants2.Tile.SelectedSize + 56 + 11 + p2.props.globalGuiInset.bottom + v19

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = uDim2,
		Size = uDim2_2
	}, {
		SizeFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Size = p2.contextMenuSize
		}, {
			ContextMenu = Roact.createElement(ContextualMenu, {
				open = true,
				buttonProps = t1,
				menuDirection = MenuDirection.Up,
				openPositionY = UDim.new(1, v35),
				closeBackgroundVisible = not IsVRAppBuild(),
				screenSize = screenSize,
				onDismiss = closePrompt
			})
		})
	})
end
function v20.render(p4) -- line: 130
	-- upvalues: withLocalization (copy)
	return withLocalization({
		unequip = "Feature.Avatar.Action.Unequip"
	})(function(p5) -- line: 133
		-- upvalues: p4 (copy)
		return p4:renderLocalized(p5)
	end)
end

return (withMappedNavigationParams((withAvatarRoute((withOverlayFocusHandling((RoactRodux.connect(function(p6, _) -- line: 138
	-- upvalues: selectIsPortrait (copy)
	return {
		screenSize = p6.ScreenSize,
		globalGuiInset = p6.GlobalGuiInset,
		isPortrait = selectIsPortrait(p6)
	}
end, nil)(v20))))))))
