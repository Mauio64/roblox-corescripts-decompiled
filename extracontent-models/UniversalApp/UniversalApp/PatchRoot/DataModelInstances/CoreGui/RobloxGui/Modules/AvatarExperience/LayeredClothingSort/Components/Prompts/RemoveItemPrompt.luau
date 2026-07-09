local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.ToggleEquipAsset)
local SetCurrentSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetCurrentSort)
local AddRemovedItem = require(Modules.AvatarExperience.LayeredClothingSort.Actions.AddRemovedItem)
local v16 = Roact.PureComponent:extend("RemoveItemPrompt")

v16.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	equippedAssets = t.optional(t.table),
	currentSort = t.table,
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

function v16.init(p1) -- line: 52
	-- upvalues: NavigationUtils (copy)
	function p1.removeItem() -- line: 53
		-- upvalues: p1 (copy)
		local id = p1.props.asset.id
		local typeId = p1.props.asset.typeId

		if p1.props.equippedAssets and (p1.props.equippedAssets[typeId] and p1.props.equippedAssets[typeId][id]) then
			p1.props.toggleEquipAsset(typeId, id)
		end

		local t1 = {}

		for _, v28 in p1.props.currentSort do
			if id ~= v28.id then
				table.insert(t1, v28)
			end
		end

		p1.props.setCurrentSort(t1)
		p1.props.addRemovedItem(id, typeId)

		if p1.props.onUnequip then
			p1.props.onUnequip()
		end

		p1.closePrompt()
	end
	function p1.closePrompt() -- line: 85
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v16.renderAlertLocalized(p2, p3) -- line: 90
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
						text = p3.no
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p2.removeItem,
						text = p3.yes
					}
				}
			}
		},
		screenSize = p2.props.screenSize,
		defaultChildRef = p2.props.defaultChildRef
	})
end
function v16.render(p4) -- line: 117
	-- upvalues: withLocalization (copy)
	return withLocalization({
		no = "Feature.GameDetails.Label.No",
		yes = "Feature.GameDetails.Label.Yes",
		title = "Feature.Avatar.Title.LCSortUnequip",
		body = "Feature.Avatar.Message.LCSortUnequipBody"
	})(function(p5) -- line: 123
		-- upvalues: p4 (copy)
		return p4:renderAlertLocalized(p5)
	end)
end

return (withMappedNavigationParams((withOverlayFocusHandling((RoactRodux.connect(function(p6, _) -- line: 128
	return {
		screenSize = p6.ScreenSize,
		equippedAssets = p6.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		currentSort = p6.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList
	}
end, function(p8) -- line: 134
	-- upvalues: ToggleEquipAsset (copy), SetCurrentSort (copy), AddRemovedItem (copy)
	return {
		toggleEquipAsset = function(p9, p10) -- line: 136
			-- upvalues: p8 (copy), ToggleEquipAsset (copy)
			p8(ToggleEquipAsset(p9, p10))
		end,
		setCurrentSort = function(p11) -- line: 139
			-- upvalues: p8 (copy), SetCurrentSort (copy)
			p8(SetCurrentSort(p11))
		end,
		addRemovedItem = function(p12, p13) -- line: 142
			-- upvalues: p8 (copy), AddRemovedItem (copy)
			p8(AddRemovedItem(p12, p13))
		end
	}
end)(v16))))))
