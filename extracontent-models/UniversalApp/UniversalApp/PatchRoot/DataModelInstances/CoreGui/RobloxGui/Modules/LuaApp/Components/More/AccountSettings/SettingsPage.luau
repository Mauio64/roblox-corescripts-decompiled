local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppUpdateService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppUpdateService
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local memoize = require(Modules.Common.memoize)
local Constants = require(Modules.LuaApp.Constants)
local MorePageSettings = require(Modules.LuaApp.Components.More.Config.MorePageSettings)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local MoreList = require(Modules.LuaApp.Components.More.MoreList)
local MoreItemContainer = require(Modules.LuaApp.Components.More.MoreItemContainer)
local MorePageScrollingFrame = require(Modules.LuaApp.Components.More.MorePageScrollingFrame)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local React = require(CorePackages.Packages.React)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local useSettingsPageItems = require(Modules.LuaApp.Hooks.useSettingsPageItems)
local useBillingTabVisibility = require(CorePackages.Workspace.Packages.SettingsTabVisibility).useBillingTabVisibility
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local MoreSectionList = require(Modules.LuaApp.Components.More.MoreSectionList)
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)
local SetShowAgeVerificationOverlay = VoiceChat.AgeVerificationOverlay.SetShowAgeVerificationOverlay
local SetVoiceChatOptInStatus = VoiceChat.OptInStatus.SetVoiceChatOptInStatus
local GetFFlagEnableGateNotificationPreferencesTab = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableGateNotificationPreferencesTab
local FFlagEnableBillingTabHideLogic = require(Modules.LuaApp.Flags.FFlagEnableBillingTabHideLogic)
local v31 = Roact.PureComponent:extend("SettingsPage")

function v31.init(p1) -- line: 61
	-- upvalues: Roact (copy), MoreItemContainer (copy), memoize (copy), GetFFlagEnableGateNotificationPreferencesTab (copy), FFlagEnableBillingTabHideLogic (copy), MorePageSettings (copy), Cryo (copy)
	function p1.renderItem(p2, p3) -- line: 62
		-- upvalues: Roact (copy), MoreItemContainer (copy)
		return Roact.createElement(MoreItemContainer, {
			item = p2,
			layoutInfo = p3
		})
	end

	p1.getSettingsPageItemList = memoize(function(p4, p5, p6, p7) -- line: 70
		-- upvalues: GetFFlagEnableGateNotificationPreferencesTab (copy), p1 (copy), FFlagEnableBillingTabHideLogic (copy), MorePageSettings (copy), Cryo (copy)
		local v68 = if not GetFFlagEnableGateNotificationPreferencesTab() then if not FFlagEnableBillingTabHideLogic then nil else {
			hideBillingTab = p7
		} else {
			enableNotificationPreferencesTab = p1.props.enableNotificationPreferencesTab,
			hideBillingTab = if not FFlagEnableBillingTabHideLogic then nil else p7
		}
		local v69 = MorePageSettings.GetItemsInPage(p5, nil, nil, v68, p6)

		return Cryo.List.map(v69, function(p8) -- line: 85
			-- upvalues: MorePageSettings (copy), p4 (copy), Cryo (copy)
			local contents = p8.contents
			local t1 = {}

			for i, v in ipairs(contents) do
				local v83 = v

				if v83.itemType == MorePageSettings.ItemType.Settings_AccountInfo and v83.badgeCount ~= p4 then
					v83 = Cryo.Dictionary.join(v83, {
						badgeCount = p4
					})
				end

				t1[i] = v83
			end

			return t1
		end)
	end)

	if game:GetEngineFeature("VoiceChatSupported") then
		p1.props.setShowAgeVerificationOverlay()
	end

	p1.props.setVoiceChatOptInStatus()
end
function v31.render(p9) -- line: 112
	-- upvalues: FormFactor (copy), FFlagEnableBillingTabHideLogic (copy), Constants (copy), Roact (copy), MorePageScrollingFrame (copy), MoreList (copy), TopBar (copy), withStyle (copy)
	local v38 = p9.props.formFactor == FormFactor.WIDE
	local showParentalControls = p9.props.showParentalControls
	local settingsPageType = p9.props.settingsPageType
	local v41 = if not FFlagEnableBillingTabHideLogic then nil else p9.props.hideBillingTabOverride ~= nil and p9.props.hideBillingTabOverride
	local v42 = if not FFlagEnableBillingTabHideLogic then p9.getSettingsPageItemList(p9.props.notificationCount, settingsPageType, showParentalControls) else p9.getSettingsPageItemList(p9.props.notificationCount, settingsPageType, showParentalControls, v41)
	local n1 = 0
	local n2 = 0
	local MORE_PAGE_SECTION_PADDING = Constants.MORE_PAGE_SECTION_PADDING
	local MORE_PAGE_SECTION_PADDING2 = Constants.MORE_PAGE_SECTION_PADDING

	if v38 then
		n1 = Constants.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		n2 = Constants.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		MORE_PAGE_SECTION_PADDING = Constants.MORE_PAGE_WIDE_PADDING_VERTICAL
		MORE_PAGE_SECTION_PADDING2 = Constants.MORE_PAGE_WIDE_PADDING_VERTICAL
	end

	local v47 = Constants.MORE_PAGE_CONTENT_MAX_WIDTH + n1 + n2

	local function v48(p10) -- line: 146
		-- upvalues: Roact (copy), MorePageScrollingFrame (copy), v47 (copy), n1 (ref), n2 (ref), MORE_PAGE_SECTION_PADDING (ref), MORE_PAGE_SECTION_PADDING2 (ref), MoreList (copy), v42 (copy), p9 (copy), Constants (copy), TopBar (copy)
		local v71 = Roact.createElement(MorePageScrollingFrame, {
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			maxWidth = v47
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, n1),
				PaddingRight = UDim.new(0, n2),
				PaddingTop = UDim.new(0, MORE_PAGE_SECTION_PADDING),
				PaddingBottom = UDim.new(0, MORE_PAGE_SECTION_PADDING2)
			}),
			SettingsPageList = Roact.createElement(MoreList, {
				itemList = v42,
				renderItem = p9.renderItem,
				rowHeight = Constants.MORE_PAGE_ROW_HEIGHT
			})
		})

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = p10.Color,
			BackgroundTransparency = p10.Transparency
		}, {
			TopBar = Roact.createElement(TopBar.Container, {
				leftItem = TopBar.BackButton,
				rightItems = {
					TopBar.BuyRobuxButton,
					TopBar.NotificationsButton
				}
			}),
			PageContent = Roact.createElement(TopBar.PageContent, {}, {
				Scroller = v71
			})
		})
	end

	return withStyle(function(p11) -- line: 188
		-- upvalues: v48 (copy)
		return v48(p11.Theme.BackgroundDefault)
	end)
end

local v32 = RoactAppPolicy.connect(function(p12, _) -- line: 193
	-- upvalues: GetFFlagEnableGateNotificationPreferencesTab (copy)
	return {
		settingsPageType = p12.getSettingsPageType(),
		enableNotificationPreferencesTab = if not GetFFlagEnableGateNotificationPreferencesTab() then nil else p12.getEnableNotificationPreferencesPage()
	}
end)(v31)
local v33 = RoactAppExperiment.connectUserLayer({ AppUserLayers.ParentalSpendControlsLayer }, function(p14, _) -- line: 204
	-- upvalues: AppUserLayers (copy)
	return {
		showParentalControls = (p14[AppUserLayers.ParentalSpendControlsLayer] or {}).showParentalSpendControls
	}
end)(v32)
local v34 = RoactRodux.connect(function(p16, _) -- line: 211
	local MorePageSettings2 = p16.NotificationBadgeCounts.MorePageSettings

	return {
		formFactor = p16.FormFactor,
		notificationCount = MorePageSettings2,
		screenSize = p16.ScreenSize
	}
end, function(p18) -- line: 218
	-- upvalues: SetShowAgeVerificationOverlay (copy), SetVoiceChatOptInStatus (copy)
	return {
		setShowAgeVerificationOverlay = function(p19, p20, p21, p22) -- line: 220
			-- upvalues: p18 (copy), SetShowAgeVerificationOverlay (copy)
			return p18(SetShowAgeVerificationOverlay(p19, p20, p21, p22))
		end,
		setVoiceChatOptInStatus = function(p23) -- line: 235
			-- upvalues: p18 (copy), SetVoiceChatOptInStatus (copy)
			return p18(SetVoiceChatOptInStatus(p23))
		end
	}
end)(v33)
local u35 = RoactServices.connect({
	appUpdateService = AppUpdateService
})(v34)

return function(t2: {[any]: any}) -- line: 245
	-- upvalues: RobloxAppHooks (copy), UiMode (copy), FFlagEnableBillingTabHideLogic (copy), useBillingTabVisibility (copy), Cryo (copy), useSettingsPageItems (copy), React (copy), MoreSectionList (copy), u35 (ref)
	local v58 = RobloxAppHooks.useUiModeInfo().uiMode == UiMode.TenFoot

	if FFlagEnableBillingTabHideLogic then
		local showBillingTab = useBillingTabVisibility().showBillingTab

		t2 = Cryo.Dictionary.join(t2 or {}, {
			hideBillingTabOverride = not showBillingTab
		})
	end

	local v60 = t2 or {}
	local v61 = useSettingsPageItems()

	if v58 then
		return React.createElement(MoreSectionList, {
			itemList = v61
		})
	end

	return React.createElement(u35, v60)
end
