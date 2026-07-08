local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local withStyle = UIBlox.Core.Style.withStyle
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local KeyLabel = UIBlox.App.Menu.KeyLabel
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ParentParent = script.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local SetRespawning = require(ParentParent.Actions.SetRespawning)
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local Assets = require(ParentParent.Resources.Assets)
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)
local VoiceIndicator = require(RobloxGui.Modules.VoiceChat.Components.VoiceIndicator)
local Constants = require(ParentParent.Resources.Constants)
local Direction = require(ParentParent.Enums.Direction)
local PageNavigation = require(script.Parent.PageNavigation)
local GameIconHeader = require(script.Parent.GameIconHeader)
local ZonePortal = require(script.Parent.ZonePortal)
local Flags = ParentParent.Flags
local v34 = game:DefineFastFlag("TakeAScreenshotOfThis", false)
local v35 = game:DefineFastFlag("ShowContextMenuWhenButtonsArePresent", false)
local v36 = game:DefineFastFlag("UseVRSpecificLeaveButton", false)
local GetFFlagIGMGamepadSelectionHistory = require(Flags.GetFFlagIGMGamepadSelectionHistory)
local Images = UIBlox.App.ImageSet.Images
local FocusHandler = require(script.Parent.Connection.FocusHandler)
local IGMMainPageControllerBar = require(script.Parent.IGMMainPageControllerBar)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local t1 = {
	[Constants.InputType.MouseAndKeyboard] = Enum.KeyCode.R,
	[Constants.InputType.Gamepad] = Enum.KeyCode.ButtonY
}
local t2 = {
	[Constants.InputType.MouseAndKeyboard] = Enum.KeyCode.L,
	[Constants.InputType.Gamepad] = Enum.KeyCode.ButtonX
}
local v44 = Roact.PureComponent:extend("MainPage")

local function areCapturesAllowed() -- line: 73
	-- upvalues: VRService (copy), v34 (copy), CorePackages (copy)
	if VRService.VREnabled then
		return false
	end

	if not v34 then
		return true
	end

	return not require(CorePackages.Workspace.Packages.CachedPolicyService):IsSubjectToChinaPolicies()
end

function v44.renderButtonModels(p1, _, p3) -- line: 85
	-- upvalues: VRService (copy), v34 (copy), CorePackages (copy), Images (copy), RunService (copy), CoreGui (copy), Assets (copy), t1 (copy)
	local t3 = {}
	local inputType = p1.props.inputType

	if not VRService.VREnabled and (not v34 or not require(CorePackages.Workspace.Packages.CachedPolicyService):IsSubjectToChinaPolicies()) and v34 then
		table.insert(t3, {
			icon = Images["icons/controls/screenshot"],
			text = p3.screenCapture,
			onActivated = function() -- line: 99
				-- upvalues: p1 (copy), RunService (copy), CoreGui (copy)
				p1:setState({
					modalOpen = false
				})
				p1.props.closeMenu()
				RunService.RenderStepped:Wait()
				RunService.RenderStepped:Wait()
				CoreGui:TakeScreenshot()
			end
		})
	end

	if p1.props.respawnButtonVisible then
		table.insert(t3, {
			icon = Assets.Images.RespawnIcon,
			text = p3.respawnCharacter,
			onActivated = function() -- line: 118
				-- upvalues: p1 (copy)
				p1:setState({
					modalOpen = false
				})
				p1.props.startRespawning()
			end,
			keyCodeLabel = t1[inputType]
		})
	end

	return t3
end

v44.validateProps = t.strictInterface({
	open = t.boolean,
	isMainPageMoreMenuOpen = t.optional(t.boolean),
	respawnButtonVisible = t.boolean,
	startLeavingGame = t.callback,
	startRespawning = t.callback,
	setMainPageMoreMenuOpen = t.optional(t.callback),
	closeMenu = t.callback,
	screenSize = t.Vector2,
	canCaptureFocus = t.optional(t.boolean),
	inputType = t.optional(t.string),
	setFirstItemRef = t.optional(t.callback),
	voiceEnabled = t.optional(t.boolean),
	currentZone = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.number) or nil
})

function v44.init(p4) -- line: 148
	-- upvalues: Roact (copy)
	p4.moreMenuFrameRef = nil
	p4.moreMenuFirstItemFrameRef = nil
	p4.moreMenuButtonRef = Roact.createRef()
	p4.mainPageFirstButtonRef = Roact.createRef()

	function p4.setMoreMenuRef(p5) -- line: 154
		-- upvalues: p4 (copy)
		p4.moreMenuFrameRef = p5
	end
	function p4.setMoreMenuFirstItemRef(p6) -- line: 158
		-- upvalues: p4 (copy)
		p4.moreMenuFirstItemFrameRef = p6
	end

	p4.state = {
		modalOpen = false
	}
end
function v44.getDerivedStateFromProps(p7) -- line: 169
	if not p7.canCaptureFocus then
		return {
			modalOpen = false
		}
	end

	return nil
end
function v44.renderMainPageFocusHandler(p8) -- line: 178
	-- upvalues: GetFFlagIGMGamepadSelectionHistory (copy), Roact (copy), FocusHandler (copy), ContextActionService (copy), GuiService (copy)
	local v54 = p8.canGamepadCaptureFocus(p8.props)
	local v55 = nil

	if GetFFlagIGMGamepadSelectionHistory() then
		local modalOpen = p8.state.modalOpen

		v54 = p8.canGamepadCaptureFocus(p8.props) and not modalOpen
		v55 = not p8.props.open or p8.props.currentZone == 0
	end

	return Roact.createElement(FocusHandler, {
		isFocused = v54,
		shouldForgetPreviousSelection = v55,
		didFocus = GetFFlagIGMGamepadSelectionHistory() and function(p9) -- line: 193
			-- upvalues: ContextActionService (copy), p8 (copy), GuiService (copy)
			ContextActionService:BindCoreAction("LeftStickTogglesMoreMenuAction", function(_, p11) -- line: 196
				-- upvalues: p8 (copy)
				if p11 == Enum.UserInputState.End then
					p8:setState({
						modalOpen = true
					})

					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end, false, Enum.KeyCode.ButtonL3)
			GuiService.SelectedCoreObject = p9 or p8.mainPageFirstButtonRef:getValue()
		end or function() -- line: 210
			-- upvalues: ContextActionService (copy), p8 (copy)
			ContextActionService:BindCoreAction("LeftStickTogglesMoreMenuAction", function(_, p13) -- line: 211
				-- upvalues: p8 (copy)
				if p13 == Enum.UserInputState.End then
					p8:setState({
						modalOpen = not p8.state.modalOpen
					})

					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end, false, Enum.KeyCode.ButtonL3)
		end,
		didBlur = function() -- line: 222
			-- upvalues: ContextActionService (copy)
			ContextActionService:UnbindCoreAction("LeftStickTogglesMoreMenuAction")
		end
	})
end
function v44.renderMoreMenuFocusHandler(p14) -- line: 228
	-- upvalues: Roact (copy), FocusHandler (copy), GetFFlagIGMGamepadSelectionHistory (copy), ContextActionService (copy), GuiService (copy)
	local v58 = p14.canGamepadCaptureFocus(p14.props)
	local modalOpen = p14.state.modalOpen

	return Roact.createElement(FocusHandler, {
		isFocused = v58 and modalOpen,
		didFocus = function() -- line: 235
			-- upvalues: p14 (copy), GetFFlagIGMGamepadSelectionHistory (copy), ContextActionService (copy), GuiService (copy)
			local function v77(_, p16) -- line: 236
				-- upvalues: p14 (copy)
				if p16 == Enum.UserInputState.End then
					p14:setState({
						modalOpen = false
					})

					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end

			if GetFFlagIGMGamepadSelectionHistory() then
				ContextActionService:BindCoreAction("CloseMoreMenuAction", v77, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonL3)
			else
				ContextActionService:BindCoreAction("CloseMoreMenuAction", v77, false, Enum.KeyCode.ButtonB)
			end

			if p14.moreMenuFrameRef ~= nil then
				GuiService:RemoveSelectionGroup("MainPageMoreMenu")
			end

			GuiService:AddSelectionParent("MainPageMoreMenu", p14.moreMenuFrameRef)
			GuiService.SelectedCoreObject = p14.moreMenuFirstItemFrameRef
		end,
		didBlur = function() -- line: 271
			-- upvalues: ContextActionService (copy)
			ContextActionService:UnbindCoreAction("CloseMoreMenuAction")
		end
	})
end
function v44.render(p17) -- line: 277
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), Button (copy), ButtonType (copy), Assets (copy), v35 (copy), VRService (copy), v36 (copy), t2 (copy), IGMMainPageControllerBar (copy), VoiceIndicator (copy), Players (copy), default (copy), ZonePortal (copy), Direction (copy), GameIconHeader (copy), PageNavigation (copy), Constants (copy), ContextualMenu (copy), MenuDirection (copy), KeyLabel (copy)
	local v61 = p17.canGamepadCaptureFocus(p17.props)

	return withStyle(function(p18) -- line: 280
		-- upvalues: withLocalization (copy), Roact (copy), Button (copy), ButtonType (copy), p17 (copy), Assets (copy), v35 (copy), VRService (copy), v36 (copy), t2 (copy), IGMMainPageControllerBar (copy), v61 (copy), VoiceIndicator (copy), Players (copy), default (copy), ZonePortal (copy), Direction (copy), GameIconHeader (copy), PageNavigation (copy), Constants (copy), ContextualMenu (copy), MenuDirection (copy), KeyLabel (copy)
		return withLocalization({
			leaveGame = "CoreScripts.InGameMenu.LeaveGame",
			respawnCharacter = "CoreScripts.InGameMenu.RespawnCharacter",
			screenCapture = "CoreScripts.InGameMenu.Controls.Screenshot"
		})(function(p19) -- line: 285
			-- upvalues: Roact (copy), Button (copy), ButtonType (copy), p17 (copy), Assets (copy), p18 (copy), v35 (copy), VRService (copy), v36 (copy), t2 (copy), IGMMainPageControllerBar (copy), v61 (copy), VoiceIndicator (copy), Players (copy), default (copy), ZonePortal (copy), Direction (copy), GameIconHeader (copy), PageNavigation (copy), Constants (copy), ContextualMenu (copy), MenuDirection (copy), KeyLabel (copy)
			local v86 = Roact.createElement(Button, {
				buttonType = ButtonType.Secondary,
				size = UDim2.fromOffset(44, 44),
				onActivated = function() -- line: 289
					-- upvalues: p17 (copy)
					p17:setState({
						modalOpen = true
					})
				end,
				icon = Assets.Images.MoreActions,
				[Roact.Ref] = p17.moreMenuButtonRef
			})
			local v87 = p17:renderButtonModels(p18, p19)
			local respawnButtonVisible = p17.props.respawnButtonVisible

			if v35 then
				respawnButtonVisible = #v87 > 0
			end

			local inputType = p17.props.inputType
			local v90 = if not VRService.VREnabled or not v36 then t2[inputType] else Enum.KeyCode.ButtonX
			local v91 = not respawnButtonVisible and 0 or -56
			local modalOpen = p17.state.modalOpen
			local v93 = Roact.createElement(IGMMainPageControllerBar, {
				canCaptureFocus = v61,
				isMainPageMoreMenuOpen = modalOpen
			})
			local v94 = nil

			if p17.props.voiceEnabled then
				v94 = Roact.createElement(VoiceIndicator, {
					iconStyle = "MicLight",
					size = UDim2.fromOffset(44, 44),
					userId = tostring(Players.LocalPlayer.UserId),
					onClicked = function() -- line: 323
						-- upvalues: default (copy)
						default:ToggleMic("VRInGameMenuMainPage")
					end
				})
				v91 -= 56
			end

			return Roact.createElement("TextButton", {
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				Selectable = false,
				Size = UDim2.new(0, 400, 1, 0),
				BackgroundColor3 = p18.Theme.BackgroundDefault.Color,
				BackgroundTransparency = p18.Theme.BackgroundDefault.Transparency,
				Visible = p17.props.open
			}, {
				MoreMenuFocusHandler = p17:renderMoreMenuFocusHandler(),
				MainPageFocusHandler = not VRService.VREnabled and p17:renderMainPageFocusHandler() or nil,
				ControllerBar = v93,
				ZonePortal = Roact.createElement(ZonePortal, {
					targetZone = 0,
					direction = Direction.Left
				}),
				GameIconHeader = Roact.createElement(GameIconHeader),
				PageNavigation = Roact.createElement(PageNavigation, {
					Position = UDim2.new(0, Constants.Zone.ContentOffset, 0, 148),
					mainPageFirstButtonRef = p17.mainPageFirstButtonRef
				}),
				ContextualMenu = Roact.createElement(ContextualMenu, {
					closeBackgroundVisible = true,
					buttonProps = v87,
					setFrameRef = p17.setMoreMenuRef,
					setFirstItemRef = p17.setMoreMenuFirstItemRef,
					open = modalOpen,
					menuDirection = MenuDirection.Up,
					openPositionY = UDim.new(1, -84),
					screenSize = p17.props.screenSize,
					onDismiss = function() -- line: 365
						-- upvalues: p17 (copy)
						p17:setState({
							modalOpen = false
						})
					end
				}),
				BottomButtons = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 84),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1)
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 12),
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 24),
						PaddingBottom = UDim.new(0, 24),
						PaddingLeft = UDim.new(0, 24),
						PaddingRight = UDim.new(0, 24)
					}),
					LeaveGame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(1, v91, 0, 44),
						Position = UDim2.fromScale(1, 0),
						AnchorPoint = Vector2.new(1, 0)
					}, {
						Button = Roact.createElement(Button, {
							buttonType = ButtonType.PrimarySystem,
							size = UDim2.new(1, 0, 0, 44),
							onActivated = p17.props.startLeavingGame,
							text = p19.leaveGame
						}),
						KeyLabel = v90 and Roact.createElement(KeyLabel, {
							iconThemeKey = "UIDefault",
							textThemeKey = "SystemPrimaryContent",
							LayoutOrder = 2,
							ZIndex = 2,
							keyCode = v90,
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -16, 0.5, 0)
						}) or nil
					}),
					VoiceChatMuteButton = v94,
					MoreButton = respawnButtonVisible and v86
				})
			})
		end)
	end)
end
function v44.willUnmount(_) -- line: 421
	-- upvalues: GuiService (copy)
	GuiService:RemoveSelectionGroup("MainPageMoreMenu")
end
function v44.canGamepadCaptureFocus(p21) -- line: 425
	-- upvalues: Constants (copy)
	return p21.canCaptureFocus and p21.inputType == Constants.InputType.Gamepad
end
function v44.didUpdate(p22, p23, p24) -- line: 429
	-- upvalues: GetFFlagIGMGamepadSelectionHistory (copy), GuiService (copy), VRService (copy), UserInputService (copy)
	local modalOpen = p22.state.modalOpen
	local modalOpen2 = p24.modalOpen

	if not GetFFlagIGMGamepadSelectionHistory() and (p22.canGamepadCaptureFocus(p22.props) and not modalOpen) then
		if modalOpen2 then
			GuiService.SelectedCoreObject = p22.moreMenuButtonRef:getValue()
		elseif not p22.canGamepadCaptureFocus(p23) then
			GuiService.SelectedCoreObject = p22.mainPageFirstButtonRef:getValue()
		end
	end

	if VRService.VREnabled then
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
	end
end

return RoactRodux.UNSTABLE_connect2(function(p25, _) -- line: 449
	-- upvalues: GetFFlagIGMGamepadSelectionHistory (copy), Constants (copy)
	local currentZone = nil

	if GetFFlagIGMGamepadSelectionHistory() then
		currentZone = p25.currentZone
	end

	local v72 = p25.menuPage == Constants.MainPagePageKey and (p25.isMenuOpen and (not p25.respawn.dialogOpen and p25.currentZone == 1))

	return {
		isMainPageInForeground = nil,
		open = p25.isMenuOpen,
		respawnButtonVisible = p25.respawn.enabled,
		screenSize = p25.screenSize,
		voiceEnabled = p25.voiceState.voiceEnabled,
		canCaptureFocus = v72,
		currentZone = currentZone,
		inputType = p25.displayOptions.inputType
	}
end, function(p27) -- line: 472
	-- upvalues: SetCurrentPage (copy), Constants (copy), SetRespawning (copy), CloseMenu (copy)
	return {
		startLeavingGame = function() -- line: 474
			-- upvalues: p27 (copy), SetCurrentPage (copy), Constants (copy)
			p27(SetCurrentPage(Constants.LeaveGamePromptPageKey))
		end,
		startRespawning = function() -- line: 477
			-- upvalues: p27 (copy), SetRespawning (copy)
			p27(SetRespawning(true))
		end,
		closeMenu = function() -- line: 480
			-- upvalues: p27 (copy), CloseMenu (copy)
			p27(CloseMenu)
		end
	}
end)(v44)
