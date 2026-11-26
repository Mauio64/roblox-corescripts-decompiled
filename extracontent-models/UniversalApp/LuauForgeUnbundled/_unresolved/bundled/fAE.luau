local HttpService = game:GetService("HttpService")

local CorePackages = game:GetService("CorePackages")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module = require("@luauforge/bundled/dzD")

local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local badgeStates = UIBlox.App.Indicator.Enum.BadgeStates
local utilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useIconSize = Foundation.Hooks.useIconSize
local inputSize = Foundation.Enums.InputSize

local module2 = require("@luauforge/bundled/fvT")
local module3 = require("@luauforge/bundled/egx")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module4 = require("@luauforge/bundled/dFm")
local module5 = require("@luauforge/bundled/fAF")
local module6 = require("@luauforge/bundled/fAX")
local module7 = require("@luauforge/bundled/fAY")

local module8 = require("@luauforge/bundled/dzj")
local module9 = require("@luauforge/bundled/fBj")
local module10 = require("@luauforge/bundled/fBk")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local fFlagUseSignalsForRobuxVirtualItem = SharedFlags.FFlagUseSignalsForRobuxVirtualItem

local getLegacyNavigationStore = if fFlagSignalsNavP3bTopBar then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil
local getRobuxVirtualItemStore

if fFlagUseSignalsForRobuxVirtualItem then
	getRobuxVirtualItemStore = require("@luauforge/bundled/fBd").GetRobuxVirtualItemStore
else
	getRobuxVirtualItemStore = nil
end

local defineFastFlag = game:DefineFastFlag("EnableWhiteOrGreyRobuxIcon", false)

local defineFastFlag2 = game:DefineFastFlag("RobuxIconCoachmarkAnchor", false)

local v5 = if module9 then images["icons/common/robux"] else images["icons/common/goldrobux"]
local v6

if fFlagEnableHeaderBarButtonsUpdate then
	v6 = React.forwardRef(function(p2, p3)
		local v7 = useTokens()
		local v8 = if not defineFastFlag then useIconSize(inputSize.Medium, true, true) else nil
		local v9

		if not defineFastFlag then
			v9 = React.useMemo(function()
				return {
					radius = UDim.new(0, v7.Radius.Circle),
					offset = v7.Size.Size_150,
					borderWidth = v7.Stroke.Thicker
				}
			end, { v7 })
		end

		local createElement = React.createElement
		local view = Foundation.View
		local v10 = {
			tag = {
				["auto-xy radius-circle"] = defineFastFlag,
				["size-1000-1000 radius-circle"] = not defineFastFlag,
				RobuxIconCoachmarkAnchor = defineFastFlag2
			},
			cursor = 0,
			ref = 0,
			onActivated = 0,
			testId = 0
		}

		if defineFastFlag then
			v9 = nil
		end

		v10.cursor = v9
		v10.ref = if not defineFastFlag then p3 else nil
		local v12 = if not defineFastFlag then p2.onActivated else nil
		v10.onActivated = v12
		v10.testId = not defineFastFlag and "--topbar-button-robux" or nil

		local v14 = if defineFastFlag then React.createElement(Foundation.IconButton, {
			ZIndex = 1,
			isCircular = true,
			icon = Foundation.Enums.IconName.Robux,
			onActivated = p2.onActivated,
			ref = p3,
			testId = "--topbar-button-robux"
		}) else React.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			Selectable = false,
			Size = v8,
			ZIndex = 1,
			Image = images["icons/common/goldrobux"]
		})

		local v15 = if module8 and p2.showBadge then React.createElement(Foundation.StatusIndicator, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0.5, v7.Size.Size_50, 0.5, -v7.Size.Size_50),
			ZIndex = 2,
			variant = Foundation.Enums.StatusIndicatorVariant.Emphasis
		}) else nil
		return createElement(view, v10, { Icon = v14, Badge = v15 })
	end)
else
	v6 = nil
end

local extended = Roact.PureComponent:extend("BuyRobuxButton")

local strictInterface = t.strictInterface
local v7 = {
	formFactor = t.string,
	isCompactView = t.boolean,
	isSearching = t.boolean,
	isSecondary = t.optional(t.boolean),
	setVisible = Dash.isCallable,
	cancelSearch = Dash.isCallable,
	activateSearch = Dash.isCallable,
	buttonRef = t.optional(t.table),
	currentRoute = 0,
	showBadge = 0,
	openPurchaseRobuxPage = 0,
	dispatchBuyRobuxButtonClicked = 0,
	analytics = 0,
	disableIAPEntryPoint = 0,
	networking = 0
}

local v8 = if fFlagSignalsNavP3bTopBar then t.optional(t.table) else t.table
v7.currentRoute = v8
local v9 = if module8 then t.boolean else nil
v7.showBadge = v9

v7.openPurchaseRobuxPage = Dash.isCallable
local v10 = if module8 then Dash.isCallable else nil
v7.dispatchBuyRobuxButtonClicked = v10

v7.analytics = t.any
v7.disableIAPEntryPoint = t.boolean
v7.networking = t.callback
extended.validateProps = strictInterface(v7)

function extended:init()
	function self.showBuyRobuxCallback()
		local name = (if fFlagSignalsNavP3bTopBar then getLegacyNavigationStore(false).getCurrentLegacyRoute(false) else self.props.currentRoute)[1].name

		local disableIAPEntryPoint = self.props.disableIAPEntryPoint
		local networking = self.props.networking

		local guid = HttpService:GenerateGUID(false)
		self.props.openPurchaseRobuxPage(disableIAPEntryPoint, networking, guid)

		if module8 then
			self.props.dispatchBuyRobuxButtonClicked()
		end

		self.props.analytics.reportRobuxButtonClick(name)
	end
end

local function isVisible(p2): boolean
	return not p2.isSearching
end

function extended:updateVisibility(p3)
	local v11 = not self.props.isSearching

	if v11 ~= p3 then
		self.props.setVisible(v11)
	end
end

function extended:didMount()
	self:updateVisibility(nil)
end

function extended:didUpdate(p2, p3)
	self:updateVisibility(not p2.isSearching)
end

function extended.render(p2)
	if fFlagEnableHeaderBarButtonsUpdate then
		local createElement = React.createElement
		local v13 = if module8 then p2.props.showBadge else nil
		local v14 = if p2.props.isSearching then p2.props.cancelSearch else p2.showBuyRobuxCallback
		return createElement(v6, {
			showBadge = v13,
			onActivated = v14,
			ref = p2.props.buttonRef
		})
	else
		local createElement = Roact.createElement
		local v12 = {
			icon = v5,
			badgeValue = 0,
			iconColor = 0,
			onActivated = 0,
			ref = 0
		}

		local v13 = if module8 and p2.props.showBadge then badgeStates.isEmpty else nil
		v12.badgeValue = v13
		v12.iconColor = not (module10 and module9) and {} or nil
		local v14 = if p2.props.isSearching then p2.props.cancelSearch else p2.showBuyRobuxCallback
		v12.onActivated = v14
		v12.ref = p2.props.buttonRef
		return createElement(utilityActionIcon, v12)
	end
end

local v11 = RoactRodux.connect(function(p2, p3)
	local v13

	if not fFlagSignalsNavP3bTopBar then
		if fFlagUseNavigationSelectors then
			v13 = selectors.selectCurrentLegacyRoute(p2)
		else
			v13 = p2.Navigation.history[#p2.Navigation.history]
		end
	end

	local v14 = if not (fFlagUseSignalsForRobuxVirtualItem or not module8) then p2.RobuxVirtualItem.showBuyRobuxButtonBadge else nil
	return { currentRoute = v13, showBadge = v14 }
end, function(callback)
	return {
		openPurchaseRobuxPage = function(p2, p3, p4)
			if not p2 then
				return callback(module5(nil, p3, p4))
			end

			callback(module4(module.WEBVIEWS_UNAVAILABLE_TOAST))
		end,
		dispatchBuyRobuxButtonClicked = module8 and function()
			if not fFlagUseSignalsForRobuxVirtualItem then
				return callback(module6())
			end

			getRobuxVirtualItemStore(false).setBuyRobuxButtonClicked(true)
		end or nil
	}
end)(extended)

local v12 = roactServices.connect({ analytics = module2, networking = module3 })(v11)

local v13 = roactAppPolicy.connect(function(p2)
	return { disableIAPEntryPoint = p2.getDisableIAPEntryPoint() }
end)(v12)
local v14

if not module8 then
	v14 = v13
	return v14
end

v14 = function(p2)
	module7()

	if not fFlagUseSignalsForRobuxVirtualItem then
		return Roact.createElement(v13, p2)
	end

	local v15 = useSignalState(getRobuxVirtualItemStore(false).getShowBuyRobuxButtonBadge)
	return Roact.createElement(v13, Cryo.Dictionary.union(p2, { showBadge = v15 }))
end

if fFlagUseSignalsForRobuxVirtualItem then
	return (React.memo(v14))
end

return v14
