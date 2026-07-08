local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(AbuseReportMenu.Components.Constants)
local ModalBaseSelectorDialog = require(AbuseReportMenu.Components.ModalBaseSelectorDialog)
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
	mountModalSelector = function(p1, p2, p3, p4, p5, p6) -- line: 58
		-- upvalues: GuiService (copy), isInExperienceUIVREnabled (copy), isSpatial (ref), UIManager (ref), PanelType (ref), t1 (copy), CoreGui (copy), Constants (copy), FFlagHideShortcutsOnReportDropdown (copy), Roact (copy), ModalBaseSelectorDialog (copy)
		local v21, _ = GuiService:GetGuiInset()

		if isInExperienceUIVREnabled and isSpatial() then
			local v23 = UIManager.getInstance():getPanelObject(PanelType.MoreMenu)
			local Frame = Instance.new("Frame")

			Frame.BackgroundTransparency = 1
			Frame.Position = UDim2.new(0, 0, 0, 0)
			Frame.Size = UDim2.new(1, 0, 1, 0)
			Frame.ZIndex = 10
			Frame.Parent = v23
			t1.modalSelectorFrame = Frame
		elseif not t1.modalSelectorScreenGui then
			local ScreenGui = Instance.new("ScreenGui")

			ScreenGui.Name = "ModalSelectorDialogGui"
			ScreenGui.DisplayOrder = 7
			ScreenGui.Enabled = true
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			ScreenGui.Parent = CoreGui:FindFirstChild(Constants.AbuseReportMenuPlaceholderFrame, true)
			t1.modalSelectorScreenGui = ScreenGui

			local Frame = Instance.new("Frame")

			Frame.BackgroundTransparency = 1
			Frame.Position = UDim2.new(0, 0, 0, -v21.Y)
			Frame.Size = UDim2.new(1, 0, 1, v21.Y)
			Frame.Parent = t1.modalSelectorScreenGui
			t1.modalSelectorFrame = Frame
		end

		if FFlagHideShortcutsOnReportDropdown and p6 ~= nil then
			p6()
		end

		local v27 = Roact.createElement(ModalBaseSelectorDialog, {
			isShown = true,
			cellData = p3,
			viewportHeight = p1,
			viewportWidth = p2,
			onSelect = p4,
			onClose = p5
		})

		t1.modalSelectorHandle = Roact.mount(v27, t1.modalSelectorFrame, "ModalSelectorDialog")
	end,
	unmountModalSelector = function() -- line: 34
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
