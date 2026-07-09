local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local NavOverlayScreenContainer = require(Modules.AvatarExperience.Common.Components.NavOverlayScreenContainer)
local OutfitSelectionGridContainer = require(Modules.AvatarExperience.AvatarEditor.Components.OutfitSelectionGrid.OutfitSelectionGridContainer)
local ManageActionBar = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.ManageActionBar)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local View = Foundation.View

local function ManageOutfitsPage(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), ButtonSize (copy), Button (copy), NavOverlayScreenContainer (copy), View (copy), OutfitSelectionGridContainer (copy), AvatarScreen (copy), ManageActionBar (copy)
	local v17 = React.useCallback(function() -- line: 43
		-- upvalues: React (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), ButtonSize (copy), t1 (copy)
		return React.createElement(IconButton, {
			icon = IconName.ChevronLargeLeft,
			variant = ButtonVariant.Utility,
			size = ButtonSize.Medium,
			onActivated = t1.onBackActivated
		})
	end, { t1.onBackActivated })
	local v18 = React.useCallback(function() -- line: 52
		-- upvalues: React (copy), Button (copy), t1 (copy), ButtonVariant (copy), ButtonSize (copy)
		return React.createElement(Button, {
			text = t1.selectActionText,
			variant = ButtonVariant.Link,
			size = ButtonSize.Medium,
			onActivated = t1.onSelectActivated
		})
	end, {
		t1.selectActionText,
		t1.onSelectActivated
	})

	return React.createElement(NavOverlayScreenContainer, {
		ZIndex = 1,
		headerBarProps = {
			title = t1.titleText,
			renderLeft = v17,
			renderRight = v18
		}
	}, {
		Body = React.createElement(View, {
			tag = "fill size-full clip bg-surface-0",
			LayoutOrder = 1
		}, {
			OutfitSelectionGrid = React.createElement(OutfitSelectionGridContainer, {
				isEditable = true,
				outfitType = t1.outfitType,
				onToggleOutfitCard = t1.onToggleOutfitCard,
				selectedOutfits = t1.selectedOutfits,
				setSelectedOutfits = t1.setSelectedOutfits,
				setCanScroll = t1.setCanScroll,
				multiSelect = t1.multiSelect,
				goBack = t1.onBackActivated,
				pageOwner = AvatarScreen.ManageOutfitsPage,
				ref = t1.gridRef
			}),
			ManageActionBar = t1.multiSelect and React.createElement(ManageActionBar, {
				multiSelect = true,
				ZIndex = 2,
				gradientFade = t1.outfitGridCanScroll,
				selectedOutfits = t1.selectedOutfits,
				deleteOutfit = t1.deleteOutfit,
				renameOutfit = t1.renameOutfit,
				ref = t1.actionBarRef
			}) or nil
		})
	})
end

return ManageOutfitsPage
