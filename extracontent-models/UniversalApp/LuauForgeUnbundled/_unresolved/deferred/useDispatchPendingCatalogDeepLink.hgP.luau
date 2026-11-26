local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module = require("@luauforge/bundled/dSW")

local function useDispatchPendingCatalogDeepLink()
	local v5 = useDispatch()
	local catalogCategoriesStore = module.getCatalogCategoriesStore()
	local v6 = useSignalState(catalogCategoriesStore.getHasFetchedCategories)
	local ref = React.useRef(false)

	React.useEffect(function()
		local getPendingDeepLinkAction = catalogCategoriesStore.getPendingDeepLinkAction
		local clearPendingDeepLinkAction = catalogCategoriesStore.clearPendingDeepLinkAction

		if not (getPendingDeepLinkAction and clearPendingDeepLinkAction) then
			return
		end

		local v7 = v6 and not ref.current and getPendingDeepLinkAction(false)

		if v7 then
			ref.current = true
			v5(v7)
			clearPendingDeepLinkAction()
		end
	end, { v6, catalogCategoriesStore, v5 })
end

return useDispatchPendingCatalogDeepLink
