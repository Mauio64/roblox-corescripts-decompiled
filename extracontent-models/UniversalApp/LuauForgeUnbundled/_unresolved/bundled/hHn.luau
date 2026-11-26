local appPage = require("@luauforge/bundled/hHo").AppPage
local compositionTags = require("@luauforge/bundled/hHp").CompositionTags
local module = require("@luauforge/bundled/hHq")
local module2 = require("@luauforge/bundled/hHr")
local module3 = require("@luauforge/bundled/hHs")
local useRouteName = require("@luauforge/bundled/hHt").useRouteName
local module4 = require("@luauforge/bundled/hHu")
local module5 = require("@luauforge/bundled/hHv")
local module6 = require("@luauforge/bundled/hHw")
local module7 = require("@luauforge/bundled/hHx")

local getSubscriptionPurchaseCloseCallback = require("@luauforge/bundled/hHy").Utils.getSubscriptionPurchaseCloseCallback
local useCloseWithBackButton = require("@luauforge/bundled/hHz").useCloseWithBackButton
local useDispatch = require("@luauforge/bundled/hHA").Hooks.RoactRodux.useDispatch

local appFocusRoot = module.AppFocusRoot
local focusNavigableSurfaceIdentifierEnum = module.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum
local sduiPageEntryPoint = module7.SduiPageEntryPoint
local sduiSurfaceLoadTimeTracker = module7.SduiSurfaceLoadTimeTracker
local usePageScopeRef = module7.usePageScopeRef

local module8 = require("@luauforge/bundled/hHB")
local module9 = require("@luauforge/bundled/hHF")
local module10 = require("@luauforge/bundled/hHI")

local module11 = require("@luauforge/bundled/hHJ")
local module12 = require("@luauforge/bundled/hHK")
local module13 = require("@luauforge/bundled/hHL")

local module14 = require("@luauforge/bundled/hHM")
local module15 = require("@luauforge/bundled/hHN")
local module16 = require("@luauforge/bundled/hIn")
local module17 = require("@luauforge/bundled/hIq")
local module18 = require("@luauforge/bundled/hJj")
local module19 = require("@luauforge/bundled/hJz")
local module20 = require("@luauforge/bundled/hJE")
local module21 = require("@luauforge/bundled/hJF")
local module22 = require("@luauforge/bundled/hIc")
local module23 = require("@luauforge/bundled/hJI")

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
	module20()
	module21()
	local v5 = if module11 then useRouteName() else nil

	module4.useEffect(function()
		return function()
			module22().set(pageScopeFieldProductsListExpanded, nil)
		end
	end, {})

	if module14 then
		module4.useEffect(function()
			local subscriptionPurchaseCloseCallback = getSubscriptionPurchaseCloseCallback()
			return function()
				if subscriptionPurchaseCloseCallback then
					subscriptionPurchaseCloseCallback()
				end
			end
		end, {})
	end

	local v6 = module6.useDeviceInsets()
	local top = math.ceil(v6.top)

	local bottom = math.ceil(v6.bottom)
	local v7 = module2.Hooks.useTokens()

	local v8 = module4.useMemo(function()
		return createPageTimer("mount")
	end, {})

	local analyticId = if p2.analyticId ~= "" then p2.analyticId else nil
	local state, setState = module4.useState(false)
	local v9 = module7.useInputData(buyRobux, module10.PageEntryIdentifier)
	local purchase_flow_id = if v9 then v9.purchase_flow_id else nil
	local v10 = module4.useMemo(function()
		return { [purchaseFlowUuidField] = purchase_flow_id }
	end, { purchase_flow_id })

	module4.useEffect(function()
		local flag = true
		module19(v8, true, analyticId):finally(function()
			if flag then
				setState(true)
			end
		end)

		return function()
			flag = false
		end
	end, { v8, analyticId })

	local v11 = module4.useCallback(function()
		module19(createPageTimer("refresh"), true, analyticId)
	end, { analyticId })

	local v12 = useDispatch()
	local v13 = module4.useCallback(function()
		module8.navigateBack(v12)
	end, { v12 })

	local state2, setState2 = module4.useState(nil)

	local v14, v15 = module5.useMostRecentOrDefaultFocusBehavior(setState2)
	local v16 = useCloseWithBackButton(v15, v13)
	local v17

	if module12 then
		v17 = module4.useMemo(function()
			local v18 = {}
			v18[focusNavigationEventNameEnum.NavigateBack] = {
				handler = module3.onRelease(function(object)
					v13()
					object:cancel()
				end)
			}

			return v18
		end, { v13 })
	end

	local v18 = not state
	module23(purchase_flow_id, not v18)
	local v19

	if v18 then
		v19 = module4.createElement(module2.View, { tag = "size-full", ref = v16 }, {
			Loading = module4.createElement(module2.Loading, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		})
	else
		local createElement = module4.createElement
		local v21 = {
			appPage = buyRobux,
			configKey = buyRobux,
			pageTimer = v8,
			onCloseActivated = v13,
			refresh = v11,
			contentTag = compositionTags.ContentRegion.Body,
			pageBottomPadding = if module12 then bottom else nil,
			additionalAnalyticsData = v10,
			routeName = 0
		}

		if not module11 then
			v5 = nil
		end

		v21.routeName = v5
		v19 = createElement(sduiPageEntryPoint, v21)
	end

	local createElement = module4.createElement
	local view = module2.View
	local v21 = if module12 then UDim2.new(1, 0, 1, bottom) else nil
	local v20 = {
		Size = v21,
		tag = {
			["size-full"] = not module12
		},
		backgroundStyle = v7.Color.Surface.Surface_0
	}

	local v22 = if top > 0 then module4.createElement("Frame", {
		BorderSizePixel = 0,
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, top + 1),
		BackgroundColor3 = v7.Color.Surface.Surface_100.Color3,
		BackgroundTransparency = v7.Color.Surface.Surface_100.Transparency
	}) else nil
	local children = {
		SafeAreaTop = v22,
		ContentArea = module4.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 1,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, top),
			Size = UDim2.new(1, 0, 1, -top),
			ClipsDescendants = true
		}, {
			Content = v19,
			CloseButton = module4.createElement(module9, {
				onActivated = v13,
				showWithDirectionalInput = v18
			})
		}),
		PurchaseSpinner = 0,
		SendRobux = 0,
		PurchaseWarnings = 0,
		PendingTransfers = 0
	}

	local v23 = if module13 then module4.createElement(module16, { ZIndex = 3 }) else nil
	children.PurchaseSpinner = v23

	children.SendRobux = module4.createElement(module18, {
		purchaseFlowUuid = purchase_flow_id
	})

	children.PurchaseWarnings = module4.createElement(module17)
	children.PendingTransfers = module4.createElement(module15, {
		purchaseFlowUuid = purchase_flow_id
	})
	local element = createElement(view, v20, children)

	if module12 then
		return module4.createElement(appFocusRoot, {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
			isAutoFocusRoot = true,
			isIsolated = true,
			shouldRestoreFocus = false,
			customEventHandlers = v17
		}, { Page = element })
	end

	return element
end

return module4.memo(BuyRobuxSduiPage)
