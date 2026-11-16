local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local Constants = require(AbuseReportMenu.Components.Constants)
local ModalBaseSelectorDialog = require(AbuseReportMenu.Components.ModalBaseSelectorDialog)

local FFlagHideShortcutsOnReportDropdown = require(AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local isSpatial, uiManager, panelType

if isInExperienceUIVREnabled then
	local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
	isSpatial = AppCommonLib.isSpatial

	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
	uiManager = VrSpatialUi.UIManager
	panelType = VrSpatialUi.Constants.PanelType
else
	isSpatial = nil
	uiManager = nil
	panelType = nil
end

local v = { modalSelectorHandle = nil, modalSelectorFrame = nil, modalSelectorScreenGui = nil }
local ModalBasedSelectorDialogController = {}

function ModalBasedSelectorDialogController.mountModalSelector(viewportHeight, viewportWidth, cellData, onSelect, onClose, callback)
	local guiInset, _ = GuiService:GetGuiInset()

	if isInExperienceUIVREnabled and isSpatial() then
		local panelObject = uiManager.getInstance():getPanelObject(panelType.MoreMenu)
		local frame = Instance.new("Frame")
		frame.BackgroundTransparency = 1
		frame.Position = UDim2.new(0, 0, 0, 0)
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.ZIndex = 10
		frame.Parent = panelObject
		v.modalSelectorFrame = frame
	elseif not v.modalSelectorScreenGui then
		local modalSelectorDialogGui = Instance.new("ScreenGui")
		modalSelectorDialogGui.Name = "ModalSelectorDialogGui"
		modalSelectorDialogGui.DisplayOrder = 7
		modalSelectorDialogGui.Enabled = true
		modalSelectorDialogGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		modalSelectorDialogGui.Parent = CoreGui:FindFirstChild(Constants.AbuseReportMenuPlaceholderFrame, true)

		v.modalSelectorScreenGui = modalSelectorDialogGui

		local frame = Instance.new("Frame")
		frame.BackgroundTransparency = 1
		frame.Position = UDim2.new(0, 0, 0, -guiInset.Y)
		frame.Size = UDim2.new(1, 0, 1, guiInset.Y)
		frame.Parent = v.modalSelectorScreenGui

		v.modalSelectorFrame = frame
	end

	if FFlagHideShortcutsOnReportDropdown and callback ~= nil then
		callback()
	end

	local element = Roact.createElement(ModalBaseSelectorDialog, {
		isShown = true,
		cellData = cellData,
		viewportHeight = viewportHeight,
		viewportWidth = viewportWidth,
		onSelect = onSelect,
		onClose = onClose
	})

	v.modalSelectorHandle = Roact.mount(element, v.modalSelectorFrame, "ModalSelectorDialog")
end

function ModalBasedSelectorDialogController.unmountModalSelector()
	if v.modalSelectorHandle ~= nil then
		Roact.unmount(v.modalSelectorHandle)
		v.modalSelectorHandle = nil
	end

	if isInExperienceUIVREnabled then
		if v.modalSelectorFrame ~= nil then
			v.modalSelectorFrame.Parent = nil
			v.modalSelectorFrame = nil
		end

		if v.modalSelectorScreenGui ~= nil then
			v.modalSelectorScreenGui = nil
		end
	elseif v.modalSelectorScreenGui ~= nil then
		v.modalSelectorFrame.Parent = nil
		v.modalSelectorFrame = nil
		v.modalSelectorScreenGui = nil
	end
end

return ModalBasedSelectorDialogController
