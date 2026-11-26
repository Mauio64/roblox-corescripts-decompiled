local CorePackages = game:GetService("CorePackages")

local appUpdateService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppUpdateService

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local module = require("@luauforge/bundled/ehO")
local module2 = require("@luauforge/bundled/dzD")
local module3 = require("@luauforge/deferred/fFQ")
local module4 = require("@luauforge/bundled/dFu")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local ixpServiceWrapper = require("@luauforge/bundled/fwW").IXPServiceWrapper

local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module5 = require("@luauforge/bundled/fvR")
local module6 = require("@luauforge/deferred/fGd")
local module7 = require("@luauforge/deferred/fGe")
local module8 = require("@luauforge/bundled/fGj")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local React = require(CorePackages.Packages.React)
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local module10 = require("@luauforge/deferred/hSk")
local useBillingTabVisibility = require("@luauforge/deferred/hSl").useBillingTabVisibility
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local module11 = require("@luauforge/deferred/hSt")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage
local useThemeBackground = require("@luauforge/bundled/ehR").useThemeBackground

local module13 = require("@luauforge/bundled/hTw")

local module14 = require("@luauforge/bundled/dBN")
local setShowAgeVerificationOverlay = module14.AgeVerificationOverlay.SetShowAgeVerificationOverlay
local setVoiceChatOptInStatus = module14.OptInStatus.SetVoiceChatOptInStatus

local getFFlagEnableGateNotificationPreferencesTab = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableGateNotificationPreferencesTab

local module15 = require("@luauforge/deferred/hSs")

local defineFastFlag = game:DefineFastFlag("UCUASettingsPageLogExposure", false)

local defineFastString = game:DefineFastString(
	"LuaAppUCUASettingsPageIxpLayer",
	appUserLayers.UCUASettingsPageExposureLayer
)

local v5 = false

local extended = Roact.PureComponent:extend("SettingsPage")

function extended:init()
	function self.renderItem(p3, p4)
		local createElement = Roact.createElement
		local v7 = {
			item = p3,
			layoutInfo = p4,
			transparentBackground = self.props.hasThemeBackground,
			disableAutoFocus = 0,
			setDefaultFocusGuiObject = 0
		}
		local v8 = if fFlagUnifyConsoleSettingsPage then self.props.defaultFocusRef ~= nil else nil
		v7.disableAutoFocus = v8
		local v9 = if fFlagUnifyConsoleSettingsPage and p4.LayoutOrder == 1 then self.props.setListDefaultFocus else nil
		v7.setDefaultFocusGuiObject = v9
		return createElement(module7, v7)
	end

	self.getSettingsPageItemList = module(function(p3, p4, p5, hideBillingTab, p6)
		local v6

		if getFFlagEnableGateNotificationPreferencesTab() then
			v6 = {
				enableNotificationPreferencesTab = self.props.enableNotificationPreferencesTab,
				hideBillingTab = 0
			}

			if not module15 then
				hideBillingTab = nil
			end

			v6.hideBillingTab = hideBillingTab
		else
			v6 = module15 and { hideBillingTab = hideBillingTab } or nil
		end

		local getItemsInPage = module3.GetItemsInPage

		if not fFlagUnifyConsoleSettingsPage then
			p6 = nil
		end

		local itemsInPage = getItemsInPage(p4, nil, nil, v6, p5, p6)

		return Cryo.List.map(itemsInPage, function(p7)
			local contents = p7.contents
			local result = {}

			for i, joined in ipairs(contents) do
				if joined.itemType == module3.ItemType.Settings_AccountInfo and joined.badgeCount ~= p3 then
					joined = Cryo.Dictionary.join(joined, { badgeCount = p3 })
				end

				result[i] = joined
			end

			return result
		end)
	end)

	if game:GetEngineFeature("VoiceChatSupported") then
		self.props.setShowAgeVerificationOverlay()
	end

	self.props.setVoiceChatOptInStatus()
end

function extended.render(data)
	local v6 = data.props.formFactor == formFactor.WIDE
	local showParentalControls = data.props.showParentalControls
	local v7

	if fFlagUnifyConsoleSettingsPage and data.props.disableWebViewSupport then
		v7 = module4.Settings
	else
		v7 = data.props.settingsPageType
	end

	local v8

	if module15 then
		v8 = not (data.props.hideBillingTabOverride == nil) and data.props.hideBillingTabOverride
	end

	local disableWebViewSupport = if fFlagUnifyConsoleSettingsPage then data.props.disableWebViewSupport else nil
	local v9

	if module15 then
		local getSettingsPageItemList = data.getSettingsPageItemList
		local notificationCount = data.props.notificationCount
		local v10 = if fFlagUnifyConsoleSettingsPage then disableWebViewSupport else nil
		v9 = getSettingsPageItemList(notificationCount, v7, showParentalControls, v8, v10)
	else
		local getSettingsPageItemList = data.getSettingsPageItemList
		local notificationCount = data.props.notificationCount
		local v11 = if fFlagUnifyConsoleSettingsPage then disableWebViewSupport else nil
		v9 = getSettingsPageItemList(notificationCount, v7, showParentalControls, nil, v11)
	end

	local v10 = module2.MORE_PAGE_SECTION_PADDING
	local v11 = module2.MORE_PAGE_SECTION_PADDING
	local v12, v13

	if v6 then
		v12 = module2.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		v13 = module2.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		v10 = module2.MORE_PAGE_WIDE_PADDING_VERTICAL
		v11 = module2.MORE_PAGE_WIDE_PADDING_VERTICAL
	else
		v12 = 0
		v13 = 0
	end

	local v14 = module2.MORE_PAGE_CONTENT_MAX_WIDTH + v12 + v13

	local function fn(backgroundDefault)
		local createElement = Roact.createElement
		local v16 = {
			itemList = v9,
			renderItem = data.renderItem,
			rowHeight = 0,
			defaultFocusRef = 0,
			backgroundTransparency = 0
		}
		local v17 = if fFlagUnifyConsoleSettingsPage then data.props.rowHeight else module2.MORE_PAGE_ROW_HEIGHT
		v16.rowHeight = v17
		local v18 = if fFlagUnifyConsoleSettingsPage then data.props.defaultFocusRef else nil
		v16.defaultFocusRef = v18
		v16.backgroundTransparency = data.props.hasThemeBackground and 1 or nil
		local v19 = createElement(module6, v16)

		local createElement2 = Roact.createElement
		local v21 = {
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			maxWidth = v14
		}

		local v22 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v12),
				PaddingRight = UDim.new(0, v13),
				PaddingTop = UDim.new(0, v10),
				PaddingBottom = UDim.new(0, v11)
			}),
			SettingsPageListContainer = 0
		}

		if fFlagUnifyConsoleSettingsPage and disableWebViewSupport then
			v19 = Roact.createElement("Frame", {
				[Roact.Ref] = data.props.listContainerRef,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				SelectionGroup = true,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			}, { List = v19 })
		end

		v22.SettingsPageListContainer = v19
		local element = createElement2(module8, v21, v22)

		local createElement3 = Roact.createElement
		local ref = Roact.Ref
		local v25 = if fFlagUnifyConsoleSettingsPage then data.props.containerRef else nil
		local v24 = {
			[ref] = v25,
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = backgroundDefault.Color,
			BackgroundTransparency = data.props.hasThemeBackground and 1 or backgroundDefault.Transparency
		}

		local createElement4 = Roact.createElement
		local container = module5.Container
		local v27 = if not (fFlagUnifyConsoleSettingsPage and disableWebViewSupport) then module5.BackButton else nil
		return createElement3("Frame", v24, {
			TopBar = createElement4(container, {
				leftItem = v27,
				rightItems = { module5.BuyRobuxButton, module5.NotificationsButton }
			}),
			PageContent = Roact.createElement(module5.PageContent, {}, {
				Scroller = element
			})
		})
	end

	return withStyle(function(p2)
		return fn(p2.Theme.BackgroundDefault)
	end)
end

local v6 = roactAppPolicy.connect(function(p2, p3)
	local v7 = {
		settingsPageType = p2.getSettingsPageType(),
		enableNotificationPreferencesTab = 0
	}
	local v8 = if getFFlagEnableGateNotificationPreferencesTab() then p2.getEnableNotificationPreferencesPage() else nil
	v7.enableNotificationPreferencesTab = v8
	return v7
end)(extended)

local v7 = RoactAppExperiment.connectUserLayer(
	{ appUserLayers.ParentalSpendControlsLayer },
	function(p2, p3)
		return {
			showParentalControls = (p2[appUserLayers.ParentalSpendControlsLayer] or {}).showParentalSpendControls
		}
	end
)(v6)

local v8 = RoactRodux.connect(function(data, p2)
	local morePageSettings = data.NotificationBadgeCounts.MorePageSettings
	return {
		formFactor = data.FormFactor,
		notificationCount = morePageSettings,
		screenSize = data.ScreenSize
	}
end, function(callback)
	return {
		setShowAgeVerificationOverlay = function(p2, p3, p4, p5)
			return callback(setShowAgeVerificationOverlay(p2, p3, p4, p5))
		end,
		setVoiceChatOptInStatus = function(p2)
			return callback(setVoiceChatOptInStatus(p2))
		end
	}
end)(v7)

local v9 = roactServices.connect({ appUpdateService = appUpdateService })(v8)

return function(options)
	local v10 = RobloxAppHooks.useUiModeInfo().uiMode == uiMode.TenFoot

	if module15 then
		local v11 = not useBillingTabVisibility().showBillingTab

		options = Cryo.Dictionary.join(options or {}, { hideBillingTabOverride = v11 })
	end

	if fFlagUnifyConsoleSettingsPage then
		local v11 = useAppPolicy(function(p2): boolean
			return not p2.getWebViewSupport()
		end)

		local v12 = useDesignTokens()

		local v13, v14 = ReactFocusNavigation.useDefaultFocusBehavior()
		local v15, v16 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()

		options = Cryo.Dictionary.join(options or {}, {
			disableWebViewSupport = v11,
			rowHeight = module2.MORE_PAGE_ROW_HEIGHT * v12.Stroke.Standard,
			defaultFocusRef = v13,
			containerRef = v14,
			setListDefaultFocus = v15,
			listContainerRef = v16
		})
	end

	local joined = options or {}
	local v11

	if module13 then
		v11 = useThemeBackground() ~= nil

		if v11 then
			joined = Cryo.Dictionary.join(joined, { hasThemeBackground = true })
		end
	end

	local v12 = module10()

	if defineFastFlag then
		local v13 = useAppPolicy(function(p2): boolean
			return not p2.getWebViewSupport()
		end)

		React.useEffect(function()
			if not v5 and v13 then
				v5 = true
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString)
			end
		end, { v13 })
	end

	if fFlagUnifyConsoleSettingsPage or not v10 then
		return React.createElement(v9, joined)
	end

	return React.createElement(module11, { itemList = v12, transparentBackground = v11 })
end
