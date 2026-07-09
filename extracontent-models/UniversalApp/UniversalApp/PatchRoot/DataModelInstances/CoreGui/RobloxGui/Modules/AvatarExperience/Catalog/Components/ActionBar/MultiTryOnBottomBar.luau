local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local withStyle = UIBlox.Core.Style.withStyle
local Modules = CoreGui.RobloxGui.Modules
local BuyActionBar = require(Modules.AvatarExperience.Catalog.Components.ActionBar.BuyActionBar)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.LuaApp.Constants)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local ItemDataValidator = require(Modules.AvatarExperience.Common.Validators.ItemDataValidator)

require(Modules.AvatarExperience.Common.Types)

local Display = require(CorePackages.Workspace.Packages.Display)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local AXShareButtonOnActionBarIXP = require(Modules.AvatarExperience.Experiments.AXShareButtonOnActionBarIXP)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AXRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local v34 = game:DefineFastFlag("BuyActionBarShouldNotUnrenderInFullscreenMode", false)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagStackedBottomNavMarketplaceCTA = require(CorePackages.Workspace.Packages.SharedFlags).FFlagStackedBottomNavMarketplaceCTA
local ActionBarHeight = CatalogConstants.ActionBar.ActionBarHeight
local n1 = nil
local n2 = nil

if FFlagAXMISEnableMultiShopping then
	n1 = 16
	n2 = 20
end

local v40 = Roact.PureComponent:extend("MultiTryOnBottomBar")

v40.validateProps = t.strictInterface({
	bottomBarRef = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	Visible = t.optional(t.boolean),
	isConsoleWithGamepad = t.optional(t.boolean),
	itemDetailsPeekViewRefs = t.optional(t.table),
	onAbsoluteSizeChanged = if not FFlagAXMISEnableMultiShopping then nil else t.optional(t.callback),
	footerVisibilityBinding = if not FFlagStackedBottomNavMarketplaceCTA then nil else t.optional(t.table),
	lastToggledItem = t.table,
	isPortrait = t.boolean,
	tryOnItems = t.optional(t.table),
	itemData = t.optional(ItemDataValidator),
	itemId = t.optional(t.string),
	itemType = t.optional(t.string),
	boundInputs = t.optional(t.table),
	currentTryOnItem = if not FFlagAXDurablesForMIS then nil else t.optional(t.table),
	fetchItemData = t.callback,
	networking = t.callback,
	appAnalytics = t.table,
	catalogAnalytics = t.table,
	localization = t.table,
	navigation = t.table,
	deviceSafePadding = if not FFlagEnableLeftNavOnConsole then nil else t.table
})
v40.defaultProps = {
	Visible = true,
	lastToggledItem = {}
}

function v40.init(p1) -- line: 109
	-- upvalues: AXRecentlyViewedSearchItemsIXPTest (copy), Roact (copy)
	function p1.fetchItemData() -- line: 110
		-- upvalues: p1 (copy), AXRecentlyViewedSearchItemsIXPTest (copy)
		local lastToggledItem = p1.props.lastToggledItem

		if AXRecentlyViewedSearchItemsIXPTest.isEnabled() then
			if not lastToggledItem.isUnequipped and lastToggledItem.itemId and lastToggledItem.itemType then
				p1.props.fetchItemData(p1.props.networking, p1.props.appAnalytics, lastToggledItem.itemId, lastToggledItem.itemType)

				return
			end
		elseif not lastToggledItem.isUnequipped then
			p1.props.fetchItemData(p1.props.networking, p1.props.appAnalytics, lastToggledItem.itemId, lastToggledItem.itemType)
		end
	end

	p1.state = {}

	function p1.onTimedOptionSelected(p2) -- line: 125
		-- upvalues: p1 (copy), Roact (copy)
		if not p2 then
			p1:setState({
				selectedTimedOptionDays = Roact.None
			})

			return
		end

		p1:setState({
			selectedTimedOptionDays = p2
		})
	end
end
function v40.getGamepadBottomBarHeight(p3) -- line: 138
	-- upvalues: Cryo (copy), Constants (copy), FFlagEnableLeftNavOnConsole (copy)
	if p3.props.isConsoleWithGamepad and not Cryo.isEmpty(p3.props.boundInputs) then
		return Constants.GAMEPAD_BOTTOM_BAR_SIZE + (FFlagEnableLeftNavOnConsole and p3.props.deviceSafePadding.bottom or 0)
	end

	return 0
end
function v40.renderActionBar(p4) -- line: 146
	-- upvalues: Roact (copy), v34 (copy), FFlagAXMISEnableMultiShopping (copy), BuyActionBar (copy), FFlagAXDurablesForMIS (copy), n2 (ref), n1 (ref)
	local itemId = p4.props.itemId
	local itemType = p4.props.itemType
	local v51 = if not p4.props.itemData or not p4.props.itemData.timedOptions then nil else p4.props.itemData.timedOptions

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 1, -p4:getGamepadBottomBarHeight()),
		AnchorPoint = Vector2.new(0, 1),
		ZIndex = 3,
		Visible = if not v34 then nil else p4.props.Visible,
		[Roact.Change.AbsoluteSize] = if not FFlagAXMISEnableMultiShopping then nil else p4.props.onAbsoluteSizeChanged
	}, {
		BuyActionBar = Roact.createElement(BuyActionBar, {
			hideGradient = true,
			headerPadding = 24,
			bottomPadding = 20,
			ZIndex = 1,
			itemId = itemId,
			itemType = itemType,
			timedOptions = v51,
			hidePrice = not not v51 or nil,
			selectedTimedOptionIndexInReducer = if not FFlagAXDurablesForMIS or not p4.props.currentTryOnItem then nil else p4.props.currentTryOnItem.selectedTimedOptionIndex,
			selectedTimedOptionDays = if not p4.state then nil else p4.state.selectedTimedOptionDays,
			setSelectedTimedOptionDays = p4.onTimedOptionSelected,
			leftPadding = not FFlagAXMISEnableMultiShopping and 10 or n2,
			rightPadding = not FFlagAXMISEnableMultiShopping and 10 or n2,
			topPadding = not FFlagAXMISEnableMultiShopping and 10 or n1,
			itemDetailsPeekViewRefs = p4.props.itemDetailsPeekViewRefs
		})
	})
end
function v40.renderWithProviders(p5, _) -- line: 185
	-- upvalues: ActionBarHeight (copy), v34 (copy), FFlagStackedBottomNavMarketplaceCTA (copy), Constants (copy), Roact (copy), RoactGamepad (copy)
	local v54 = not p5.props.isPortrait and 0.4 or 1
	local v55 = not p5.props.isPortrait and 0.6 or 0
	local v56 = ActionBarHeight + 20
	local v57 = nil

	if v34 then
		v57 = p5:renderActionBar()
	elseif p5.props.Visible then
		v57 = p5:renderActionBar()
	end

	local v58 = v56 + p5:getGamepadBottomBarHeight()
	local v59 = if not FFlagStackedBottomNavMarketplaceCTA then nil else (not p5.props.itemData or not p5.props.itemData.timedOptions) and 8 or 0
	local v60 = if not FFlagStackedBottomNavMarketplaceCTA or not p5.props.footerVisibilityBinding then UDim2.new(v55, 0, 1, -v58) else p5.props.footerVisibilityBinding:map(function(p7) -- line: 204
		-- upvalues: v55 (copy), v58 (copy), Constants (copy), v59 (copy)
		return UDim2.new(v55, 0, 1, -v58 - (Constants.BOTTOM_BAR_SIZE - v59) * p7)
	end)

	return Roact.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		ZIndex = 3,
		Size = UDim2.new(v54, 0, 0, v58),
		Position = v60,
		ref = p5.props.bottomBarRef,
		NextSelectionLeft = p5.props.NextSelectionLeft,
		Visible = p5.props.Visible
	}, {
		BottomBar = v57
	})
end
function v40.render(p8) -- line: 227
	-- upvalues: withStyle (copy)
	return withStyle(function(p9) -- line: 228
		-- upvalues: p8 (copy)
		return p8:renderWithProviders(p9)
	end)
end
function v40.didUpdate(p10, p11) -- line: 233
	-- upvalues: AXShareButtonOnActionBarIXP (copy), IxpUtils (copy)
	if not p10.props.itemData or not p10.props.itemData.timedOptions then
		p10.onTimedOptionSelected()
	end

	if p10.props.Visible and (p10.props.lastToggledItem ~= p11.lastToggledItem and not p10.props.lastToggledItem.isUnequipped or not p11.Visible) then
		p10.fetchItemData()
	end

	if AXShareButtonOnActionBarIXP.isEnabled() and p10.props.Visible and not p11.Visible and IxpUtils.logExperimentExposure then
		IxpUtils.logExperimentExposure(AXShareButtonOnActionBarIXP)
	end
end

local function mapStateToProps(p12) -- line: 258
	-- upvalues: tutils (copy), FFlagAXDurablesForMIS (copy), ItemData (copy), DeviceOrientationMode (copy)
	local TryOnItems = p12.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local v66 = nil
	local itemType = nil
	local str = nil
	local v69 = nil

	if tutils.fieldCount(TryOnItems) == 1 then
		local _, v71 = next(TryOnItems, nil)

		if FFlagAXDurablesForMIS then
			v69 = v71
		end

		str = tostring(v71.itemId)
		itemType = v71.itemType
		v66 = ItemData(p12.AvatarExperience.Common, str, itemType)
	end

	local v72 = p12.DeviceOrientation == DeviceOrientationMode.Portrait
	local LastToggledItem = p12.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem

	return {
		isPortrait = v72,
		tryOnItems = TryOnItems,
		lastToggledItem = LastToggledItem,
		currentTryOnItem = if not FFlagAXDurablesForMIS then nil else v69,
		itemData = v66,
		itemId = str,
		itemType = itemType,
		boundInputs = p12.GamepadBottomBar.boundInputs
	}
end
local function mapDispatchToProps(p13: ((...any) -> ...any)) -- line: 293
	-- upvalues: FetchAssetOrBundleInfo (copy)
	return {
		fetchItemData = function(p14, p15, p16, p17) -- line: 295
			-- upvalues: p13 (copy), FetchAssetOrBundleInfo (copy)
			return p13(FetchAssetOrBundleInfo(p14, p15, p16, p17))
		end
	}
end

local v43 = withNavigation(v40, nil)
local v44 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v43)
local u45 = RoactServices.connect({
	catalogAnalytics = Analytics,
	appAnalytics = RoactAnalytics,
	networking = RoactNetworking,
	localization = RoactLocalization
})(v44)

if FFlagEnableLeftNavOnConsole then
	return function(p18) -- line: 313
		-- upvalues: FFlagEnableLeftNavOnConsole (copy), useSignalState (copy), Display (copy), Roact (copy), u45 (ref), Cryo (copy)
		local v76 = if not FFlagEnableLeftNavOnConsole then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

		return Roact.createElement(u45, Cryo.Dictionary.join(p18, {
			deviceSafePadding = v76
		}))
	end
end

return u45
