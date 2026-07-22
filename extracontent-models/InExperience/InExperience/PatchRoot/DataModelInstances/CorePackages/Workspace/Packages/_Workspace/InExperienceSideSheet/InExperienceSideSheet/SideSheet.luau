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
local v38 = if not FFlagEnableWhatsNew then nil else require(InExperienceSideSheetParent.WhatsNew).WhatsNewAnchor
local t1 = {}
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local usePreferredInput = Responsive.usePreferredInput

local function getDeviceSafePadding(p1) -- line: 85
	-- upvalues: Display (copy)
	return Display.GetDisplayStore(p1).getDeviceSafePadding(p1)
end
local function getToggleIntegrations(p2) -- line: 89
	-- upvalues: GetIntegrationsStore (copy)
	return GetIntegrationsStore(p2).getToggleIntegrations(p2)
end
local function v45(p3) -- line: 93
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

local u48 = nil

local function SideSheetContent(t3: {[any]: any}) -- line: 108
	-- upvalues: useTokens (copy), useStyleSheet (copy), useBackgroundStyle (copy), SignalsReact (copy), getDeviceSafePadding (copy), FFlagMountUnmountSideSheet (copy), useDrawerShouldMount (copy), getToggleIntegrations (copy), React (copy), SidesheetAnalytics (copy), FFlagSideSheetFocusNav (copy), useFocusGuiObject (ref), GetSideSheetConfigStore (copy), usePreferredInput (copy), Signals (copy), getSideSheetVisibility (copy), Responsive (copy), MouseIconOverrideService (copy), FIntSideSheetVariant (copy), t2 (ref), ExperienceDetailsRow (copy), View (copy), Divider (copy), GridList (copy), VerticalList (copy), v45 (copy), ScrollView (copy), Footer (copy), FFlagEnableWhatsNew (copy), v38 (copy), DrawerContainer (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v54 = useTokens()
	local v55 = useStyleSheet()
	local v56 = useBackgroundStyle()
	local v57 = SignalsReact.useSignalState(getDeviceSafePadding)
	local v58 = not FFlagMountUnmountSideSheet or useDrawerShouldMount()
	local v59 = SignalsReact.useSignalState(getToggleIntegrations)
	local v60 = React.useCallback(function(p4) -- line: 116
		-- upvalues: SidesheetAnalytics (copy)
		SidesheetAnalytics.logSidesheetClosed(p4.source)
	end, {})
	local u61 = nil
	local v62 = nil

	if FFlagSideSheetFocusNav then
		u61 = useFocusGuiObject()
		v62 = React.useCallback(function(p5) -- line: 123
			-- upvalues: u61 (ref)
			u61(p5)
		end, { u61 })
	end

	local v63 = if not FFlagSideSheetFocusNav then nil else React.useRef(nil)
	local v64 = React.useCallback(function(p6) -- line: 130
		-- upvalues: GetSideSheetConfigStore (copy)
		return GetSideSheetConfigStore().onHeightChanged(p6.AbsoluteSize.Y)
	end, {})
	local v65 = React.useRef(false)
	local v66 = React.useRef(false)
	local v67 = usePreferredInput()

	React.useEffect(function() -- line: 138
		-- upvalues: Signals (copy), getSideSheetVisibility (copy), t3 (copy), v65 (copy), v67 (copy), Responsive (copy), v66 (copy), MouseIconOverrideService (copy)
		local v79 = Signals.createEffect(function(p7) -- line: 139
			-- upvalues: getSideSheetVisibility (copy), t3 (copy), v65 (copy), v67 (copy), Responsive (copy), v66 (copy), MouseIconOverrideService (copy)
			local v82 = getSideSheetVisibility(p7)

			if t3.ChatSelector then
				if v82 then
					v65.current = t3.ChatSelector:GetVisibility()
					t3.ChatSelector:SetVisible(false)
				elseif v65.current then
					t3.ChatSelector:SetVisible(true)
					v65.current = false
				end
			end

			if v67 == Responsive.Input.Pointer then
				if v82 and not v66.current then
					MouseIconOverrideService.push("InExperienceSideSheet", Enum.OverrideMouseIconBehavior.ForceShow)
					v66.current = true

					return
				end

				if not v82 and v66.current then
					MouseIconOverrideService.pop("InExperienceSideSheet")
					v66.current = false
				end
			end
		end)
		local u80 = nil

		if t3.ChatSelector then
			u80 = t3.ChatSelector.VisibilityStateChanged:connect(function(p8) -- line: 167
				-- upvalues: getSideSheetVisibility (copy), v65 (copy)
				if getSideSheetVisibility() and p8 then
					v65.current = false
				end
			end)
		end

		return function() -- line: 174
			-- upvalues: v79 (copy), u80 (ref)
			v79()

			if u80 ~= nil then
				u80:disconnect()
			end
		end
	end, {
		t3.ChatSelector,
		v67
	})

	local v68 = nil

	if FFlagSideSheetFocusNav then
		v68 = if FIntSideSheetVariant ~= 2 and not (#v59 <= 0) then t2.IntegrationsList else t2.PageList
	end

	if not v58 then
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
		IntegrationsList = if not (#v59 <= 0) then if FIntSideSheetVariant ~= 0 then React.createElement(VerticalList, {
			layoutOrder = FIntSideSheetVariant ~= 2 and 2 or 4,
			integrationsGetter = getToggleIntegrations,
			firstIntegrationToFocusCallback = if not FFlagSideSheetFocusNav or v68 ~= t2.IntegrationsList then nil else v62
		}) else React.createElement(GridList, {
			layoutOrder = 2,
			integrationsGetter = getToggleIntegrations,
			firstIntegrationToFocusCallback = if not FFlagSideSheetFocusNav or v68 ~= t2.IntegrationsList then nil else v62
		}) else nil,
		PageDivider = if not (#v59 > 0) then nil else React.createElement(View, {
			tag = "size-full-0 auto-y padding-right-xlarge",
			LayoutOrder = 3
		}, {
			Divider = React.createElement(Divider)
		}),
		PageList = React.createElement(VerticalList, {
			layoutOrder = FIntSideSheetVariant ~= 2 and 4 or 2,
			integrationsGetter = v45,
			firstIntegrationToFocusCallback = if not FFlagSideSheetFocusNav or v68 ~= t2.PageList then nil else v62
		})
	}
	local v70 = React.createElement(View, {
		tag = "col size-full",
		onAbsoluteSizeChanged = v64,
		ref = if not FFlagSideSheetFocusNav then nil else v63
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
			}
		}, t4),
		Footer = React.createElement(Footer, {
			layoutOrder = 2
		})
	})

	if FFlagEnableWhatsNew then
		v70 = React.createElement(v38, {
			anchorId = "sideSheet",
			tag = "size-full"
		}, {
			SideSheetPanel = v70
		})
	end

	return React.createElement(DrawerContainer, {
		displayOrder = 12,
		scrimIsModal = true,
		menuWidth = 300 - v54.Padding.XLarge,
		leftOffset = v57.left + v54.Padding.XLarge,
		topOffset = v57.top,
		bottomOffset = v57.bottom,
		backgroundStyle = v56,
		onDrawerClosedAnalytics = v60
	}, {
		FoundationStyleLink = React.createElement("StyleLink", {
			StyleSheet = v55
		}),
		if not FFlagSideSheetFocusNav then v70 else React.createElement(FocusRoot, {
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, {
			Content = v70
		})
	})
end

function t1.createSideSheet(p9, t5: {[any]: any}, p10) -- line: 302
	-- upvalues: u48 (ref), CoreGui (copy), wrapWithProviders (copy), React (copy), SideSheetContent (copy), ReactRoblox (copy)
	if not u48 then
		local Folder = Instance.new("Folder")

		Folder.Name = "InExperienceSideSheet"
		Folder.Parent = CoreGui

		local v75 = wrapWithProviders({
			SideSheetContent = React.createElement(SideSheetContent, t5)
		}, p9, p10)

		u48 = ReactRoblox.createRoot(Folder)
		u48:render(v75)
	end

	return u48
end

return t1
