local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local SafetyService = game:GetService("SafetyService")
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local CoreScriptsRootProvider = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).CoreScriptsRootProvider
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
local ChatModalSelectorDialogController = require(AbuseReportMenu.Components.ChatModalSelectorDialogController)
local ModalBasedSelectorDialogController = require(AbuseReportMenu.Components.ModalBasedSelectorDialogController)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local setTimeout = require(CorePackages.Packages.LuauPolyfill).setTimeout
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useReportAnythingWithScreenshot = require(AbuseReportMenu.Hooks.useReportAnythingWithScreenshot)
local getMenuItemSizings = require(AbuseReportMenu.Utility.getMenuItemSizings)
local analyticsReducer = require(AbuseReportMenu.Reducers.analyticsReducer)
local createCleanup = require(AbuseReportMenu.Components.createCleanup)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
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
local GetFFlagWHAM1707ExperimentForceEnabled = require(AbuseReportMenu.Flags.GetFFlagWHAM1707ExperimentForceEnabled)
local FStringWHAM1707IXPField = require(AbuseReportMenu.Flags.FStringWHAM1707IXPField)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringReportMenuIXPLayer = SharedFlags.FStringReportMenuIXPLayer
local FStringEARReportMenuIXPLayer = SharedFlags.FStringEARReportMenuIXPLayer
local FStringSelectInSceneIXPField = SharedFlags.FStringSelectInSceneIXPField
local FFlagHighlightModePreciseSelectionEnabled = SharedFlags.FFlagHighlightModePreciseSelectionEnabled
local FFlagHideShortcutsOnReportDropdown = require(AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)
local v56 = game:DefineFastFlag("AbuseReportTabClearCapturedScreenshotOnCloseFix", false)
local FFlagMigrateAllOsaMessagingToCentralService = require(CorePackages.Workspace.Packages.SharedFlags).FFlagMigrateAllOsaMessagingToCentralService
local v58 = game:DefineFastFlag("IEMReportScrollingFix", false)
local FFlagReportFocusNavIEMButtons = require(AbuseReportMenu.Flags.FFlagReportFocusNavIEMButtons)
local FFlagIEMTabFocusNav = SharedFlags.FFlagIEMTabFocusNav
local FFlagAddTakeItDownReportLinkToSurfaces = SharedFlags.FFlagAddTakeItDownReportLinkToSurfaces
local isShowSelectInSceneReportMenu = require(AbuseReportMenu.Utility.isShowSelectInSceneReportMenu)
local getHighlightModeVariant = require(CorePackages.Workspace.Packages.InGameAssetReporting).getHighlightModeVariant
local SegmentedControl = require(CorePackages.Packages.UIBlox).App.Control.SegmentedControl
local t1 = {
	ReportModes.Classic,
	ReportModes.SelectInScene
}
local t2 = {
	ReportTypes.Person,
	ReportTypes.Experience
}

local function isInSelectInSceneExperiment() -- line: 102
	-- upvalues: IXPService (copy), FStringReportMenuIXPLayer (copy), FStringSelectInSceneIXPField (copy)
	local ok, result = pcall(function() -- line: 104
		-- upvalues: IXPService (copy), FStringReportMenuIXPLayer (copy)
		return IXPService:GetUserLayerVariables(FStringReportMenuIXPLayer)
	end)

	if not ok or (not result or result[FStringSelectInSceneIXPField] == nil) then
		return false
	end

	IXPService:LogUserLayerExposure(FStringReportMenuIXPLayer)

	return result[FStringSelectInSceneIXPField]
end
local function isInWHAM1707Experiment() -- line: 116
	-- upvalues: GetFFlagWHAM1707ExperimentForceEnabled (copy), IXPService (copy), FStringEARReportMenuIXPLayer (copy), FStringWHAM1707IXPField (copy)
	if GetFFlagWHAM1707ExperimentForceEnabled() then
		return true
	end

	local ok, result = pcall(function() -- line: 122
		-- upvalues: IXPService (copy), FStringEARReportMenuIXPLayer (copy)
		return IXPService:GetUserLayerVariables(FStringEARReportMenuIXPLayer)
	end)

	if not ok or not result or result[FStringWHAM1707IXPField] == nil then
		return false
	end

	IXPService:LogUserLayerExposure(FStringEARReportMenuIXPLayer)

	return result[FStringWHAM1707IXPField]
end
local function v69(t3: {[any]: any}) -- line: 134
	-- upvalues: React (copy), analyticsReducer (copy), Constants (copy), t1 (copy), t2 (copy), createCleanup (copy), useReportAnythingWithScreenshot (copy), getMenuItemSizings (copy), useTokens (copy), useLocalization (copy), isAbuseReportMenuOpenCloseSignalEnabled (copy), isInWHAM1707Experiment (copy), SafetyService (copy), AnnotationModal (copy), ChatModalSelectorDialogController (copy), ModalBasedSelectorDialogController (copy), v56 (copy), setTimeout (copy), ReportAbuseAnalytics (copy), FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay (copy), Players (copy), isShowSelectInSceneReportMenu (copy), IXPService (copy), FStringReportMenuIXPLayer (copy), FStringSelectInSceneIXPField (copy), FFlagReportFocusNavIEMButtons (copy), GuiService (copy), FFlagIEMTabFocusNav (copy), FFlagHideShortcutsOnReportDropdown (copy), ReportAnythingAnalytics (copy), ReportTypes (copy), ReportPersonMenuItemsContainer (copy), ReportExperienceMenuItemsContainer (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), v58 (copy), SegmentedControl (copy), ReportModes (copy), SelectInSceneReportMenu (copy), FFlagHighlightModePreciseSelectionEnabled (copy), getHighlightModeVariant (copy), ReportTypeSelector (copy), View (copy), FoundationText (copy), isShowUKOSAIllegalContentReportingLink (copy), FFlagMigrateAllOsaMessagingToCentralService (copy), isShowEUDSAIllegalContentReportingLink (copy), DSAReportLink (copy), OSAReportLink (copy), isShowGenericIllegalContentReportingLink (copy), GenericReportLink (copy), FFlagAddTakeItDownReportLinkToSurfaces (copy), getTakeItDownReportLinkVisibility (copy), TakeItDownReportLink (copy)
	local v75, v76 = React.useState(false)
	local v77, v78 = React.useState(1)
	local v79, v80 = React.useState(1)
	local v81, v82 = React.useState(nil)
	local v83, v84 = React.useState(0)
	local v85, v86 = React.useState(false)
	local v87, v88 = React.useState(false)
	local v89, v90 = React.useState(true)
	local v91 = React.useRef(nil)
	local v92 = React.useRef(nil)
	local v93, v94 = React.useState({
		width = 0,
		height = 0
	})
	local v95 = v93.width < v93.height and v93.width < 700
	local v96, v97 = React.useReducer(analyticsReducer, Constants.AnalyticsInitialState)
	local v98 = t1[v77]
	local v99 = t2[v79]
	local v100 = React.useCallback(createCleanup(v96, v97, v82, v99), {
		v96,
		v79
	})
	local v101, v102 = useReportAnythingWithScreenshot(v75, t3.hideReportTab, t3.showReportTab, v100)
	local v103 = getMenuItemSizings()
	local v104 = useTokens()
	local v105 = useLocalization(Constants.localizationKeys)

	React.useEffect(function() -- line: 165
		-- upvalues: t3 (copy), v76 (copy), isAbuseReportMenuOpenCloseSignalEnabled (copy), isInWHAM1707Experiment (copy), v101 (copy), SafetyService (copy), AnnotationModal (copy), ChatModalSelectorDialogController (copy), ModalBasedSelectorDialogController (copy), v82 (copy), v84 (copy), v56 (copy), setTimeout (copy), ReportAbuseAnalytics (copy), v102 (copy), Constants (copy), FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay (copy)
		t3.registerOnReportTabDisplayed(function() -- line: 166
			-- upvalues: v76 (copy), isAbuseReportMenuOpenCloseSignalEnabled (copy), isInWHAM1707Experiment (copy), v101 (copy), SafetyService (copy)
			v76(true)

			if isAbuseReportMenuOpenCloseSignalEnabled() and (isInWHAM1707Experiment() and v101.screenshotContentId ~= "") then
				SafetyService:ReportMenuTabOpen()
			end
		end)
		t3.registerOnReportTabHidden(function() -- line: 175
			-- upvalues: v76 (copy), AnnotationModal (copy), ChatModalSelectorDialogController (copy), ModalBasedSelectorDialogController (copy), isAbuseReportMenuOpenCloseSignalEnabled (copy), isInWHAM1707Experiment (copy), SafetyService (copy)
			v76(false)
			AnnotationModal.unmountAnnotationPage()
			ChatModalSelectorDialogController.unmountModalSelector()
			ModalBasedSelectorDialogController.unmountModalSelector()

			if isAbuseReportMenuOpenCloseSignalEnabled() and isInWHAM1707Experiment() then
				SafetyService:ReportMenuTabClose()
			end
		end)
		t3.registerSetNextPlayerToReport(function(p1) -- line: 185
			-- upvalues: v82 (copy)
			v82(p1)
		end)
		t3.registerOnMenuWidthChange(function(p2) -- line: 188
			-- upvalues: v84 (copy)
			v84(p2)
		end)
		t3.registerOnSettingsHidden(function() -- line: 191
			-- upvalues: v56 (copy), setTimeout (copy), ReportAbuseAnalytics (copy), v102 (copy), Constants (copy), FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay (copy)
			if v56 then
				setTimeout(function() -- line: 198
					-- upvalues: ReportAbuseAnalytics (copy), v102 (copy), Constants (copy)
					if ReportAbuseAnalytics:getAbuseReportSessionEntryPoint() == "" then
						v102({
							type = Constants.ReportAnythingActions.ClearAll
						})

						return
					end
				end, FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay)

				return
			end

			if ReportAbuseAnalytics:getAbuseReportSessionEntryPoint() == "" then
				v102({
					type = Constants.ReportAnythingActions.ClearAll
				})
			end
		end)
	end, { v101 })
	React.useEffect(function() -- line: 216
		-- upvalues: v75 (copy), v80 (copy), v78 (copy), v88 (copy), Players (copy), v86 (copy)
		if not v75 then
			v80(0)
			v78(1)
			v88(false)

			return
		end

		if #Players:GetPlayers() <= 1 then
			v86(true)
			v80(2)

			return
		end

		v80(1)
		v86(false)
	end, { v75 })
	React.useEffect(function() -- line: 236
		-- upvalues: v75 (copy), v97 (copy), Constants (copy), ReportAbuseAnalytics (copy), isShowSelectInSceneReportMenu (copy), IXPService (copy), FStringReportMenuIXPLayer (copy), FStringSelectInSceneIXPField (copy), v88 (copy), v94 (copy)
		if v75 then
			v97({
				type = Constants.AnalyticsActions.SetMenuOpenedTimestamp,
				timestamp = math.floor(workspace:GetServerTimeNow() * 1000)
			})
			ReportAbuseAnalytics:startAbuseReportSession("ReportPage")

			if isShowSelectInSceneReportMenu(v97) then
				local ok, result = pcall(function() -- line: 104
					-- upvalues: IXPService (copy), FStringReportMenuIXPLayer (copy)
					return IXPService:GetUserLayerVariables(FStringReportMenuIXPLayer)
				end)
				local v112

				if not ok or not result or result[FStringSelectInSceneIXPField] == nil then
					v112 = false
				else
					IXPService:LogUserLayerExposure(FStringReportMenuIXPLayer)
					v112 = result[FStringSelectInSceneIXPField]
				end

				if v112 then
					v88(true)
				end
			end
		end

		local CurrentCamera = game.Workspace.CurrentCamera

		if CurrentCamera ~= nil then
			local ViewportSize = CurrentCamera.ViewportSize

			v94({
				width = ViewportSize.X,
				height = ViewportSize.Y
			})
			v97({
				type = Constants.AnalyticsActions.SetViewportInformation,
				viewportSizeX = ViewportSize.X,
				viewportSizeY = ViewportSize.Y
			})
		end
	end, {
		v75,
		v83
	})

	if FFlagReportFocusNavIEMButtons then
		React.useEffect(function() -- line: 270
			-- upvalues: v75 (copy), t3 (copy), GuiService (copy), v90 (copy)
			if not v75 then
				return
			end

			local function isMenuSelected() -- line: 275
				-- upvalues: t3 (copy), GuiService (copy)
				local getSettingsHubRef = t3.getSettingsHubRef
				local v126 = getSettingsHubRef and getSettingsHubRef()
				local v127 = v126 and v126.MenuContainer

				return GuiService.SelectedCoreObject ~= nil and (v127 ~= nil and GuiService.SelectedCoreObject:IsDescendantOf(v127))
			end

			local v116 = v90
			local getSettingsHubRef = t3.getSettingsHubRef
			local v118 = getSettingsHubRef and getSettingsHubRef()
			local v119 = v118 and v118.MenuContainer

			v116(not (GuiService.SelectedCoreObject ~= nil and (v119 ~= nil and GuiService.SelectedCoreObject:IsDescendantOf(v119))))

			local connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 286
				-- upvalues: v90 (copy), t3 (copy), GuiService (copy)
				local v128 = v90
				local getSettingsHubRef2 = t3.getSettingsHubRef
				local v130 = getSettingsHubRef2 and getSettingsHubRef2()
				local v131 = v130 and v130.MenuContainer

				v128(not (GuiService.SelectedCoreObject ~= nil and (v131 ~= nil and GuiService.SelectedCoreObject:IsDescendantOf(v131))))
			end)

			return function() -- line: 290
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, {
			v75,
			t3.getSettingsHubRef
		})
	end

	if FFlagIEMTabFocusNav then
		React.useEffect(function() -- line: 298
			-- upvalues: v75 (copy), v91 (copy), t3 (copy)
			if not v75 then
				return
			end

			local t4 = nil

			if v91.current and v91.current.tabRefs then
				t4 = {
					v91.current.tabRefs[1].current:FindFirstChild("Tab"),
					v91.current.tabRefs[2].current:FindFirstChild("Tab")
				}
			end

			if t3.setFirstSelectableObjects and t4 then
				t3.setFirstSelectableObjects(t4)
			end
		end, {
			v75,
			v91,
			t3.setFirstSelectableObjects,
			v87
		})
	end

	if not v75 then
		return nil
	end

	local v106 = nil
	local t5 = {
		onReportComplete = t3.onReportComplete,
		onDropdownMenuOpenChange = if not FFlagHideShortcutsOnReportDropdown then nil else t3.onDropdownMenuOpenChange,
		reportAnythingAnalytics = ReportAnythingAnalytics,
		reportAnythingState = v101,
		reportAnythingDispatch = v102,
		hideReportTab = t3.hideReportTab,
		isReportTabVisible = v75,
		showReportSentPage = t3.showReportSentPage,
		analyticsState = v96,
		analyticsDispatch = v97,
		preselectedPlayer = v81,
		setPreselectedPlayer = v82,
		menuWidth = v83,
		viewportDimension = v93,
		setLastSelectableObjects = if not FFlagReportFocusNavIEMButtons then nil else t3.setLastSelectableObjects
	}

	if v99 == ReportTypes.Person then
		v106 = React.createElement(ReportPersonMenuItemsContainer, {
			utilityProps = t5,
			isSmallPortraitViewport = v95
		})
	elseif v99 == ReportTypes.Experience then
		v106 = React.createElement(ReportExperienceMenuItemsContainer, {
			utilityProps = t5,
			isSmallPortraitViewport = v95
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v92,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 0, v103.TopPadding)
	}, {
		FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView,
			frameProps = {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			isIsolated = not v58 or nil,
			isAutoFocusRoot = not FFlagReportFocusNavIEMButtons or v89,
			shouldRestoreFocus = not FFlagReportFocusNavIEMButtons
		}, {
			[Constants.AbuseReportMenuPlaceholderFrame] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1)
			}, {
				MenuLayoutFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					Layout = React.createElement("UIListLayout", {
						HorizontalAlignment = 0,
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 12)
					}),
					Padding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v103.ItemPadding),
						PaddingBottom = UDim.new(0, v103.ItemPadding)
					}),
					SelectInSceneToggleFrame = if not v87 then nil else React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 0,
						AutomaticSize = Enum.AutomaticSize.XY,
						Position = UDim2.new(0.5, 0, 0, 0),
						AnchorPoint = Vector2.new(0.5, 0)
					}, {
						SelectInSceneToggle = React.createElement(SegmentedControl, {
							onTabActivated = function(p3) -- line: 402
								-- upvalues: v78 (copy)
								v78(p3)
							end,
							selectedTabIndex = v77,
							tabs = {
								{
									tabName = v105.BuildAReport
								},
								{
									tabName = v105.SelectInScene
								}
							},
							width = UDim.new(0, v83),
							ref = if not FFlagIEMTabFocusNav then nil else v91
						})
					}),
					Menu = if v98 ~= ReportModes.SelectInScene then if v98 ~= ReportModes.Classic then nil else React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0)
					}, {
						Layout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, v103.ItemPadding)
						}),
						ReportTypeSelector = React.createElement(ReportTypeSelector, {
							layoutOrder = 0,
							label = v105.ReportType,
							abuseType = v105[t2[v79]],
							utilityProps = t5,
							isSelectionDisabled = v85,
							menuWidth = v83,
							isSmallPortraitViewport = v95,
							onClickLeft = function() -- line: 445
								-- upvalues: v102 (copy), Constants (copy), v97 (copy), v80 (copy), v79 (copy), t2 (copy)
								v102({
									type = Constants.ReportAnythingActions.ClearAnnotationFlowProperties
								})
								v97({
									type = Constants.AnalyticsActions.IncrementExperiencePersonChanged
								})
								v80((v79 - 1 - 1) % #t2 + 1)
							end,
							onClickRight = function() -- line: 455
								-- upvalues: v102 (copy), Constants (copy), v97 (copy), v80 (copy), v79 (copy), t2 (copy)
								v102({
									type = Constants.ReportAnythingActions.ClearAnnotationFlowProperties
								})
								v97({
									type = Constants.AnalyticsActions.IncrementExperiencePersonChanged
								})
								v80((v79 - 1 + 1) % #t2 + 1)
							end
						}),
						MenuItemsContainer = React.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 0, 0)
						}, {
							MenuItems = v106
						}),
						FooterFrame = React.createElement(View, {
							tag = "size-full-0 auto-y",
							LayoutOrder = 2
						}, {
							TextFrame = React.createElement(View, {
								tag = "size-full col align-x-left gap-small padding-top-medium"
							}, {
								Divider = React.createElement(View, {
									tag = "size-full-0 stroke-muted padding-top-medium",
									LayoutOrder = 1
								}),
								InfoText = React.createElement(FoundationText, {
									TextWrapped = true,
									tag = "auto-xy",
									LayoutOrder = 2,
									Text = if not isShowUKOSAIllegalContentReportingLink() then v105.FooterInformation1 else v105.FooterInformation2,
									fontStyle = v104.Typography.BodySmall,
									textStyle = v104.Color.Content.Muted,
									TextXAlignment = Enum.TextXAlignment.Left
								})
							})
						}),
						DSALinkFrame = if FFlagMigrateAllOsaMessagingToCentralService or not isShowEUDSAIllegalContentReportingLink() then nil else React.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 0, 0)
						}, {
							DSALink = React.createElement(DSAReportLink)
						}),
						OSALinkFrame = if FFlagMigrateAllOsaMessagingToCentralService or not isShowUKOSAIllegalContentReportingLink() then nil else React.createElement(View, {
							tag = "size-full-0 auto-y",
							LayoutOrder = 3
						}, {
							OSALink = React.createElement(OSAReportLink)
						}),
						GenericIllegalContentReportLink = if not FFlagMigrateAllOsaMessagingToCentralService or not isShowGenericIllegalContentReportingLink() then nil else React.createElement(View, {
							tag = "size-full-0 auto-y",
							LayoutOrder = 3
						}, React.createElement(GenericReportLink)),
						TakeItDownReportLink = if not FFlagAddTakeItDownReportLinkToSurfaces or not getTakeItDownReportLinkVisibility() then nil else React.createElement(TakeItDownReportLink, {
							layoutOrder = 4
						})
					}) else React.createElement(SelectInSceneReportMenu, {
						hideReportTab = t3.hideReportTab,
						variant = if not FFlagHighlightModePreciseSelectionEnabled then nil else getHighlightModeVariant()
					})
				})
			})
		})
	})
end

return function(t6: {[any]: any}) -- line: 539
	-- upvalues: Localization (copy), LocalizationService (copy), React (copy), CoreScriptsRootProvider (copy), LocalizationProvider (copy), Constants (copy), v69 (copy)
	local v109 = Localization.new(LocalizationService.RobloxLocaleId)

	return React.createElement(CoreScriptsRootProvider, {}, {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = v109
		}, {
			[Constants.AbuseReportMenuRootName] = React.createElement(v69, t6)
		})
	})
end
