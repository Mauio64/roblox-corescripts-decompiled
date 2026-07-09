local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local LayeredClothingSortUtils = require(Modules.AvatarExperience.LayeredClothingSort.LayeredClothingSortUtils)
local LayeredMakeupSortUtils = require(Modules.AvatarExperience.LayeredMakeupSort.LayeredMakeupSortUtils)
local SetCurrentSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetCurrentSort)
local ClearRemovedItems = require(Modules.AvatarExperience.LayeredClothingSort.Actions.ClearRemovedItems)
local EquipOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.EquipOutfit)
local SetOrderForTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetOrderForTryOns
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.LayeredClothingSort.Services.Analytics)
local SendRefinementAnalytics = require(Modules.AvatarExperience.LayeredClothingSort.Thunks.SendRefinementAnalytics)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local FFlagAXCustomizeMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCustomizeMakeupSupport
local v25 = Roact.PureComponent:extend("ResetLayeredItemsSortPrompt")

v25.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	lastSavedSort = t.table,
	equippedAssets = t.optional(t.table),
	tryOnItems = if not FFlagAXCustomizeMakeupSupport then nil else t.optional(t.table),
	removedList = if not FFlagAXCustomizeMakeupSupport then nil else t.optional(t.table),
	setCurrentSort = t.callback,
	equipOutfit = t.callback,
	clearRemovedItems = t.callback,
	sendAnalytics = t.callback,
	setOrderForTryOns = if not FFlagAXCustomizeMakeupSupport then nil else t.callback,
	analytics = t.table,
	navigation = t.table,
	avatarRoute = if not FFlagAXCustomizeMakeupSupport then nil else t.table,
	focusController = t.optional(t.table),
	defaultChildRef = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback)
})

function v25.init(p1) -- line: 65
	-- upvalues: FFlagAXCustomizeMakeupSupport (copy), AvatarScreen (copy), LayeredMakeupSortUtils (copy), LayeredClothingSortUtils (copy), NavigationUtils (copy)
	function p1.resetToDefault() -- line: 66
		-- upvalues: p1 (copy), FFlagAXCustomizeMakeupSupport (copy), AvatarScreen (copy), LayeredMakeupSortUtils (copy), LayeredClothingSortUtils (copy)
		p1.props.sendAnalytics(p1.props.analytics.avatarRefineLayersResetConfirm)

		if FFlagAXCustomizeMakeupSupport and p1.props.avatarRoute.current.name == AvatarScreen.LayeredMakeupSort then
			local v35 = LayeredMakeupSortUtils.getEquippedAssetsBasedOnSortTable(p1.props.lastSavedSort, p1.props.equippedAssets, p1.props.tryOnItems, p1.props.removedList)
			local v36 = LayeredMakeupSortUtils.getTryOnItemsOrderBasedOnSortTable(p1.props.lastSavedSort, p1.props.tryOnItems)

			p1.props.equipOutfit(v35)
			p1.props.setOrderForTryOns(v36)
		else
			local v37 = LayeredClothingSortUtils.formatForEquipOutfit(p1.props.lastSavedSort, p1.props.equippedAssets)

			p1.props.equipOutfit(v37)
		end

		p1.props.setCurrentSort(p1.props.lastSavedSort)
		p1.props.clearRemovedItems()
		p1.closePrompt()
	end
	function p1.closePrompt() -- line: 97
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v25.renderAlertLocalized(p2, p3) -- line: 102
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return Roact.createElement(InteractiveAlert, {
		title = p3.title,
		bodyText = p3.body,
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
						onActivated = p2.resetToDefault,
						text = p3.resetButtonText
					}
				}
			}
		},
		screenSize = p2.props.screenSize,
		defaultChildRef = p2.props.defaultChildRef
	})
end
function v25.render(p4) -- line: 129
	-- upvalues: withLocalization (copy)
	return withLocalization({
		title = "Feature.Avatar.Title.LCSortReset",
		body = "Feature.Avatar.Message.LCSortResetBody",
		cancelButtonText = "Feature.Catalog.Action.Cancel",
		resetButtonText = "CommonUI.Messages.Action.Reset"
	})(function(p5) -- line: 135
		-- upvalues: p4 (copy)
		return p4:renderAlertLocalized(p5)
	end)
end

local v26 = RoactRodux.connect(function(p6, _) -- line: 140
	-- upvalues: FFlagAXCustomizeMakeupSupport (copy)
	return {
		screenSize = p6.ScreenSize,
		equippedAssets = p6.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		tryOnItems = if not FFlagAXCustomizeMakeupSupport then nil else p6.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems,
		lastSavedSort = p6.AvatarExperience.LayeredClothingSort.LastSavedSort,
		removedList = if not FFlagAXCustomizeMakeupSupport then nil else p6.AvatarExperience.LayeredClothingSort.CurrentSort.RemovedList
	}
end, function(p8) -- line: 152
	-- upvalues: SetCurrentSort (copy), ClearRemovedItems (copy), EquipOutfit (copy), FFlagAXCustomizeMakeupSupport (copy), SetOrderForTryOns (copy), SendRefinementAnalytics (copy)
	return {
		setCurrentSort = function(p9) -- line: 154
			-- upvalues: p8 (copy), SetCurrentSort (copy)
			p8(SetCurrentSort(p9))
		end,
		clearRemovedItems = function() -- line: 157
			-- upvalues: p8 (copy), ClearRemovedItems (copy)
			p8(ClearRemovedItems())
		end,
		equipOutfit = function(p10) -- line: 160
			-- upvalues: p8 (copy), EquipOutfit (copy)
			p8(EquipOutfit(p10, false))
		end,
		setOrderForTryOns = if not FFlagAXCustomizeMakeupSupport then nil else function(p11) -- line: 164
			-- upvalues: p8 (copy), SetOrderForTryOns (copy)
			p8(SetOrderForTryOns(p11))
		end,
		sendAnalytics = function(p12) -- line: 168
			-- upvalues: p8 (copy), SendRefinementAnalytics (copy)
			p8(SendRefinementAnalytics(p12))
		end
	}
end)(v25)
local v27 = withMappedNavigationParams((withOverlayFocusHandling((RoactServices.connect({
	analytics = Analytics
})(v26)))))

if FFlagAXCustomizeMakeupSupport then
	v27 = withAvatarRoute(v27)
end

return v27
