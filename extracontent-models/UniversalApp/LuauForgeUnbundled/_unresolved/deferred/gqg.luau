local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local withStyle = UIBlox.Core.Style.withStyle

local module3 = require("@luauforge/deferred/gmq")
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module4 = require("@luauforge/bundled/fuC")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module5 = require("@luauforge/bundled/eda")
local module6 = require("@luauforge/bundled/dYT")
local module7 = require("@luauforge/bundled/edB")
local module8 = require("@luauforge/bundled/fvF")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module9 = require("@luauforge/bundled/dME")
local module10 = require("@luauforge/bundled/dwA")
require("@luauforge/bundled/dHK")

local module11 = require("@luauforge/deferred/ggy")
require("@luauforge/bundled/dMc")
local module12 = require("@luauforge/bundled/dUd")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module13 = require("@luauforge/deferred/gmu")
local module14 = require("@luauforge/bundled/dMB")
local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS

local defineFastFlag = game:DefineFastFlag("BuyActionBarShouldNotUnrenderInFullscreenMode", false)

local fFlagStackedBottomNavMarketplaceCTA = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagStackedBottomNavMarketplaceCTA
local fFlagAXFixBottomNavCTAHeight = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXFixBottomNavCTAHeight
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fuN") else nil

local actionBarHeight = module9.ActionBar.ActionBarHeight

local extended = Roact.PureComponent:extend("MultiTryOnBottomBar")

local strictInterface = t.strictInterface
local v6 = {
	bottomBarRef = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	Visible = t.optional(t.boolean),
	isConsoleWithGamepad = t.optional(t.boolean),
	itemDetailsPeekViewRefs = t.optional(t.table),
	onAbsoluteSizeChanged = t.optional(t.callback),
	footerVisibilityBinding = 0,
	lastToggledItem = 0,
	isPortrait = 0,
	tryOnItems = 0,
	itemData = 0,
	itemId = 0,
	itemType = 0,
	boundInputs = 0,
	currentTryOnItem = 0,
	fetchItemData = 0,
	networking = 0,
	appAnalytics = 0,
	catalogAnalytics = 0,
	localization = 0,
	navigation = 0,
	deviceSafePadding = 0,
	isSupportPaneLayoutActive = 0,
	supportPaneWidthFraction = 0
}
local v7 = if fFlagStackedBottomNavMarketplaceCTA then t.optional(t.table) else nil
v6.footerVisibilityBinding = v7

v6.lastToggledItem = t.table
v6.isPortrait = t.boolean
v6.tryOnItems = t.optional(t.table)
v6.itemData = t.optional(module11)
v6.itemId = t.optional(t.string)
v6.itemType = t.optional(t.string)
v6.boundInputs = t.optional(t.table)
local v8 = if fFlagAXDurablesForMIS then t.optional(t.table) else nil
v6.currentTryOnItem = v8

v6.fetchItemData = t.callback

v6.networking = t.callback
v6.appAnalytics = t.table
v6.catalogAnalytics = t.table
v6.localization = t.table

v6.navigation = t.table

v6.deviceSafePadding = t.table
local v9 = if fFlagEnableSplitPane then t.boolean else nil
v6.isSupportPaneLayoutActive = v9
local v10 = if fFlagEnableSplitPane then t.number else nil
v6.supportPaneWidthFraction = v10
extended.validateProps = strictInterface(v6)

extended.defaultProps = { Visible = true, lastToggledItem = {} }

function extended:init()
	function self.fetchItemData()
		local lastToggledItem = self.props.lastToggledItem

		if axRecentlyViewedSearchItemsIXPTest.isEnabled() then
			if not lastToggledItem.isUnequipped and lastToggledItem.itemId and lastToggledItem.itemType then
				self.props.fetchItemData(
					self.props.networking,
					self.props.appAnalytics,
					lastToggledItem.itemId,
					lastToggledItem.itemType
				)
			end
		elseif not lastToggledItem.isUnequipped then
			self.props.fetchItemData(
				self.props.networking,
				self.props.appAnalytics,
				lastToggledItem.itemId,
				lastToggledItem.itemType
			)
		end
	end

	self.state = {}

	function self.onTimedOptionSelected(p2)
		if p2 then
			self:setState({ selectedTimedOptionDays = p2 })
		else
			self:setState({ selectedTimedOptionDays = Roact.None })
		end
	end
end

function extended:getGamepadBottomBarHeight()
	if self.props.isConsoleWithGamepad and not Cryo.isEmpty(self.props.boundInputs) then
		return module10.GAMEPAD_BOTTOM_BAR_SIZE + self.props.deviceSafePadding.bottom
	end

	return 0
end

function extended:renderActionBar()
	local itemId = self.props.itemId
	local itemType = self.props.itemType
	local timedOptions

	if self.props.itemData and self.props.itemData.timedOptions then
		timedOptions = self.props.itemData.timedOptions
	end

	local createElement = Roact.createElement
	local onAbsoluteSizeChangedsByAbsoluteSize = {
		BackgroundTransparency = 1,
		["AutomaticSize"] = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 1, -self:getGamepadBottomBarHeight()),
		AnchorPoint = Vector2.new(0, 1),
		ZIndex = 3
	}

	local v12 = if defineFastFlag then self.props.Visible else nil
	onAbsoluteSizeChangedsByAbsoluteSize.Visible = v12
	onAbsoluteSizeChangedsByAbsoluteSize[Roact.Change.AbsoluteSize] = self.props.onAbsoluteSizeChanged

	local createElement2 = Roact.createElement

	local v16 = if fFlagAXDurablesForMIS and self.props.currentTryOnItem then self.props.currentTryOnItem.selectedTimedOptionIndex else nil

	local v17 = if self.state then self.state.selectedTimedOptionDays else nil
	return createElement("Frame", onAbsoluteSizeChangedsByAbsoluteSize, {
		BuyActionBar = createElement2(module3, {
			hideGradient = true,
			itemId = itemId,
			itemType = itemType,
			timedOptions = timedOptions,
			hidePrice = timedOptions and true or nil,
			selectedTimedOptionIndexInReducer = v16,
			selectedTimedOptionDays = v17,
			setSelectedTimedOptionDays = self.onTimedOptionSelected,
			headerPadding = 24,
			leftPadding = 20,
			bottomPadding = 20,
			rightPadding = 20,
			topPadding = 16,
			ZIndex = 1,
			itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs
		})
	})
end

function extended:renderWithProviders(p2)
	local isSupportPaneLayoutActive = fFlagEnableSplitPane and self.props.isSupportPaneLayoutActive
	local v11, v12

	if self.props.isPortrait and not isSupportPaneLayoutActive then
		v11 = 0
		v12 = 1
	elseif isSupportPaneLayoutActive then
		v12 = self.props.supportPaneWidthFraction

		v11 = 1 - v12
	else
		v11 = 0.6
		v12 = 0.4
	end

	local v13 = actionBarHeight + 20
	local v14 = nil

	if defineFastFlag then
		v14 = self:renderActionBar()
	elseif self.props.Visible then
		v14 = self:renderActionBar()
	end

	local v15 = v13 + self:getGamepadBottomBarHeight()

	local v16 = fFlagStackedBottomNavMarketplaceCTA
		and not fFlagAXFixBottomNavCTAHeight
		and (self.props.itemData and self.props.itemData.timedOptions and 0 or 8)
		or nil
	local v17

	if fFlagStackedBottomNavMarketplaceCTA and self.props.footerVisibilityBinding then
		v17 = self.props.footerVisibilityBinding:map(function(p3)
			if not fFlagAXFixBottomNavCTAHeight then
				return UDim2.new(v11, 0, 1, -v15 - (module10.BOTTOM_BAR_SIZE - v16) * p3)
			end

			local v18 = math.max(0, module10.BOTTOM_BAR_SIZE * p3 - 8)
			return UDim2.new(v11, 0, 1, -v15 - v18)
		end)
	else
		v17 = UDim2.new(v11, 0, 1, -v15)
	end

	return Roact.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(v12, 0, 0, v15),
		Position = v17,
		ZIndex = 3,
		ref = self.props.bottomBarRef,
		NextSelectionLeft = self.props.NextSelectionLeft,
		Visible = self.props.Visible
	}, { BottomBar = v14 })
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithProviders(p2)
	end)
end

function extended.didUpdate(data, p2)
	if not (data.props.itemData and data.props.itemData.timedOptions) then
		data.onTimedOptionSelected()
	end

	if
		data.props.Visible
		and (data.props.lastToggledItem ~= p2.lastToggledItem and not data.props.lastToggledItem.isUnequipped or not p2.Visible)
	then
		data.fetchItemData()
	end

	if
		module13.isEnabled()
		and data.props.Visible
		and not p2.Visible
		and module14.logExperimentExposure
	then
		module14.logExperimentExposure(module13)
	end
end

local function mapStateToProps(data)
	local tryOnItems = data.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	local v11 = nil
	local itemId, itemType, v12

	if tutils.fieldCount(tryOnItems) == 1 then
		local v13, v14 = next(tryOnItems, nil)

		if fFlagAXDurablesForMIS then
			v11 = v14
		end

		itemId = tostring(v14.itemId)
		itemType = v14.itemType
		v12 = itemData(data.AvatarExperience.Common, itemId, itemType)
	end

	local v13 = {
		isPortrait = data.DeviceOrientation == deviceOrientationMode.Portrait,
		tryOnItems = tryOnItems,
		lastToggledItem = data.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem,
		currentTryOnItem = 0,
		itemData = 0,
		itemId = 0,
		itemType = 0,
		boundInputs = 0
	}

	if not fFlagAXDurablesForMIS then
		v11 = nil
	end

	v13.currentTryOnItem = v11
	v13.itemData = v12
	v13.itemId = itemId
	v13.itemType = itemType
	v13.boundInputs = data.GamepadBottomBar.boundInputs
	return v13
end

local function mapDispatchToProps(callback)
	return {
		fetchItemData = function(p2, p3, p4, p5)
			return callback(module4(p2, p3, p4, p5))
		end
	}
end

local v11 = withNavigation(extended, nil)

local v12 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v11)

local v13 = roactServices.connect({
	catalogAnalytics = module8,
	appAnalytics = module6,
	networking = module5,
	localization = module7
})(v12)

return function(p2)
	local v14 = useSignalState(module12.GetDisplayStore().getDeviceSafePadding)

	local v15 = if fFlagEnableSplitPane then useSignalState(v5.isSupportPaneLayoutActive) else nil

	local v16 = if fFlagEnableSplitPane then useSignalState(v5.getSupportPaneWidthFraction) else nil

	return Roact.createElement(
		v13,
		Cryo.Dictionary.join(p2, {
			deviceSafePadding = v14,
			isSupportPaneLayoutActive = v15,
			supportPaneWidthFraction = v16
		})
	)
end
