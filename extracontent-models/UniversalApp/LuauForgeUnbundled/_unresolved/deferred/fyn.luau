local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module = require("@luauforge/bundled/dwL")
local module2 = require("@luauforge/deferred/fya")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking

local module3 = require("@luauforge/deferred/fyo")
local module4 = require("@luauforge/deferred/fyq")

local t = require(CorePackages.Packages.t)
local module5 = require("@luauforge/bundled/dYU")
local module6 = require("@luauforge/bundled/eda")
local module7 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module8 = require("@luauforge/deferred/fyr")
local module9 = require("@luauforge/deferred/fyh")
local module10 = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local module12 = require("@luauforge/bundled/dHC")
local defineFastFlag = game:DefineFastFlag("MoreItemClickTelemetryWithoutFlyout", false)
local extended = Roact.PureComponent:extend("MoreItemContainer")

local v6 = if module12 or defineFastFlag then t.any else nil
extended.defaultProps = { layoutInfo = {}, eventIngest = v6 }

function extended:init()
	function self.navigateDown()
		local item = self.props.item
		local v7 = item.context.url
		local titleKey = item.context.titleKey
		local notificationType = item.context.notificationType

		if item.urlGenerator then
			local localUserId = self.props.localUserId

			if module9() then
				v7 = item.urlGenerator(localUserId, self.props.appPolicy)
			else
				v7 = item.urlGenerator(localUserId)
			end
		end

		local v8 = if item.getSearchParams then item.getSearchParams(self.props.formFactor) else nil

		local v9 = (titleKey or v8 or notificationType)
			and {
				titleKey = titleKey,
				searchParams = v8,
				notificationType = notificationType
			}
			or nil

		local v10 = item.shouldOpenInExternalBrowser
			and self.props.shouldUseExternalBrowserForMorePageItem()
		local v11

		if self.props.disableWebViewSupport == true then
			v11 = item.context.fallbackToExternalBrowser == true
		else
			v11 = false
		end

		if v10 or v11 then
			module8(self.props.linking, v7)
		elseif not fFlagUnifyConsoleSettingsPage or item.context.page then
			self.props.navigateDown({
				name = item.context.page,
				detail = v7,
				extraProps = v9
			})
		end

		if defineFastFlag or module12 then
			self.props.eventIngest:sendEventDeferred("moreGridItem", "moreGridItemClick", {
				itemType = item.itemType,
				url = v7,
				localUserId = self.props.localUserId,
				source = module12 and "flyout" or "morePage"
			})
		end
	end

	local v7 = if fFlagUnifyConsoleSettingsPage then self.props.setDefaultFocusGuiObject or Roact.createRef() else Roact.createRef()
	self.focusableButtonRef = v7
end

function extended.didMount(p2)
	local layoutInfo = p2.props.layoutInfo

	if
		not (fFlagUnifyConsoleSettingsPage and p2.props.disableAutoFocus)
		and p2.props.focusGuiObject
		and p2.focusableButtonRef
		and p2.focusableButtonRef.current
		and layoutInfo.LayoutOrder == 1
	then
		p2.props.focusGuiObject(p2.focusableButtonRef.current)
	end
end

function extended.render(props)
	local layoutInfo = props.props.layoutInfo
	local item = props.props.item

	module.isType(layoutInfo, "table", "MoreItemContainer.props.layoutInfo")
	module.isType(item, "table", "MoreItemContainer.props.item")

	if item.itemType == module2.ItemType.LogOut then
		return Roact.createElement(module3, { onActivated = props.onActivated })
	end

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join
	local v8 = {
		transparentBackground = props.props.transparentBackground,
		badgeComponent = item.badgeComponent,
		badgeCount = item.badgeCount,
		icon = 0,
		rightImage = 0,
		textKey = 0,
		TextXAlignment = 0,
		onActivated = 0,
		buttonRef = 0
	}

	local v9 = if not module12 then item.icon else nil
	v8.icon = v9
	v8.rightImage = item.rightImage
	v8.textKey = item.textKey
	v8.TextXAlignment = item.textXAlignment
	v8.onActivated = props.navigateDown
	v8.buttonRef = props.focusableButtonRef
	return createElement(module4, join(layoutInfo, v8))
end

local v7 = RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor, localUserId = p2.LocalUserId }
end, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module7(p2))
			end
		end
	}
end)(extended)

local v8 = roactAppPolicy.connect(function(appPolicy)
	local v9 = not appPolicy.getWebViewSupport()
	local v10 = {
		shouldUseExternalBrowserForMorePageItem = appPolicy.shouldUseExternalBrowserForMorePageItem,
		disableWebViewSupport = v9,
		appPolicy = 0
	}

	if not module9() then
		appPolicy = nil
	end

	v10.appPolicy = appPolicy
	return v10
end)(v7)

local connect = roactServices.connect

if not (module12 or defineFastFlag) then
	module5 = nil
end

local v10 = connect({
	linking = appLinking,
	networkImpl = module6,
	eventIngest = module5
})(v8)

return function(p2)
	local v11 = useFocusGuiObject()
	local v12 = module10.useLastInputMethod()
	local v13 = Responsive.useIsSpatial()
	local v14 = (v12 == "Gamepad" or v12 == "Keyboard") and not v13

	local v16 = p2.setDefaultFocusGuiObject
	local v18 = if fFlagUnifyConsoleSettingsPage then v16 else nil
	local v19 = useTableWrappedCallbackRef(v18)
	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join

	if not v14 then
		v11 = nil
	end

	if fFlagUnifyConsoleSettingsPage then
		v16 = v19
	end

	return createElement(v10, join(p2, {
		focusGuiObject = v11,
		setDefaultFocusGuiObject = v16
	}))
end
