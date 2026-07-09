local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local mutedError = require(Modules.LuaApp.mutedError)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetCategoryAndSubcategory)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local GoToCustomizeToEditPrompt = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Components.Prompts.GoToCustomizeToEditPrompt
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local GetAvatarEditorStructure = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorStructure)
local v21 = Roact.PureComponent:extend("LeaveCatalogToAvatarPrompt")
local FFlagAXFixBundleRedirectFromCatalogForSlots = require(Modules.AvatarExperience.Flags.FFlagAXFixBundleRedirectFromCatalogForSlots)
local FFlagAXFixEmoteRedirectFromCatalogForSlots = require(Modules.AvatarExperience.Flags.FFlagAXFixEmoteRedirectFromCatalogForSlots)
local FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters
local FFlagAXMISEnableMultiShopping = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping

function v21.init(p1) -- line: 47
	-- upvalues: FFlagAXFixEmoteRedirectFromCatalogForSlots (copy), Constants (copy), AvatarScreen (copy), NavigationUtils (copy), GetAvatarEditorStructure (copy), FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters (copy), FFlagAXFixBundleRedirectFromCatalogForSlots (copy), mutedError (copy)
	function p1.openAvatarPage() -- line: 48
		-- upvalues: p1 (copy), FFlagAXFixEmoteRedirectFromCatalogForSlots (copy), Constants (copy), AvatarScreen (copy), NavigationUtils (copy), GetAvatarEditorStructure (copy), FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters (copy), FFlagAXFixBundleRedirectFromCatalogForSlots (copy), mutedError (copy)
		local itemType = p1.props.itemType
		local itemSubType = p1.props.itemSubType
		local categoryOverride = nil
		local subcategoryOverride = nil
		local subcategoryFilter = nil

		if FFlagAXFixEmoteRedirectFromCatalogForSlots and itemSubType == Constants.AssetTypeIdStrings.EmoteAnimation then
			p1.props.navigation.navigate(AvatarScreen.AvatarEditor)
			NavigationUtils.navigateFromOverlay(p1.props.navigation, AvatarScreen.EditEmotes)

			return
		end

		if p1.props.categoryOverride then
			categoryOverride = p1.props.categoryOverride
			subcategoryOverride = p1.props.subcategoryOverride
		else
			local v40 = GetAvatarEditorStructure()

			if itemType == Constants.ItemType.Asset then
				local v41 = v40.AssetTypeToCategorySubcategory[itemSubType]

				if v41 then
					categoryOverride = v41.category
					subcategoryOverride = v41.subcategory

					if FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters then
						subcategoryFilter = v41.subcategoryFilter
					end
				end
			elseif itemType == Constants.ItemType.Bundle then
				if FFlagAXFixBundleRedirectFromCatalogForSlots then
					categoryOverride = v40.BundleToCategorySubcategory[itemSubType].category
					subcategoryOverride = v40.BundleToCategorySubcategory[itemSubType].subcategory

					if FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters then
						subcategoryFilter = v40.BundleToCategorySubcategory[itemSubType].subcategoryFilter
					end
				else
					categoryOverride = v40.BundleToCategorySubcategory.category
					subcategoryOverride = v40.BundleToCategorySubcategory.subcategory
				end
			end
		end

		local avatarAnalytics = p1.props.avatarAnalytics

		if categoryOverride == nil then
			mutedError("[AvatarExperience] No category for itemType: " .. tostring(itemType) .. " / " .. tostring(itemSubType))
		else
			p1.props.setCategoryAndSubcategory(categoryOverride, subcategoryOverride, avatarAnalytics, subcategoryFilter)
		end

		NavigationUtils.navigateFromOverlay(p1.props.navigation, AvatarScreen.AvatarEditor)
		p1.props.catalogAnalytics.clickCustomizeAvatarFromItemDetailPage()
	end
	function p1.closePrompt() -- line: 109
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v21.renderAlertLocalized(p2, p3) -- line: 114
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
						onActivated = p2.openAvatarPage,
						text = p3.confirmButtonText
					}
				}
			}
		},
		screenSize = p2.props.screenSize,
		defaultChildRef = p2.props.defaultChildRef
	})
end

if FFlagAXMISEnableMultiShopping then
	function v21.renderGoToCustomizePrompt(p4) -- line: 142
		-- upvalues: Roact (copy), GoToCustomizeToEditPrompt (copy)
		return Roact.createElement(GoToCustomizeToEditPrompt, {
			onConfirm = p4.openAvatarPage,
			navigation = p4.props.navigation
		})
	end
end

function v21.render(p5) -- line: 150
	-- upvalues: FFlagAXMISEnableMultiShopping (copy), withLocalization (copy)
	if FFlagAXMISEnableMultiShopping then
		return p5:renderGoToCustomizePrompt()
	end

	return withLocalization({
		titleText = "Feature.Catalog.Action.Customize",
		messageText = "Feature.Catalog.Label.MarketplaceToAvatarPage",
		confirmButtonText = "Feature.Catalog.Action.Customize",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(p6) -- line: 160
		-- upvalues: p5 (copy)
		return p5:renderAlertLocalized(p6)
	end)
end

local v26 = RoactRodux.connect(function(p7, _) -- line: 165
	return {
		screenSize = p7.ScreenSize
	}
end, function(p9) -- line: 169
	-- upvalues: SetCategoryAndSubcategory (copy)
	return {
		setCategoryAndSubcategory = function(p10, p11, p12, p13) -- line: 171
			-- upvalues: p9 (copy), SetCategoryAndSubcategory (copy)
			p9(SetCategoryAndSubcategory(p10, p11, p12, p13))
		end
	}
end)(v21)

return (withMappedNavigationParams((withOverlayFocusHandling((RoactServices.connect({
	avatarAnalytics = Analytics,
	catalogAnalytics = Analytics2
})(v26))))))
