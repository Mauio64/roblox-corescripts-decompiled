local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local selectEquippedAssets = AvatarExperienceCommon.State.Selectors.selectEquippedAssets
local selectTryOnItems = AvatarExperienceCommon.State.Selectors.selectTryOnItems

local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore

local module3 = require("@luauforge/bundled/dOz")

local function useCatalogPageRevertToLastEquippedStateHook()
	local v5 = useDispatch()
	local ref = React.useRef({})

	local v6 = useSelector(selectEquippedAssets, tutils.deepEqual)
	local v7 = useSelector(selectTryOnItems)

	React.useEffect(function()
		if
			avatarLastEquippedStateStore.getChangedLayeredMakeupSorting()
			and #Cryo.Dictionary.keys(v7) == 0
			and #Cryo.Dictionary.keys(ref.current) > 0
			and avatarLastEquippedStateStore.getShouldRevertLastEquippedState()
			and avatarLastEquippedStateStore.getAvatarLastEquippedState()
		then
			avatarLastEquippedStateStore.setChangedLayeredMakeupSorting(false)
			v5(module3(avatarLastEquippedStateStore.getAvatarLastEquippedState(), true))
		end

		if
			not avatarLastEquippedStateStore.getShouldRevertLastEquippedState()
			and #Cryo.Dictionary.keys(v7) == 0
			and #Cryo.Dictionary.keys(ref.current) > 0
		then
			avatarLastEquippedStateStore.setShouldRevertLastEquippedState(true)
			avatarLastEquippedStateStore.setChangedLayeredMakeupSorting(false)
		end
	end, { v6, v7, v5 })

	React.useEffect(function()
		if
			not avatarLastEquippedStateStore.getChangedLayeredMakeupSorting()
			and #Cryo.Dictionary.keys(v7) == 0
		then
			avatarLastEquippedStateStore.setAvatarLastEquippedState(v6)
		end
	end, { v6, v7 })

	React.useEffect(function()
		ref.current = v7
	end, { v7 })
end

return useCatalogPageRevertToLastEquippedStateHook
