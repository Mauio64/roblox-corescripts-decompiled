local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local Constants = require(Modules.LuaApp.Constants)
local Dash = require(CorePackages.Packages.Dash)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local BadgeStates = UIBlox.App.Indicator.Enum.BadgeStates
local UtilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useIconSize = Foundation.Hooks.useIconSize
local InputSize = Foundation.Enums.InputSize
local RoactAnalyticsTopBar = require(Modules.LuaApp.Services.RoactAnalyticsTopBar)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local OpenPurchaseRobuxPage = require(Modules.LuaApp.Thunks.Economy.OpenPurchaseRobuxPage)
local SetBuyRobuxButtonClicked = require(Modules.LuaApp.Actions.Economy.SetBuyRobuxButtonClicked)
local useRobuxBadge = require(Modules.LuaApp.Components.TopBar.Utils.useRobuxBadge)
local FFlagRobuxBadgeEnabled = require(Modules.LuaApp.Flags.FFlagRobuxBadgeEnabled)
local FFlagEnableWhiteRobuxIcon = require(Modules.LuaApp.Flags.FFlagEnableWhiteRobuxIcon)
local FFlagRobuxIconColorHotfix = require(Modules.LuaApp.Flags.FFlagRobuxIconColorHotfix)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v37 = if not FFlagSignalsNavP3bTopBar then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local v38 = game:DefineFastFlag("EnableWhiteOrGreyRobuxIcon", false)
local v39 = if not FFlagEnableWhiteRobuxIcon then Images["icons/common/goldrobux"] else Images["icons/common/robux"]
local v40 = if not FFlagEnableHeaderBarButtonsUpdate then nil else React.forwardRef(function(t1: {[any]: any}, p1) -- line: 57
	-- upvalues: useTokens (copy), v38 (copy), useIconSize (copy), InputSize (copy), React (copy), Foundation (copy), ImageSetLabel (copy), Images (copy), FFlagRobuxBadgeEnabled (copy)
	local v50 = useTokens()
	local v51 = if not v38 then useIconSize(InputSize.Medium, true, true) else nil
	local v52 = if not v38 then React.useMemo(function() -- line: 62
		-- upvalues: v50 (copy)
		return {
			radius = UDim.new(0, v50.Radius.Circle),
			offset = v50.Size.Size_150,
			borderWidth = v50.Stroke.Thicker
		}
	end, { v50 }) else nil

	return React.createElement(Foundation.View, {
		tag = not v38 and "size-1000-1000 radius-circle" or "auto-xy radius-circle",
		cursor = if not v38 then v52 else nil,
		ref = if not v38 then p1 else nil,
		onActivated = if not v38 then t1.onActivated else nil
	}, {
		Icon = if not v38 then React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Selectable = false,
			ZIndex = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = v51,
			Image = Images["icons/common/goldrobux"]
		}) else React.createElement(Foundation.IconButton, {
			ZIndex = 1,
			isCircular = true,
			icon = Foundation.Enums.IconName.Robux,
			onActivated = t1.onActivated,
			ref = p1
		}),
		Badge = if not FFlagRobuxBadgeEnabled or not t1.showBadge then nil else React.createElement(Foundation.StatusIndicator, {
			ZIndex = 2,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0.5, v50.Size.Size_50, 0.5, -v50.Size.Size_50),
			variant = Foundation.Enums.StatusIndicatorVariant.Alert
		})
	})
end)
local v41 = Roact.PureComponent:extend("BuyRobuxButton")

v41.validateProps = t.strictInterface({
	formFactor = t.string,
	isCompactView = t.boolean,
	isSearching = t.boolean,
	isSecondary = t.optional(t.boolean),
	setVisible = Dash.isCallable,
	cancelSearch = Dash.isCallable,
	activateSearch = Dash.isCallable,
	buttonRef = t.optional(t.table),
	currentRoute = t.table,
	showBadge = if not FFlagRobuxBadgeEnabled then nil else t.boolean,
	openPurchaseRobuxPage = Dash.isCallable,
	dispatchBuyRobuxButtonClicked = if not FFlagRobuxBadgeEnabled then nil else Dash.isCallable,
	analytics = t.any,
	disableIAPEntryPoint = t.boolean,
	networking = t.callback
})

function v41.init(p2) -- line: 134
	-- upvalues: HttpService (copy), FFlagRobuxBadgeEnabled (copy)
	function p2.showBuyRobuxCallback() -- line: 135
		-- upvalues: p2 (copy), HttpService (copy), FFlagRobuxBadgeEnabled (copy)
		local name = p2.props.currentRoute[1].name
		local disableIAPEntryPoint = p2.props.disableIAPEntryPoint
		local networking = p2.props.networking
		local guid = HttpService:GenerateGUID(false)

		p2.props.openPurchaseRobuxPage(disableIAPEntryPoint, networking, guid)

		if FFlagRobuxBadgeEnabled then
			p2.props.dispatchBuyRobuxButtonClicked()
		end

		p2.props.analytics.reportRobuxButtonClick(name)
	end
end

local function isVisible(p3) -- line: 154
	return not p3.isSearching
end

function v41.updateVisibility(p4, p5) -- line: 158
	local v57 = not p4.props.isSearching

	if v57 ~= p5 then
		p4.props.setVisible(v57)
	end
end
function v41.didMount(p6) -- line: 165
	p6:updateVisibility(nil)
end
function v41.didUpdate(p7, p8, _) -- line: 169
	p7:updateVisibility(not p8.isSearching)
end
function v41.render(p10) -- line: 173
	-- upvalues: FFlagEnableHeaderBarButtonsUpdate (copy), React (copy), v40 (copy), FFlagRobuxBadgeEnabled (copy), Roact (copy), UtilityActionIcon (copy), v39 (copy), BadgeStates (copy), FFlagRobuxIconColorHotfix (copy), FFlagEnableWhiteRobuxIcon (copy)
	if FFlagEnableHeaderBarButtonsUpdate then
		return React.createElement(v40, {
			showBadge = if not FFlagRobuxBadgeEnabled then nil else p10.props.showBadge,
			onActivated = if not p10.props.isSearching then p10.showBuyRobuxCallback else p10.props.cancelSearch,
			ref = p10.props.buttonRef
		})
	end

	return Roact.createElement(UtilityActionIcon, {
		icon = v39,
		badgeValue = if not FFlagRobuxBadgeEnabled or not p10.props.showBadge then nil else BadgeStates.isEmpty,
		iconColor = if not FFlagRobuxIconColorHotfix or not FFlagEnableWhiteRobuxIcon then {} else nil,
		onActivated = if not p10.props.isSearching then p10.showBuyRobuxCallback else p10.props.cancelSearch,
		ref = p10.props.buttonRef
	})
end

local v43 = RoactRodux.connect(function(p11, _) -- line: 191
	-- upvalues: FFlagSignalsNavP3bTopBar (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), FFlagRobuxBadgeEnabled (copy)
	return {
		currentRoute = if not FFlagSignalsNavP3bTopBar then if not FFlagUseNavigationSelectors then p11.Navigation.history[#p11.Navigation.history] else Selectors.selectCurrentLegacyRoute(p11) else nil,
		showBadge = if not FFlagRobuxBadgeEnabled then nil else p11.RobuxVirtualItem.showBuyRobuxButtonBadge
	}
end, function(p13) -- line: 200
	-- upvalues: SetCurrentToastMessage (copy), Constants (copy), OpenPurchaseRobuxPage (copy), FFlagRobuxBadgeEnabled (copy), SetBuyRobuxButtonClicked (copy)
	return {
		openPurchaseRobuxPage = function(p14, p15, p16) -- line: 202
			-- upvalues: p13 (copy), SetCurrentToastMessage (copy), Constants (copy), OpenPurchaseRobuxPage (copy)
			if p14 then
				p13(SetCurrentToastMessage(Constants.WEBVIEWS_UNAVAILABLE_TOAST))

				return
			end

			return p13(OpenPurchaseRobuxPage(nil, p15, p16))
		end,
		dispatchBuyRobuxButtonClicked = if not FFlagRobuxBadgeEnabled then nil else function() -- line: 210
			-- upvalues: p13 (copy), SetBuyRobuxButtonClicked (copy)
			return p13(SetBuyRobuxButtonClicked())
		end
	}
end)(v41)

if FFlagSignalsNavP3bTopBar then
	local v44 = v43

	function v43(p17) -- line: 220
		-- upvalues: v37 (copy), useSignalState (copy), React (copy), v44 (copy), Cryo (copy)
		local v67 = v37(false)
		local v68 = useSignalState(v67.getCurrentLegacyRoute)

		return React.createElement(v44, Cryo.Dictionary.union(p17, {
			currentRoute = v68
		}))
	end
end

local v45 = RoactServices.connect({
	analytics = RoactAnalyticsTopBar,
	networking = RoactNetworking
})(v43)
local v46 = RoactAppPolicy.connect(function(p18) -- line: 237
	return {
		disableIAPEntryPoint = p18.getDisableIAPEntryPoint()
	}
end)(v45)

if FFlagRobuxBadgeEnabled then
	local v47 = v46

	function v46(p19) -- line: 246
		-- upvalues: useRobuxBadge (copy), Roact (copy), v47 (copy)
		useRobuxBadge()

		return Roact.createElement(v47, p19)
	end
end

return v46
