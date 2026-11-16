local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local focusNavigationEventNameEnum = require("@luauforge/bundled/eeo").FocusNavigationEventNameEnum

local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local useIsDirectional = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Hooks.useIsDirectional

local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/fwb")
local module4 = require("@luauforge/bundled/dNA")
local module5 = require("@luauforge/bundled/dTM")
local module6 = require("@luauforge/bundled/gfm")

require("@luauforge/deferred/gnj")

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function fn(p2)
	return p2.AvatarExperience.AvatarEditor.OutfitInfos
end

local function useOutfitDetailsScreenProps(data)
	local outfitId = data.outfitId
	local navigation = data.navigation
	local avatarRoute = data.avatarRoute
	local onClose = data.onClose

	local v5 = useDispatch()

	local v6 = useIsSpatial()
	local v7 = useSelector(module6)

	local v8 = useSelector(fn)
	local v9 = if v8 then v8[outfitId] or nil else nil

	React.useEffect(function()
		v5(module3(outfitId))
	end, { v5, outfitId })

	React.useEffect(function()
		v5(module4(true))

		return function()
			if
				avatarRoute.current.name ~= avatarScreen.OutfitDetails
				or avatarRoute.current.key == navigation.state.key
			then
				v5(module4(false))
			end
		end
	end, { v5, avatarRoute, navigation.state.key })

	local v10 = React.useCallback(function()
		if onClose then
			onClose()
		end

		module5.closeFocusedScreen(navigation)
	end, { navigation, onClose })

	local v11 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2)
					p2.cancelled = true
					v10()
				end)
			}
		}
	end, { v10 })
	local v12 = ReactFocusNavigation.useEventMap(navigateBacks)
	local v13 = ReactFocusNavigation.useEventHandlerMap(v11, v12)

	local v14 = useIsDirectional()

	if v9 then
		v9 = v9.isEditable == true and not v14
	end

	local udim, udim2

	if v7 then
		udim = UDim2.fromScale(0, 0)
		udim2 = UDim2.fromScale(1, 1)
	elseif v6 then
		udim = UDim2.fromScale(0, 0)
		udim2 = UDim2.fromScale(1, 1)
	else
		udim = UDim2.new(module2.LandscapeNavWidth, 0, 0, 0)
		udim2 = UDim2.new(module2.LandscapeSceneWidth, 0, 1, 0)
	end

	return {
		outfitId = outfitId,
		isPortrait = v7,
		isSpatial = v6,
		showActionBar = v9 == true,
		onGoBack = v10,
		framePosition = udim,
		frameSize = udim2,
		panelRef = v13
	}
end

return useOutfitDetailsScreenProps
