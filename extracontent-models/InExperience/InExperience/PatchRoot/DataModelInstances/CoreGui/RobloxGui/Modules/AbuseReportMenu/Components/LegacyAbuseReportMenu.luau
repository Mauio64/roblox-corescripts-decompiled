local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")

local GuiService = game:GetService("GuiService")
local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local SafetyService = game:GetService("SafetyService")
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider

local ReportTypeSelector = require(AbuseReportMenu.Components.ReportTypeSelector)
local Constants = require(AbuseReportMenu.Components.Constants)
local ReportModes = Constants.ReportModes
local ReportTypes = Constants.ReportTypes
local SelectInSceneReportMenu = require(AbuseReportMenu.Components.SelectInSceneReportMenu)
local ReportPersonMenuItemsContainer = require(AbuseReportMenu.Components.Containers.ReportPersonMenuItemsContainer)
local ReportExperienceMenuItemsContainer = require(AbuseReportMenu.Components.Containers.ReportExperienceMenuItemsContainer)
local ReportAnythingAnalytics = require(AbuseReportMenu.ReportAnything.Utility.ReportAnythingAnalytics)
local ReportAbuseAnalytics = require(AbuseReportMenu.Analytics.ReportAbuseAnalytics)
local AnnotationModal = require(AbuseReportMenu.ReportAnything.Components.AnnotationModal)
local ModalBasedSelectorDialogController = require(AbuseReportMenu.Components.ModalBasedSelectorDialogController)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout

local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local Localization3 = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization3.Hooks.useLocalization
local useReportAnythingWithScreenshot = require(AbuseReportMenu.Hooks.useReportAnythingWithScreenshot)
local getMenuItemSizings = require(AbuseReportMenu.Utility.getMenuItemSizings)
local analyticsReducer = require(AbuseReportMenu.Reducers.analyticsReducer)
local createCleanup = require(AbuseReportMenu.Components.createCleanup)

local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local View = Foundation.View

local DsaIllegalContentReporting = require(CorePackages.Workspace.Packages.DsaIllegalContentReporting)
local isShowEUDSAIllegalContentReportingLink = DsaIllegalContentReporting.isShowEUDSAIllegalContentReportingLink
local DSAReportLink = DsaIllegalContentReporting.DSAReportLink
local isShowUKOSAIllegalContentReportingLink = DsaIllegalContentReporting.isShowUKOSAIllegalContentReportingLink
local OSAReportLink = DsaIllegalContentReporting.OSAReportLink
local isShowGenericIllegalContentReportingLink = DsaIllegalContentReporting.isShowGenericIllegalContentReportingLink
local GenericReportLink = DsaIllegalContentReporting.GenericReportLink
local getTakeItDownReportLinkVisibility = DsaIllegalContentReporting.getTakeItDownReportLinkVisibility
local TakeItDownReportLink = DsaIllegalContentReporting.TakeItDownReportLink

local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local isAbuseReportMenuOpenCloseSignalEnabled = require(AbuseReportMenu.Flags.isAbuseReportMenuOpenCloseSignalEnabled)

local FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay = require(AbuseReportMenu.Flags.FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringReportMenuIXPLayer = SharedFlags.FStringReportMenuIXPLayer
local FStringSelectInSceneIXPField = SharedFlags.FStringSelectInSceneIXPField
local FFlagHighlightModePreciseSelectionEnabled = SharedFlags.FFlagHighlightModePreciseSelectionEnabled
local FFlagHideShortcutsOnReportDropdown = require(AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)

local defineFastFlag = game:DefineFastFlag("AbuseReportTabClearCapturedScreenshotOnCloseFix", false)

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagMigrateAllOsaMessagingToCentralService = SharedFlags2.FFlagMigrateAllOsaMessagingToCentralService
local defineFastFlag2 = game:DefineFastFlag("IEMReportScrollingFix", false)
local FFlagReportFocusNavIEMButtons = require(AbuseReportMenu.Flags.FFlagReportFocusNavIEMButtons)
local FFlagIEMTabFocusNav = SharedFlags.FFlagIEMTabFocusNav
local FFlagAddTakeItDownReportLinkToSurfaces = SharedFlags.FFlagAddTakeItDownReportLinkToSurfaces

local isShowSelectInSceneReportMenu = require(AbuseReportMenu.Utility.isShowSelectInSceneReportMenu)

local InGameAssetReporting = require(CorePackages.Workspace.Packages.InGameAssetReporting)
local getHighlightModeVariant = InGameAssetReporting.getHighlightModeVariant

local UIBlox = require(CorePackages.Packages.UIBlox)
local SegmentedControl = UIBlox.App.Control.SegmentedControl

local v = { ReportModes.Classic, ReportModes.SelectInScene }
local v2 = { ReportTypes.Person, ReportTypes.Experience }

local function isInSelectInSceneExperiment()
	local success, result = pcall(function()
		return IXPService:GetUserLayerVariables(FStringReportMenuIXPLayer)
	end)

	if not success or not result or result[FStringSelectInSceneIXPField] == nil then
		return false
	end

	IXPService:LogUserLayerExposure(FStringReportMenuIXPLayer)
	return result[FStringSelectInSceneIXPField]
end

local function fn(props)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(1)
	local state3, setState3 = React.useState(1)
	local state4, setState4 = React.useState(nil)
	local state5, setState5 = React.useState(0)
	local state6, setState6 = React.useState(false)
	local state7, setState7 = React.useState(false)
	local state8, setState8 = React.useState(true)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local state9, setState9 = React.useState({ width = 0, height = 0 })
	local isSmallPortraitViewport

	if state9.width < state9.height then
		isSmallPortraitViewport = state9.width < 700
	else
		isSmallPortraitViewport = false
	end

	local analyticsState, analyticsDispatch = React.useReducer(analyticsReducer, Constants.AnalyticsInitialState)
	local v3 = v[state2]
	local v4 = v2[state3]
	local v5 = React.useCallback(createCleanup(analyticsState, analyticsDispatch, setState4, v4), {
		analyticsState,
		state3
	})

	local reportAnythingState, reportAnythingDispatch = useReportAnythingWithScreenshot(
		state,
		props.hideReportTab,
		props.showReportTab,
		v5
	)

	local menuItemSizings = getMenuItemSizings()
	local v6 = useTokens()

	local v7 = useLocalization(Constants.localizationKeys)

	React.useEffect(function()
		props.registerOnReportTabDisplayed(function()
			setState(true)

			if isAbuseReportMenuOpenCloseSignalEnabled() and reportAnythingState.screenshotContentId ~= "" then
				SafetyService:ReportMenuTabOpen()
			end
		end)
		props.registerOnReportTabHidden(function()
			setState(false)
			AnnotationModal.unmountAnnotationPage()

			ModalBasedSelectorDialogController.unmountModalSelector()

			if isAbuseReportMenuOpenCloseSignalEnabled() then
				SafetyService:ReportMenuTabClose()
			end
		end)
		props.registerSetNextPlayerToReport(function(p)
			setState4(p)
		end)
		props.registerOnMenuWidthChange(function(p)
			setState5(p)
		end)
		props.registerOnSettingsHidden(function()
			if defineFastFlag then
				setTimeout(function()
					if ReportAbuseAnalytics:getAbuseReportSessionEntryPoint() ~= "" then
						return
					end

					reportAnythingDispatch({ type = Constants.ReportAnythingActions.ClearAll })
				end, FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay)
			elseif ReportAbuseAnalytics:getAbuseReportSessionEntryPoint() == "" then
				reportAnythingDispatch({ type = Constants.ReportAnythingActions.ClearAll })
			end
		end)
	end, { reportAnythingState })

	React.useEffect(function()
		if state then
			if #Players:GetPlayers() <= 1 then
				setState6(true)
				setState3(2)
			else
				setState3(1)
				setState6(false)
			end
		else
			setState3(0)

			setState2(1)

			setState7(false)
		end
	end, { state })

	React.useEffect(function()
		if state then
			analyticsDispatch({
				type = Constants.AnalyticsActions.SetMenuOpenedTimestamp,
				timestamp = math.floor(workspace:GetServerTimeNow() * 1000)
			})

			ReportAbuseAnalytics:startAbuseReportSession("ReportPage")

			if isShowSelectInSceneReportMenu(analyticsDispatch) then
				local success, result = pcall(function()
					return IXPService:GetUserLayerVariables(FStringReportMenuIXPLayer)
				end)
				local v8

				if success and result and result[FStringSelectInSceneIXPField] ~= nil then
					IXPService:LogUserLayerExposure(FStringReportMenuIXPLayer)
					v8 = result[FStringSelectInSceneIXPField]
				else
					v8 = false
				end

				if v8 then
					setState7(true)
				end
			end
		end

		local currentCamera = game.Workspace.CurrentCamera

		if currentCamera ~= nil then
			local viewportSize = currentCamera.ViewportSize
			setState9({ width = viewportSize.X, height = viewportSize.Y })
			analyticsDispatch({
				type = Constants.AnalyticsActions.SetViewportInformation,
				viewportSizeX = viewportSize.X,
				viewportSizeY = viewportSize.Y
			})
		end
	end, { state, state5 })

	if FFlagReportFocusNavIEMButtons then
		React.useEffect(function()
			if not state then
				return
			end

			local function isMenuSelected() -- 2 equivalent calls inferred from this helper
				local getSettingsHubRef = props.getSettingsHubRef
				local v8 = getSettingsHubRef and getSettingsHubRef()
				local menuContainer = v8 and v8.MenuContainer
				return GuiService.SelectedCoreObject ~= nil
					and menuContainer ~= nil
					and GuiService.SelectedCoreObject:IsDescendantOf(menuContainer)
			end

			setState8(not isMenuSelected()) -- inferred equivalent call

			local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
				setState8(not isMenuSelected()) -- inferred equivalent call
			end)

			return function()
				selectedCoreObjectChangedConnection:Disconnect()
			end
		end, { state, props.getSettingsHubRef })
	end

	if FFlagIEMTabFocusNav then
		React.useEffect(function()
			if not state then
				return
			end

			local v8 = nil
			v8 = ref.current
				and ref.current.tabRefs
				and {
					ref.current.tabRefs[1].current:FindFirstChild("Tab"),
					ref.current.tabRefs[2].current:FindFirstChild("Tab")
				}
				or v8

			if props.setFirstSelectableObjects and v8 then
				props.setFirstSelectableObjects(v8)
			end
		end, { state, ref, props.setFirstSelectableObjects, state7 })
	end

	if not state then
		return nil
	end

	local menuItems = nil

	local utilityProps = {
		onReportComplete = props.onReportComplete,
		onDropdownMenuOpenChange = 0,
		reportAnythingAnalytics = 0,
		reportAnythingState = 0,
		reportAnythingDispatch = 0,
		hideReportTab = 0,
		isReportTabVisible = 0,
		showReportSentPage = 0,
		analyticsState = 0,
		analyticsDispatch = 0,
		preselectedPlayer = 0,
		setPreselectedPlayer = 0,
		menuWidth = 0,
		viewportDimension = 0,
		setLastSelectableObjects = 0
	}
	local onDropdownMenuOpenChange

	if FFlagHideShortcutsOnReportDropdown then
		onDropdownMenuOpenChange = props.onDropdownMenuOpenChange
	end

	utilityProps.onDropdownMenuOpenChange = onDropdownMenuOpenChange
	utilityProps.reportAnythingAnalytics = ReportAnythingAnalytics
	utilityProps.reportAnythingState = reportAnythingState
	utilityProps.reportAnythingDispatch = reportAnythingDispatch
	utilityProps.hideReportTab = props.hideReportTab
	utilityProps.isReportTabVisible = state
	utilityProps.showReportSentPage = props.showReportSentPage
	utilityProps.analyticsState = analyticsState
	utilityProps.analyticsDispatch = analyticsDispatch
	utilityProps.preselectedPlayer = state4
	utilityProps.setPreselectedPlayer = setState4
	utilityProps.menuWidth = state5
	utilityProps.viewportDimension = state9
	local setLastSelectableObjects

	if FFlagReportFocusNavIEMButtons then
		setLastSelectableObjects = props.setLastSelectableObjects
	end

	utilityProps.setLastSelectableObjects = setLastSelectableObjects

	if v4 == ReportTypes.Person then
		menuItems = React.createElement(ReportPersonMenuItemsContainer, {
			utilityProps = utilityProps,
			isSmallPortraitViewport = isSmallPortraitViewport
		})
	elseif v4 == ReportTypes.Experience then
		menuItems = React.createElement(ReportExperienceMenuItemsContainer, {
			utilityProps = utilityProps,
			isSmallPortraitViewport = isSmallPortraitViewport
		})
	end

	local createElement = React.createElement
	local v8 = {
		ref = ref2,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 0, menuItemSizings.TopPadding)
	}

	local createElement2 = React.createElement
	local v9 = {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView,
		frameProps = { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y },
		isIsolated = not defineFastFlag2 or nil,
		isAutoFocusRoot = not FFlagReportFocusNavIEMButtons or state8,
		shouldRestoreFocus = not FFlagReportFocusNavIEMButtons
	}

	local abuseReportMenuPlaceholderFrame = Constants.AbuseReportMenuPlaceholderFrame
	local createElement3 = React.createElement
	local v10 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0 }

	local createElement4 = React.createElement
	local v11 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v12 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = 0,
			Padding = UDim.new(0, 12)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, menuItemSizings.ItemPadding),
			PaddingBottom = UDim.new(0, menuItemSizings.ItemPadding)
		}),
		SelectInSceneToggleFrame = 0,
		Menu = 0
	}
	local selectInSceneToggleFrame

	if state7 then
		local createElement5 = React.createElement
		local v13 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			LayoutOrder = 0
		}

		local createElement6 = React.createElement
		local v14 = {
			onTabActivated = function(p)
				setState2(p)
			end,
			selectedTabIndex = state2,
			tabs = {
				{ tabName = v7.BuildAReport },
				{ tabName = v7.SelectInScene }
			},
			width = UDim.new(0, state5),
			ref = 0
		}
		local ref3

		if FFlagIEMTabFocusNav then
			ref3 = ref
		end

		v14.ref = ref3
		selectInSceneToggleFrame = createElement5("Frame", v13, {
			SelectInSceneToggle = createElement6(SegmentedControl, v14)
		})
	end

	v12.SelectInSceneToggleFrame = selectInSceneToggleFrame
	local menu

	if v3 == ReportModes.SelectInScene then
		local createElement5 = React.createElement
		local v13 = { hideReportTab = props.hideReportTab, variant = 0 }
		local variant

		if FFlagHighlightModePreciseSelectionEnabled then
			variant = getHighlightModeVariant()
		end

		v13.variant = variant
		menu = createElement5(SelectInSceneReportMenu, v13)
	elseif v3 == ReportModes.Classic then
		local createElement5 = React.createElement
		local v13 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 1
		}

		local v14 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, menuItemSizings.ItemPadding)
			}),
			ReportTypeSelector = React.createElement(ReportTypeSelector, {
				label = v7.ReportType,
				abuseType = v7[v2[state3]],
				layoutOrder = 0,
				utilityProps = utilityProps,
				isSelectionDisabled = state6,
				menuWidth = state5,
				isSmallPortraitViewport = isSmallPortraitViewport,
				onClickLeft = function()
					reportAnythingDispatch({
						type = Constants.ReportAnythingActions.ClearAnnotationFlowProperties
					})

					analyticsDispatch({
						type = Constants.AnalyticsActions.IncrementExperiencePersonChanged
					})

					setState3((state3 - 1 - 1) % #v2 + 1)
				end,
				onClickRight = function()
					reportAnythingDispatch({
						type = Constants.ReportAnythingActions.ClearAnnotationFlowProperties
					})

					analyticsDispatch({
						type = Constants.AnalyticsActions.IncrementExperiencePersonChanged
					})

					setState3((state3 - 1 + 1) % #v2 + 1)
				end
			}),
			MenuItemsContainer = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				},
				{ MenuItems = menuItems }
			),
			FooterFrame = 0,
			DSALinkFrame = 0,
			OSALinkFrame = 0,
			GenericIllegalContentReportLink = 0,
			TakeItDownReportLink = 0
		}

		local createElement6 = React.createElement

		local createElement7 = React.createElement

		local v15 = {
			Divider = React.createElement(View, {
				tag = "size-full-0 stroke-muted padding-top-medium",
				LayoutOrder = 1
			}),
			InfoText = 0
		}

		local createElement8 = React.createElement
		local text

		if isShowUKOSAIllegalContentReportingLink() then
			text = v7.FooterInformation2
		else
			text = v7.FooterInformation1
		end

		v15.InfoText = createElement8(Text, {
			Text = text,
			fontStyle = v6.Typography.BodySmall,
			textStyle = v6.Color.Content.Muted,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			tag = "auto-xy",
			LayoutOrder = 2
		})
		v14.FooterFrame = createElement6(View, { tag = "size-full-0 auto-y", LayoutOrder = 2 }, {
			TextFrame = createElement7(View, {
				tag = "size-full col align-x-left gap-small padding-top-medium"
			}, v15)
		})
		local dsaLinkFrame

		if not (FFlagMigrateAllOsaMessagingToCentralService or not isShowEUDSAIllegalContentReportingLink()) then
			dsaLinkFrame = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				},
				{
					DSALink = React.createElement(DSAReportLink)
				}
			)
		end

		v14.DSALinkFrame = dsaLinkFrame
		local osaLinkFrame

		if not (FFlagMigrateAllOsaMessagingToCentralService or not isShowUKOSAIllegalContentReportingLink()) then
			osaLinkFrame = React.createElement(View, { tag = "size-full-0 auto-y", LayoutOrder = 3 }, {
				OSALink = React.createElement(OSAReportLink)
			})
		end

		v14.OSALinkFrame = osaLinkFrame
		local genericIllegalContentReportLink

		if FFlagMigrateAllOsaMessagingToCentralService and isShowGenericIllegalContentReportingLink() then
			genericIllegalContentReportLink = React.createElement(
				View,
				{ tag = "size-full-0 auto-y", LayoutOrder = 3 },
				React.createElement(GenericReportLink)
			)
		end

		v14.GenericIllegalContentReportLink = genericIllegalContentReportLink
		local takeItDownReportLink

		if FFlagAddTakeItDownReportLinkToSurfaces and getTakeItDownReportLinkVisibility() then
			takeItDownReportLink = React.createElement(TakeItDownReportLink, { layoutOrder = 4 })
		end

		v14.TakeItDownReportLink = takeItDownReportLink
		menu = createElement5("Frame", v13, v14)
	end

	v12.Menu = menu
	return createElement("Frame", v8, {
		FocusNavigationCoreScriptsWrapper = createElement2(FocusRoot, v9, {
			[abuseReportMenuPlaceholderFrame] = createElement3("Frame", v10, {
				MenuLayoutFrame = createElement4("Frame", v11, v12)
			})
		})
	})
end

return function(p)
	local localization = Localization.new(LocalizationService.RobloxLocaleId)
	return React.createElement(CoreScriptsRootProvider, {}, {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = localization
		}, {
			[Constants.LegacyAbuseReportMenuRootName] = React.createElement(fn, p)
		})
	})
end
