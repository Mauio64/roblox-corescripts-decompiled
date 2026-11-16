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

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local KeyLabel = UIBlox.App.Menu.KeyLabel
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local parent = script.Parent.Parent

local withLocalization = require(parent.Localization.withLocalization)

local SetRespawning = require(parent.Actions.SetRespawning)
local CloseMenu = require(parent.Thunks.CloseMenu)
local Assets = require(parent.Resources.Assets)
local SetCurrentPage = require(parent.Actions.SetCurrentPage)
local VoiceIndicator = require(RobloxGui.Modules.VoiceChat.Components.VoiceIndicator)

local Constants = require(parent.Resources.Constants)
local Direction = require(parent.Enums.Direction)

local PageNavigation = require(script.Parent.PageNavigation)
local GameIconHeader = require(script.Parent.GameIconHeader)
local ZonePortal = require(script.Parent.ZonePortal)

local flags = parent.Flags
local defineFastFlag = game:DefineFastFlag("TakeAScreenshotOfThis", false)
local defineFastFlag2 = game:DefineFastFlag("ShowContextMenuWhenButtonsArePresent", false)
local defineFastFlag3 = game:DefineFastFlag("UseVRSpecificLeaveButton", false)
local GetFFlagIGMGamepadSelectionHistory = require(flags.GetFFlagIGMGamepadSelectionHistory)
local Images = UIBlox.App.ImageSet.Images
local FocusHandler = require(script.Parent.Connection.FocusHandler)
local IGMMainPageControllerBar = require(script.Parent.IGMMainPageControllerBar)

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default

local v = {
	[Constants.InputType.MouseAndKeyboard] = Enum.KeyCode.R,
	[Constants.InputType.Gamepad] = Enum.KeyCode.ButtonY
}

local v2 = {
	[Constants.InputType.MouseAndKeyboard] = Enum.KeyCode.L,
	[Constants.InputType.Gamepad] = Enum.KeyCode.ButtonX
}

local extended = Roact.PureComponent:extend("MainPage")

local function areCapturesAllowed(): boolean -- 1 equivalent call inferred from this helper
	if VRService.VREnabled then
		return false
	end

	if not defineFastFlag then
		return true
	end

	local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
	return not CachedPolicyService:IsSubjectToChinaPolicies()
end

function extended:renderButtonModels(_, p)
	local buttonModels = {}
	local inputType = self.props.inputType

	if areCapturesAllowed() and defineFastFlag then -- inferred equivalent call
		table.insert(buttonModels, {
			icon = Images["icons/controls/screenshot"],
			text = p.screenCapture,
			onActivated = function()
				self:setState({ modalOpen = false })

				self.props.closeMenu()

				RunService.RenderStepped:Wait()
				RunService.RenderStepped:Wait()

				CoreGui:TakeScreenshot()
			end
		})
	end

	if self.props.respawnButtonVisible then
		table.insert(buttonModels, {
			icon = Assets.Images.RespawnIcon,
			text = p.respawnCharacter,
			onActivated = function()
				self:setState({ modalOpen = false })

				self.props.startRespawning()
			end,
			keyCodeLabel = v[inputType]
		})
	end

	return buttonModels
end

extended.validateProps = t.strictInterface({
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

function extended:init()
	self.moreMenuFrameRef = nil
	self.moreMenuFirstItemFrameRef = nil
	self.moreMenuButtonRef = Roact.createRef()
	self.mainPageFirstButtonRef = Roact.createRef()

	function self.setMoreMenuRef(moreMenuFrameRef)
		self.moreMenuFrameRef = moreMenuFrameRef
	end

	function self.setMoreMenuFirstItemRef(moreMenuFirstItemFrameRef)
		self.moreMenuFirstItemFrameRef = moreMenuFirstItemFrameRef
	end

	self.state = { modalOpen = false }
end

function extended.getDerivedStateFromProps(p)
	if p.canCaptureFocus then
		return nil
	end

	return { modalOpen = false }
end

function extended:renderMainPageFocusHandler()
	local isFocused = self.canGamepadCaptureFocus(self.props)
	local shouldForgetPreviousSelection

	if GetFFlagIGMGamepadSelectionHistory() then
		local modalOpen = self.state.modalOpen

		isFocused = self.canGamepadCaptureFocus(self.props) and not modalOpen

		shouldForgetPreviousSelection = not self.props.open or self.props.currentZone == 0
	end

	return Roact.createElement(FocusHandler, {
		isFocused = isFocused,
		shouldForgetPreviousSelection = shouldForgetPreviousSelection,
		didFocus = GetFFlagIGMGamepadSelectionHistory() and function(p)
			ContextActionService:BindCoreAction("LeftStickTogglesMoreMenuAction", function(_, p2)
				if p2 ~= Enum.UserInputState.End then
					return Enum.ContextActionResult.Pass
				end

				self:setState({ modalOpen = true })

				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonL3)

			GuiService.SelectedCoreObject = p or self.mainPageFirstButtonRef:getValue()
		end or function()
			ContextActionService:BindCoreAction("LeftStickTogglesMoreMenuAction", function(_, p)
				if p ~= Enum.UserInputState.End then
					return Enum.ContextActionResult.Pass
				end

				self:setState({
					modalOpen = not self.state.modalOpen
				})

				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonL3)
		end,
		didBlur = function()
			ContextActionService:UnbindCoreAction("LeftStickTogglesMoreMenuAction")
		end
	})
end

function extended:renderMoreMenuFocusHandler()
	local canGamepadCaptureFocus = self.canGamepadCaptureFocus(self.props)

	local modalOpen = self.state.modalOpen

	return Roact.createElement(FocusHandler, {
		isFocused = canGamepadCaptureFocus and modalOpen,
		didFocus = function()
			local function fn(_, p)
				if p ~= Enum.UserInputState.End then
					return Enum.ContextActionResult.Pass
				end

				self:setState({ modalOpen = false })

				return Enum.ContextActionResult.Sink
			end

			if GetFFlagIGMGamepadSelectionHistory() then
				ContextActionService:BindCoreAction(
					"CloseMoreMenuAction",
					fn,
					false,
					Enum.KeyCode.ButtonB,
					Enum.KeyCode.ButtonL3
				)
			else
				ContextActionService:BindCoreAction("CloseMoreMenuAction", fn, false, Enum.KeyCode.ButtonB)
			end

			if self.moreMenuFrameRef ~= nil then
				GuiService:RemoveSelectionGroup("MainPageMoreMenu")
			end

			GuiService:AddSelectionParent("MainPageMoreMenu", self.moreMenuFrameRef)

			GuiService.SelectedCoreObject = self.moreMenuFirstItemFrameRef
		end,
		didBlur = function()
			ContextActionService:UnbindCoreAction("CloseMoreMenuAction")
		end
	})
end

function extended:render()
	local canGamepadCaptureFocus = self.canGamepadCaptureFocus(self.props)

	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				BackgroundDefault = {
					Color = p.Color.Surface.Surface_0.Color3,
					Transparency = p.Color.Surface.Surface_0.Transparency
				}
			}
		}
	end, function(p)
		return withLocalization({
			leaveGame = "CoreScripts.InGameMenu.LeaveGame",
			respawnCharacter = "CoreScripts.InGameMenu.RespawnCharacter",
			screenCapture = "CoreScripts.InGameMenu.Controls.Screenshot"
		})(function(p2)
			local element = Roact.createElement(Button, {
				buttonType = ButtonType.Secondary,
				size = UDim2.fromOffset(44, 44),
				onActivated = function()
					self:setState({ modalOpen = true })
				end,
				icon = Assets.Images.MoreActions,
				[Roact.Ref] = self.moreMenuButtonRef
			})

			local buttonModels = self:renderButtonModels(p, p2)
			local v3 = self.props.respawnButtonVisible

			if defineFastFlag2 then
				v3 = #buttonModels > 0
			end

			local inputType = self.props.inputType
			local keyCode

			if VRService.VREnabled and defineFastFlag3 then
				keyCode = Enum.KeyCode.ButtonX
			else
				keyCode = v2[inputType]
			end

			local v4 = v3 and -56 or 0
			local modalOpen = self.state.modalOpen

			local element2 = Roact.createElement(IGMMainPageControllerBar, {
				canCaptureFocus = canGamepadCaptureFocus,
				isMainPageMoreMenuOpen = modalOpen
			})
			local voiceChatMuteButton

			if self.props.voiceEnabled then
				voiceChatMuteButton = Roact.createElement(VoiceIndicator, {
					size = UDim2.fromOffset(44, 44),
					userId = tostring(Players.LocalPlayer.UserId),
					iconStyle = "MicLight",
					onClicked = function()
						default:ToggleMic("VRInGameMenuMainPage")
					end
				})

				v4 -= 56
			end

			local createElement = Roact.createElement
			local v5 = {
				Size = UDim2.new(0, 400, 1, 0),
				BackgroundColor3 = p.Theme.BackgroundDefault.Color,
				BackgroundTransparency = p.Theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				Visible = self.props.open,
				Text = "",
				AutoButtonColor = false,
				Selectable = false
			}

			local children = {
				MoreMenuFocusHandler = self:renderMoreMenuFocusHandler(),
				MainPageFocusHandler = 0,
				ControllerBar = 0,
				ZonePortal = 0,
				GameIconHeader = 0,
				PageNavigation = 0,
				ContextualMenu = 0,
				BottomButtons = 0
			}
			local mainPageFocusHandler

			if not VRService.VREnabled then
				mainPageFocusHandler = self:renderMainPageFocusHandler() or nil
			end

			children.MainPageFocusHandler = mainPageFocusHandler
			children.ControllerBar = element2
			children.ZonePortal = Roact.createElement(ZonePortal, {
				targetZone = 0,
				direction = Direction.Left
			})

			children.GameIconHeader = Roact.createElement(GameIconHeader)
			children.PageNavigation = Roact.createElement(PageNavigation, {
				Position = UDim2.new(0, Constants.Zone.ContentOffset, 0, 148),
				mainPageFirstButtonRef = self.mainPageFirstButtonRef
			})

			children.ContextualMenu = Roact.createElement(ContextualMenu, {
				buttonProps = buttonModels,
				setFrameRef = self.setMoreMenuRef,
				setFirstItemRef = self.setMoreMenuFirstItemRef,
				open = modalOpen,
				menuDirection = MenuDirection.Up,
				openPositionY = UDim.new(1, -84),
				closeBackgroundVisible = true,
				screenSize = self.props.screenSize,
				onDismiss = function()
					self:setState({ modalOpen = false })
				end
			})

			children.BottomButtons = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 84),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1
				},
				{
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
						Size = UDim2.new(1, v4, 0, 44),
						Position = UDim2.fromScale(1, 0),
						AnchorPoint = Vector2.new(1, 0),
						LayoutOrder = 1
					}, {
						Button = Roact.createElement(Button, {
							buttonType = ButtonType.PrimarySystem,
							size = UDim2.new(1, 0, 0, 44),
							onActivated = self.props.startLeavingGame,
							text = p2.leaveGame
						}),
						KeyLabel = keyCode and Roact.createElement(KeyLabel, {
							keyCode = keyCode,
							iconThemeKey = "UIDefault",
							textThemeKey = "SystemPrimaryContent",
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -16, 0.5, 0),
							LayoutOrder = 2,
							ZIndex = 2
						}) or nil
					}),
					VoiceChatMuteButton = voiceChatMuteButton,
					MoreButton = v3 and element
				}
			)
			return createElement("TextButton", v5, children)
		end)
	end)
end

function extended.willUnmount(_)
	GuiService:RemoveSelectionGroup("MainPageMoreMenu")
end

function extended.canGamepadCaptureFocus(p)
	return p.canCaptureFocus and p.inputType == Constants.InputType.Gamepad
end

function extended.didUpdate(data, p, p2)
	local modalOpen = data.state.modalOpen

	local modalOpen2 = p2.modalOpen

	if not GetFFlagIGMGamepadSelectionHistory() and data.canGamepadCaptureFocus(data.props) and not modalOpen then
		if modalOpen2 then
			GuiService.SelectedCoreObject = data.moreMenuButtonRef:getValue()
		elseif not data.canGamepadCaptureFocus(p) then
			GuiService.SelectedCoreObject = data.mainPageFirstButtonRef:getValue()
		end
	end

	if VRService.VREnabled then
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
	end
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local currentZone

	if GetFFlagIGMGamepadSelectionHistory() then
		currentZone = data.currentZone
	end

	local canCaptureFocus = data.menuPage == Constants.MainPagePageKey
		and data.isMenuOpen
		and not data.respawn.dialogOpen
		and data.currentZone == 1

	return {
		open = data.isMenuOpen,
		respawnButtonVisible = data.respawn.enabled,
		screenSize = data.screenSize,
		voiceEnabled = data.voiceState.voiceEnabled,
		canCaptureFocus = canCaptureFocus,
		currentZone = currentZone,
		inputType = data.displayOptions.inputType,
		isMainPageInForeground = nil
	}
end, function(callback)
	return {
		startLeavingGame = function()
			callback(SetCurrentPage(Constants.LeaveGamePromptPageKey))
		end,
		startRespawning = function()
			callback(SetRespawning(true))
		end,
		closeMenu = function()
			callback(CloseMenu)
		end
	}
end)(extended)
