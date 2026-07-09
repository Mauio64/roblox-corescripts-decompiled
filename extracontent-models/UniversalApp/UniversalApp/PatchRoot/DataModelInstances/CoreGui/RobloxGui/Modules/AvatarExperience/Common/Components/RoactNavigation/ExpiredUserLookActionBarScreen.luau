local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local Constants = AvatarExperienceCommon.Constants
local ItemTypeEnum = AvatarExperienceCommon.Enums.ItemTypeEnum
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local ToggleTryOn = AvatarExperienceRodux.Actions.ToggleTryOn
local RemoveFromTryOn = AvatarExperienceRodux.Actions.RemoveFromTryOn
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local ActionBarWithExpiredTimedOptions = require(Modules.AvatarExperience.Catalog.Components.ActionBar.ActionBarWithExpiredTimedOptions)

local function selectDeviceOrientation(p1) -- line: 39
	return p1.DeviceOrientation
end
local function selectTryOnItems(p2) -- line: 43
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end
local function ExpiredUserLookActionBarScreen() -- line: 47
	-- upvalues: useNavigation (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), RoactNetworking (copy), useSelector (copy), selectDeviceOrientation (copy), selectTryOnItems (copy), DeviceOrientationMode (copy), React (copy), RemoveFromTryOn (copy), ItemTypeEnum (copy), getTryOnItemReducerKey (copy), ToggleTryOn (copy), FetchAssetOrBundleInfo (copy), AvatarScreen (copy), Foundation (copy), Constants (copy), ActionBarWithExpiredTimedOptions (copy)
	local v28 = useNavigation()
	local v29 = useDispatch()
	local v30 = useRoactService(Analytics)
	local v31 = useRoactService(RoactNetworking)
	local v32 = useSelector(selectDeviceOrientation)
	local v33 = useSelector(selectTryOnItems)
	local v34 = v32 == DeviceOrientationMode.Portrait
	local v35 = v28.state.params or {}
	local v36 = v35.expiredItemCount or 0
	local expiredItems = v35.expiredItems
	local v38 = React.useRef(expiredItems)

	v38.current = expiredItems

	local v39 = React.useRef(v29)

	v39.current = v29
	React.useEffect(function() -- line: 68
		-- upvalues: v38 (copy), v39 (copy), RemoveFromTryOn (copy), ItemTypeEnum (copy)
		return function() -- line: 69
			-- upvalues: v38 (copy), v39 (copy), RemoveFromTryOn (copy), ItemTypeEnum (copy)
			local current = v38.current

			if not current then
				return
			end

			for _, v46 in current do
				v39.current(RemoveFromTryOn(v46.itemId, ItemTypeEnum.Asset))
			end
		end
	end, {})

	local v40 = React.useCallback(function() -- line: 80
		-- upvalues: expiredItems (copy), getTryOnItemReducerKey (copy), ItemTypeEnum (copy), v33 (copy), v29 (copy), ToggleTryOn (copy), FetchAssetOrBundleInfo (copy), v31 (copy), v30 (copy), v28 (copy), AvatarScreen (copy)
		if expiredItems then
			for _, v42 in expiredItems do
				local v43 = getTryOnItemReducerKey(v42.itemId, ItemTypeEnum.Asset)

				if not v33 or not v33[v43] then
					v29(ToggleTryOn(ItemTypeEnum.Asset, v42.itemSubType, v42.itemId, true, v42.order))
					v29(FetchAssetOrBundleInfo(v31, v30, v42.itemId, ItemTypeEnum.Asset))
				end
			end
		end

		v28.navigate(AvatarScreen.ExpiredUserLookCheckout)
	end, {
		v28,
		v29,
		expiredItems,
		v33,
		v30,
		v31
	})

	if v36 > 0 then
		return (React.createElement(Foundation.View, {
			tag = "size-full gui-object-defaults",
			ZIndex = 4
		}, {
			ActionBarInner = React.createElement(Foundation.View, {
				tag = "gui-object-defaults",
				Size = if not v34 then UDim2.fromScale(Constants.LANDSCAPE_SCENE_WIDTH_PERCENTAGE, 1) else UDim2.fromScale(1, 1),
				Position = if not v34 then UDim2.fromScale(Constants.LANDSCAPE_UI_WIDTH_PERCENTAGE, 0) else UDim2.fromScale(0, 0)
			}, {
				ActionBar = React.createElement(ActionBarWithExpiredTimedOptions, {
					expiredItemCount = v36,
					onViewPressed = v40
				})
			})
		}))
	end

	return nil
end

return require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)(ExpiredUserLookActionBarScreen)
