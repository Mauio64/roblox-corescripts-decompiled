local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useCallback = React.useCallback
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Categories = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Constants.Categories
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local FFlagAXCustomizeMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCustomizeMakeupSupport
local t1 = {
	[Categories.Animations] = {
		title = "Feature.Avatar.Title.ClearAnimationsConfirmation",
		message = "Feature.Avatar.Message.ClearAnimations"
	},
	[Categories.Accessories] = {
		title = "Feature.Avatar.Title.ClearAccessoriesConfirmation",
		message = "Feature.Avatar.Message.ClearAccessories"
	},
	[Categories.Body] = {
		title = "Feature.Avatar.Title.ClearBodyConfirmation",
		message = "Feature.Avatar.Message.ClearBody"
	},
	[Categories.Clothing] = {
		title = "Feature.Avatar.Title.ClearClothesConfirmation",
		message = "Feature.Avatar.Message.ClearClothes"
	},
	[Categories.Makeup] = if not FFlagAXCustomizeMakeupSupport then nil else {
		title = "Feature.Avatar.Title.ClearMakeupConfirmation",
		message = "Feature.Avatar.Message.ClearMakeupConfirmation"
	}
}

local function selectScreenSize(p1) -- line: 51
	return p1.ScreenSize
end
local function SlotEditorClearAllConfirmationPrompt(_: {[any]: any}) -- line: 55
	-- upvalues: useNavigation (copy), useSelector (copy), selectScreenSize (copy), useLocalization (copy), t1 (copy), useCallback (copy), NavigationUtils (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	local v20 = useNavigation()
	local v21 = useSelector(selectScreenSize)
	local v22 = v20.getParam("slotCategory")
	local v23 = v20.getParam("clearAll")
	local v24 = useLocalization({
		confirmationModalLeftButton = "Feature.Avatar.Action.Cancel",
		confirmationModalRightButton = "Feature.Avatar.Action.Clear",
		confirmationModalTitle = t1[v22].title,
		confirmationModalDescription = t1[v22].message
	})
	local v25 = useCallback(function() -- line: 68
		-- upvalues: NavigationUtils (copy), v20 (copy)
		NavigationUtils.closeFocusedScreen(v20)
	end, { v20 })

	return React.createElement(InteractiveAlert, {
		title = v24.confirmationModalTitle,
		bodyText = v24.confirmationModalDescription,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = v25,
						text = v24.confirmationModalLeftButton
					}
				},
				{
					buttonType = ButtonType.PrimaryContextual,
					props = {
						onActivated = function() -- line: 86
							-- upvalues: v23 (copy), v25 (copy)
							v23()
							v25()
						end,
						text = v24.confirmationModalRightButton
					}
				}
			}
		},
		screenSize = v21
	})
end

return (withOverlayFocusHandling(SlotEditorClearAllConfirmationPrompt))
