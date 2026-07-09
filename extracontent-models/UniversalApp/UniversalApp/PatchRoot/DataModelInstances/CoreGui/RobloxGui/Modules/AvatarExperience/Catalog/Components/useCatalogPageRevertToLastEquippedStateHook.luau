local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local selectEquippedAssets = AvatarExperienceCommon.State.Selectors.selectEquippedAssets
local selectTryOnItems = AvatarExperienceCommon.State.Selectors.selectTryOnItems
local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local EquipOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.EquipOutfit)

local function useCatalogPageRevertToLastEquippedStateHook() -- line: 22
	-- upvalues: useDispatch (copy), React (copy), useSelector (copy), selectEquippedAssets (copy), tutils (copy), selectTryOnItems (copy), avatarLastEquippedStateStore (copy), Cryo (copy), EquipOutfit (copy)
	local v16 = useDispatch()
	local v17 = React.useRef({})
	local v18 = useSelector(selectEquippedAssets, tutils.deepEqual)
	local v19 = useSelector(selectTryOnItems)

	React.useEffect(function() -- line: 29
		-- upvalues: avatarLastEquippedStateStore (copy), Cryo (copy), v19 (copy), v17 (copy), v16 (copy), EquipOutfit (copy)
		if avatarLastEquippedStateStore.getChangedLayeredMakeupSorting() and (#Cryo.Dictionary.keys(v19) == 0 and #Cryo.Dictionary.keys(v17.current) > 0 and avatarLastEquippedStateStore.getShouldRevertLastEquippedState() and avatarLastEquippedStateStore.getAvatarLastEquippedState()) then
			avatarLastEquippedStateStore.setChangedLayeredMakeupSorting(false)
			v16(EquipOutfit(avatarLastEquippedStateStore.getAvatarLastEquippedState(), true))
		end

		if not avatarLastEquippedStateStore.getShouldRevertLastEquippedState() and #Cryo.Dictionary.keys(v19) == 0 and #Cryo.Dictionary.keys(v17.current) > 0 then
			avatarLastEquippedStateStore.setShouldRevertLastEquippedState(true)
			avatarLastEquippedStateStore.setChangedLayeredMakeupSorting(false)
		end
	end, {
		v18,
		v19,
		v16
	})
	React.useEffect(function() -- line: 53
		-- upvalues: avatarLastEquippedStateStore (copy), Cryo (copy), v19 (copy), v18 (copy)
		if not avatarLastEquippedStateStore.getChangedLayeredMakeupSorting() and #Cryo.Dictionary.keys(v19) == 0 then
			avatarLastEquippedStateStore.setAvatarLastEquippedState(v18)
		end
	end, {
		v18,
		v19
	})
	React.useEffect(function() -- line: 63
		-- upvalues: v17 (copy), v19 (copy)
		v17.current = v19
	end, { v19 })
end

return useCatalogPageRevertToLastEquippedStateHook
