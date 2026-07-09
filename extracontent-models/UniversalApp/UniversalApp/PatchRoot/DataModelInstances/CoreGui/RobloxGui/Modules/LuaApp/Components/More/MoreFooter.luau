local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local MorePageSettings = require(Modules.LuaApp.Components.More.Config.MorePageSettings)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v12 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local openExternalBrowser = require(Modules.LuaApp.openExternalBrowser)
local withLocalization = require(Modules.LuaApp.withLocalization)
local GetFFlagEnableGUACControlTOSPPLinks = require(Modules.LuaApp.Flags.GetFFlagEnableGUACControlTOSPPLinks)
local ItemType = MorePageSettings.ItemType
local ItemInfo = MorePageSettings.ItemInfo
local v21 = Roact.PureComponent:extend("MoreFooter")

function v21.init(p1) -- line: 30
	-- upvalues: ItemInfo (copy), ItemType (copy)
	function p1.onTermsActivated() -- line: 31
		-- upvalues: p1 (copy), ItemInfo (copy), ItemType (copy)
		p1:navigateToItem(ItemInfo[ItemType.About_Terms])
	end
	function p1.onPrivacyActivated() -- line: 35
		-- upvalues: p1 (copy), ItemInfo (copy), ItemType (copy)
		p1:navigateToItem(ItemInfo[ItemType.About_Privacy])
	end
end
function v21.navigateToItem(p2, p3) -- line: 40
	-- upvalues: GetFFlagEnableGUACControlTOSPPLinks (copy), openExternalBrowser (copy)
	local url = p3.context.url
	local titleKey = p3.context.titleKey

	if p3.urlGenerator then
		local localUserId = p2.props.localUserId

		url = if not GetFFlagEnableGUACControlTOSPPLinks() then p3.urlGenerator(localUserId) else p3.urlGenerator(localUserId, p2.props.appPolicy)
	end

	local t1 = nil

	if titleKey then
		t1 = {
			titleKey = titleKey
		}
	end

	local v31 = p3.shouldOpenInExternalBrowser and p2.props.shouldUseExternalBrowserForMorePageItem()
	local v32 = p2.props.disableWebViewSupport == true and p3.context.fallbackToExternalBrowser == true

	if v31 or v32 then
		openExternalBrowser(p2.props.linking, url)

		return
	end

	p2.props.navigateDown({
		name = p3.context.page,
		detail = url,
		extraProps = t1
	})
end
function v21.render(p4) -- line: 72
	-- upvalues: withLocalization (copy), Roact (copy), React (copy), View (copy), FoundationText (copy)
	return withLocalization({
		termsText = "CommonUI.Features.Label.Terms",
		privacyText = "CommonUI.Features.Label.Privacy"
	})(function(p5) -- line: 76
		-- upvalues: Roact (copy), p4 (copy), React (copy), View (copy), FoundationText (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, p4.props.height),
			LayoutOrder = p4.props.layoutOrder
		}, {
			Content = React.createElement(View, {
				tag = "row align-x-center align-y-center gap-xxlarge size-full padding-x-xlarge padding-y-medium"
			}, {
				Terms = React.createElement(View, {
					tag = "auto-xy",
					LayoutOrder = 1,
					onActivated = p4.onTermsActivated
				}, {
					Label = React.createElement(FoundationText, {
						tag = "auto-xy text-label-medium content-default",
						Text = p5.termsText
					})
				}),
				Privacy = React.createElement(View, {
					tag = "auto-xy",
					LayoutOrder = 2,
					onActivated = p4.onPrivacyActivated
				}, {
					Label = React.createElement(FoundationText, {
						tag = "auto-xy text-label-medium content-default",
						Text = p5.privacyText
					})
				})
			})
		})
	end)
end

local v22 = RoactRodux.connect(function(p6) -- line: 110
	return {
		localUserId = p6.LocalUserId
	}
end, function(p7) -- line: 114
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateDown (copy)
	return {
		navigateDown = function(p8) -- line: 116
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v12 (copy), p7 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v12.down(v12.fromLegacyPage(p8))

				return
			end

			p7(NavigateDown(p8))
		end
	}
end)(v21)
local v23 = RoactAppPolicy.connect(function(p9) -- line: 126
	-- upvalues: GetFFlagEnableGUACControlTOSPPLinks (copy)
	local v37 = p9.getWebViewSupport()

	return {
		shouldUseExternalBrowserForMorePageItem = p9.shouldUseExternalBrowserForMorePageItem,
		disableWebViewSupport = not v37,
		appPolicy = if not GetFFlagEnableGUACControlTOSPPLinks() then nil else p9
	}
end)(v22)

return (RoactServices.connect({
	linking = AppLinking
})(v23))
