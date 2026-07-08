local CoreGui = game:GetService("CoreGui")
local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local CoreScriptsCommon = require(InExperienceSideSheetParent.CoreScriptsCommon)
local Display = require(InExperienceSideSheetParent.Display)
local Drawer = require(InExperienceSideSheetParent.Drawer)
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
local t1 = {}
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local usePreferredInput = Responsive.usePreferredInput

local function getDeviceSafePadding(p1) -- line: 72
	-- upvalues: Display (copy)
	return Display.GetDisplayStore(p1).getDeviceSafePadding(p1)
end
local function getToggleIntegrations(p2) -- line: 76
	-- upvalues: GetIntegrationsStore (copy)
	return GetIntegrationsStore(p2).getToggleIntegrations(p2)
end
local function v39(p3) -- line: 80
	-- upvalues: GetIntegrationsStore (copy)
	return GetIntegrationsStore(p3).getPageIntegrations(p3)
end

local u40 = nil

local function SideSheetContent(t2: {[any]: any}) -- line: 85
	-- upvalues: useTokens (copy), useStyleSheet (copy), useBackgroundStyle (copy), SignalsReact (copy), getDeviceSafePadding (copy), FFlagMountUnmountSideSheet (copy), useDrawerShouldMount (copy), getToggleIntegrations (copy), React (copy), SidesheetAnalytics (copy), GetSideSheetConfigStore (copy), usePreferredInput (copy), Signals (copy), getSideSheetVisibility (copy), Responsive (copy), MouseIconOverrideService (copy), ExperienceDetailsRow (copy), View (copy), Divider (copy), FIntSideSheetVariant (copy), GridList (copy), VerticalList (copy), v39 (copy), DrawerContainer (copy), ScrollView (copy), Footer (copy)
	local v46 = useTokens()
	local v47 = useStyleSheet()
	local v48 = useBackgroundStyle()
	local v49 = SignalsReact.useSignalState(getDeviceSafePadding)
	local v50 = not FFlagMountUnmountSideSheet or useDrawerShouldMount()
	local v51 = SignalsReact.useSignalState(getToggleIntegrations)
	local v52 = React.useCallback(function(p4) -- line: 93
		-- upvalues: SidesheetAnalytics (copy)
		SidesheetAnalytics.logSidesheetClosed(p4.source)
	end, {})
	local v53 = React.useCallback(function(p5) -- line: 97
		-- upvalues: GetSideSheetConfigStore (copy)
		return GetSideSheetConfigStore().onHeightChanged(p5.AbsoluteSize.Y)
	end, {})
	local v54 = React.useRef(false)
	local v55 = React.useRef(false)
	local v56 = usePreferredInput()

	React.useEffect(function() -- line: 105
		-- upvalues: Signals (copy), getSideSheetVisibility (copy), t2 (copy), v54 (copy), v56 (copy), Responsive (copy), v55 (copy), MouseIconOverrideService (copy)
		local v65 = Signals.createEffect(function(p6) -- line: 106
			-- upvalues: getSideSheetVisibility (copy), t2 (copy), v54 (copy), v56 (copy), Responsive (copy), v55 (copy), MouseIconOverrideService (copy)
			local v68 = getSideSheetVisibility(p6)

			if t2.ChatSelector then
				if v68 then
					v54.current = t2.ChatSelector:GetVisibility()
					t2.ChatSelector:SetVisible(false)
				elseif v54.current then
					t2.ChatSelector:SetVisible(true)
					v54.current = false
				end
			end

			if v56 == Responsive.Input.Pointer then
				if v68 and not v55.current then
					MouseIconOverrideService.push("InExperienceSideSheet", Enum.OverrideMouseIconBehavior.ForceShow)
					v55.current = true

					return
				end

				if not v68 and v55.current then
					MouseIconOverrideService.pop("InExperienceSideSheet")
					v55.current = false
				end
			end
		end)
		local u66 = nil

		if t2.ChatSelector then
			u66 = t2.ChatSelector.VisibilityStateChanged:connect(function(p7) -- line: 133
				-- upvalues: getSideSheetVisibility (copy), v54 (copy)
				if getSideSheetVisibility() and p7 then
					v54.current = false
				end
			end)
		end

		return function() -- line: 140
			-- upvalues: v65 (copy), u66 (ref)
			v65()

			if u66 ~= nil then
				u66:disconnect()
			end
		end
	end, {
		t2.ChatSelector,
		v56
	})

	if not v50 then
		return nil
	end

	local t3 = {
		ExperienceDetailsRow = React.createElement(ExperienceDetailsRow, {
			layoutOrder = 0
		}),
		HeaderDivider = React.createElement(View, {
			tag = "size-full-0 auto-y padding-right-xlarge",
			LayoutOrder = 1
		}, {
			Divider = React.createElement(Divider)
		}),
		IntegrationsList = if not (#v51 <= 0) then if FIntSideSheetVariant ~= 0 then React.createElement(VerticalList, {
			layoutOrder = FIntSideSheetVariant ~= 2 and 2 or 4,
			integrationsGetter = getToggleIntegrations
		}) else React.createElement(GridList, {
			layoutOrder = 2,
			integrationsGetter = getToggleIntegrations
		}) else nil,
		PageDivider = if not (#v51 > 0) then nil else React.createElement(View, {
			tag = "size-full-0 auto-y padding-right-xlarge",
			LayoutOrder = 3
		}, {
			Divider = React.createElement(Divider)
		}),
		PageList = React.createElement(VerticalList, {
			layoutOrder = FIntSideSheetVariant ~= 2 and 4 or 2,
			integrationsGetter = v39
		})
	}

	return React.createElement(DrawerContainer, {
		displayOrder = 12,
		scrimIsModal = true,
		menuWidth = 300 - v46.Padding.XLarge,
		leftOffset = v49.left + v46.Padding.XLarge,
		topOffset = v49.top,
		bottomOffset = v49.bottom,
		backgroundStyle = v48,
		onDrawerClosedAnalytics = v52
	}, {
		FoundationStyleLink = React.createElement("StyleLink", {
			StyleSheet = v47
		}),
		Content = React.createElement(View, {
			tag = "col size-full",
			onAbsoluteSizeChanged = v53
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
				}
			}, t3),
			Footer = React.createElement(Footer, {
				layoutOrder = 2
			})
		})
	})
end

function t1.createSideSheet(p8, t4: {[any]: any}, p9) -- line: 224
	-- upvalues: u40 (ref), CoreGui (copy), wrapWithProviders (copy), React (copy), SideSheetContent (copy), ReactRoblox (copy)
	if not u40 then
		local Folder = Instance.new("Folder")

		Folder.Name = "InExperienceSideSheet"
		Folder.Parent = CoreGui

		local v62 = wrapWithProviders({
			SideSheetContent = React.createElement(SideSheetContent, t4)
		}, p8, p9)

		u40 = ReactRoblox.createRoot(Folder)
		u40:render(v62)
	end

	return u40
end

return t1
