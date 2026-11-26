local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/dPN")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local canGoBack = require("@game/CorePackages/Workspace/Packages/Navigation").canGoBack
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module2 = require("@luauforge/deferred/hbc")
local module3 = require("@luauforge/bundled/gJz")
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local fFlagAXModeratedItemsFlow = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXModeratedItemsFlow

local module4 = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module4.FocusNavigationEventNameEnum

require("@luauforge/deferred/hjr")

local updateOutfitsByButtonX = {
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.UpdateOutfit
}

local module5 = require("@luauforge/bundled/egx")

local v5 = {
	[module.OutfitTypes.Avatar] = {
		title = "Feature.Avatar.Heading.SelectToUpdate",
		updateButtonText = "Feature.Avatar.Action.Update"
	},
	[module.OutfitTypes.Makeup] = {
		title = "Feature.Avatar.Title.SelectMakeupLookForUpdate",
		updateButtonText = "Feature.Avatar.Action.UpdateMakeupLook"
	}
}

local function useUpdateOutfitPageProps()
	local v6 = useNavigation()
	local v7 = useDispatch()
	local v8 = useRoactService(module3)
	local v9 = if fFlagAXModeratedItemsFlow then useRoactService(module5) else nil
	local state, setState = React.useState({})

	local param = v6.getParam("outfitType")

	React.useEffect(function()
		if not param then
			mutedError("Outfit type is required")
		end
	end, { param })

	local v10 = param or module.OutfitTypes.Avatar

	local v11 = useLocalization(v5[v10])

	local ref = React.useRef(nil)

	local v12 = React.useCallback(function()
		if canGoBack(v6) then
			v6.goBack()
		end
	end, { v6 })

	local v13 = React.useCallback(function()
		if fFlagAXModeratedItemsFlow then
			v7(module2(v8, state[1], nil, nil, v9))
		else
			v7(module2(v8, state[1]))
		end

		v12()
	end, { state[1], v12, v8, v9, v7 })

	local v14 = ReactFocusNavigation.useEventMap(updateOutfitsByButtonX, nil)
	local v15 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.UpdateOutfit] = #state > 0 and {
				handler = InputHandlers.onRelease(function(p2)
					v13()
				end)
			} or nil
		}
	end, { state, v13 })
	return {
		outfitType = v10,
		localized = v11,
		onBackActivated = v12,
		onUpdateActivated = v13,
		selectedOutfits = state,
		setSelectedOutfits = setState,
		onToggleOutfitCard = function() end,
		gridRef = ref,
		focusNavigationRef = ReactFocusNavigation.useEventHandlerMap(v15, v14)
	}
end

return useUpdateOutfitPageProps
