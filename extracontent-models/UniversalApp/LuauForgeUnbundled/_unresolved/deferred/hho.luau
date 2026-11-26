local CorePackages = game:GetService("CorePackages")

local NotificationService = game:GetService("NotificationService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")

local module2 = require("@luauforge/bundled/fCe")
local module3 = require("@luauforge/bundled/dPN")
local module4 = require("@luauforge/bundled/fIl")
local GetGameName = require("@game/CoreGui/RobloxGui/Modules/AvatarEditorPrompts/Thunks/GetGameName")
local module6 = require("@luauforge/bundled/fwS")
require("@luauforge/bundled/dKT")

local images = UIBlox.App.ImageSet.Images
local module7 = require("@luauforge/deferred/hhm")
local module8 = require("@luauforge/bundled/dAB")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local t = require(CorePackages.Packages.t)

local module9 = require("@luauforge/bundled/gZQ")
local module10 = require("@luauforge/bundled/ciE")
local constants = module10.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module10.Utils.getRbxthumbWithTypeSizeAndOptions

require("@luauforge/bundled/dXi")

require(CorePackages.Packages.LuauPolyfill)

local asset = constants.RbxthumbTypes.Asset

local bundleThumbnail = constants.RbxthumbTypes.BundleThumbnail

local iconsmenushop_large = images["icons/menu/shop_large"]

local module11 = require("@luauforge/deferred/hhp")

local extended = Roact.PureComponent:extend("CatalogPageButton")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXFixCatalogPageButtonSduiCrash = AvatarExperienceFlags.FFlagAXFixCatalogPageButtonSduiCrash

local module13 = require("@luauforge/bundled/dSW")

local strictInterface = t.strictInterface
local v5 = {
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
	externalNavigationRequest = 0,
	setSearchParameters = 0,
	fetchCatalogData = 0
}
local v6 = if module11() then t.optional(t.table) else nil
v5.externalNavigationRequest = v6

v5.setSearchParameters = t.callback
v5.fetchCatalogData = t.callback
extended.validateProps = strictInterface(v5)

extended.defaultProps = { transparencyModifier = 0 }

local vector2 = Vector2.new(0, 0)

function extended:init()
	self.state = {
		style = string.lower(NotificationService.SelectedTheme)
	}

	function self.fetchInitialCatalogItems()
		local networking = self.props.networking

		if not fFlagAXFixCatalogPageButtonSduiCrash then
			module2.getCatalogCategoryInfo(1, 0)
		end

		local v7

		if fFlagAXMigrateAllTabToSduiDev then
			local defaultCatalogCategoryId = module3.DefaultCatalogCategoryId

			v7 = module13.getCatalogCategoriesStore().getCategoriesMap(false)[defaultCatalogCategoryId]
				or module2.getCatalogCategoryInfoById(defaultCatalogCategoryId, nil)

			if v7 == nil then
				return nil
			end
		else
			local defaultCatalogCategoryId = module3.DefaultCatalogCategoryId

			v7 = module2.getCatalogCategoryInfoById(defaultCatalogCategoryId, nil)
		end

		assert(v7 ~= nil, "categoryInfo is not nil. Silence type checker")

		local v8 = { searchUuid = v7.SearchUuid, categoryInfo = v7 }

		self.props.setSearchParameters(v8.searchUuid, v8)
		return self.props.fetchCatalogData(networking, v8)
	end
end

function extended.render(p2)
	local catalogItem = p2.props.catalogItem
	local style = p2.state.style
	local transparencyModifier = p2.props.transparencyModifier
	local nextSelectionLeft = p2.props.NextSelectionLeft
	local nextSelectionRight = p2.props.NextSelectionRight
	local nextSelectionUp = p2.props.NextSelectionUp
	local nextSelectionDown = p2.props.NextSelectionDown

	local v7 = style == "dark" and "rbxasset://textures/AvatarEditorImages/Catalog.png"
		or "rbxasset://textures/AvatarEditorImages/Catalog_LightTheme.png"
	local v8, v9

	if catalogItem then
		if catalogItem.type == module3.ItemType.Bundle then
			v8 = getRbxthumbWithTypeSizeAndOptions(catalogItem.id, bundleThumbnail, 420)
		else
			v8 = getRbxthumbWithTypeSizeAndOptions(catalogItem.id, asset, 420)
		end
	else
		v8 = nil
	end

	v9 = 420
	local forwardRef = p2.props.forwardRef

	return withLocalization({ catalogText = "Feature.Avatar.Action.Marketplace" })(function(p3)
		return Roact.createElement(module7, {
			Size = UDim2.new(1, 0, 1, 0),
			backgroundImage = v7,
			thumbnailImage = v8,
			thumbnailSize = v9,
			thumbnailScaleOffset = vector2,
			icon = iconsmenushop_large,
			text = p3.catalogText,
			transparencyModifier = transparencyModifier,
			NextSelectionLeft = nextSelectionLeft,
			NextSelectionRight = nextSelectionRight,
			NextSelectionUp = nextSelectionUp,
			NextSelectionDown = nextSelectionDown,
			[Roact.Ref] = forwardRef,
			onActivated = p2.props.onActivated
		})
	end)
end

function extended:checkFetchSortData()
	if module11() and module4.catalogDeepLinkExists(self.props.externalNavigationRequest) then
		return
	end

	local v7 = self.props.dataStatus == module8.NotStarted

	if self.props.catalogItem == nil and v7 then
		self.fetchInitialCatalogItems()
	end
end

function extended:didUpdate()
	self:checkFetchSortData()
end

function extended:didMount()
	self.themeChangedConn = NotificationService:GetPropertyChangedSignal("SelectedTheme"):Connect(function()
		self:setState({
			style = string.lower(NotificationService.SelectedTheme)
		})
	end)

	self:checkFetchSortData()
end

function extended:willUnmount()
	if self.themeChangedConn then
		self.themeChangedConn:Disconnect()
		self.themeChangedConn = nil
	end
end

local function mapStateToProps(p2)
	local v7

	if fFlagAXMigrateAllTabToSduiDev then
		local defaultCatalogCategoryId = module3.DefaultCatalogCategoryId

		v7 = module13.getCatalogCategoriesStore().getCategoriesMap(false)[defaultCatalogCategoryId]
			or module2.getCatalogCategoryInfoById(defaultCatalogCategoryId, nil)
	else
		v7 = module2.getCatalogCategoryInfo(1, 0)
	end

	local v8 = not module11() and {} or p2.AvatarExperience.ExternalNavigationRequest

	if fFlagAXMigrateAllTabToSduiDev and v7 == nil then
		local v9 = {
			catalogItem = nil,
			dataStatus = module8.NotStarted,
			externalNavigationRequest = 0
		}

		if not module11() then
			v8 = nil
		end

		v9.externalNavigationRequest = v8
		return v9
	else
		local searchUuid = v7.SearchUuid
		assert(searchUuid ~= nil, "searchUuid is not nil. Silence type checker")
		local v9 = p2.Search.SearchesInCatalog[searchUuid] or {}
		local items = v9 and v9.items or {}
		local searchKey = module2.getSearchKey(p2, searchUuid)

		local v10 = {
			catalogItem = items[1],
			dataStatus = performFetch.GetStatus(p2, searchKey),
			externalNavigationRequest = 0
		}

		if not module11() then
			v8 = nil
		end

		v10.externalNavigationRequest = v8
		return v10
	end
end

local function mapDispatchToProps(callback)
	return {
		fetchCatalogData = function(p2, p3)
			return callback(GetGameName(module9(p2, p3)))
		end,
		setSearchParameters = function(p2, p3)
			return callback(module6(p2, p3))
		end
	}
end

local v7 = roactServices.connect({ networking = module })(extended)

local v8 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v7)

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v8, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
