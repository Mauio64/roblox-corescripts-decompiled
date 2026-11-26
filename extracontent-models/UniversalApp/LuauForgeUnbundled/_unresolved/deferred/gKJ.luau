local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local SignalsExperimental = require(CorePackages.Packages.SignalsExperimental)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXUseSignalsForLayeredClothingCurrentSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingCurrentSort
local getLayeredClothingCurrentSortStore

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	getLayeredClothingCurrentSortStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Stores.getLayeredClothingCurrentSortStore
else
	getLayeredClothingCurrentSortStore = nil
end

local fFlagAXUseSignalsForLayeredClothingLastSavedSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingLastSavedSort
local getLayeredClothingLastSavedSortStore

if fFlagAXUseSignalsForLayeredClothingLastSavedSort then
	getLayeredClothingLastSavedSortStore = require("@luauforge/bundled/dPt").Stores.getLayeredClothingLastSavedSortStore
else
	getLayeredClothingLastSavedSortStore = nil
end

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local module2 = require("@luauforge/bundled/fAe")

local module3 = require("@luauforge/deferred/gJH")
local module4 = require("@luauforge/deferred/gJI")
local module5 = require("@luauforge/bundled/dXh")
local module6 = require("@luauforge/bundled/dRT")
local module7 = require("@luauforge/bundled/dRW")
local module8 = require("@luauforge/bundled/dWW")
local module9 = require("@luauforge/bundled/dWZ")
local module10 = require("@luauforge/bundled/dRP")
local setOrderForTryOns = require("@luauforge/bundled/dKU").Actions.SetOrderForTryOns
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module11 = require("@luauforge/deferred/gKK")
local module12 = require("@luauforge/deferred/gKL")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local extended = Roact.PureComponent:extend("ResetLayeredItemsSortPrompt")

local strictInterface = t.strictInterface
local v5 = {
	screenSize = t.Vector2,
	lastSavedSort = 0,
	equippedAssets = 0,
	tryOnItems = 0,
	removedList = 0,
	setCurrentSort = 0,
	equipOutfit = 0,
	clearRemovedItems = 0,
	sendAnalytics = 0,
	setOrderForTryOns = 0,
	analytics = 0,
	navigation = 0,
	avatarRoute = 0,
	focusController = 0,
	defaultChildRef = 0,
	onOverlayClosed = 0
}
local v6 = if fFlagAXUseSignalsForLayeredClothingLastSavedSort then t.optional(t.table) else t.table
v5.lastSavedSort = v6
v5.equippedAssets = t.optional(t.table)
v5.tryOnItems = t.optional(t.table)
v5.removedList = t.optional(t.table)

v5.setCurrentSort = t.callback
v5.equipOutfit = t.callback
v5.clearRemovedItems = t.callback
v5.sendAnalytics = t.callback
v5.setOrderForTryOns = t.callback

v5.analytics = t.table

v5.navigation = t.table

v5.avatarRoute = t.table

v5.focusController = t.optional(t.table)
v5.defaultChildRef = t.optional(t.table)
v5.onOverlayClosed = t.optional(t.callback)
extended.validateProps = strictInterface(v5)

function extended:init()
	function self.resetToDefault()
		self.props.sendAnalytics(self.props.analytics.avatarRefineLayersResetConfirm)
		local v7

		if fFlagAXUseSignalsForLayeredClothingCurrentSort then
			v7 = getLayeredClothingCurrentSortStore(false).getRemovedList(false)
		else
			v7 = self.props.removedList
		end

		local v8

		if fFlagAXUseSignalsForLayeredClothingLastSavedSort then
			v8 = getLayeredClothingLastSavedSortStore(false).getLastSavedSort(false)
		else
			v8 = self.props.lastSavedSort
		end

		if self.props.avatarRoute.current.name == avatarScreen.LayeredMakeupSort then
			local equippedAssetsBasedOnSortTable = module7.getEquippedAssetsBasedOnSortTable(
				v8,
				self.props.equippedAssets,
				self.props.tryOnItems,
				v7
			)

			local tryOnItemsOrderBasedOnSortTable = module7.getTryOnItemsOrderBasedOnSortTable(
				v8,
				self.props.tryOnItems
			)

			self.props.equipOutfit(equippedAssetsBasedOnSortTable)
			self.props.setOrderForTryOns(tryOnItemsOrderBasedOnSortTable)
		else
			local formatForEquipOutfit = module6.formatForEquipOutfit(v8, self.props.equippedAssets)
			self.props.equipOutfit(formatForEquipOutfit)
		end

		if fFlagAXUseSignalsForLayeredClothingCurrentSort then
			local layeredClothingCurrentSortStore = getLayeredClothingCurrentSortStore(false)
			SignalsExperimental.batch(function()
				layeredClothingCurrentSortStore.setCurrentSort(v8)
				layeredClothingCurrentSortStore.clearRemovedItems()
			end)
		else
			self.props.setCurrentSort(v8)
			self.props.clearRemovedItems()
		end

		self.closePrompt()
	end

	function self.closePrompt()
		module5.closeOverlay(self.props.navigation)
	end
end

function extended:renderAlertLocalized(props2)
	return Roact.createElement(interactiveAlert, {
		title = props2.title,
		bodyText = props2.body,
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
						onActivated = self.resetToDefault,
						text = props2.resetButtonText
					}
				}
			}
		},
		screenSize = self.props.screenSize,
		defaultChildRef = self.props.defaultChildRef
	})
end

function extended:render()
	return withLocalization({
		title = "Feature.Avatar.Title.LCSortReset",
		body = "Feature.Avatar.Message.LCSortResetBody",
		cancelButtonText = "Feature.Catalog.Action.Cancel",
		resetButtonText = "CommonUI.Messages.Action.Reset"
	})(function(p2)
		return self:renderAlertLocalized(p2)
	end)
end

local v7 = RoactRodux.connect(function(p2, p3)
	local v8 = {
		screenSize = p2.ScreenSize,
		equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems,
		lastSavedSort = 0,
		removedList = 0
	}

	local v9 = if not fFlagAXUseSignalsForLayeredClothingLastSavedSort then p2.AvatarExperience.LayeredClothingSort.LastSavedSort else nil
	v8.lastSavedSort = v9

	local v10 = if not fFlagAXUseSignalsForLayeredClothingCurrentSort then p2.AvatarExperience.LayeredClothingSort.CurrentSort.RemovedList else nil
	v8.removedList = v10
	return v8
end, function(callback)
	return {
		setCurrentSort = function(p2)
			if fFlagAXUseSignalsForLayeredClothingCurrentSort then
				getLayeredClothingCurrentSortStore(false).setCurrentSort(p2)
			else
				callback(module8(p2))
			end
		end,
		clearRemovedItems = function()
			if fFlagAXUseSignalsForLayeredClothingCurrentSort then
				getLayeredClothingCurrentSortStore(false).clearRemovedItems()
			else
				callback(module9())
			end
		end,
		equipOutfit = function(p2)
			callback(module10(p2, false))
		end,
		setOrderForTryOns = function(p2)
			callback(setOrderForTryOns(p2))
		end,
		sendAnalytics = function(p2)
			callback(module12(p2))
		end
	}
end)(extended)

return (module2((module3((module4((roactServices.connect({ analytics = module11 })(v7))))))))
