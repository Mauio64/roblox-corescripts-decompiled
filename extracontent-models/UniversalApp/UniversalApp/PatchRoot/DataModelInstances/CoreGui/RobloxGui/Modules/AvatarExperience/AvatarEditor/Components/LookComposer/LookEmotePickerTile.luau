local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local Cryo = require(CorePackages.Packages.Cryo)
local ItemTile = require(CorePackages.Packages.UIBlox).Tile.ItemTile
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local CatalogItemCard = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.CatalogItemCard.CatalogItemCard
local ItemCardThumbnail = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local UpdateLookDetails = require(Modules.AvatarExperience.Common.Actions.UpdateLookDetails)
local selectItemInfo = require(Modules.AvatarExperience.Common.Selectors.selectItemInfo)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

local function LookEmotePickerTile(t1: {[any]: any}) -- line: 34
	-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), useSelector (copy), selectItemInfo (copy), Constants2 (copy), useDispatch (copy), React (copy), Cryo (copy), UpdateLookDetails (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), CatalogItemCard (copy), ItemCardThumbnail (copy), Focusable (copy), ItemTile (copy)
	local v20 = getRbxthumbWithTypeSizeAndOptions(t1.itemId, Constants.RbxthumbTypes.Asset, 150)
	local v21 = useSelector(function(p1) -- line: 38
		-- upvalues: selectItemInfo (copy), t1 (copy), Constants2 (copy)
		local v27 = selectItemInfo(p1.AvatarExperience, t1.itemId, Constants2.ItemType.Asset)

		if v27 then
			return v27.name
		end

		return nil
	end)
	local v22 = useSelector(function(p2) -- line: 43
		-- upvalues: Constants2 (copy)
		return p2.AvatarExperience.AvatarScene.Looks[Constants2.DraftLookId]
	end)
	local v23 = useDispatch()
	local v24 = v22 and v22.displayProperties.emoteAssetId == t1.itemId
	local v25 = React.useCallback(function() -- line: 51
		-- upvalues: v22 (copy), Cryo (copy), v24 (copy), t1 (copy), v23 (copy), UpdateLookDetails (copy), Constants2 (copy)
		local displayProperties = v22.displayProperties
		local v30 = Cryo.Dictionary.join(displayProperties, {
			emoteAssetId = if not v24 then t1.itemId else Cryo.None
		})

		v23(UpdateLookDetails(Constants2.DraftLookId, {
			displayProperties = v30
		}))
	end, {
		v22,
		v23,
		t1.itemId,
		v24
	})

	if FFlagAXMigrateAXToGlobalAutofocus then
		return React.createElement(CatalogItemCard, {
			onActivated = v25,
			presentationSlot = if not v20 then nil else React.createElement(ItemCardThumbnail, {
				url = v20
			}),
			title = v21,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			isSelected = v24
		})
	end

	return React.createElement(Focusable[ItemTile], {
		thumbnail = v20,
		name = v21,
		isSelected = v24,
		onActivated = v25
	})
end

return LookEmotePickerTile
