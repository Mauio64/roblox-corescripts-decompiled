local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Foundation = require(CorePackages.Packages.Foundation)

local view = Foundation.View
local text = Foundation.Text

local module = require("@luauforge/deferred/fFQ")
local module2 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local module3 = require("@luauforge/deferred/fGi")
local module4 = require("@luauforge/bundled/egZ")
local module5 = require("@luauforge/deferred/fFY")

local itemType = module.ItemType
local itemInfo = module.ItemInfo

local extended = Roact.PureComponent:extend("MoreFooter")

function extended:init()
	function self.onTermsActivated()
		self:navigateToItem(itemInfo[itemType.About_Terms])
	end

	function self.onPrivacyActivated()
		self:navigateToItem(itemInfo[itemType.About_Privacy])
	end
end

function extended:navigateToItem(data)
	local v5 = data.context.url
	local titleKey = data.context.titleKey

	if data.urlGenerator then
		local localUserId = self.props.localUserId

		if module5() then
			v5 = data.urlGenerator(localUserId, self.props.appPolicy)
		else
			v5 = data.urlGenerator(localUserId)
		end
	end

	local v6 = titleKey and { titleKey = titleKey } or nil

	local v7 = data.shouldOpenInExternalBrowser and self.props.shouldUseExternalBrowserForMorePageItem()
	local v8

	if self.props.disableWebViewSupport == true then
		v8 = data.context.fallbackToExternalBrowser == true
	else
		v8 = false
	end

	if v7 or v8 then
		module3(self.props.linking, v5)
	else
		self.props.navigateDown({
			name = data.context.page,
			detail = v5,
			extraProps = v6
		})
	end
end

function extended.render(data)
	return module4({
		termsText = "CommonUI.Features.Label.Terms",
		privacyText = "CommonUI.Features.Label.Privacy"
	})(function(p2)
		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, data.props.height),
				BackgroundTransparency = 1,
				LayoutOrder = data.props.layoutOrder
			},
			{
				Content = React.createElement(
					view,
					{
						tag = "row align-x-center align-y-center gap-xxlarge size-full padding-x-xlarge padding-y-medium"
					},
					{
						Terms = React.createElement(
							view,
							{
								tag = "auto-xy",
								onActivated = data.onTermsActivated,
								LayoutOrder = 1
							},
							{
								Label = React.createElement(text, {
									tag = "auto-xy text-label-medium content-default",
									Text = p2.termsText
								})
							}
						),
						Privacy = React.createElement(
							view,
							{
								tag = "auto-xy",
								onActivated = data.onPrivacyActivated,
								LayoutOrder = 2
							},
							{
								Label = React.createElement(text, {
									tag = "auto-xy text-label-medium content-default",
									Text = p2.privacyText
								})
							}
						)
					}
				)
			}
		)
	end)
end

local v5 = RoactRodux.connect(function(p2)
	return { localUserId = p2.LocalUserId }
end, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module2(p2))
			end
		end
	}
end)(extended)

local v6 = roactAppPolicy.connect(function(appPolicy)
	local v7 = not appPolicy.getWebViewSupport()
	local v8 = {
		shouldUseExternalBrowserForMorePageItem = appPolicy.shouldUseExternalBrowserForMorePageItem,
		disableWebViewSupport = v7,
		appPolicy = 0
	}

	if not module5() then
		appPolicy = nil
	end

	v8.appPolicy = appPolicy
	return v8
end)(v5)

return (roactServices.connect({ linking = appLinking })(v6))
