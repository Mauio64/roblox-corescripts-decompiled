local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local ScrollingListTable = UIBlox.App.Table.ScrollingListTable
local CellHeadDetail = UIBlox.App.Table.CellHeadDetail
local Cell = UIBlox.App.Table.Cell
local CellTailDescription = UIBlox.App.Table.CellTailDescription
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local Dash = require(CorePackages.Packages.Dash)
local Cryo = require(CorePackages.Packages.Cryo)
local useStyle = UIBlox.Core.Style.useStyle
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport

local Images = UIBlox.App.ImageSet.Images

local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

local GetFFlagModalSelectorCloseButton = require(AbuseReportMenu.Flags.GetFFlagModalSelectorCloseButton)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local Responsive, uiManager, panelType

if isInExperienceUIVREnabled then
	Responsive = require(CorePackages.Workspace.Packages.Responsive)
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
	uiManager = VrSpatialUi.UIManager
	panelType = VrSpatialUi.Constants.PanelType
else
	Responsive = nil
	uiManager = nil
	panelType = nil
end

local function ModalBaseSelectorDialog(props)
	local v = useTokens()
	local v2 = useStyle()
	local theme = v2.Theme

	local size_1000 = v2.Tokens.Size.Size_1000
	local v3

	if isInExperienceUIVREnabled then
		local v4 = Responsive.useIsSpatial()
		local v5 = props.viewportHeight

		if v4 then
			v5 = uiManager.getInstance():getPanelObject(panelType.MoreMenu).AbsoluteSize.Y
		end

		v3 = math.min(#props.cellData * v.Size.Size_1000, v5 - 80 - 24)
	else
		v3 = math.min(#props.cellData * v.Size.Size_1000, props.viewportHeight - 80 - 24)
	end

	local v4 = v3 + 24

	local joined = {
		Paddings = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12)
		})
	}
	local v5, v6

	if GetFFlagModalSelectorCloseButton() then
		v4 = v3 + 48 + size_1000

		joined = Cryo.Dictionary.join(joined, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = 0
			}),
			Header = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, size_1000),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right
					}),
					CloseButton = React.createElement(IconButton, {
						size = UDim2.fromOffset(0, 0),
						iconSize = IconSize.Medium,
						icon = Images["icons/navigation/close"],
						onActivated = function()
							props.onClose()
						end
					})
				}
			),
			Divider = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = v2.Theme.Divider.Transparency,
				BackgroundColor3 = v2.Theme.Divider.Color,
				BorderSizePixel = 0,
				LayoutOrder = 2
			})
		})
		v5 = -36
		v6 = 12
	else
		v5 = 0
		v6 = 0
	end

	local joined2 = Cryo.Dictionary.join(joined, {
		SelectorFrame = React.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, v5), BackgroundTransparency = 1, LayoutOrder = 3 },
			{
				Paddings = React.createElement("UIPadding", { PaddingTop = UDim.new(0, v6) }),
				ModalSelector = React.createElement(ScrollingListTable, {
					selectable = false,
					size = UDim2.new(1, 0, 1, 0),
					cells = Dash.map(props.cellData, function(props2)
						local createElement = React.createElement
						local createElement2 = React.createElement
						local v7 = {
							labelText = props2.label,
							subLabelText = props2.subLabel,
							openTypeFeatures = 0
						}
						local openTypeFeatures

						if GetFFlagLuaAppEnableOpenTypeSupport() then
							openTypeFeatures = OpenTypeSupport:getUserNameStylisticAlternative()
						end

						v7.openTypeFeatures = openTypeFeatures
						return createElement(Cell, {
							head = createElement2(CellHeadDetail, v7),
							tail = React.createElement(CellTailDescription, {
								text = "",
								showArrow = false
							}),
							background = React.createElement("Frame", {
								BackgroundTransparency = 1,
								Size = UDim2.fromScale(1, 1)
							}),
							size = UDim2.new(1, 0, 0, v.Size.Size_1000),
							userInteractionEnabled = true,
							onActivated = function()
								props.onSelect(props2.label, props2.subLabel, props2.identifier)
								props.onClose()
							end
						})
					end)
				})
			}
		)
	})

	local createElement = React.createElement
	local v7 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0)
	}
	local overlay

	if props.isShown then
		overlay = React.createElement("TextButton", {
			Selectable = false,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundColor3 = theme.Overlay.Color,
			BackgroundTransparency = theme.Overlay.Transparency,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = 10,
			Text = "",
			[React.Event.Activated] = function()
				props.onClose()
			end
		}, {
			Modal = React.createElement(
				ModalWindow,
				{
					isFullHeight = false,
					screenSize = Vector2.new(props.viewportWidth, props.viewportHeight)
				},
				{
					ModalContent = React.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, v4),
						BackgroundTransparency = 0,
						BackgroundColor3 = theme.BackgroundDefault.Color,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 20)
					}, joined2)
				}
			)
		})
	end

	return createElement("Frame", v7, { Overlay = overlay })
end

function DialogWrapper(p)
	return React.createElement(CoreScriptsRootProvider, {}, {
		FocusNavigationCoreScriptsWrapper = React.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
				isIsolated = true,
				isAutoFocusRoot = true
			},
			{
				DialogContainer = React.createElement(ModalBaseSelectorDialog, p)
			}
		)
	})
end

return DialogWrapper
