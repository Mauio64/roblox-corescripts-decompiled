local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)

local function useDispatchPendingCatalogDeepLink() -- line: 28
	-- upvalues: useDispatch (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), React (copy)
	local v8 = useDispatch()
	local v9 = GetCatalogCategoriesStore.getCatalogCategoriesStore()
	local v10 = useSignalState(v9.getHasFetchedCategories)
	local v11 = React.useRef(false)

	React.useEffect(function() -- line: 34
		-- upvalues: v9 (copy), v10 (copy), v11 (copy), v8 (copy)
		local getPendingDeepLinkAction = v9.getPendingDeepLinkAction
		local clearPendingDeepLinkAction = v9.clearPendingDeepLinkAction

		if not getPendingDeepLinkAction or not clearPendingDeepLinkAction then
			return
		end

		if v10 and not v11.current then
			local v14 = getPendingDeepLinkAction(false)

			if v14 then
				v11.current = true
				v8(v14)
				clearPendingDeepLinkAction()
			end
		end
	end, {
		v10,
		v9,
		v8
	})
end

return useDispatchPendingCatalogDeepLink
