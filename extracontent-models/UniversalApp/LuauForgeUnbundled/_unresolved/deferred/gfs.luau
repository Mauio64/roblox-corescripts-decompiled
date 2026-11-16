local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/dCn")

local module2 = require("@luauforge/bundled/geT")
local module3 = require("@luauforge/bundled/fvF")

local module4 = require("@luauforge/deferred/gfb")
local module5 = require("@luauforge/deferred/gfc")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module6 = require("@luauforge/bundled/dMx")
local module7 = require("@luauforge/deferred/gft")
local module8 = require("@luauforge/bundled/dTM")
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local goToCustomizeToEditPrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Prompts.GoToCustomizeToEditPrompt

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local module9 = require("@luauforge/bundled/dOi")

local extended = Roact.PureComponent:extend("LeaveCatalogToAvatarPrompt")

local module10 = require("@luauforge/bundled/dOu")

local module11 = require("@luauforge/deferred/gfu")
local fFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters

local module12 = require("@luauforge/deferred/gfv")

function extended:init()
	function self.openAvatarPage()
		local itemType = self.props.itemType
		local itemSubType = self.props.itemSubType
		local v5 = nil
		local v6 = nil
		local subcategoryFilter = nil

		if module11 and itemSubType == module6.AssetTypeIdStrings.EmoteAnimation then
			self.props.navigation.navigate(avatarScreen.AvatarEditor)
			module8.navigateFromOverlay(self.props.navigation, avatarScreen.EditEmotes)
		else
			if self.props.categoryOverride then
				v5 = self.props.categoryOverride
				v6 = self.props.subcategoryOverride
			else
				local v7 = module9()

				if itemType == module6.ItemType.Asset then
					local v8 = v7.AssetTypeToCategorySubcategory[itemSubType]

					if v8 then
						v5 = v8.category
						v6 = v8.subcategory

						if fFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters then
							subcategoryFilter = v8.subcategoryFilter
						end
					end
				elseif itemType == module6.ItemType.Bundle then
					if module10 then
						if
							v7.BundleToCategorySubcategory
							and v7.BundleToCategorySubcategory[itemSubType]
						then
							v5 = v7.BundleToCategorySubcategory[itemSubType].category
							v6 = v7.BundleToCategorySubcategory[itemSubType].subcategory

							if fFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters then
								subcategoryFilter = v7.BundleToCategorySubcategory[itemSubType].subcategoryFilter
							end
						end
					else
						v5 = v7.BundleToCategorySubcategory.category
						v6 = v7.BundleToCategorySubcategory.subcategory
					end
				end
			end

			local avatarAnalytics = self.props.avatarAnalytics

			if v5 == nil then
				module("[AvatarExperience] No category for itemType: " .. tostring(itemType) .. " / " .. tostring(itemSubType))
			else
				self.props.setCategoryAndSubcategory(v5, v6, avatarAnalytics, subcategoryFilter)
			end

			module8.navigateFromOverlay(self.props.navigation, avatarScreen.AvatarEditor)

			self.props.catalogAnalytics.clickCustomizeAvatarFromItemDetailPage()
		end
	end

	function self.closePrompt()
		module8.closeOverlay(self.props.navigation)
	end
end

function extended:renderAlertLocalized(props2)
	return Roact.createElement(interactiveAlert, {
		title = props2.titleText,
		bodyText = props2.messageText,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = self.closePrompt,
						text = props2.cancelButtonText
					},
					isDefaultChild = true
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = self.openAvatarPage,
						text = props2.confirmButtonText
					}
				}
			}
		},
		screenSize = self.props.screenSize,
		defaultChildRef = self.props.defaultChildRef
	})
end

function extended:renderGoToCustomizePrompt()
	return Roact.createElement(goToCustomizeToEditPrompt, {
		onConfirm = self.openAvatarPage,
		navigation = self.props.navigation
	})
end

function extended:render()
	return self:renderGoToCustomizePrompt()
end

local v5 = RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		setCategoryAndSubcategory = function(p2, p3, p4, p5)
			callback(module7(p2, p3, p4, p5))
		end
	}
end)(extended)

local v6 = roactServices.connect({
	avatarAnalytics = module2,
	catalogAnalytics = module3
})(v5)

if not module12 then
	return (module4((module5(v6))))
end

local v7 = module5(v6)
local function LeaveCatalogToAvatarPromptContainer(p2)
	if useIsSpatial() then
		return Roact.createElement(v7, p2)
	end

	return Roact.createElement(v6, p2)
end

return module4(LeaveCatalogToAvatarPromptContainer)
