local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local NotificationService = game:GetService("NotificationService")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local DeepLinkUtils = require(Modules.AvatarExperience.Common.DeepLinkUtils)
local FetchDataWithErrorToasts = require(Modules.LuaApp.Thunks.FetchDataWithErrorToasts)
local SetSearchParameters = require(Modules.LuaApp.Actions.SetSearchParameters)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Images = UIBlox.App.ImageSet.Images
local PageButton = require(Modules.AvatarExperience.Common.Components.Landing.PageButton)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local t = require(CorePackages.Packages.t)
local FetchCatalogSearchWithSponsoredItems = require(Modules.AvatarExperience.Catalog.Thunks.FetchCatalogSearchWithSponsoredItems)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants2 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

require(Modules.AvatarExperience.Catalog.SearchTypes)
require(CorePackages.Packages.LuauPolyfill)

local Asset = Constants2.RbxthumbTypes.Asset
local BundleThumbnail = Constants2.RbxthumbTypes.BundleThumbnail
local v28 = Images["icons/menu/shop_large"]
local GetFFlagAXDisableCatalogFetchOnDeepLinkForConsole = require(Modules.AvatarExperience.Flags.GetFFlagAXDisableCatalogFetchOnDeepLinkForConsole)
local v30 = Roact.PureComponent:extend("CatalogPageButton")
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local FFlagAXFixCatalogPageButtonSduiCrash = AvatarExperienceFlags.FFlagAXFixCatalogPageButtonSduiCrash
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)

v30.validateProps = t.strictInterface({
	transparencyModifier = t.number,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	onActivated = t.callback,
	networking = t.callback,
	forwardRef = t.optional(t.table),
	catalogItem = t.optional(t.table),
	dataStatus = t.string,
	externalNavigationRequest = if not GetFFlagAXDisableCatalogFetchOnDeepLinkForConsole() then nil else t.optional(t.table),
	setSearchParameters = t.callback,
	fetchCatalogData = t.callback
})
v30.defaultProps = {
	transparencyModifier = 0
}

local vector2 = Vector2.new(0, 0)

function v30.init(p1) -- line: 93
	-- upvalues: NotificationService (copy), FFlagAXFixCatalogPageButtonSduiCrash (copy), Utils (copy), FFlagAXMigrateAllTabToSduiDev (copy), Constants (copy), GetCatalogCategoriesStore (copy)
	p1.state = {
		style = string.lower(NotificationService.SelectedTheme)
	}

	function p1.fetchInitialCatalogItems() -- line: 98
		-- upvalues: p1 (copy), FFlagAXFixCatalogPageButtonSduiCrash (copy), Utils (copy), FFlagAXMigrateAllTabToSduiDev (copy), Constants (copy), GetCatalogCategoriesStore (copy)
		local networking = p1.props.networking

		if not FFlagAXFixCatalogPageButtonSduiCrash then
			Utils.getCatalogCategoryInfo(1, 0)
		end

		local v73

		if FFlagAXMigrateAllTabToSduiDev then
			local DefaultCatalogCategoryId = Constants.DefaultCatalogCategoryId

			v73 = GetCatalogCategoriesStore.getCatalogCategoriesStore().getCategoriesMap(false)[DefaultCatalogCategoryId] or Utils.getCatalogCategoryInfoById(DefaultCatalogCategoryId, nil)
		else
			local DefaultCatalogCategoryId = Constants.DefaultCatalogCategoryId

			v73 = Utils.getCatalogCategoryInfoById(DefaultCatalogCategoryId, nil)
		end

		local t1 = {
			searchUuid = v73.SearchUuid,
			categoryInfo = v73
		}

		p1.props.setSearchParameters(t1.searchUuid, t1)

		return p1.props.fetchCatalogData(networking, t1)
	end
end
function v30.render(p2) -- line: 141
	-- upvalues: Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), BundleThumbnail (copy), Asset (copy), withLocalization (copy), Roact (copy), PageButton (copy), vector2 (copy), v28 (copy)
	local catalogItem = p2.props.catalogItem
	local style = p2.state.style
	local transparencyModifier = p2.props.transparencyModifier
	local NextSelectionLeft = p2.props.NextSelectionLeft
	local NextSelectionRight = p2.props.NextSelectionRight
	local NextSelectionUp = p2.props.NextSelectionUp
	local NextSelectionDown = p2.props.NextSelectionDown
	local s1 = "rbxasset://textures/AvatarEditorImages/Catalog_LightTheme.png"

	if style == "dark" then
		s1 = "rbxasset://textures/AvatarEditorImages/Catalog.png"
	end

	local u50 = nil
	local n1 = 420

	if catalogItem then
		if catalogItem.type == Constants.ItemType.Bundle then
			u50 = getRbxthumbWithTypeSizeAndOptions(catalogItem.id, BundleThumbnail, 420)
			n1 = 420
		else
			u50 = getRbxthumbWithTypeSizeAndOptions(catalogItem.id, Asset, 420)
			n1 = 420
		end
	end

	local forwardRef = p2.props.forwardRef

	return withLocalization({
		catalogText = "Feature.Avatar.Action.Marketplace"
	})(function(p3) -- line: 179
		-- upvalues: Roact (copy), PageButton (copy), s1 (ref), u50 (ref), n1 (ref), vector2 (copy), v28 (copy), transparencyModifier (copy), NextSelectionLeft (copy), NextSelectionRight (copy), NextSelectionUp (copy), NextSelectionDown (copy), forwardRef (copy), p2 (copy)
		return Roact.createElement(PageButton, {
			Size = UDim2.new(1, 0, 1, 0),
			backgroundImage = s1,
			thumbnailImage = u50,
			thumbnailSize = n1,
			thumbnailScaleOffset = vector2,
			icon = v28,
			text = p3.catalogText,
			transparencyModifier = transparencyModifier,
			NextSelectionLeft = NextSelectionLeft,
			NextSelectionRight = NextSelectionRight,
			NextSelectionUp = NextSelectionUp,
			NextSelectionDown = NextSelectionDown,
			[Roact.Ref] = forwardRef,
			onActivated = p2.props.onActivated
		})
	end)
end
function v30.checkFetchSortData(p4) -- line: 202
	-- upvalues: GetFFlagAXDisableCatalogFetchOnDeepLinkForConsole (copy), DeepLinkUtils (copy), RetrievalStatus (copy)
	if GetFFlagAXDisableCatalogFetchOnDeepLinkForConsole() and DeepLinkUtils.catalogDeepLinkExists(p4.props.externalNavigationRequest) then
		return
	end

	local v54 = p4.props.dataStatus == RetrievalStatus.NotStarted

	if p4.props.catalogItem == nil and v54 then
		p4.fetchInitialCatalogItems()
	end
end
function v30.didUpdate(p5) -- line: 224
	p5:checkFetchSortData()
end
function v30.didMount(p6) -- line: 228
	-- upvalues: NotificationService (copy)
	p6.themeChangedConn = NotificationService:GetPropertyChangedSignal("SelectedTheme"):Connect(function() -- line: 229
		-- upvalues: p6 (copy), NotificationService (copy)
		p6:setState({
			style = string.lower(NotificationService.SelectedTheme)
		})
	end)
	p6:checkFetchSortData()
end
function v30.willUnmount(p7) -- line: 238
	if p7.themeChangedConn then
		p7.themeChangedConn:Disconnect()
		p7.themeChangedConn = nil
	end
end

local function mapStateToProps(p8) -- line: 245
	-- upvalues: FFlagAXMigrateAllTabToSduiDev (copy), Constants (copy), GetCatalogCategoriesStore (copy), Utils (copy), PerformFetch (copy), GetFFlagAXDisableCatalogFetchOnDeepLinkForConsole (copy)
	local v60

	if FFlagAXMigrateAllTabToSduiDev then
		local DefaultCatalogCategoryId = Constants.DefaultCatalogCategoryId

		v60 = GetCatalogCategoriesStore.getCatalogCategoriesStore().getCategoriesMap(false)[DefaultCatalogCategoryId] or Utils.getCatalogCategoryInfoById(DefaultCatalogCategoryId, nil)
	else
		v60 = Utils.getCatalogCategoryInfo(1, 0)
	end

	local SearchUuid = v60.SearchUuid

	assert(SearchUuid ~= nil, "searchUuid is not nil. Silence type checker")

	local v62 = p8.Search.SearchesInCatalog[SearchUuid] or {}
	local v63 = v62 and v62.items or {}
	local v64 = Utils.getSearchKey(p8, SearchUuid)
	local v65 = v63[1]
	local v66 = PerformFetch.GetStatus(p8, v64)
	local v67 = if not GetFFlagAXDisableCatalogFetchOnDeepLinkForConsole() then {} else p8.AvatarExperience.ExternalNavigationRequest

	return {
		catalogItem = v65,
		dataStatus = v66,
		externalNavigationRequest = if not GetFFlagAXDisableCatalogFetchOnDeepLinkForConsole() then nil else v67
	}
end
local function mapDispatchToProps(p9) -- line: 284
	-- upvalues: FetchDataWithErrorToasts (copy), FetchCatalogSearchWithSponsoredItems (copy), SetSearchParameters (copy)
	return {
		fetchCatalogData = function(p10: ((...any) -> ...any), p11) -- line: 286
			-- upvalues: p9 (copy), FetchDataWithErrorToasts (copy), FetchCatalogSearchWithSponsoredItems (copy)
			return p9(FetchDataWithErrorToasts(FetchCatalogSearchWithSponsoredItems(p10, p11)))
		end,
		setSearchParameters = function(p12, p13) -- line: 295
			-- upvalues: p9 (copy), SetSearchParameters (copy)
			return p9(SetSearchParameters(p12, p13))
		end
	}
end

local v38 = RoactServices.connect({
	networking = RoactNetworking
})(v30)
local u39 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v38)

return Roact.forwardRef(function(p14, p15) -- line: 307
	-- upvalues: Roact (copy), u39 (ref), Cryo (copy)
	return Roact.createElement(u39, Cryo.Dictionary.join(p14, {
		forwardRef = p15
	}))
end)
