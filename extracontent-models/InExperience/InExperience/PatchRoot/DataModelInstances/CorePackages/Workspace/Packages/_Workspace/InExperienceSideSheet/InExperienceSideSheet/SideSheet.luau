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
local t1 = {}
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local usePreferredInput = Responsive.usePreferredInput

local function getDeviceSafePadding(p1) -- line: 80
	-- upvalues: Display (copy)
	return Display.GetDisplayStore(p1).getDeviceSafePadding(p1)
end
local function getToggleIntegrations(p2) -- line: 84
	-- upvalues: GetIntegrationsStore (copy)
	return GetIntegrationsStore(p2).getToggleIntegrations(p2)
end
local function v43(p3) -- line: 88
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

local u46 = nil

local function SideSheetContent(t3: {[any]: any}) -- line: 103
	-- upvalues: useTokens (copy), useStyleSheet (copy), useBackgroundStyle (copy), SignalsReact (copy), getDeviceSafePadding (copy), FFlagMountUnmountSideSheet (copy), useDrawerShouldMount (copy), getToggleIntegrations (copy), React (copy), SidesheetAnalytics (copy), FFlagSideSheetFocusNav (copy), useFocusGuiObject (ref), GetSideSheetConfigStore (copy), usePreferredInput (copy), Signals (copy), getSideSheetVisibility (copy), Responsive (copy), MouseIconOverrideService (copy), FIntSideSheetVariant (copy), t2 (ref), ExperienceDetailsRow (copy), View (copy), Divider (copy), GridList (copy), VerticalList (copy), v43 (copy), ScrollView (copy), Footer (copy), DrawerContainer (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v52 = useTokens()
	local v53 = useStyleSheet()
	local v54 = useBackgroundStyle()
	local v55 = SignalsReact.useSignalState(getDeviceSafePadding)
	local v56 = not FFlagMountUnmountSideSheet or useDrawerShouldMount()
	local v57 = SignalsReact.useSignalState(getToggleIntegrations)
	local v58 = React.useCallback(function(p4) -- line: 111
		-- upvalues: SidesheetAnalytics (copy)
		SidesheetAnalytics.logSidesheetClosed(p4.source)
	end, {})
	local u59 = nil
	local v60 = nil

	if FFlagSideSheetFocusNav then
		u59 = useFocusGuiObject()
		v60 = React.useCallback(function(p5) -- line: 118
			-- upvalues: u59 (ref)
			u59(p5)
		end, { u59 })
	end

	local v61 = if not FFlagSideSheetFocusNav then nil else React.useRef(nil)
	local v62 = React.useCallback(function(p6) -- line: 125
		-- upvalues: GetSideSheetConfigStore (copy)
		return GetSideSheetConfigStore().onHeightChanged(p6.AbsoluteSize.Y)
	end, {})
	local v63 = React.useRef(false)
	local v64 = React.useRef(false)
	local v65 = usePreferredInput()

	React.useEffect(function() -- line: 133
		-- upvalues: Signals (copy), getSideSheetVisibility (copy), t3 (copy), v63 (copy), v65 (copy), Responsive (copy), v64 (copy), MouseIconOverrideService (copy)
		local v77 = Signals.createEffect(function(p7) -- line: 134
			-- upvalues: getSideSheetVisibility (copy), t3 (copy), v63 (copy), v65 (copy), Responsive (copy), v64 (copy), MouseIconOverrideService (copy)
			local v80 = getSideSheetVisibility(p7)

			if t3.ChatSelector then
				if v80 then
					v63.current = t3.ChatSelector:GetVisibility()
					t3.ChatSelector:SetVisible(false)
				elseif v63.current then
					t3.ChatSelector:SetVisible(true)
					v63.current = false
				end
			end

			if v65 == Responsive.Input.Pointer then
				if v80 and not v64.current then
					MouseIconOverrideService.push("InExperienceSideSheet", Enum.OverrideMouseIconBehavior.ForceShow)
					v64.current = true

					return
				end

				if not v80 and v64.current then
					MouseIconOverrideService.pop("InExperienceSideSheet")
					v64.current = false
				end
			end
		end)
		local u78 = nil

		if t3.ChatSelector then
			u78 = t3.ChatSelector.VisibilityStateChanged:connect(function(p8) -- line: 162
				-- upvalues: getSideSheetVisibility (copy), v63 (copy)
				if getSideSheetVisibility() and p8 then
					v63.current = false
				end
			end)
		end

		return function() -- line: 169
			-- upvalues: v77 (copy), u78 (ref)
			v77()

			if u78 ~= nil then
				u78:disconnect()
			end
		end
	end, {
		t3.ChatSelector,
		v65
	})

	local v66 = nil

	if FFlagSideSheetFocusNav then
		v66 = if FIntSideSheetVariant ~= 2 and not (#v57 <= 0) then t2.IntegrationsList else t2.PageList
	end

	if not v56 then
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
		IntegrationsList = if not (#v57 <= 0) then if FIntSideSheetVariant ~= 0 then React.createElement(VerticalList, {
			layoutOrder = FIntSideSheetVariant ~= 2 and 2 or 4,
			integrationsGetter = getToggleIntegrations,
			firstIntegrationToFocusCallback = if not FFlagSideSheetFocusNav or v66 ~= t2.IntegrationsList then nil else v60
		}) else React.createElement(GridList, {
			layoutOrder = 2,
			integrationsGetter = getToggleIntegrations,
			firstIntegrationToFocusCallback = if not FFlagSideSheetFocusNav or v66 ~= t2.IntegrationsList then nil else v60
		}) else nil,
		PageDivider = if not (#v57 > 0) then nil else React.createElement(View, {
			tag = "size-full-0 auto-y padding-right-xlarge",
			LayoutOrder = 3
		}, {
			Divider = React.createElement(Divider)
		}),
		PageList = React.createElement(VerticalList, {
			layoutOrder = FIntSideSheetVariant ~= 2 and 4 or 2,
			integrationsGetter = v43,
			firstIntegrationToFocusCallback = if not FFlagSideSheetFocusNav or v66 ~= t2.PageList then nil else v60
		})
	}
	local v68 = React.createElement(View, {
		tag = "col size-full",
		onAbsoluteSizeChanged = v62,
		ref = if not FFlagSideSheetFocusNav then nil else v61
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

	return React.createElement(DrawerContainer, {
		displayOrder = 12,
		scrimIsModal = true,
		menuWidth = 300 - v52.Padding.XLarge,
		leftOffset = v55.left + v52.Padding.XLarge,
		topOffset = v55.top,
		bottomOffset = v55.bottom,
		backgroundStyle = v54,
		onDrawerClosedAnalytics = v58
	}, {
		FoundationStyleLink = React.createElement("StyleLink", {
			StyleSheet = v53
		}),
		if not FFlagSideSheetFocusNav then v68 else React.createElement(FocusRoot, {
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, {
			Content = v68
		})
	})
end

function t1.createSideSheet(p9, t5: {[any]: any}, p10) -- line: 288
	-- upvalues: u46 (ref), CoreGui (copy), wrapWithProviders (copy), React (copy), SideSheetContent (copy), ReactRoblox (copy)
	if not u46 then
		local Folder = Instance.new("Folder")

		Folder.Name = "InExperienceSideSheet"
		Folder.Parent = CoreGui

		local v73 = wrapWithProviders({
			SideSheetContent = React.createElement(SideSheetContent, t5)
		}, p9, p10)

		u46 = ReactRoblox.createRoot(Folder)
		u46:render(v73)
	end

	return u46
end

return t1
