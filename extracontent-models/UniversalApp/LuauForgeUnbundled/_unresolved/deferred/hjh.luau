local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/dPt")
local module3 = require("@luauforge/bundled/dKU")
local constants = AvatarExperienceCommon.Constants
local itemTypeEnum = module2.Enums.ItemTypeEnum
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local toggleTryOn = module3.Actions.ToggleTryOn
local module4 = require("@luauforge/bundled/fCd")
local module5 = require("@luauforge/bundled/fDf")
local module6 = require("@luauforge/bundled/egx")
local module7 = require("@luauforge/bundled/eie")

local module8 = require("@luauforge/deferred/hji")

local function selectDeviceOrientation(p2)
	return p2.DeviceOrientation
end

local function selectTryOnItems(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function ExpiredUserLookActionBarScreen()
	local v5 = useNavigation()
	local v6 = useDispatch()
	local v7 = module7(module5)
	local v8 = module7(module6)
	local v9 = useSelector(selectDeviceOrientation)
	local v10 = useSelector(selectTryOnItems)
	local v11 = v9 == deviceOrientationMode.Portrait

	local params = v5.state.params or {}
	local expiredItemCount = params.expiredItemCount or 0
	local expiredItems = params.expiredItems

	local v12 = React.useCallback(function()
		if expiredItems then
			for k, expiredItem in expiredItems do
				local tryOnItemReducerKey = getTryOnItemReducerKey(expiredItem.itemId, itemTypeEnum.Asset)

				if v10 and v10[tryOnItemReducerKey] then
					continue
				end

				v6(toggleTryOn(
					itemTypeEnum.Asset,
					expiredItem.itemSubType,
					expiredItem.itemId,
					true,
					expiredItem.order
				))

				v6(module4(v8, v7, expiredItem.itemId, itemTypeEnum.Asset))
			end
		end

		v5.navigate(avatarScreen.ExpiredUserLookCheckout)
	end, { v5, v6, expiredItems, v10, v7, v8 })

	if not (expiredItemCount > 0) then
		return nil
	end

	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v16 = if v11 then UDim2.fromScale(1, 1) else UDim2.fromScale(
		constants.LANDSCAPE_SCENE_WIDTH_PERCENTAGE,
		1
	)

	local v17 = if v11 then UDim2.fromScale(0, 0) else UDim2.fromScale(constants.LANDSCAPE_UI_WIDTH_PERCENTAGE, 0)
	return (createElement(view, { tag = "size-full gui-object-defaults", ZIndex = 4 }, {
		ActionBarInner = createElement2(
			view2,
			{ tag = "gui-object-defaults", Size = v16, Position = v17 },
			{
				ActionBar = React.createElement(module8, {
					expiredItemCount = expiredItemCount,
					onViewPressed = v12
				})
			}
		)
	}))
end

return require("@luauforge/deferred/gRz")(ExpiredUserLookActionBarScreen)
