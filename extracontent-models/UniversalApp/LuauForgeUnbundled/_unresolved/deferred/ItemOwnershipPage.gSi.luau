local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useProperty = require("@luauforge/bundled/fyQ").useProperty
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useMostRecentFocusBehavior = ReactFocusNavigation.useMostRecentFocusBehavior
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useRedirectFocusIntoGuiObject = AvatarExperienceCommon.Hooks.useRedirectFocusIntoGuiObject

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local images = UIBlox.App.ImageSet.Images
local verticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local useStyle = UIBlox.Core.Style.useStyle

local module3 = require("@luauforge/deferred/gQK")
local module4 = require("@luauforge/bundled/dPU")
local module5 = require("@luauforge/bundled/fvR")
local module6 = require("@luauforge/deferred/gSj")
local module7 = require("@luauforge/deferred/fCG")

local module8 = require("@luauforge/bundled/fCt")
local module9 = require("@luauforge/bundled/gxM")
local module10 = require("@luauforge/bundled/eie")
local module11 = require("@luauforge/bundled/egx")
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Models/CollectibleInstance")
local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed
require("@luauforge/bundled/dPs")
local module12 = require("@luauforge/bundled/ehL")
local useFocusNavigableSurfaceRegistryConnection = module12.useFocusNavigableSurfaceRegistryConnection
local focusNavigableSurfaceIdentifierEnum = module12.FocusNavigableSurfaceIdentifierEnum

local module13 = require("@luauforge/bundled/dVl")
local module14 = require("@luauforge/deferred/gOY")

local module15 = require("@luauforge/bundled/dKz")
local fFlagAppIaScrollAway = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIaScrollAway
local module16 = require("@luauforge/deferred/gSb")

local iconsactionsinfo_small = images["icons/actions/info_small"]

local function ItemOwnershipPage(p2)
	local params = p2.navigation.state.params
	local v5 = useStyle()

	local v6 = useSelector(function(p3)
		return p3.LocalUserId
	end)

	local v7 = useSelector(function(p3)
		return p3.AvatarExperience.Catalog.UserAssets
	end)

	local v8 = useSelector(function(p3)
		return p3.AvatarExperience.Catalog.Sell.AvailableToSellAssets[params.itemId]
	end, getUseSelectorDeepEquals())

	local v9 = useSelector(function(p3)
		return p3.AvatarExperience.Catalog.Sell.CurrentlySellingAssets[params.itemId]
	end, getUseSelectorDeepEquals())

	local v10 = useSelector(function(p3)
		return itemData(p3.AvatarExperience.Common, params.itemId, params.itemType)
	end, getUseSelectorDeepEquals())

	local collectibleItemId = params.collectibleItemId
	local isResellable = module13.IsResellable(v10)

	local v11 = useSelector(function(p3)
		if not isResellable then
			return {}
		end

		if params.collectibleItemId then
			return p3.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[params.collectibleItemId]
		end

		return {}
	end, getUseSelectorDeepEquals())

	local v13 = useSelector(React.useCallback(function(p3)
		if collectibleItemId then
			return p3.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[collectibleItemId]
		end

		return nil
	end, { collectibleItemId }), getUseSelectorDeepEquals())

	if useAppPolicy(function(p3)
		return p3.getDisableResellingCollectiblesForCompliance()
	end) and v13 then
		v13.resaleRestriction = module4.ResaleRestriction.Disabled
	end

	local v14 = useSelector(function(p3): boolean
		local user = p3.Users[p3.LocalUserId]
		local membership = if user then user.membership else nil
		return membership ~= nil and membership ~= Enum.MembershipType.None
	end, getUseSelectorDeepEquals())

	local v15 = module10(module11)
	local v16 = useDispatch()
	React.useEffect(function()
		if params.collectibleItemId then
			v16(module8(v15, params.collectibleItemId, v6))
		else
			v16(module7(v15, params.itemId, v6))
		end
	end, {})

	local sellItemPeekView = avatarScreen.SellItemPeekView

	local v17 = React.useCallback(function(p3)
		if v14 then
			p2.navigation.navigate(sellItemPeekView, {
				itemId = params.itemId,
				itemType = params.itemType,
				collectibleItemId = collectibleItemId,
				userAssetId = p3
			})
		else
			p2.navigation.navigate(avatarScreen.PremiumSellOnlyPrompt)
		end
	end, { params.itemId, params.itemType, params.collectibleItemId, collectibleItemId })

	local v18 = React.useCallback(function()
		logOnOverlayClosed("ItemOwnershipPage", (wasLastInputGamepad()))
	end)

	local v19 = React.useCallback(function(p3)
		local navigate = p2.navigation.navigate
		local removeCurrentlySellingItemPrompt = avatarScreen.RemoveCurrentlySellingItemPrompt
		local v20 = {
			itemId = params.itemId,
			collectibleItemId = params.collectibleItemId,
			userAssetId = p3,
			onOverlayClosed = 0
		}

		local v21 = if module14() then v18 else nil
		v20.onOverlayClosed = v21
		navigate(removeCurrentlySellingItemPrompt, v20)
	end, { p2.navigation, params.itemId, params.collectibleItemId, v18 })

	local v20 = React.useCallback(function(p3, p4)
		if p4 then
			v19(p3)
		else
			v17(p3)
		end
	end)

	local name = if v10 then v10.name else nil

	local v21 = React.useCallback(function(list, items, p3)
		if items == nil then
			return
		end

		for k, serialNumber in items do
			local v22 = v7[serialNumber]

			if not v22 then
				continue
			end

			local v23 = if v22.serialNumber then "#" .. v22.serialNumber else name
			local priceInRobux = if p3 then v22.priceInRobux else nil
			local v24 = if not p3 then v22.isOnHold else nil
			local v25 = {
				id = serialNumber,
				title = v23,
				salePrice = priceInRobux,
				isOnHold = v24,
				isOnSale = p3,
				order = 0
			}

			if v22.serialNumber then
				serialNumber = v22.serialNumber
			end

			v25.order = serialNumber
			table.insert(list, v25)
		end
	end, { v7 })

	local v22 = if v13 then v13.resaleRestriction else module4.ResaleRestriction.None

	local v23 = false

	local v24 = {}

	if collectibleItemId then
		if v11 then
			for k, v25 in v11 do
				v23 = v25.isHeld and true or v23

				local v26 = {
					id = v25.collectibleInstanceId,
					title = 0,
					salePrice = 0,
					isOnHold = 0,
					isOnSale = 0,
					order = 0
				}
				local v27 = if v25.serialNumber then "#" .. v25.serialNumber else v13 and v13.name or "N/A"
				v26.title = v27

				local v28 = if v25.saleState == "OnSale" then v25.price else nil
				v26.salePrice = v28
				v26.isOnHold = v25.isHeld
				v26.isOnSale = v25.saleState == "OnSale"
				v26.order = not v25.serialNumber and 0 or v25.serialNumber
				table.insert(v24, v26)
			end
		end
	else
		v21(v24, v9, true)
		v21(v24, v8, false)

		for k, v26 in v24 do
			if v26.isOnHold then
				v23 = true
				break
			end
		end
	end

	table.sort(v24, function(a, b): boolean
		return a.order < b.order
	end)

	if v22 == module4.ResaleRestriction.Disabled then
		v23 = false
	end

	local v25 = useNavigation()
	local v26 = module9({
		headerText = {
			"Feature.Catalog.Label.ItemOwnedCount",
			itemCount = #v24
		},
		holdingMessageText = "Feature.Catalog.Label.ItemInAHold",
		holdingPromptTitleText = "Feature.Catalog.Heading.HoldingPolicy",
		holdingPromptBodyText = params.collectibleItemId and {
			"Feature.Catalog.Message.HoldingPolicyL2",
			purchaseDays = 30,
			resaleDays = 7
		} or {
			"Feature.Catalog.Message.HoldingPolicyL1",
			days = 7
		},
		holdingPromptButtonText = "Feature.Avatar.Action.GotIt"
	})

	local function onHoldingPolicyButtonActivated(p3, p4)
		v25.navigate(avatarScreen.GenericPrompt, {
			titleText = v26.holdingPromptTitleText,
			bodyText = v26.holdingPromptBodyText,
			buttonText = v26.holdingPromptButtonText
		})
	end

	local textSize = getTextSize(
		v26.holdingMessageText,
		v5.Font.BaseSize * v5.Font.SubHeader1.RelativeSize,
		v5.Tokens.Typography.TitleLarge.Font,
		Vector2.new(10000, 10000)
	)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v27 = useProperty(ref, "AbsoluteSize") or nil
	local v28 = useProperty(ref2, "AbsoluteSize") or nil

	local v29 = if module16 then useSelector(module5.selectTopBarHeight) else nil

	local v30 = 0

	if v27 == nil or v28 == nil then
		if v27 ~= nil then
			v30 = v27.Y - 24
		end
	else
		v30 = v27.Y - v28.Y - 24
	end

	if module16 and fFlagAppIaScrollAway and module15.getScrollAwayEnabled() then
		v30 -= v29
	end

	local ref4 = React.useRef(nil)

	useFocusNavigableSurfaceRegistryConnection(
		ref4.current,
		focusNavigableSurfaceIdentifierEnum.CentralOverlay
	)
	local ref5 = React.useRef(nil)

	useRedirectFocusIntoGuiObject(ref5)

	local v32 = useTableWrappedCallbackRef((useMostRecentFocusBehavior(ref5)))

	local tileRestrictionsMap = if v10 then v10.tileRestrictionsMap else nil

	local createElement = React.createElement
	local createElement2 = React.createElement
	local v36 = not module14() and "Frame" or focusable.Frame
	local v37 = {
		ref = ref4,
		SelectionGroup = true,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		BackgroundColor3 = v5.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v5.Theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		defaultChild = 0,
		restorePreviousChildFocus = 0,
		Active = true
	}
	local v38 = if module14() then ref3 else nil
	v37.defaultChild = v38
	v37.restorePreviousChildFocus = module14() and true or nil

	local v39 = {
		TopBar = React.createElement(module5.Container, {
			ZIndex = 2,
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = v26.headerText,
			leftItem = module5.BackButton
		}),
		Contents = 0
	}

	local createElement3 = React.createElement
	local pageContent = module5.PageContent

	local createElement4 = React.createElement
	local v43 = {
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ref = ref
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = 0,
		ScrollView = 0,
		HoldingPolicyInfoContainer = 0
	}

	local createElement5 = React.createElement

	local v46 = if module16 and fFlagAppIaScrollAway and module15.getScrollAwayEnabled() then UDim.new(0, v29) else nil
	children.Padding = createElement5("UIPadding", {
		PaddingTop = v46,
		PaddingBottom = UDim.new(0, 24)
	})

	local createElement6 = React.createElement
	local v48 = {
		useAutomaticCanvasSize = true,
		canvasSizeY = UDim.new(1, 0),
		size = UDim2.new(1, 0, 0, v30),
		Selectable = false,
		ref = v32
	}

	local v49 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 24),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", { PaddingBottom = UDim.new(0, 24) }),
		ItemsList = 0
	}
	local v50

	if #v24 > 0 then
		local createElement7 = React.createElement
		local v52 = {
			itemsOnSale = true,
			itemId = params.itemId,
			itemType = params.itemType,
			restrictionTypes = tileRestrictionsMap,
			onItemActivated = v20,
			resaleRestriction = v22,
			items = v24,
			layoutOrder = 1,
			ref = 0
		}

		if not module14() then
			ref3 = nil
		end

		v52.ref = ref3
		v50 = createElement7(module6, v52)
	else
		v50 = false
	end

	v49.ItemsList = v50
	children.ScrollView = createElement6(verticalScrollViewWithMargin, v48, v49)

	if v23 then
		v23 = React.createElement("Frame", {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			ref = ref2
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0)
			}),
			Padding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 24) }),
			HoldingPromptTextButton = React.createElement("TextButton", {
				LayoutOrder = 1,
				Text = v26.holdingMessageText,
				FontFace = normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font),
				Size = UDim2.new(0, textSize.X, 0, textSize.Y),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextSize = v5.Font.BaseSize * v5.Font.SubHeader1.RelativeSize,
				TextColor3 = v5.Theme.TextEmphasis.Color,
				TextTransparency = v5.Theme.TextEmphasis.Transparency,
				BackgroundTransparency = 1,
				Selectable = false,
				[React.Event.Activated] = onHoldingPolicyButtonActivated
			}),
			HoldingPromptIconButton = React.createElement(iconButton, {
				layoutOrder = 2,
				icon = iconsactionsinfo_small,
				iconSize = iconSize.Small,
				iconColor3 = v5.Theme.IconEmphasis.Color,
				iconTransparency = v5.Theme.IconEmphasis.Transparency,
				backgroundTransparency = 1,
				onActivated = onHoldingPolicyButtonActivated
			})
		})
	end

	children.HoldingPolicyInfoContainer = v23
	v39.Contents = createElement3(pageContent, { ZIndex = 2 }, {
		PageContentFrame = createElement4("Frame", v43, children)
	})
	return createElement(module3, {}, { Background = createElement2(v36, v37, v39) })
end

return ItemOwnershipPage
