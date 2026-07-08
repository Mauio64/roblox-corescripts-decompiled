local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local ExpChatShared = require(CorePackages.Workspace.Packages.ExpChatShared)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Style = require(CorePackages.Workspace.Packages.Style)
local LayerCollectorProvider = require(CorePackages.Packages.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local Constants = require(AbuseReportMenu.Components.Constants)
local ChatModalSelectorDialog = require(AbuseReportMenu.Components.ChatModalSelectorDialog)

require(AbuseReportMenu.Components.Types)

local FFlagHideShortcutsOnReportDropdown = require(AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local isSpatial = nil
local UIManager = nil
local PanelType = nil

if isInExperienceUIVREnabled then
	isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial

	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)

	UIManager = VrSpatialUi.UIManager
	PanelType = VrSpatialUi.Constants.PanelType
end

local t1 = {
	modalSelectorHandle = nil,
	modalSelectorFrame = nil,
	modalSelectorScreenGui = nil
}

return {
	mountModalSelector = function(p1: ((...any) -> ...any), p2: ((...any) -> ...any)?, p3: ((...any) -> ...any)) -- line: 71
		-- upvalues: isInExperienceUIVREnabled (copy), isSpatial (ref), UIManager (ref), PanelType (ref), t1 (copy), CoreGui (copy), Constants (copy), FFlagHideShortcutsOnReportDropdown (copy), Roact (copy), LayerCollectorProvider (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), RoactRodux (copy), ExpChatShared (copy), StyleProviderWithDefaultTheme (copy), ChatModalSelectorDialog (copy)
		if isInExperienceUIVREnabled and isSpatial() then
			local v25 = UIManager.getInstance():getPanelObject(PanelType.MoreMenu)
			local Frame = Instance.new("Frame")

			Frame.BackgroundTransparency = 1
			Frame.Position = UDim2.new(0, 0, 0, 0)
			Frame.Size = UDim2.new(1, 0, 1, 0)
			Frame.ZIndex = 10
			Frame.Parent = v25
			t1.modalSelectorFrame = Frame
		elseif not t1.modalSelectorScreenGui then
			local ScreenGui = Instance.new("ScreenGui")

			ScreenGui.Name = "ModalSelectorDialogGui"
			ScreenGui.DisplayOrder = 7
			ScreenGui.Enabled = true
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			ScreenGui.Parent = CoreGui:FindFirstChild(Constants.AbuseReportMenuPlaceholderFrame, true)
			ScreenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
			t1.modalSelectorScreenGui = ScreenGui

			local Frame = Instance.new("Frame")

			Frame.BackgroundTransparency = 1
			Frame.Position = UDim2.new(0, 0, 0, 0)
			Frame.Size = UDim2.new(1, 0, 1, 0)
			Frame.Parent = t1.modalSelectorScreenGui
			t1.modalSelectorFrame = Frame
		end

		if FFlagHideShortcutsOnReportDropdown and p2 ~= nil then
			p2()
		end

		local v29 = Roact.createElement(LayerCollectorProvider, {}, Roact.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			StoreProvider = Roact.createElement(RoactRodux.StoreProvider, {
				store = ExpChatShared.context.store
			}, {
				StyleProviderWithDefaultTheme = Roact.createElement(StyleProviderWithDefaultTheme, {
					withDarkTheme = true
				}, {
					ChatModalSelectorDialog = Roact.createElement(ChatModalSelectorDialog, {
						isShown = true,
						onClose = p1,
						onSelect = p3
					})
				})
			})
		}))

		t1.modalSelectorHandle = Roact.mount(v29, t1.modalSelectorFrame, "ChatModalSelectorDialog")
	end,
	unmountModalSelector = function() -- line: 43
		-- upvalues: t1 (copy), Roact (copy), isInExperienceUIVREnabled (copy)
		if t1.modalSelectorHandle ~= nil then
			Roact.unmount(t1.modalSelectorHandle)
			t1.modalSelectorHandle = nil
		end

		if isInExperienceUIVREnabled then
			if t1.modalSelectorFrame ~= nil then
				t1.modalSelectorFrame.Parent = nil
				t1.modalSelectorFrame = nil
			end

			if t1.modalSelectorScreenGui ~= nil then
				t1.modalSelectorScreenGui = nil

				return
			end
		elseif t1.modalSelectorScreenGui ~= nil then
			t1.modalSelectorFrame.Parent = nil
			t1.modalSelectorFrame = nil
			t1.modalSelectorScreenGui = nil
		end
	end
}
