local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local SignalsExperimental = require(CorePackages.Packages.SignalsExperimental)
local fFlagAXUseSignalsForLayeredClothingCurrentSort = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForLayeredClothingCurrentSort
local getLayeredClothingCurrentSortStore

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	getLayeredClothingCurrentSortStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Stores.getLayeredClothingCurrentSortStore
else
	getLayeredClothingCurrentSortStore = nil
end

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local module = require("@luauforge/deferred/gfb")
local module2 = require("@luauforge/deferred/gfc")
local module3 = require("@luauforge/bundled/dTM")
local module4 = require("@luauforge/bundled/dOy")
local module5 = require("@luauforge/bundled/dTB")
local module6 = require("@luauforge/bundled/dTD")

local extended = Roact.PureComponent:extend("RemoveItemPrompt")

local v5 = if fFlagAXUseSignalsForLayeredClothingCurrentSort then t.optional(t.table) else t.table

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	equippedAssets = t.optional(t.table),
	currentSort = v5,
	toggleEquipAsset = t.callback,
	setCurrentSort = t.callback,
	addRemovedItem = t.callback,
	asset = t.table,
	onUnequip = t.optional(t.callback),
	navigation = t.table,
	focusController = t.optional(t.table),
	defaultChildRef = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback)
})

function extended:init()
	function self.removeItem()
		local id = self.props.asset.id
		local typeId = self.props.asset.typeId

		if
			self.props.equippedAssets
			and self.props.equippedAssets[typeId]
			and self.props.equippedAssets[typeId][id]
		then
			self.props.toggleEquipAsset(typeId, id)
		end

		local v6

		if fFlagAXUseSignalsForLayeredClothingCurrentSort then
			v6 = getLayeredClothingCurrentSortStore(false).getOrderedList(false)
		else
			v6 = self.props.currentSort
		end

		local v7 = {}

		for k, v8 in v6 do
			if v8.id ~= id then
				table.insert(v7, v8)
			end
		end

		if fFlagAXUseSignalsForLayeredClothingCurrentSort then
			local layeredClothingCurrentSortStore = getLayeredClothingCurrentSortStore(false)
			SignalsExperimental.batch(function()
				layeredClothingCurrentSortStore.setCurrentSort(v7)
				layeredClothingCurrentSortStore.addRemovedItem(id, typeId)
			end)
		else
			self.props.setCurrentSort(v7)
			self.props.addRemovedItem(id, typeId)
		end

		if self.props.onUnequip then
			self.props.onUnequip()
		end

		self.closePrompt()
	end

	function self.closePrompt()
		module3.closeOverlay(self.props.navigation)
	end
end

function extended:renderAlertLocalized(props2)
	return Roact.createElement(interactiveAlert, {
		title = props2.title,
		bodyText = props2.body,
		buttonStackInfo = {
			buttons = {
				{
					props = { onActivated = self.closePrompt, text = props2.no },
					isDefaultChild = true
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = self.removeItem, text = props2.yes }
				}
			}
		},
		screenSize = self.props.screenSize,
		defaultChildRef = self.props.defaultChildRef
	})
end

function extended:render()
	return withLocalization({
		no = "Feature.GameDetails.Label.No",
		yes = "Feature.GameDetails.Label.Yes",
		title = "Feature.Avatar.Title.LCSortUnequip",
		body = "Feature.Avatar.Message.LCSortUnequipBody"
	})(function(p2)
		return self:renderAlertLocalized(p2)
	end)
end

return (module((module2((RoactRodux.connect(function(p2, p3)
	local v6 = {
		screenSize = p2.ScreenSize,
		equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		currentSort = 0
	}

	local v7 = if not fFlagAXUseSignalsForLayeredClothingCurrentSort then p2.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList else nil
	v6.currentSort = v7
	return v6
end, function(callback)
	return {
		toggleEquipAsset = function(p2, p3)
			callback(module4(p2, p3))
		end,
		setCurrentSort = function(p2)
			if fFlagAXUseSignalsForLayeredClothingCurrentSort then
				getLayeredClothingCurrentSortStore(false).setCurrentSort(p2)
			else
				callback(module5(p2))
			end
		end,
		addRemovedItem = function(p2, p3)
			if fFlagAXUseSignalsForLayeredClothingCurrentSort then
				getLayeredClothingCurrentSortStore(false).addRemovedItem(p2, p3)
			else
				callback(module6(p2, p3))
			end
		end
	}
end)(extended))))))
