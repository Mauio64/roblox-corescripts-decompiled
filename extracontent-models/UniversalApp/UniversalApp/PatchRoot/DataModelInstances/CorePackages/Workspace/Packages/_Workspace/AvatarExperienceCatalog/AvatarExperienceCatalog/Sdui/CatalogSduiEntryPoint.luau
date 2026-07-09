local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local useSignalState = require(AvatarExperienceCatalogParent.SignalsReact).useSignalState
local AvatarScreen = require(AvatarExperienceCatalogParent.AvatarExperienceNavigation).Enums.AvatarScreen
local SduiSharedUtilities = require(AvatarExperienceCatalogParent.SduiSharedUtilities)
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer

require(AvatarExperienceCatalogParent.Foundation)

local fetchCatalogPage = require(script.Parent.fetchCatalogPage)
local useComponentBreakpointSize = require(script.Parent.Hooks.useComponentBreakpointSize)
local getCatalogConfigKey = require(script.Parent.Utils.getCatalogConfigKey)
local CatalogSduiPageContext = require(script.Parent.CatalogSduiPageContext)
local GetCatalogPageRequestIdStore = require(AvatarExperienceCatalog.Stores.GetCatalogPageRequestIdStore)

local function CatalogSduiEntryPoint(t1: {[any]: any}, p1) -- line: 37
	-- upvalues: useComponentBreakpointSize (copy), React (copy), SduiLoadTimer (copy), AvatarScreen (copy), GetCatalogPageRequestIdStore (copy), useSignalState (copy), fetchCatalogPage (copy), CatalogSduiPageContext (copy), SduiFeatureEntryPoint (copy), getCatalogConfigKey (copy)
	local v17, v18 = useComponentBreakpointSize()
	local v19 = React.useMemo(function() -- line: 51
		-- upvalues: SduiLoadTimer (copy), AvatarScreen (copy)
		return SduiLoadTimer.createLoadTimer(AvatarScreen.Catalog)
	end, {})
	local v20 = if not t1.loadTimer then v19 else t1.loadTimer
	local v21 = if not t1.appPage then AvatarScreen.Catalog else t1.appPage
	local v22 = GetCatalogPageRequestIdStore(false)
	local v23 = useSignalState(v22.getPageRequestIdMap)[t1.identifier]
	local v24 = React.useMemo(function() -- line: 62
		-- upvalues: t1 (copy)
		return {
			identifier = t1.identifier
		}
	end, { t1.identifier })

	React.useEffect(function() -- line: 68
		-- upvalues: v22 (copy), t1 (copy), fetchCatalogPage (copy), v17 (copy), v20 (copy)
		local v26 = v22.getOrCreatePageRequestId(t1.identifier)

		fetchCatalogPage({
			requestId = v26,
			context = t1.context,
			screenSize = v17
		}, v20)
	end, {
		v20,
		v17,
		t1.context,
		t1.identifier,
		v23,
		v22
	})

	local v25 = React.useCallback(function() -- line: 79
		-- upvalues: v22 (copy), t1 (copy), fetchCatalogPage (copy), v17 (copy), v20 (copy)
		v22.resetPageRequestId(t1.identifier)

		local v27 = v22.getOrCreatePageRequestId(t1.identifier)

		fetchCatalogPage({
			requestId = v27,
			context = t1.context,
			screenSize = v17
		}, v20, {
			forceRefresh = true
		})
	end, {
		v20,
		v17,
		t1.context,
		t1.identifier,
		v22
	})

	return React.createElement(CatalogSduiPageContext.Provider, {
		value = v24
	}, React.createElement(SduiFeatureEntryPoint, {
		configKey = getCatalogConfigKey(t1.context, v17),
		identifier = t1.identifier,
		appPage = v21,
		loadTimer = v20,
		Size = t1.Size,
		AutomaticSize = t1.AutomaticSize,
		Position = t1.Position,
		onAbsoluteSizeChange = v18,
		onRetry = v25,
		shouldDisplayLoading = t1.shouldDisplayLoading,
		shouldDisplayError = t1.shouldDisplayError,
		loadingSlot = t1.loadingSlot,
		errorSlot = t1.errorSlot,
		ref = p1
	}))
end

return React.forwardRef(CatalogSduiEntryPoint)
