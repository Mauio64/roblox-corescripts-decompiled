local CoreGui = game:GetService("CoreGui")
local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local CoreScriptsCommon = require(InExperienceSideSheetParent.CoreScriptsCommon)
local Display = require(InExperienceSideSheetParent.Display)
local Drawer = require(InExperienceSideSheetParent.Drawer)
local FocusNavigationUtils = require(InExperienceSideSheetParent.FocusNavigationUtils)
local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)
local ReactRoblox = require(InExperienceSideSheetParent.ReactRoblox)
local Responsive = require(InExperienceSideSheetParent.Responsive)
local Signals = require(InExperienceSideSheetParent.Signals)
local SignalsReact = require(InExperienceSideSheetParent.SignalsReact)
local Divider = Foundation.Divider
local DrawerContainer = Drawer.DrawerContainer
local ExperienceDetailsRow = require(InExperienceSideSheet.Components.ExperienceDetailsRow)
local Footer = require(InExperienceSideSheet.Components.Footer)
local ScrollView = Foundation.ScrollView
local GridList = require(InExperienceSideSheet.Components.GridList)
local VerticalList = require(InExperienceSideSheet.Components.VerticalList)
local View = Foundation.View
local FocusRoot = FocusNavigationUtils.FocusRoot
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)
local useDrawerShouldMount = Drawer.Hooks.useDrawerShouldMount
local useTokens = Foundation.Hooks.useTokens
local useStyleSheet = Foundation.Hooks.useStyleSheet
local useBackgroundStyle = require(InExperienceSideSheet.Hooks.useBackgroundStyle)
local useSideSheetFocusNavScrollViewAnimation = require(InExperienceSideSheet.Hooks.useSideSheetFocusNavScrollViewAnimation)
local GetIntegrationsStore = require(InExperienceSideSheet.Stores.GetIntegrationsStore)
local GetSideSheetConfigStore = require(InExperienceSideSheet.Stores.GetSideSheetConfigStore)
local wrapWithProviders = require(InExperienceSideSheet.Utils.wrapWithProviders)
local getSideSheetVisibility = require(InExperienceSideSheet.Utils.getSideSheetVisibility)
local Flags = require(InExperienceSideSheet.Flags)
local SharedFlags = require(InExperienceSideSheetParent.SharedFlags)
local FFlagMountUnmountSideSheet = Flags.FFlagMountUnmountSideSheet
local FIntSideSheetVariant = SharedFlags.FIntSideSheetVariant
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav
local FFlagEnableWhatsNew = SharedFlags.FFlagEnableWhatsNew
local FFlagUseAnimateScrollViewToSelectionHelper = SharedFlags.FFlagUseAnimateScrollViewToSelectionHelper
local v40 = if not FFlagEnableWhatsNew then nil else require(InExperienceSideSheetParent.WhatsNew).WhatsNewAnchor
local t1 = {}
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local usePreferredInput = Responsive.usePreferredInput

local function getDeviceSafePadding(p1) -- line: 87
	-- upvalues: Display (copy)
	return Display.GetDisplayStore(p1).getDeviceSafePadding(p1)
end
local function getToggleIntegrations(p2) -- line: 91
	-- upvalues: GetIntegrationsStore (copy)
	return GetIntegrationsStore(p2).getToggleIntegrations(p2)
end
local function v47(p3) -- line: 95
	-- upvalues: GetIntegrationsStore (copy)
	return GetIntegrationsStore(p3).getPageIntegrations(p3)
end

local t2 = nil
local useFocusGuiObject = nil

if FFlagSideSheetFocusNav then
	t2 = {
		IntegrationsList = 0,
		PageList = 1
	}
	useFocusGuiObject = require(InExperienceSideSheetParent.ReactFocusNavigation).useFocusGuiObject
end

local u50 = nil

local function SideSheetContent(t3: {[any]: any}) -- line: 110
	-- upvalues: useTokens (copy), useStyleSheet (copy), useBackgroundStyle (copy), SignalsReact (copy), getDeviceSafePadding (copy), FFlagMountUnmountSideSheet (copy), useDrawerShouldMount (copy), getToggleIntegrations (copy), React (copy), SidesheetAnalytics (copy), FFlagSideSheetFocusNav (copy), useFocusGuiObject (ref), GetSideSheetConfigStore (copy), usePreferredInput (copy), Signals (copy), getSideSheetVisibility (copy), Responsive (copy), MouseIconOverrideService (copy), FFlagUseAnimateScrollViewToSelectionHelper (copy), useSideSheetFocusNavScrollViewAnimation (copy), FIntSideSheetVariant (copy), t2 (ref), ExperienceDetailsRow (copy), View (copy), Divider (copy), GridList (copy), VerticalList (copy), v47 (copy), ScrollView (copy), Footer (copy), FFlagEnableWhatsNew (copy), v40 (copy), DrawerContainer (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v56 = useTokens()
	local v57 = useStyleSheet()
	local v58 = useBackgroundStyle()
	local v59 = SignalsReact.useSignalState(getDeviceSafePadding)
	local v60 = not FFlagMountUnmountSideSheet or useDrawerShouldMount()
	local v61 = SignalsReact.useSignalState(getToggleIntegrations)
	local v62 = React.useCallback(function(p4) -- line: 118
		-- upvalues: SidesheetAnalytics (copy)
		SidesheetAnalytics.logSidesheetClosed(p4.source)
	end, {})
	local u63 = nil
	local v64 = nil

	if FFlagSideSheetFocusNav then
		u63 = useFocusGuiObject()
		v64 = React.useCallback(function(p5) -- line: 125
			-- upvalues: u63 (ref)
			u63(p5)
		end, { u63 })
	end

	local v65 = if not FFlagSideSheetFocusNav then nil else React.useRef(nil)
	local v66 = React.useCallback(function(p6) -- line: 132
		-- upvalues: GetSideSheetConfigStore (copy)
		return GetSideSheetConfigStore().onHeightChanged(p6.AbsoluteSize.Y)
	end, {})
	local v67 = React.useRef(false)
	local v68 = React.useRef(false)
	local v69 = usePreferredInput()

	React.useEffect(function() -- line: 140
		-- upvalues: Signals (copy), getSideSheetVisibility (copy), t3 (copy), v67 (copy), v69 (copy), Responsive (copy), v68 (copy), MouseIconOverrideService (copy)
		local v82 = Signals.createEffect(function(p7) -- line: 141
			-- upvalues: getSideSheetVisibility (copy), t3 (copy), v67 (copy), v69 (copy), Responsive (copy), v68 (copy), MouseIconOverrideService (copy)
			local v85 = getSideSheetVisibility(p7)

			if t3.ChatSelector then
				if v85 then
					v67.current = t3.ChatSelector:GetVisibility()
					t3.ChatSelector:SetVisible(false)
				elseif v67.current then
					t3.ChatSelector:SetVisible(true)
					v67.current = false
				end
			end

			if v69 == Responsive.Input.Pointer then
				if v85 and not v68.current then
					MouseIconOverrideService.push("InExperienceSideSheet", Enum.OverrideMouseIconBehavior.ForceShow)
					v68.current = true

					return
				end

				if not v85 and v68.current then
					MouseIconOverrideService.pop("InExperienceSideSheet")
					v68.current = false
				end
			end
		end)
		local u83 = nil

		if t3.ChatSelector then
			u83 = t3.ChatSelector.VisibilityStateChanged:connect(function(p8) -- line: 169
				-- upvalues: getSideSheetVisibility (copy), v67 (copy)
				if getSideSheetVisibility() and p8 then
					v67.current = false
				end
			end)
		end

		return function() -- line: 176
			-- upvalues: v82 (copy), u83 (ref)
			v82()

			if u83 ~= nil then
				u83:disconnect()
			end
		end
	end, {
		t3.ChatSelector,
		v69
	})

	local v70 = if not FFlagSideSheetFocusNav or not FFlagUseAnimateScrollViewToSelectionHelper then nil else useSideSheetFocusNavScrollViewAnimation()
	local v71 = nil

	if FFlagSideSheetFocusNav then
		v71 = if FIntSideSheetVariant ~= 2 and not (#v61 <= 0) then t2.IntegrationsList else t2.PageList
	end

	if not v60 then
		return nil
	end

	local t4 = {
		ExperienceDetailsRow = React.createElement(ExperienceDetailsRow, {
			layoutOrder = 0
		}),
		HeaderDivider = React.createElement(View, {
			tag = "size-full-0 auto-y padding-right-xlarge",
			LayoutOrder = 1
		}, {
			Divider = React.createElement(Divider)
		}),
		IntegrationsList = if not (#v61 <= 0) then if FIntSideSheetVariant ~= 0 then React.createElement(VerticalList, {
			layoutOrder = FIntSideSheetVariant ~= 2 and 2 or 4,
			integrationsGetter = getToggleIntegrations,
			firstIntegrationToFocusCallback = if not FFlagSideSheetFocusNav or v71 ~= t2.IntegrationsList then nil else v64
		}) else React.createElement(GridList, {
			layoutOrder = 2,
			integrationsGetter = getToggleIntegrations,
			firstIntegrationToFocusCallback = if not FFlagSideSheetFocusNav or v71 ~= t2.IntegrationsList then nil else v64
		}) else nil,
		PageDivider = if not (#v61 > 0) then nil else React.createElement(View, {
			tag = "size-full-0 auto-y padding-right-xlarge",
			LayoutOrder = 3
		}, {
			Divider = React.createElement(Divider)
		}),
		PageList = React.createElement(VerticalList, {
			layoutOrder = FIntSideSheetVariant ~= 2 and 4 or 2,
			integrationsGetter = v47,
			firstIntegrationToFocusCallback = if not FFlagSideSheetFocusNav or v71 ~= t2.PageList then nil else v64
		})
	}
	local v73 = React.createElement(View, {
		tag = "col size-full",
		onAbsoluteSizeChanged = v66,
		ref = if not FFlagSideSheetFocusNav then nil else v65
	}, {
		ScrollableContent = React.createElement(ScrollView, {
			tag = "fill size-full-0",
			LayoutOrder = 1,
			scroll = {
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 0)
			},
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			},
			selection = if not FFlagSideSheetFocusNav then nil else {
				Selectable = false
			},
			scrollingFrameRef = if not FFlagSideSheetFocusNav or not FFlagUseAnimateScrollViewToSelectionHelper then nil else v70
		}, t4),
		Footer = React.createElement(Footer, {
			layoutOrder = 2
		})
	})

	if FFlagEnableWhatsNew then
		v73 = React.createElement(v40, {
			anchorId = "sideSheet",
			tag = "size-full"
		}, {
			SideSheetPanel = v73
		})
	end

	return React.createElement(DrawerContainer, {
		displayOrder = 12,
		scrimIsModal = true,
		menuWidth = 300 - v56.Padding.XLarge,
		leftOffset = v59.left + v56.Padding.XLarge,
		topOffset = v59.top,
		bottomOffset = v59.bottom,
		backgroundStyle = v58,
		onDrawerClosedAnalytics = v62
	}, {
		FoundationStyleLink = React.createElement("StyleLink", {
			StyleSheet = v57
		}),
		if not FFlagSideSheetFocusNav then v73 else React.createElement(FocusRoot, {
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, {
			Content = v73
		})
	})
end

function t1.createSideSheet(p9, t5: {[any]: any}, p10) -- line: 311
	-- upvalues: u50 (ref), CoreGui (copy), wrapWithProviders (copy), React (copy), SideSheetContent (copy), ReactRoblox (copy)
	if not u50 then
		local Folder = Instance.new("Folder")

		Folder.Name = "InExperienceSideSheet"
		Folder.Parent = CoreGui

		local v78 = wrapWithProviders({
			SideSheetContent = React.createElement(SideSheetContent, t5)
		}, p9, p10)

		u50 = ReactRoblox.createRoot(Folder)
		u50:render(v78)
	end

	return u50
end

return t1
