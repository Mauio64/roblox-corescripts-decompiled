local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Packages = CorePackages.Packages
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization
local React = require(Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local LuauPolyfill = require(Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout
require(script.Parent.Parent.Parent.Chrome.ChromeShared.Service.WindowSizeSignal)
local useWindowSizeIsLarge = require(script.Parent.Parent.Parent.Chrome.ChromeShared.Hooks.useWindowSizeIsLarge)

local UIBlox = require(Packages.UIBlox)
local Interactable = UIBlox.Core.Control.Interactable
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local ControlState = UIBlox.Core.Control.Enum.ControlState
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local CameraStatusIcon = require(script.Parent.CameraStatusIcon)
local CameraStatusDot = require(script.Parent.CameraStatusDot)
local SizingUtils = require(script.Parent.Parent.Utils.SizingUtils)
local FaceChatUtils = require(script.Parent.Parent.Utils.FaceChatUtils)
local ModelUtils = require(script.Parent.Parent.Utils.ModelUtils)
local useCameraOn = require(script.Parent.Parent.Hooks.useCameraOn)
local useLocalPlayer = require(script.Parent.Parent.Hooks.useLocalPlayer)
local useTrackerMessage = require(script.Parent.Parent.Hooks.useTrackerMessage)
local useTooltipDismissal = require(script.Parent.Parent.Hooks.useTooltipDismissal)
local useScreenSize = require(CoreGui.RobloxGui.Modules.Common.Hooks.useScreenSize)
local Constants = require(script.Parent.Parent.Parent.Chrome.ChromeShared.Unibar.Constants)
local Chrome = script.Parent.Parent.Parent.Chrome
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local Service

if Chrome2.Enabled() then
	Service = require(Chrome.Service)
else
	Service = nil
end

local Chrome3 = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome3.UnibarStyle

local Flags = require(Chrome.ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize
local defineFastFlag = game:DefineFastFlag("ReactDevtoolsFixTopbar", true)

local Analytics = require(RobloxGui.Modules.SelfView.Analytics)
local v = Analytics.new()

local iconsactionspreviewShrink = Images["icons/actions/previewShrink"]
local iconsactionspreviewExpand = Images["icons/actions/previewExpand"]

local FaceClone = require(script.Parent.FaceClone)

local function Window(p)
	local id = p.id
	local v2 = useStyle()

	local theme = v2.Theme
	local font = v2.Font
	local CLOSE_BUTTON_FRAME

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		CLOSE_BUTTON_FRAME = UnibarStyle.use().CLOSE_BUTTON_FRAME
	else
		CLOSE_BUTTON_FRAME = Constants.CLOSE_BUTTON_FRAME
	end

	local v3 = useLocalization({
		robloxPermissionErrorHeader = "CoreScripts.TopBar.RobloxPermissionErrorHeader",
		robloxPermissionErrorBody = useAppPolicy(function(p2)
			return p2.getShowUpdatedCameraPath()
		end) and "CoreScripts.TopBar.RobloxPermissionErrorBodyTwo" or "CoreScripts.TopBar.RobloxPermissionErrorBody",
		dynamicAvatarMissingErrorHeader = "CoreScripts.TopBar.DynamicAvatarMissingErrorHeader",
		dynamicAvatarMissingErrorBody = "CoreScripts.TopBar.DynamicAvatarMissingErrorBody"
	})

	local v4 = useCameraOn()
	local v5 = useTrackerMessage()

	local v6 = useWindowSizeIsLarge(p.windowSize)

	local v7 = useScreenSize()
	local v8

	if FFlagTopBarSignalizeScreenSize then
		v8 = SizingUtils.getSize(v7, v6)
	else
		v8 = useSelector(function(p2)
			return SizingUtils.getSize(p2.displayOptions.screenSize, v6)
		end)
	end

	React.useEffect(function()
		p.windowSize:requestSize(v8.X, v8.Y)
	end, { v8 })

	local v9 = useLocalPlayer()

	local v10 = React.useMemo(function()
		return FaceChatUtils.getPermissions().userCamEligible and FaceChatUtils.getPermissions().placeCamEnabled
	end)

	local headerText, bodyText, active, v11 = useTooltipDismissal(2000)

	local state, setState = React.useState(true)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)
	local ref = React.useRef(nil)
	local function fn() -- 3 equivalent calls inferred from this helper
		if ref.current then
			clearTimeout(ref.current)
		end

		setState(true)
		ref.current = setTimeout(function()
			setState(false)
		end, 2000)
	end
	React.useEffect(function()
		fn() -- inferred equivalent call
		return function()
			if ref.current then
				clearTimeout(ref.current)
			end
		end
	end, { ref })

	local function fn2(p2)
		fn() -- inferred equivalent call

		if not (FaceChatUtils.getPermissions().userCamEnabled or p2) then
			v11(v3.robloxPermissionErrorHeader, v3.robloxPermissionErrorBody)
			return
		end

		if v9.Character and not (ModelUtils.hasDynamicHead(v9.Character) or FaceChatUtils.isCameraOn() or p2) then
			v11(v3.dynamicAvatarMissingErrorHeader, v3.dynamicAvatarMissingErrorBody)
		end

		v:setLastCtx("SelfView")
		FaceChatUtils.toggleVideoAnimation()
	end

	local v12 = React.useCallback(function()
		fn2(false)
	end, { FaceChatUtils, ModelUtils, v3, v9 })

	local v13 = React.useCallback(function()
		fn() -- inferred equivalent call
	end, { fn, state, p.windowSize })

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		if _G.__TESTEZ_RUNNING_TEST__ then
			return
		end

		local faceClone = FaceClone(v9, ref2.current)

		return function()
			if faceClone then
				faceClone()
			end
		end
	end, { v9, ref2 })

	local onStateChanged = React.useCallback(function(_, p2)
		setState3(p2 == ControlState.Hover)
	end, { setState3 })

	local onStateChanged2 = React.useCallback(function(_, p2)
		setState2(p2 == ControlState.Hover)
	end, { setState2 })

	local onStateChanged3 = React.useCallback(function(_, p2)
		setState4(p2 == ControlState.Hover)
	end, { setState4 })

	local v14 = React.useCallback(function(p2)
		local createElement = React.createElement
		local v14 = {
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			Size = UDim2.fromOffset(36, 36)
		}
		local backgroundColor

		if state3 and FaceChatUtils.getPermissions().userCamEnabled then
			backgroundColor = v2.Theme.BackgroundOnHover.Color
		else
			backgroundColor = v2.Theme.BackgroundUIContrast.Color
		end

		v14.BackgroundColor3 = backgroundColor

		v14.BackgroundTransparency = v2.Theme.Overlay.Transparency
		v14.onStateChanged = onStateChanged
		v14.Position = UDim2.fromScale(0.5, 0.5)
		v14.AnchorPoint = Vector2.new(0.5, 0.5)
		v14[React.Change.AbsoluteSize] = p2
		v14[React.Change.AbsolutePosition] = p2
		v14[React.Event.Activated] = v12
		return createElement(Interactable, v14, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
			CameraStatusIcon = React.createElement(CameraStatusIcon, {
				iconSize = UDim2.fromOffset(28, 28),
				transparency = FaceChatUtils.getPermissions().userCamEnabled and 0 or 0.5
			})
		})
	end, { onStateChanged, v12 })

	local createElement = React.createElement
	local v15 = {
		Name = "SelfieViewFrame",
		Active = true,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v2.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = 0,
		[React.Event.MouseEnter] = fn,
		[React.Event.MouseMoved] = fn,
		ref = ref2
	}
	local closeButtonWrapper

	if state then
		local createElement2 = React.createElement

		local v16 = {
			CloseButtonLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			CloseButtonInteractable = 0
		}

		local createElement3 = React.createElement
		local v17 = {
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			Size = UDim2.fromOffset(36, 36)
		}
		local backgroundColor

		if state2 then
			backgroundColor = v2.Theme.BackgroundOnHover.Color
		else
			backgroundColor = v2.Theme.BackgroundUIContrast.Color
		end

		v17.BackgroundColor3 = backgroundColor

		v17.BackgroundTransparency = 0.8
		v17.onStateChanged = onStateChanged2
		v17[React.Event.Activated] = Service and function()
			Service:toggleWindow(id)
		end or nil
		v16.CloseButtonInteractable = createElement3(Interactable, v17, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
			Fragment = React.createElement(React.Fragment, nil, {
				React.createElement("Frame", {
					Name = "X1",
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(0, 16, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = v2.Theme.IconEmphasis.Color,
					BackgroundTransparency = 0,
					Rotation = 45
				}, {
					Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
				}),
				(React.createElement("Frame", {
					Name = "X2",
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(0, 16, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = v2.Theme.IconEmphasis.Color,
					BackgroundTransparency = 0,
					Rotation = -45
				}, {
					Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
				}))
			})
		})
		closeButtonWrapper = createElement2(
			"Frame",
			{ ZIndex = 2, BackgroundTransparency = 1, Size = CLOSE_BUTTON_FRAME },
			v16
		)
	else
		closeButtonWrapper = state
	end

	local expandButtonWrapper

	if state then
		local createElement2 = React.createElement
		local v16 = {
			ZIndex = 2,
			BackgroundTransparency = 1,
			Size = CLOSE_BUTTON_FRAME,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0)
		}
		local v17 = {
			ExpandButtonLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			ExpandButtonPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4)
			}),
			ExpandButtonInteractable = 0
		}

		local createElement3 = React.createElement
		local v18 = {
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			Size = UDim2.fromOffset(36, 36)
		}
		local backgroundColor

		if state4 then
			backgroundColor = v2.Theme.BackgroundOnHover.Color
		else
			backgroundColor = v2.Theme.BackgroundUIContrast.Color
		end

		v18.BackgroundColor3 = backgroundColor

		v18.BackgroundTransparency = 0.8
		v18.onStateChanged = onStateChanged3
		v18[React.Event.Activated] = Service and function()
			p.windowSize:toggleIsLarge()
		end or nil

		local v19 = {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
			ExpandImage = 0
		}

		local createElement4 = React.createElement
		local v20 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(28, 28),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = 0,
			ImageColor3 = 0,
			ImageTransparency = 0
		}
		local image

		if v6 then
			image = iconsactionspreviewShrink
		else
			image = iconsactionspreviewExpand
		end

		v20.Image = image
		v20.ImageColor3 = theme.TextEmphasis.Color
		v20.ImageTransparency = theme.TextEmphasis.Transparency
		v19.ExpandImage = createElement4(ImageSetLabel, v20)
		v17.ExpandButtonInteractable = createElement3(Interactable, v18, v19)
		expandButtonWrapper = createElement2("Frame", v16, v17)
	end

	local children = {
		CloseButtonWrapper = closeButtonWrapper,
		ExpandButtonWrapper = expandButtonWrapper,
		Corners = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		ControlMessage = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -44),
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			AutomaticSize = Enum.AutomaticSize.XY,
			ZIndex = 2,
			BorderSizePixel = 0,
			Visible = v5.visible
		}, {
			Corners = React.createElement("UICorner", {}),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 8)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical
			}),
			Line1 = React.createElement(StyledTextLabel, {
				text = v5.text,
				fontStyle = font.Footer,
				colorStyle = theme.TextDefault,
				textXAlignment = Enum.TextXAlignment.Center,
				layoutOrder = 1,
				size = UDim2.fromOffset(46, 36),
				TextWrapped = not defineFastFlag or nil,
				textWrapped = defineFastFlag and true or nil
			}),
			Line2 = React.createElement(StyledTextLabel, {
				text = v5.status,
				fontStyle = font.Footer,
				colorStyle = theme.ContextualPrimaryContent,
				textXAlignment = Enum.TextXAlignment.Center,
				layoutOrder = 2,
				size = UDim2.fromOffset(46, 12),
				automaticSize = Enum.AutomaticSize.Y
			})
		}),
		IconFrame = state and v10 and React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = CLOSE_BUTTON_FRAME,
			Position = UDim2.fromScale(0.5, 1),
			AnchorPoint = Vector2.new(0.5, 1),
			ZIndex = 2
		}, {
			Tooltip = withTooltip(
				{
					headerText = headerText,
					bodyText = bodyText,
					textXAlignment = Enum.TextXAlignment.Left
				},
				{
					guiTarget = CoreGui,
					active = active,
					DisplayOrder = 101,
					preferredOrientation = TooltipOrientation.Bottom
				},
				v14
			),
			Hover = React.createElement("Frame", {
				Size = UDim2.fromOffset(32, 32),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = v2.Theme.BackgroundOnHover.Transparency,
				BackgroundColor3 = v2.Theme.BackgroundOnHover.Color
			}, {
				Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
			})
		}) or nil,
		CameraStatusDot = 0,
		Interactable = 0
	}
	local cameraStatusDot

	if v4 then
		cameraStatusDot = React.createElement(CameraStatusDot, {
			Position = UDim2.new(1, -12, 1, -12),
			ZIndex = 2,
			Size = UDim2.fromOffset(8, 8)
		})
	end

	children.CameraStatusDot = cameraStatusDot

	children.Interactable = React.createElement(Interactable, {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		[React.Event.Activated] = v13
	})
	return createElement("Frame", v15, {}, children)
end

return Window
