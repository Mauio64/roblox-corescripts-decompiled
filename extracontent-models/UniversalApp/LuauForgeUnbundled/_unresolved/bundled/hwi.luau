local appPage = require("@luauforge/bundled/hwj").AppPage
local compositionTags = require("@luauforge/bundled/hwk").CompositionTags
local module = require("@luauforge/bundled/hwl")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/Foundation")
local module3 = require("@luauforge/bundled/hwn")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")
local module5 = require("@luauforge/bundled/hwp")
local module6 = require("@luauforge/bundled/hwq")
local module7 = require("@luauforge/bundled/hwr")

local getSubscriptionPurchaseCloseCallback = require("@luauforge/bundled/hws").Utils.getSubscriptionPurchaseCloseCallback
local useCloseWithBackButton = require("@luauforge/bundled/hwt").useCloseWithBackButton
local useDispatch = require("@luauforge/bundled/hwu").Hooks.RoactRodux.useDispatch

local appFocusRoot = module.AppFocusRoot
local focusNavigableSurfaceIdentifierEnum = module.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum
local sduiPageEntryPoint = module7.SduiPageEntryPoint
local sduiSurfaceLoadTimeTracker = module7.SduiSurfaceLoadTimeTracker
local usePageScopeRef = module7.usePageScopeRef

local module8 = require("@luauforge/bundled/hwv")
local module9 = require("@luauforge/bundled/hwz")
local module10 = require("@luauforge/bundled/hwC")
local module11 = require("@luauforge/bundled/hwD")

local module12 = require("@luauforge/bundled/hwE")
local module13 = require("@luauforge/bundled/hwF")
local module14 = require("@luauforge/bundled/hxd")
local module15 = require("@luauforge/bundled/hxW")
local module16 = require("@luauforge/bundled/hym")
local module17 = require("@luauforge/bundled/hyr")
local module18 = require("@luauforge/bundled/hys")
local module19 = require("@luauforge/bundled/hwU")
local module20 = require("@luauforge/bundled/hyv")

local buyRobux = appPage.BuyRobux
local surfaceLoadTimeEventName = module10.SurfaceLoadTimeEventName
local purchaseFlowUuidField = module10.PurchaseFlowUuidField
local pageScopeFieldProductsListExpanded = module10.PageScopeFieldProductsListExpanded

local function createPageTimer(p2)
	local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
		buyRobux,
		{
			eventName = surfaceLoadTimeEventName,
			metadata = { page = p2 }
		}
	)

	loadTimerWithSurfaceLoadTime.start(p2)
	return loadTimerWithSurfaceLoadTime
end

local function BuyRobuxSduiPage(p2)
	usePageScopeRef(buyRobux)
	module17()
	module18()

	React.useEffect(function()
		return function()
			module19().set(pageScopeFieldProductsListExpanded, nil)
		end
	end, {})

	if module12 then
		React.useEffect(function()
			local subscriptionPurchaseCloseCallback = getSubscriptionPurchaseCloseCallback()
			return function()
				if subscriptionPurchaseCloseCallback then
					subscriptionPurchaseCloseCallback()
				end
			end
		end, {})
	end

	local v5 = module6.useDeviceInsets()
	local top = math.ceil(v5.top)

	local bottom = math.ceil(v5.bottom)
	local v6 = Foundation.Hooks.useTokens()

	local v7 = React.useMemo(function()
		return createPageTimer("mount")
	end, {})

	local analyticId = if p2.analyticId ~= "" then p2.analyticId else nil
	local state, setState = React.useState(false)
	local v8 = module7.useInputData(buyRobux, module10.PageEntryIdentifier)
	local purchase_flow_id = if v8 then v8.purchase_flow_id else nil
	local v9 = React.useMemo(function()
		return { [purchaseFlowUuidField] = purchase_flow_id }
	end, { purchase_flow_id })

	React.useEffect(function()
		local flag = true
		module16(v7, true, analyticId):finally(function()
			if flag then
				setState(true)
			end
		end)

		return function()
			flag = false
		end
	end, { v7, analyticId })

	local v10 = React.useCallback(function()
		module16(createPageTimer("refresh"), true, analyticId)
	end, { analyticId })

	local v11 = useDispatch()
	local v12 = React.useCallback(function()
		module8.navigateBack(v11)
	end, { v11 })

	local state2, setState2 = React.useState(nil)

	local v13, v14 = module5.useMostRecentOrDefaultFocusBehavior(setState2)
	local v15 = useCloseWithBackButton(v14, v12)
	local v16

	if module11 then
		v16 = React.useMemo(function()
			local v17 = {}
			v17[focusNavigationEventNameEnum.NavigateBack] = {
				handler = module3.onRelease(function(object)
					v12()
					object:cancel()
				end)
			}

			return v17
		end, { v12 })
	end

	local v17 = not state
	module20(purchase_flow_id, not v17)
	local v18

	if v17 then
		v18 = React.createElement(Foundation.View, { tag = "size-full", ref = v15 }, {
			Loading = React.createElement(Foundation.Loading, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		})
	else
		v18 = React.createElement(sduiPageEntryPoint, {
			appPage = buyRobux,
			configKey = buyRobux,
			pageTimer = v7,
			onCloseActivated = v12,
			refresh = v10,
			contentTag = compositionTags.ContentRegion.Body,
			pageBottomPadding = if module11 then bottom else nil,
			additionalAnalyticsData = v9
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v20 = if module11 then UDim2.new(1, 0, 1, bottom) else nil
	local v19 = {
		Size = v20,
		tag = {
			["size-full"] = not module11
		},
		backgroundStyle = v6.Color.Surface.Surface_0
	}

	local v21 = if top > 0 then React.createElement("Frame", {
		BorderSizePixel = 0,
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, top + 1),
		BackgroundColor3 = v6.Color.Surface.Surface_100.Color3,
		BackgroundTransparency = v6.Color.Surface.Surface_100.Transparency
	}) else nil
	local element = createElement(view, v19, {
		SafeAreaTop = v21,
		ContentArea = React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 1,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, top),
			Size = UDim2.new(1, 0, 1, -top),
			ClipsDescendants = true
		}, {
			Content = v18,
			CloseButton = React.createElement(module9, {
				onActivated = v12,
				showWithDirectionalInput = v17
			})
		}),
		SendRobux = React.createElement(module15, {
			purchaseFlowUuid = purchase_flow_id
		}),
		PurchaseWarnings = React.createElement(module14),
		PendingTransfers = React.createElement(module13, {
			purchaseFlowUuid = purchase_flow_id
		})
	})

	if module11 then
		return React.createElement(appFocusRoot, {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
			isAutoFocusRoot = true,
			isIsolated = true,
			shouldRestoreFocus = false,
			customEventHandlers = v16
		}, { Page = element })
	end

	return element
end

return React.memo(BuyRobuxSduiPage)
