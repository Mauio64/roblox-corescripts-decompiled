local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local MemStorageService = game:GetService("MemStorageService")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local SetPageFinished = require(Modules.AvatarExperience.AvatarEditor.Actions.SetPageFinished)
local getStaleInventoryGrantStore = AvatarExperienceSlotBasedEditor.Stores.getStaleInventoryGrantStore
local FFlagAXRefetchInventoryOnAssetGrant = AvatarExperienceFlags.FFlagAXRefetchInventoryOnAssetGrant

local function useRefetchStaleInventoryCategory(s1: string, p1, p2: ((...any) -> ...any)) -- line: 24
	-- upvalues: useDispatch (copy), getStaleInventoryGrantStore (copy), useSignalState (copy), React (copy), FFlagAXRefetchInventoryOnAssetGrant (copy), MemStorageService (copy), SetPageFinished (copy)
	local v17 = useDispatch()
	local v18 = getStaleInventoryGrantStore()
	local v19 = useSignalState(v18.getStaleSearchUuids)[s1] == true

	React.useEffect(function() -- line: 35
		-- upvalues: FFlagAXRefetchInventoryOnAssetGrant (copy), v19 (copy), p1 (copy), MemStorageService (copy), s1 (copy), v17 (copy), SetPageFinished (copy), p2 (copy)
		if not FFlagAXRefetchInventoryOnAssetGrant or not v19 then
			return
		end

		if p1 then
			p1.startNewSearch()
		end

		MemStorageService:SetItem(s1, "")
		v17(SetPageFinished(s1, false))
		p2()
	end, {
		v19,
		s1,
		p1,
		p2,
		v17
	})
end

return useRefetchStaleInventoryCategory
