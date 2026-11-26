local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/ciE")
local constants = module.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module.Utils.getRbxthumbWithTypeSizeAndOptions
local catalogItemCard = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = require("@luauforge/deferred/gPt").ItemCardComponents.ItemCardThumbnail

local module2 = require("@luauforge/bundled/dPN")
local module3 = require("@luauforge/bundled/dPv")
local module4 = require("@luauforge/deferred/hjP")

local function LookEmotePickerTile(p2)
	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		p2.itemId,
		constants.RbxthumbTypes.Asset,
		150
	)

	local v5 = useSelector(function(p3)
		local v6 = module4(p3.AvatarExperience, p2.itemId, module2.ItemType.Asset)

		if v6 then
			return v6.name
		end

		return nil
	end)

	local v6 = useSelector(function(p3)
		return p3.AvatarExperience.AvatarScene.Looks[module2.DraftLookId]
	end)

	local v7 = useDispatch()

	local v8 = v6 and v6.displayProperties.emoteAssetId == p2.itemId

	local v9 = React.useCallback(function()
		local displayProperties = v6.displayProperties
		local join = Cryo.Dictionary.join
		local v11 = if v8 then Cryo.None else p2.itemId
		local v12 = join(displayProperties, { emoteAssetId = v11 })

		v7(module3(module2.DraftLookId, { displayProperties = v12 }))
	end, { v6, v7, p2.itemId, v8 })

	local createElement = React.createElement

	local v12 = if rbxthumbWithTypeSizeAndOptions then React.createElement(itemCardThumbnail, {
		url = rbxthumbWithTypeSizeAndOptions
	}) else nil
	return createElement(catalogItemCard, {
		onActivated = v9,
		presentationSlot = v12,
		title = v5,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		isSelected = v8
	})
end

return LookEmotePickerTile
