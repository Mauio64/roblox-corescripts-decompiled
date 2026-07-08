local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
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
local CoreScriptsRootProvider = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).CoreScriptsRootProvider
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagModalSelectorCloseButton = require(AbuseReportMenu.Flags.GetFFlagModalSelectorCloseButton)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local Responsive = nil
local UIManager = nil
local PanelType = nil

if isInExperienceUIVREnabled then
	Responsive = require(CorePackages.Workspace.Packages.Responsive)

	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)

	UIManager = VrSpatialUi.UIManager
	PanelType = VrSpatialUi.Constants.PanelType
end

local function ModalBaseSelectorDialog(t1: {[any]: any}) -- line: 63
	-- upvalues: useTokens (copy), useStyle (copy), isInExperienceUIVREnabled (copy), Responsive (ref), UIManager (ref), PanelType (ref), React (copy), GetFFlagModalSelectorCloseButton (copy), Cryo (copy), IconButton (copy), IconSize (copy), Images (copy), ScrollingListTable (copy), Dash (copy), Cell (copy), CellHeadDetail (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy), CellTailDescription (copy), ModalWindow (copy)
	local v32 = useTokens()
	local v33 = useStyle()
	local Theme = v33.Theme
	local Size_1000 = v33.Tokens.Size.Size_1000
	local v38

	if isInExperienceUIVREnabled then
		local v36 = Responsive.useIsSpatial()
		local viewportHeight = t1.viewportHeight

		if v36 then
			viewportHeight = UIManager.getInstance():getPanelObject(PanelType.MoreMenu).AbsoluteSize.Y
		end

		v38 = math.min(#t1.cellData * v32.Size.Size_1000, viewportHeight - 80 - 24)
	else
		v38 = math.min(#t1.cellData * v32.Size.Size_1000, t1.viewportHeight - 80 - 24)
	end

	local v39 = v38 + 24
	local n1 = 0
	local n2 = 0
	local t2 = {
		Paddings = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12)
		})
	}

	if GetFFlagModalSelectorCloseButton() then
		v39 = v38 + 48 + Size_1000
		n1 = 12
		n2 = -36
		t2 = Cryo.Dictionary.join(t2, {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = 0,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Header = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, Size_1000)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right
				}),
				CloseButton = React.createElement(IconButton, {
					size = UDim2.fromOffset(0, 0),
					iconSize = IconSize.Medium,
					icon = Images["icons/navigation/close"],
					onActivated = function() -- line: 120
						-- upvalues: t1 (copy)
						t1.onClose()
					end
				})
			}),
			Divider = React.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = v33.Theme.Divider.Transparency,
				BackgroundColor3 = v33.Theme.Divider.Color
			})
		})
	end

	local v43 = Cryo.Dictionary.join(t2, {
		SelectorFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 1, n2)
		}, {
			Paddings = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, n1)
			}),
			ModalSelector = React.createElement(ScrollingListTable, {
				selectable = false,
				size = UDim2.new(1, 0, 1, 0),
				cells = Dash.map(t1.cellData, function(p1) -- line: 149
					-- upvalues: React (copy), Cell (copy), CellHeadDetail (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy), CellTailDescription (copy), v32 (copy), t1 (copy)
					return React.createElement(Cell, {
						userInteractionEnabled = true,
						head = React.createElement(CellHeadDetail, {
							labelText = p1.label,
							subLabelText = p1.subLabel,
							openTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getUserNameStylisticAlternative()
						}),
						tail = React.createElement(CellTailDescription, {
							text = "",
							showArrow = false
						}),
						background = React.createElement("Frame", {
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(1, 1)
						}),
						size = UDim2.new(1, 0, 0, v32.Size.Size_1000),
						onActivated = function() -- line: 168
							-- upvalues: t1 (copy), p1 (copy)
							t1.onSelect(p1.label, p1.subLabel, p1.identifier)
							t1.onClose()
						end
					})
				end)
			})
		})
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0)
	}, {
		Overlay = if not t1.isShown then nil else React.createElement("TextButton", {
			Selectable = false,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.Overlay.Color,
			BackgroundTransparency = Theme.Overlay.Transparency,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = 10,
			Text = "",
			[React.Event.Activated] = function() -- line: 195
				-- upvalues: t1 (copy)
				t1.onClose()
			end
		}, {
			Modal = React.createElement(ModalWindow, {
				isFullHeight = false,
				screenSize = Vector2.new(t1.viewportWidth, t1.viewportHeight)
			}, {
				ModalContent = React.createElement("Frame", {
					BackgroundTransparency = 0,
					Size = UDim2.new(1, 0, 0, v39),
					BackgroundColor3 = Theme.BackgroundDefault.Color,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 20)
				}, v43)
			})
		})
	})
end

function DialogWrapper(p2) -- line: 216
	-- upvalues: React (copy), CoreScriptsRootProvider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), ModalBaseSelectorDialog (copy)
	return React.createElement(CoreScriptsRootProvider, {}, {
		FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			DialogContainer = React.createElement(ModalBaseSelectorDialog, p2)
		})
	})
end

return DialogWrapper
