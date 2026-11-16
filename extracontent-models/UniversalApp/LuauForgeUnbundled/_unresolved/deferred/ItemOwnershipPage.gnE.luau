local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useProperty = require("@luauforge/bundled/frw").useProperty
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad
local compositionTags = require("@luauforge/bundled/gns").CompositionTags
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
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local images = UIBlox.App.ImageSet.Images
local verticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local useStyle = UIBlox.Core.Style.useStyle

local module3 = require("@luauforge/deferred/gmf")
local module4 = require("@luauforge/bundled/dME")
local module5 = require("@luauforge/bundled/fox")
local module6 = require("@luauforge/deferred/gnF")
local module7 = require("@luauforge/deferred/fvf")

local module8 = require("@luauforge/bundled/fuS")
local module9 = require("@luauforge/bundled/fTi")
local module10 = require("@luauforge/bundled/eeH")
local module11 = require("@luauforge/bundled/eda")
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Models/CollectibleInstance")
local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed
local module12 = require("@luauforge/bundled/fpF")
require("@luauforge/bundled/dMc")
local module13 = require("@luauforge/bundled/eeo")
local useFocusNavigableSurfaceRegistryConnection = module13.useFocusNavigableSurfaceRegistryConnection
local focusNavigableSurfaceIdentifierEnum = module13.FocusNavigableSurfaceIdentifierEnum

local module14 = require("@luauforge/bundled/dRQ")
local module15 = require("@luauforge/deferred/gks")

local module16 = require("@luauforge/bundled/dHu")
local fFlagAppIaScrollAway = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIaScrollAway
local module17 = require("@luauforge/deferred/gnx")

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
	local isResellable = module14.IsResellable(v10)

	local v11 = useSelector(function(p3)
		if not isResellable then
			return {}
		end

		if params.collectibleItemId then
			return p3.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[params.collectibleItemId]
		end

		return {}
	end, getUseSelectorDeepEquals())

	local v12 = useSelector(React.useCallback(function(p3)
		if collectibleItemId then
			return p3.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[collectibleItemId]
		end

		return nil
	end, { collectibleItemId }), getUseSelectorDeepEquals())

	if useAppPolicy(function(p3)
		return p3.getDisableResellingCollectiblesForCompliance()
	end) and v12 then
		v12.resaleRestriction = module4.ResaleRestriction.Disabled
	end

	local v13 = useSelector(function(p3): boolean
		local user = p3.Users[p3.LocalUserId]
		local membership = if user then user.membership else nil
		return membership ~= nil and membership ~= Enum.MembershipType.None
	end, getUseSelectorDeepEquals())

	local v14 = module10(module11)
	local v15 = useDispatch()
	React.useEffect(function()
		if params.collectibleItemId then
			v15(module8(v14, params.collectibleItemId, v6))
		else
			v15(module7(v14, params.itemId, v6))
		end
	end, {})

	local sellItemPeekView = avatarScreen.SellItemPeekView

	local v16 = React.useCallback(function(p3)
		if v13 then
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

	local v17 = React.useCallback(function()
		logOnOverlayClosed("ItemOwnershipPage", (wasLastInputGamepad()))
	end)

	local v18 = React.useCallback(function(p3)
		local navigate = p2.navigation.navigate
		local removeCurrentlySellingItemPrompt = avatarScreen.RemoveCurrentlySellingItemPrompt
		local v19 = {
			itemId = params.itemId,
			collectibleItemId = params.collectibleItemId,
			userAssetId = p3,
			onOverlayClosed = 0
		}

		local v20 = if module15() then v17 else nil
		v19.onOverlayClosed = v20
		navigate(removeCurrentlySellingItemPrompt, v19)
	end, { p2.navigation, params.itemId, params.collectibleItemId, v17 })

	local v19 = React.useCallback(function(p3, p4)
		if p4 then
			v18(p3)
		else
			v16(p3)
		end
	end)

	local name = if v10 then v10.name else nil

	local v20 = React.useCallback(function(list, items, p3)
		if items == nil then
			return
		end

		for k, serialNumber in items do
			local v21 = v7[serialNumber]

			if not v21 then
				continue
			end

			local v22 = if v21.serialNumber then "#" .. v21.serialNumber else name
			local priceInRobux = if p3 then v21.priceInRobux else nil
			local v23 = if not p3 then v21.isOnHold else nil
			local v24 = {
				id = serialNumber,
				title = v22,
				salePrice = priceInRobux,
				isOnHold = v23,
				isOnSale = p3,
				order = 0
			}

			if v21.serialNumber then
				serialNumber = v21.serialNumber
			end

			v24.order = serialNumber
			table.insert(list, v24)
		end
	end, { v7 })

	local v21 = if v12 then v12.resaleRestriction else module4.ResaleRestriction.None

	local v22 = false

	local v23 = {}

	if collectibleItemId then
		if v11 then
			for k, v24 in v11 do
				v22 = v24.isHeld and true or v22

				local v25 = {
					id = v24.collectibleInstanceId,
					title = 0,
					salePrice = 0,
					isOnHold = 0,
					isOnSale = 0,
					order = 0
				}
				local v26 = if v24.serialNumber then "#" .. v24.serialNumber else v12 and v12.name or "N/A"
				v25.title = v26

				local v27 = if v24.saleState == "OnSale" then v24.price else nil
				v25.salePrice = v27
				v25.isOnHold = v24.isHeld
				v25.isOnSale = v24.saleState == "OnSale"
				v25.order = not v24.serialNumber and 0 or v24.serialNumber
				table.insert(v23, v25)
			end
		end
	else
		v20(v23, v9, true)
		v20(v23, v8, false)

		for k, v25 in v23 do
			if v25.isOnHold then
				v22 = true
				break
			end
		end
	end

	table.sort(v23, function(a, b): boolean
		return a.order < b.order
	end)

	if v21 == module4.ResaleRestriction.Disabled then
		v22 = false
	end

	local v24 = useNavigation()
	local v25 = module9({
		headerText = {
			"Feature.Catalog.Label.ItemOwnedCount",
			itemCount = #v23
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
		v24.navigate(avatarScreen.GenericPrompt, {
			titleText = v25.holdingPromptTitleText,
			bodyText = v25.holdingPromptBodyText,
			buttonText = v25.holdingPromptButtonText
		})
	end

	local v26

	if foundationFontFaceMigration then
		v26 = getTextSize(
			v25.holdingMessageText,
			v5.Font.BaseSize * v5.Font.SubHeader1.RelativeSize,
			v5.Tokens.Typography.TitleLarge.Font,
			Vector2.new(10000, 10000)
		)
	else
		v26 = module12.GetTextBounds(
			v25.holdingMessageText,
			v5.Font.SubHeader1.Font,
			v5.Font.BaseSize * v5.Font.SubHeader1.RelativeSize,
			Vector2.new(10000, 10000)
		)
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v27 = useProperty(ref, "AbsoluteSize") or nil
	local v28 = useProperty(ref2, "AbsoluteSize") or nil

	local v29 = if module17 then useSelector(module5.selectTopBarHeight) else nil

	local v30 = 0

	if v27 == nil or v28 == nil then
		if v27 ~= nil then
			v30 = v27.Y - 24
		end
	else
		v30 = v27.Y - v28.Y - 24
	end

	if module17 and fFlagAppIaScrollAway and module16.getScrollAwayEnabled() then
		v30 -= v29
	end

	local ref4 = React.useRef(nil)

	useFocusNavigableSurfaceRegistryConnection(
		ref4.current,
		focusNavigableSurfaceIdentifierEnum.CentralOverlay
	)
	local ref5 = React.useRef(nil)

	useRedirectFocusIntoGuiObject(ref5)

	local v31 = useTableWrappedCallbackRef((useMostRecentFocusBehavior(ref5)))

	local tileRestrictionsMap = if v10 then v10.tileRestrictionsMap else nil

	local createElement = React.createElement
	local createElement2 = React.createElement
	local v35 = not module15() and "Frame" or focusable.Frame
	local v36 = {
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
	local v37 = if module15() then ref3 else nil
	v36.defaultChild = v37
	v36.restorePreviousChildFocus = module15() and true or nil

	local v38 = {
		TopBar = React.createElement(module5.Container, {
			ZIndex = 2,
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = v25.headerText,
			leftItem = module5.BackButton
		}),
		Contents = 0
	}

	local createElement3 = React.createElement
	local pageContent = module5.PageContent

	local createElement4 = React.createElement
	local v42 = {
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

	local v45 = if module17 and fFlagAppIaScrollAway and module16.getScrollAwayEnabled() then UDim.new(0, v29) else nil
	children.Padding = createElement5("UIPadding", {
		PaddingTop = v45,
		PaddingBottom = UDim.new(0, 24)
	})

	local createElement6 = React.createElement
	local v47 = {
		useAutomaticCanvasSize = true,
		canvasSizeY = UDim.new(1, 0),
		size = UDim2.new(1, 0, 0, v30),
		Selectable = false,
		ref = v31
	}

	local v48 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 24),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", { PaddingBottom = UDim.new(0, 24) }),
		ItemsList = 0
	}
	local v49

	if #v23 > 0 then
		local createElement7 = React.createElement
		local v51 = {
			itemsOnSale = true,
			itemId = params.itemId,
			itemType = params.itemType,
			restrictionTypes = tileRestrictionsMap,
			onItemActivated = v19,
			resaleRestriction = v21,
			items = v23,
			layoutOrder = 1,
			ref = 0
		}

		if not module15() then
			ref3 = nil
		end

		v51.ref = ref3
		v49 = createElement7(module6, v51)
	else
		v49 = false
	end

	v48.ItemsList = v49
	children.ScrollView = createElement6(verticalScrollViewWithMargin, v47, v48)

	if v22 then
		local createElement7 = React.createElement
		local v51 = {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			ref = ref2
		}

		local children2 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0)
			}),
			Padding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 24) }),
			HoldingPromptTextButton = 0,
			HoldingPromptIconButton = 0
		}

		local createElement8 = React.createElement
		local onHoldingPolicyButtonActivatedsByActivated = {}
		onHoldingPolicyButtonActivatedsByActivated.LayoutOrder = 1
		onHoldingPolicyButtonActivatedsByActivated.Text = v25.holdingMessageText
		local v53 = if not foundationFontFaceMigration then v5.Font.SubHeader1.Font else nil
		onHoldingPolicyButtonActivatedsByActivated.Font = v53

		local v54 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font) else nil
		onHoldingPolicyButtonActivatedsByActivated.FontFace = v54

		onHoldingPolicyButtonActivatedsByActivated.Size = UDim2.new(0, v26.X, 0, v26.Y)
		onHoldingPolicyButtonActivatedsByActivated.TextXAlignment = Enum.TextXAlignment.Center
		onHoldingPolicyButtonActivatedsByActivated.TextSize = v5.Font.BaseSize * v5.Font.SubHeader1.RelativeSize
		onHoldingPolicyButtonActivatedsByActivated.TextColor3 = v5.Theme.TextEmphasis.Color
		onHoldingPolicyButtonActivatedsByActivated.TextTransparency = v5.Theme.TextEmphasis.Transparency
		onHoldingPolicyButtonActivatedsByActivated.BackgroundTransparency = 1
		onHoldingPolicyButtonActivatedsByActivated.Selectable = false
		onHoldingPolicyButtonActivatedsByActivated[React.Event.Activated] = onHoldingPolicyButtonActivated
		children2.HoldingPromptTextButton = createElement8(
			"TextButton",
			onHoldingPolicyButtonActivatedsByActivated
		)

		children2.HoldingPromptIconButton = React.createElement(iconButton, {
			layoutOrder = 2,
			icon = iconsactionsinfo_small,
			iconSize = iconSize.Small,
			iconColor3 = v5.Theme.IconEmphasis.Color,
			iconTransparency = v5.Theme.IconEmphasis.Transparency,
			backgroundTransparency = 1,
			onActivated = onHoldingPolicyButtonActivated
		})
		v22 = createElement7("Frame", v51, children2)
	end

	children.HoldingPolicyInfoContainer = v22
	v38.Contents = createElement3(pageContent, { ZIndex = 2 }, {
		PageContentFrame = createElement4("Frame", v42, children)
	})
	return createElement(module3, {}, { Background = createElement2(v35, v36, v38) })
end

return ItemOwnershipPage
