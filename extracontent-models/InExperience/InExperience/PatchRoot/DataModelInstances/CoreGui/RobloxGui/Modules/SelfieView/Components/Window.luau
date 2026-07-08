local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Packages = CorePackages.Packages
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local React = require(Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
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
local v35 = if not require(CorePackages.Workspace.Packages.Chrome).Enabled() then nil else require(Chrome.Service)
local UnibarStyle = require(CorePackages.Workspace.Packages.Chrome).UnibarStyle
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(Chrome.ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local FFlagTopBarSignalizeScreenSize = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeScreenSize
local v39 = game:DefineFastFlag("ReactDevtoolsFixTopbar", true)
local v40 = require(RobloxGui.Modules.SelfView.Analytics).new()
local v41 = Images["icons/actions/previewShrink"]
local v42 = Images["icons/actions/previewExpand"]
local FaceClone = require(script.Parent.FaceClone)

local function Window(t1: {[any]: any}) -- line: 78
	-- upvalues: useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), useAppPolicy (copy), useLocalization (copy), useCameraOn (copy), useTrackerMessage (copy), useWindowSizeIsLarge (copy), useScreenSize (copy), FFlagTopBarSignalizeScreenSize (copy), SizingUtils (copy), useSelector (copy), React (copy), useLocalPlayer (copy), FaceChatUtils (copy), useTooltipDismissal (copy), clearTimeout (copy), setTimeout (copy), ModelUtils (copy), v40 (copy), FaceClone (copy), ControlState (copy), Interactable (copy), CameraStatusIcon (copy), v35 (copy), ImageSetLabel (copy), v41 (copy), v42 (copy), StyledTextLabel (copy), v39 (copy), withTooltip (copy), CoreGui (copy), TooltipOrientation (copy), CameraStatusDot (copy)
	local id = t1.id
	local v47 = useStyle()
	local Theme = v47.Theme
	local Font = v47.Font
	local v50 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.CLOSE_BUTTON_FRAME else UnibarStyle.use().CLOSE_BUTTON_FRAME
	local v51 = useAppPolicy(function(p1) -- line: 93
		return p1.getShowUpdatedCameraPath()
	end)
	local v52 = useLocalization({
		robloxPermissionErrorHeader = "CoreScripts.TopBar.RobloxPermissionErrorHeader",
		dynamicAvatarMissingErrorHeader = "CoreScripts.TopBar.DynamicAvatarMissingErrorHeader",
		dynamicAvatarMissingErrorBody = "CoreScripts.TopBar.DynamicAvatarMissingErrorBody",
		robloxPermissionErrorBody = not v51 and "CoreScripts.TopBar.RobloxPermissionErrorBody" or "CoreScripts.TopBar.RobloxPermissionErrorBodyTwo"
	})
	local v53 = useCameraOn()
	local v54 = useTrackerMessage()
	local v55 = useWindowSizeIsLarge(t1.windowSize)
	local v56 = useScreenSize()
	local v57 = if not FFlagTopBarSignalizeScreenSize then useSelector(function(p2) -- line: 114
		-- upvalues: SizingUtils (copy), v55 (copy)
		return SizingUtils.getSize(p2.displayOptions.screenSize, v55)
	end) else SizingUtils.getSize(v56, v55)

	React.useEffect(function() -- line: 117
		-- upvalues: t1 (copy), v57 (copy)
		t1.windowSize:requestSize(v57.X, v57.Y)
	end, { v57 })

	local v58 = useLocalPlayer()
	local v59 = React.useMemo(function() -- line: 123
		-- upvalues: FaceChatUtils (copy)
		return FaceChatUtils.getPermissions().userCamEligible and FaceChatUtils.getPermissions().placeCamEnabled
	end)
	local v60, v61, v62, v63 = useTooltipDismissal(2000)
	local v64, v65 = React.useState(true)
	local v66, v67 = React.useState(false)
	local v68, v69 = React.useState(false)
	local v70, v71 = React.useState(false)
	local v72 = React.useRef(nil)

	local function v73() -- line: 136
		-- upvalues: v72 (copy), clearTimeout (copy), v65 (copy), setTimeout (copy)
		if v72.current then
			clearTimeout(v72.current)
		end

		v65(true)
		v72.current = setTimeout(function() -- line: 141
			-- upvalues: v65 (copy)
			v65(false)
		end, 2000)
	end

	React.useEffect(function() -- line: 145
		-- upvalues: v72 (copy), clearTimeout (copy), v65 (copy), setTimeout (copy)
		if v72.current then
			clearTimeout(v72.current)
		end

		v65(true)
		v72.current = setTimeout(function() -- line: 141
			-- upvalues: v65 (copy)
			v65(false)
		end, 2000)

		return function() -- line: 148
			-- upvalues: v72 (copy), clearTimeout (copy)
			if v72.current then
				clearTimeout(v72.current)
			end
		end
	end, { v72 })

	local function v74(p3) -- line: 155
		-- upvalues: v72 (copy), clearTimeout (copy), v65 (copy), setTimeout (copy), FaceChatUtils (copy), v63 (copy), v52 (copy), v58 (copy), ModelUtils (copy), v40 (copy)
		if v72.current then
			clearTimeout(v72.current)
		end

		v65(true)
		v72.current = setTimeout(function() -- line: 141
			-- upvalues: v65 (copy)
			v65(false)
		end, 2000)

		if not FaceChatUtils.getPermissions().userCamEnabled and not p3 then
			v63(v52.robloxPermissionErrorHeader, v52.robloxPermissionErrorBody)

			return
		end

		if v58.Character and not ModelUtils.hasDynamicHead(v58.Character) and not FaceChatUtils.isCameraOn() and not p3 then
			v63(v52.dynamicAvatarMissingErrorHeader, v52.dynamicAvatarMissingErrorBody)
		end

		v40:setLastCtx("SelfView")
		FaceChatUtils.toggleVideoAnimation()
	end

	local v75 = React.useCallback(function() -- line: 173
		-- upvalues: v74 (copy)
		v74(false)
	end, {
		FaceChatUtils,
		ModelUtils,
		v52,
		v58
	})
	local v76 = React.useCallback(function() -- line: 177
		-- upvalues: v72 (copy), clearTimeout (copy), v65 (copy), setTimeout (copy)
		if v72.current then
			clearTimeout(v72.current)
		end

		v65(true)
		v72.current = setTimeout(function() -- line: 141
			-- upvalues: v65 (copy)
			v65(false)
		end, 2000)
	end, {
		v73,
		v64,
		t1.windowSize
	})
	local v77 = React.useRef(nil)

	React.useEffect(function() -- line: 182
		-- upvalues: FaceClone (copy), v58 (copy), v77 (copy)
		if _G.__TESTEZ_RUNNING_TEST__ then
			return
		end

		local v85 = FaceClone(v58, v77.current)

		return function() -- line: 193
			-- upvalues: v85 (copy)
			if v85 then
				v85()
			end
		end
	end, {
		v58,
		v77
	})

	local v78 = React.useCallback(function(_, p5) -- line: 200
		-- upvalues: v69 (copy), ControlState (copy)
		v69(p5 == ControlState.Hover)
	end, { v69 })
	local v79 = React.useCallback(function(_, p7) -- line: 204
		-- upvalues: v67 (copy), ControlState (copy)
		v67(p7 == ControlState.Hover)
	end, { v67 })
	local v80 = React.useCallback(function(_, p9) -- line: 208
		-- upvalues: v71 (copy), ControlState (copy)
		v71(p9 == ControlState.Hover)
	end, { v71 })
	local v81 = React.useCallback(function(p10) -- line: 212
		-- upvalues: React (copy), Interactable (copy), v68 (copy), FaceChatUtils (copy), v47 (copy), v78 (copy), v75 (copy), CameraStatusIcon (copy)
		return React.createElement(Interactable, {
			Size = UDim2.fromOffset(36, 36),
			BackgroundColor3 = if not v68 or not FaceChatUtils.getPermissions().userCamEnabled then v47.Theme.BackgroundUIContrast.Color else v47.Theme.BackgroundOnHover.Color,
			BackgroundTransparency = v47.Theme.Overlay.Transparency,
			onStateChanged = v78,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			[React.Change.AbsoluteSize] = p10,
			[React.Change.AbsolutePosition] = p10,
			[React.Event.Activated] = v75
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			CameraStatusIcon = React.createElement(CameraStatusIcon, {
				iconSize = UDim2.fromOffset(28, 28),
				transparency = FaceChatUtils.getPermissions().userCamEnabled and 0 or 0.5
			})
		})
	end, {
		v78,
		v75
	})

	return React.createElement("Frame", {
		Name = "SelfieViewFrame",
		Active = true,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v47.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = 0,
		[React.Event.MouseEnter] = v73,
		[React.Event.MouseMoved] = v73,
		ref = v77
	}, {}, {
		CloseButtonWrapper = v64 and React.createElement("Frame", {
			ZIndex = 2,
			BackgroundTransparency = 1,
			Size = v50
		}, {
			CloseButtonLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			CloseButtonInteractable = React.createElement(Interactable, {
				Size = UDim2.fromOffset(36, 36),
				BackgroundColor3 = if not v66 then v47.Theme.BackgroundUIContrast.Color else v47.Theme.BackgroundOnHover.Color,
				BackgroundTransparency = 0.8,
				onStateChanged = v79,
				[React.Event.Activated] = if not v35 then nil else function() -- line: 267
					-- upvalues: v35 (copy), id (copy)
					v35:toggleWindow(id)
				end
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				Fragment = React.createElement(React.Fragment, nil, {
					React.createElement("Frame", {
						Name = "X1",
						BorderSizePixel = 0,
						BackgroundTransparency = 0,
						Rotation = 45,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Size = UDim2.new(0, 16, 0, 2),
						BackgroundColor3 = v47.Theme.IconEmphasis.Color
					}, {
						Corner = React.createElement("UICorner", {
							CornerRadius = UDim.new(1, 0)
						})
					}),
					(React.createElement("Frame", {
						Name = "X2",
						BorderSizePixel = 0,
						BackgroundTransparency = 0,
						Rotation = -45,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Size = UDim2.new(0, 16, 0, 2),
						BackgroundColor3 = v47.Theme.IconEmphasis.Color
					}, {
						Corner = React.createElement("UICorner", {
							CornerRadius = UDim.new(1, 0)
						})
					}))
				})
			})
		}),
		ExpandButtonWrapper = if not v64 then nil else React.createElement("Frame", {
			ZIndex = 2,
			BackgroundTransparency = 1,
			Size = v50,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0)
		}, {
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
			ExpandButtonInteractable = React.createElement(Interactable, {
				Size = UDim2.fromOffset(36, 36),
				BackgroundColor3 = if not v70 then v47.Theme.BackgroundUIContrast.Color else v47.Theme.BackgroundOnHover.Color,
				BackgroundTransparency = 0.8,
				onStateChanged = v80,
				[React.Event.Activated] = if not v35 then nil else function() -- line: 337
					-- upvalues: t1 (copy)
					t1.windowSize:toggleIsLarge()
				end
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				ExpandImage = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromOffset(28, 28),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Image = if not v55 then v42 else v41,
					ImageColor3 = Theme.TextEmphasis.Color,
					ImageTransparency = Theme.TextEmphasis.Transparency
				})
			})
		}),
		Corners = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		ControlMessage = React.createElement("Frame", {
			ZIndex = 2,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -44),
			BackgroundColor3 = Theme.BackgroundUIDefault.Color,
			AutomaticSize = Enum.AutomaticSize.XY,
			Visible = v54.visible
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
				layoutOrder = 1,
				text = v54.text,
				fontStyle = Font.Footer,
				colorStyle = Theme.TextDefault,
				textXAlignment = Enum.TextXAlignment.Center,
				size = UDim2.fromOffset(46, 36),
				TextWrapped = not v39 or nil,
				textWrapped = not not v39 or nil
			}),
			Line2 = React.createElement(StyledTextLabel, {
				layoutOrder = 2,
				text = v54.status,
				fontStyle = Font.Footer,
				colorStyle = Theme.ContextualPrimaryContent,
				textXAlignment = Enum.TextXAlignment.Center,
				size = UDim2.fromOffset(46, 12),
				automaticSize = Enum.AutomaticSize.Y
			})
		}),
		IconFrame = v64 and (not not v59 and React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = v50,
			Position = UDim2.fromScale(0.5, 1),
			AnchorPoint = Vector2.new(0.5, 1)
		}, {
			Tooltip = withTooltip({
				headerText = v60,
				bodyText = v61,
				textXAlignment = Enum.TextXAlignment.Left
			}, {
				DisplayOrder = 101,
				guiTarget = CoreGui,
				active = v62,
				preferredOrientation = TooltipOrientation.Bottom
			}, v81),
			Hover = React.createElement("Frame", {
				Size = UDim2.fromOffset(32, 32),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = v47.Theme.BackgroundOnHover.Transparency,
				BackgroundColor3 = v47.Theme.BackgroundOnHover.Color
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				})
			})
		})) or nil,
		CameraStatusDot = if not v53 then nil else React.createElement(CameraStatusDot, {
			ZIndex = 2,
			Position = UDim2.new(1, -12, 1, -12),
			Size = UDim2.fromOffset(8, 8)
		}),
		Interactable = React.createElement(Interactable, {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[React.Event.Activated] = v76
		})
	})
end

return Window
