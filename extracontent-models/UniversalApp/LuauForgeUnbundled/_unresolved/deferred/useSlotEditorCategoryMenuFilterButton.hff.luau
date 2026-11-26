local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Signals = require(CorePackages.Packages.Signals)
local module = require("@luauforge/bundled/fCn")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
require("@luauforge/deferred/gPt")

local module4 = require("@luauforge/bundled/eie")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module5 = require("@luauforge/deferred/heG")
local module6 = require("@luauforge/bundled/dXh")
local module7 = require("@luauforge/deferred/heH")

local module8 = require("@luauforge/deferred/haU")

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local iconName = Foundation.Enums.IconName
local iconVariant = Foundation.Enums.IconVariant

local fFlagAXAvatarEditorStoresContext = AvatarExperienceFlags.FFlagAXAvatarEditorStoresContext
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

local useSlotBasedEditorContext = module.Context.useSlotBasedEditorContext
local useAvatarEditorStores = module.Context.useAvatarEditorStores

local function useSlotEditorCategoryMenuFilterButton(p2)
	local v5 = useNavigation()
	local v6 = useAvatarRoute()
	local v7 = useDispatch()
	local v8 = module7()
	local v9 = module4(avatarExperienceAnalyticsService)

	local v10 = if module8() then useSlotBasedEditorContext() else nil

	local v11 = React.useMemo(function()
		return Signals.createSignal(0)
	end, {})
	local v12

	if module8() then
		if fFlagAXAvatarEditorStoresContext then
			v12 = useSignalState(useAvatarEditorStores().sortAndFiltersStore.getFiltersCount)
		else
			if v10 then
				v11 = v10.sortAndFiltersStore.getFiltersCount
			end

			v12 = useSignalState(v11)
		end
	else
		v12 = 0
	end

	local v13 = React.useCallback(function()
		if v6.current.name == avatarScreen.SortAndFilters then
			v8:fire()
		else
			module6.closeTryOnManager(v5)

			local navigate = v5.navigate
			local sortAndFilters = avatarScreen.SortAndFilters
			local v14 = {
				navigation = v5,
				catalogSort = "",
				isPortrait = true,
				onAcceptCallback = function() end,
				slotBasedEditorContext = 0
			}
			local v15 = if module8() then v10 else nil
			v14.slotBasedEditorContext = v15
			navigate(sortAndFilters, v14)
		end

		v7(module5(v9, v5.state.routeName))
	end, { v5, v6, v8, v10, v7, v9 })

	return React.useMemo(function()
		if not (p2 and module8()) then
			return nil
		end

		local v14 = {
			id = "filters",
			icon = iconName.ThreeSlidersHorizontal,
			onActivated = v13
		}

		if fFlagAXMigrateAllTabToSduiDev then
			v14.iconVariant = iconVariant.Regular
		end

		if v12 > 0 then
			v14.badgeCount = v12
		end

		return v14
	end, { p2, v13, v12 })
end

return useSlotEditorCategoryMenuFilterButton
