local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useProperty = require(CorePackages.Workspace.Packages.GuiObjectUtils).useProperty
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useMostRecentFocusBehavior = require(CorePackages.Packages.ReactFocusNavigation).useMostRecentFocusBehavior
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useTableWrappedCallbackRef = AvatarExperienceCommon.Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useRedirectFocusIntoGuiObject = AvatarExperienceCommon.Hooks.useRedirectFocusIntoGuiObject
local UIBlox = require(CorePackages.Packages.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local VerticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local useStyle = UIBlox.Core.Style.useStyle
local CenteredModalView = require(Modules.AvatarExperience.Common.Components.CenteredModalView)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local OwnedItemList = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemOwnershipPage.OwnedItemList)
local FetchSellPageData = require(Modules.AvatarExperience.Catalog.Thunks.FetchSellPageData)
local FetchCollectibleResellableInstances = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibleResellableInstances)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen

require(Modules.AvatarExperience.Common.Models.CollectibleInstance)

local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed
local Text = require(Modules.Common.Text)

require(Modules.AvatarExperience.Common.Types)

local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local GetFFlagL2ControllerSupport = require(Modules.AvatarExperience.Flags.GetFFlagL2ControllerSupport)
local FFlagAXMigrateItemOwnershipSellPagesInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateItemOwnershipSellPagesInputBindingsToFocusNavigation
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v45 = FFlagAXMigrateAXToGlobalAutofocus and game:DefineFastFlag("AXMigrateItemOwnerShipPageToAutofocus", false)
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local FFlagAppIaScrollAway = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppIaScrollAway
local FFlagAXFixScrollAwayTopBarOverlap = require(Modules.AvatarExperience.Flags.FFlagAXFixScrollAwayTopBarOverlap)
local v49 = Images["icons/actions/info_small"]

local function ItemOwnershipPage(t1: {[any]: any}) -- line: 83
	-- upvalues: useStyle (copy), useSelector (copy), getUseSelectorDeepEquals (copy), ItemData (copy), CatalogUtils (copy), React (copy), useAppPolicy (copy), CatalogConstants (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), FetchCollectibleResellableInstances (copy), FetchSellPageData (copy), AvatarScreen (copy), wasLastInputGamepad (copy), logOnOverlayClosed (copy), GetFFlagL2ControllerSupport (copy), useNavigation (copy), useLocalization (copy), Text (copy), useProperty (copy), FFlagAXFixScrollAwayTopBarOverlap (copy), TopBar (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), v45 (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), useRedirectFocusIntoGuiObject (copy), useMostRecentFocusBehavior (copy), useTableWrappedCallbackRef (copy), CenteredModalView (copy), Focusable (copy), FFlagAXMigrateItemOwnershipSellPagesInputBindingsToFocusNavigation (copy), NavigationUtils (copy), GamepadFocusHandlerForPage (copy), VerticalScrollViewWithMargin (copy), OwnedItemList (copy), IconButton (copy), v49 (copy), IconSize (copy)
	local params = t1.navigation.state.params
	local v53 = useStyle()
	local v54 = useSelector(function(p1) -- line: 87
		return p1.LocalUserId
	end)
	local v55 = useSelector(function(p2) -- line: 91
		return p2.AvatarExperience.Catalog.UserAssets
	end)
	local v56 = useSelector(function(p3) -- line: 95
		-- upvalues: params (copy)
		return p3.AvatarExperience.Catalog.Sell.AvailableToSellAssets[params.itemId]
	end, getUseSelectorDeepEquals())
	local v57 = useSelector(function(p4) -- line: 99
		-- upvalues: params (copy)
		return p4.AvatarExperience.Catalog.Sell.CurrentlySellingAssets[params.itemId]
	end, getUseSelectorDeepEquals())
	local v58 = useSelector(function(p5) -- line: 103
		-- upvalues: ItemData (copy), params (copy)
		return ItemData(p5.AvatarExperience.Common, params.itemId, params.itemType)
	end, getUseSelectorDeepEquals())
	local collectibleItemId = params.collectibleItemId
	local v60 = CatalogUtils.IsResellable(v58)
	local v61 = useSelector(function(p6) -- line: 111
		-- upvalues: v60 (copy), params (copy)
		if not v60 then
			return {}
		end

		if params.collectibleItemId then
			return p6.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[params.collectibleItemId]
		end

		return {}
	end, getUseSelectorDeepEquals())
	local v62 = React.useCallback(function(p7) -- line: 123
		-- upvalues: collectibleItemId (copy)
		if collectibleItemId then
			return p7.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[collectibleItemId]
		end

		return nil
	end, { collectibleItemId })
	local v63 = useSelector(v62, getUseSelectorDeepEquals())

	if useAppPolicy(function(p8) -- line: 130
		return p8.getDisableResellingCollectiblesForCompliance()
	end) and v63 then
		v63.resaleRestriction = CatalogConstants.ResaleRestriction.Disabled
	end

	local v64 = useSelector(function(p9) -- line: 137
		local v107 = p9.Users[p9.LocalUserId]
		local v108 = if not v107 then nil else v107.membership

		return v108 ~= nil and v108 ~= Enum.MembershipType.None
	end, getUseSelectorDeepEquals())
	local v65 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useRootFocusController() else nil
	local v66 = useRoactService(RoactNetworking)
	local v67 = useDispatch()

	React.useEffect(function() -- line: 146
		-- upvalues: params (copy), v67 (copy), FetchCollectibleResellableInstances (copy), v66 (copy), v54 (copy), FetchSellPageData (copy)
		if params.collectibleItemId then
			v67(FetchCollectibleResellableInstances(v66, params.collectibleItemId, v54))

			return
		end

		v67(FetchSellPageData(v66, params.itemId, v54))
	end, {})

	local SellItemPeekView = AvatarScreen.SellItemPeekView
	local v69 = React.useCallback(function(p10) -- line: 157
		-- upvalues: v64 (copy), t1 (copy), AvatarScreen (copy), SellItemPeekView (copy), params (copy), collectibleItemId (copy)
		if not v64 then
			t1.navigation.navigate(AvatarScreen.PremiumSellOnlyPrompt)

			return
		end

		t1.navigation.navigate(SellItemPeekView, {
			itemId = params.itemId,
			itemType = params.itemType,
			collectibleItemId = collectibleItemId,
			userAssetId = p10
		})
	end, {
		params.itemId,
		params.itemType,
		params.collectibleItemId,
		collectibleItemId
	})
	local v70 = React.useCallback(function() -- line: 178
		-- upvalues: wasLastInputGamepad (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v65 (copy)
		local v110 = wasLastInputGamepad()

		logOnOverlayClosed("ItemOwnershipPage", v110)

		if not FFlagAXMigrateAXToGlobalAutofocus and v110 then
			v65.captureFocus()
		end
	end)
	local v71 = React.useCallback(function(p11) -- line: 188
		-- upvalues: t1 (copy), AvatarScreen (copy), params (copy), GetFFlagL2ControllerSupport (copy), v70 (copy)
		t1.navigation.navigate(AvatarScreen.RemoveCurrentlySellingItemPrompt, {
			itemId = params.itemId,
			collectibleItemId = params.collectibleItemId,
			userAssetId = p11,
			onOverlayClosed = if not GetFFlagL2ControllerSupport() then nil else v70
		})
	end, {
		t1.navigation,
		params.itemId,
		params.collectibleItemId,
		v70
	})
	local v72 = React.useCallback(function(p12, p13) -- line: 204
		-- upvalues: v71 (copy), v69 (copy)
		if p13 then
			v71(p12)

			return
		end

		v69(p12)
	end)
	local v73 = if not v58 then nil else v58.name
	local v74 = React.useCallback(function(p14, p15, p16) -- line: 215
		-- upvalues: v55 (copy), v73 (copy)
		if p15 == nil then
			return
		end

		for _, v118 in p15 do
			local v119 = v55[v118]

			if v119 then
				local v120 = if not v119.serialNumber then v73 else "#" .. v119.serialNumber
				local v121 = if not p16 then nil else v119.priceInRobux
				local v122 = if not p16 then v119.isOnHold else nil

				table.insert(p14, {
					id = v118,
					title = v120,
					salePrice = v121,
					isOnHold = v122,
					isOnSale = p16,
					order = if not v119.serialNumber then v118 else v119.serialNumber
				})
			end
		end
	end, { v55 })
	local v75 = if not v63 then CatalogConstants.ResaleRestriction.None else v63.resaleRestriction
	local v76 = false
	local t2 = {}

	if collectibleItemId then
		if v61 then
			for _, v79 in v61 do
				if v79.isHeld then
					v76 = true
				end

				table.insert(t2, {
					id = v79.collectibleInstanceId,
					title = if not v79.serialNumber then v63 and v63.name or "N/A" else "#" .. v79.serialNumber,
					salePrice = if v79.saleState ~= "OnSale" then nil else v79.price,
					isOnHold = v79.isHeld,
					isOnSale = v79.saleState == "OnSale",
					order = not v79.serialNumber and 0 or v79.serialNumber
				})
			end
		end
	else
		v74(t2, v57, true)
		v74(t2, v56, false)

		for _, v81 in t2 do
			if v81.isOnHold then
				v76 = true

				break
			end
		end
	end

	table.sort(t2, function(p17, p18) -- line: 274
		return p17.order < p18.order
	end)

	if v75 == CatalogConstants.ResaleRestriction.Disabled then
		v76 = false
	end

	local v82 = useNavigation()
	local v83 = useLocalization({
		holdingMessageText = "Feature.Catalog.Label.ItemInAHold",
		holdingPromptTitleText = "Feature.Catalog.Heading.HoldingPolicy",
		holdingPromptButtonText = "Feature.Avatar.Action.GotIt",
		headerText = {
			"Feature.Catalog.Label.ItemOwnedCount",
			itemCount = #t2
		},
		holdingPromptBodyText = if not params.collectibleItemId then {
			"Feature.Catalog.Message.HoldingPolicyL1",
			days = 7
		} else {
			"Feature.Catalog.Message.HoldingPolicyL2",
			purchaseDays = 30,
			resaleDays = 7
		}
	})

	local function onHoldingPolicyButtonActivated(_, _) -- line: 300
		-- upvalues: v82 (copy), AvatarScreen (copy), v83 (copy)
		v82.navigate(AvatarScreen.GenericPrompt, {
			titleText = v83.holdingPromptTitleText,
			bodyText = v83.holdingPromptBodyText,
			buttonText = v83.holdingPromptButtonText
		})
	end

	local v85 = Text.GetTextBounds(v83.holdingMessageText, v53.Font.SubHeader1.Font, v53.Font.BaseSize * v53.Font.SubHeader1.RelativeSize, Vector2.new(10000, 10000))
	local v86 = React.useRef(nil)
	local v87 = React.useRef(nil)
	local v88 = React.useRef(nil)
	local v89 = useProperty(v86, "AbsoluteSize") or nil
	local v90 = useProperty(v87, "AbsoluteSize") or nil
	local v91 = nil

	if FFlagAXFixScrollAwayTopBarOverlap then
		v91 = useSelector(TopBar.selectTopBarHeight)
	end

	local n1 = 0

	if v89 ~= nil and v90 ~= nil then
		n1 = v89.Y - v90.Y - 24
	elseif v89 ~= nil then
		n1 = v89.Y - 24
	end

	if FFlagAXFixScrollAwayTopBarOverlap and FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled() then
		n1 -= v91
	end

	local v93 = nil
	local v94 = nil

	if v45 then
		v94 = React.useRef(nil)
		useFocusNavigableSurfaceRegistryConnection(v94.current, FocusNavigableSurfaceIdentifierEnum.CentralOverlay)

		local v95 = React.useRef(nil)

		useRedirectFocusIntoGuiObject(v95)

		local v96 = useMostRecentFocusBehavior(v95)

		v93 = useTableWrappedCallbackRef(v96)
	end

	local v97 = if not v58 then nil else v58.tileRestrictionsMap

	return React.createElement(CenteredModalView, {}, {
		Background = React.createElement(not GetFFlagL2ControllerSupport() and "Frame" or Focusable.Frame, {
			BorderSizePixel = 0,
			Active = true,
			ref = if not v45 then nil else v94,
			SelectionGroup = not not v45 or nil,
			SelectionBehaviorLeft = if not v45 then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = if not v45 then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = if not v45 then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = if not v45 then nil else Enum.SelectionBehavior.Stop,
			BackgroundColor3 = v53.Theme.BackgroundDefault.Color,
			BackgroundTransparency = v53.Theme.BackgroundDefault.Transparency,
			Size = UDim2.fromScale(1, 1),
			focusController = if not FFlagAXMigrateAXToGlobalAutofocus then if not GetFFlagL2ControllerSupport() then nil else v65 else nil,
			defaultChild = if not GetFFlagL2ControllerSupport() then nil else v88,
			restorePreviousChildFocus = not not GetFFlagL2ControllerSupport() or nil,
			inputBindings = if FFlagAXMigrateItemOwnershipSellPagesInputBindingsToFocusNavigation or not GetFFlagL2ControllerSupport() then nil else {
				NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 387
					-- upvalues: NavigationUtils (copy), v82 (copy)
					NavigationUtils.closeFocusedScreen(v82)
				end)
			}
		}, {
			GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then GetFFlagL2ControllerSupport() and React.createElement(GamepadFocusHandlerForPage, {
				captureFocusOnMount = true,
				focusController = v65
			}) else nil,
			TopBar = React.createElement(TopBar.Container, {
				ZIndex = 2,
				titleText = v83.headerText,
				leftItem = TopBar.BackButton
			}),
			Contents = React.createElement(TopBar.PageContent, {
				ZIndex = 2
			}, {
				PageContentFrame = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ref = v86
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Bottom,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Padding = React.createElement("UIPadding", {
						PaddingTop = if not FFlagAXFixScrollAwayTopBarOverlap or (not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled()) then nil else UDim.new(0, v91),
						PaddingBottom = UDim.new(0, 24)
					}),
					ScrollView = React.createElement(VerticalScrollViewWithMargin, {
						useAutomaticCanvasSize = true,
						canvasSizeY = UDim.new(1, 0),
						size = UDim2.new(1, 0, 0, n1),
						Selectable = not v45 and nil,
						ref = if not v45 then nil else v93
					}, {
						ListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							Padding = UDim.new(0, 24),
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						Padding = React.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, 24)
						}),
						ItemsList = #t2 > 0 and React.createElement(OwnedItemList, {
							itemsOnSale = true,
							layoutOrder = 1,
							itemId = params.itemId,
							itemType = params.itemType,
							restrictionTypes = v97,
							onItemActivated = v72,
							resaleRestriction = v75,
							items = t2,
							ref = if not GetFFlagL2ControllerSupport() then nil else v88
						})
					}),
					HoldingPolicyInfoContainer = v76 and React.createElement("Frame", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.fromScale(1, 0),
						ref = v87
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 0)
						}),
						Padding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 24)
						}),
						HoldingPromptTextButton = React.createElement("TextButton", {
							LayoutOrder = 1,
							Text = v83.holdingMessageText,
							Font = v53.Font.SubHeader1.Font,
							Size = UDim2.new(0, v85.X, 0, v85.Y),
							TextXAlignment = Enum.TextXAlignment.Center,
							TextSize = v53.Font.BaseSize * v53.Font.SubHeader1.RelativeSize,
							TextColor3 = v53.Theme.TextEmphasis.Color,
							TextTransparency = v53.Theme.TextEmphasis.Transparency,
							BackgroundTransparency = 1,
							Selectable = not v45 and nil,
							[React.Event.Activated] = onHoldingPolicyButtonActivated
						}),
						HoldingPromptIconButton = React.createElement(IconButton, {
							layoutOrder = 2,
							backgroundTransparency = 1,
							icon = v49,
							iconSize = IconSize.Small,
							iconColor3 = v53.Theme.IconEmphasis.Color,
							iconTransparency = v53.Theme.IconEmphasis.Transparency,
							onActivated = onHoldingPolicyButtonActivated
						})
					})
				})
			})
		})
	})
end

return ItemOwnershipPage
