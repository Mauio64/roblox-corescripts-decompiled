local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local MorePageSettings = require(Modules.LuaApp.Components.More.Config.MorePageSettings)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local LogOutButton = require(Modules.LuaApp.Components.More.LogOutButton)
local MoreButton = require(Modules.LuaApp.Components.More.MoreButton)
local t = require(CorePackages.Packages.t)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v17 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local openExternalBrowser = require(Modules.LuaApp.openExternalBrowser)
local GetFFlagEnableGUACControlTOSPPLinks = require(Modules.LuaApp.Flags.GetFFlagEnableGUACControlTOSPPLinks)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local v26 = Roact.PureComponent:extend("MoreItemContainer")

v26.defaultProps = {
	layoutInfo = {},
	eventIngest = if not FFlagEnableFlyoutSidePanel then nil else t.any
}

function v26.init(p1) -- line: 39
	-- upvalues: GetFFlagEnableGUACControlTOSPPLinks (copy), openExternalBrowser (copy), FFlagEnableFlyoutSidePanel (copy), Roact (copy)
	function p1.navigateDown() -- line: 40
		-- upvalues: p1 (copy), GetFFlagEnableGUACControlTOSPPLinks (copy), openExternalBrowser (copy), FFlagEnableFlyoutSidePanel (copy)
		local item = p1.props.item
		local url = item.context.url
		local titleKey = item.context.titleKey
		local notificationType = item.context.notificationType

		if item.urlGenerator then
			local localUserId = p1.props.localUserId

			url = if not GetFFlagEnableGUACControlTOSPPLinks() then item.urlGenerator(localUserId) else item.urlGenerator(localUserId, p1.props.appPolicy)
		end

		local v51 = nil

		if item.getSearchParams then
			v51 = item.getSearchParams(p1.props.formFactor)
		end

		local t1 = nil

		if titleKey or v51 or notificationType then
			t1 = {
				titleKey = titleKey,
				searchParams = v51,
				notificationType = notificationType
			}
		end

		local v53 = item.shouldOpenInExternalBrowser and p1.props.shouldUseExternalBrowserForMorePageItem()
		local v54 = p1.props.disableWebViewSupport == true and item.context.fallbackToExternalBrowser == true

		if v53 or v54 then
			openExternalBrowser(p1.props.linking, url)
		else
			p1.props.navigateDown({
				name = item.context.page,
				detail = url,
				extraProps = t1
			})
		end

		if FFlagEnableFlyoutSidePanel then
			p1.props.eventIngest:sendEventDeferred("moreGridItem", "moreGridItemClick", {
				source = "flyout",
				itemType = item.itemType,
				url = url,
				localUserId = p1.props.localUserId
			})
		end
	end

	p1.focusableButtonRef = Roact.createRef()
end
function v26.didMount(p2) -- line: 96
	local layoutInfo = p2.props.layoutInfo

	if p2.props.focusGuiObject and (p2.focusableButtonRef and p2.focusableButtonRef.current and layoutInfo.LayoutOrder == 1) then
		p2.props.focusGuiObject(p2.focusableButtonRef.current)
	end
end
function v26.render(p3) -- line: 108
	-- upvalues: ArgCheck (copy), MorePageSettings (copy), Roact (copy), LogOutButton (copy), MoreButton (copy), Cryo (copy), FFlagEnableFlyoutSidePanel (copy)
	local layoutInfo = p3.props.layoutInfo
	local item = p3.props.item

	ArgCheck.isType(layoutInfo, "table", "MoreItemContainer.props.layoutInfo")
	ArgCheck.isType(item, "table", "MoreItemContainer.props.item")

	if item.itemType == MorePageSettings.ItemType.LogOut then
		return Roact.createElement(LogOutButton, {
			onActivated = p3.onActivated
		})
	end

	return Roact.createElement(MoreButton, Cryo.Dictionary.join(layoutInfo, {
		badgeComponent = item.badgeComponent,
		badgeCount = item.badgeCount,
		icon = if not FFlagEnableFlyoutSidePanel then item.icon else nil,
		rightImage = item.rightImage,
		textKey = item.textKey,
		TextXAlignment = item.textXAlignment,
		onActivated = p3.navigateDown,
		buttonRef = p3.focusableButtonRef
	}))
end

local v27 = RoactRodux.connect(function(p4, _) -- line: 137
	return {
		formFactor = p4.FormFactor,
		localUserId = p4.LocalUserId
	}
end, function(p6) -- line: 142
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v17 (copy), NavigateDown (copy)
	return {
		navigateDown = function(p7) -- line: 144
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v17 (copy), p6 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v17.down(v17.fromLegacyPage(p7))

				return
			end

			p6(NavigateDown(p7))
		end
	}
end)(v26)
local v28 = RoactAppPolicy.connect(function(p8) -- line: 154
	-- upvalues: GetFFlagEnableGUACControlTOSPPLinks (copy)
	local v40 = p8.getWebViewSupport()

	return {
		shouldUseExternalBrowserForMorePageItem = p8.shouldUseExternalBrowserForMorePageItem,
		disableWebViewSupport = not v40,
		appPolicy = if not GetFFlagEnableGUACControlTOSPPLinks() then nil else p8
	}
end)(v27)
local u29 = RoactServices.connect({
	linking = AppLinking,
	networkImpl = RoactNetworking,
	eventIngest = if not FFlagEnableFlyoutSidePanel then nil else AppEventIngestService
})(v28)

return function(p9) -- line: 169
	-- upvalues: useFocusGuiObject (copy), FocusNavigationUtils (copy), Responsive (copy), Roact (copy), u29 (ref), Cryo (copy)
	local v42 = useFocusGuiObject()
	local v43 = FocusNavigationUtils.useLastInputMethod()
	local v44 = Responsive.useIsSpatial()
	local v45 = (v43 == "Gamepad" or v43 == "Keyboard") and not v44

	return Roact.createElement(u29, Cryo.Dictionary.join(p9, {
		focusGuiObject = if not v45 then nil else v42
	}))
end
