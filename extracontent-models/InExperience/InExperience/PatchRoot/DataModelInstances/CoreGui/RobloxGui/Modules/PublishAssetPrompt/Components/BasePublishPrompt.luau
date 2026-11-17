local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local ExperienceAuthService = game:GetService("ExperienceAuthService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle
local FullPageModal = UIBlox.App.Dialog.Modal.FullPageModal
local Overlay = UIBlox.App.Dialog.Overlay
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InputUi = require(CorePackages.Workspace.Packages.InputUi)
local GamepadUtils = InputUi.Gamepad.GamepadUtils
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local InputType = require(CorePackages.Workspace.Packages.InputType)
local InputType2 = require(CorePackages.Workspace.Packages.InputType)
local getInputGroup = InputType2.getInputGroup

local parent = script.Parent
local LabeledTextBox = require(parent.Common.LabeledTextBox)
local CloseOpenPrompt = require(script.Parent.Parent.Actions.CloseOpenPrompt)
local SetPromptVisibility = require(script.Parent.Parent.Actions.SetPromptVisibility)
local LeaveCreationAlert = require(script.Parent.LeaveCreationAlert)
local Constants = require(script.Parent.Parent.Constants)
local Constants2 = require(RobloxGui.Modules.TopBar.Constants)
local PreviewViewport = require(parent.Common.PreviewViewport)
local ValidationErrorModal = require(parent.ValidationErrorModal)
local PurchasePrompt = require(CorePackages.Workspace.Packages.PurchasePrompt)
local PublishAssetAnalytics = PurchasePrompt.PublishAssetAnalytics

local extended = Roact.PureComponent:extend("BasePublishPrompt")

local udim = UDim.new(1.5, 0)

local function isGamepadInput(p): boolean -- 2 equivalent calls inferred from this helper
	return getInputGroup(p) == InputType.InputTypeConstants.Gamepad
end

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	nameLabel = t.string,
	defaultName = t.string,
	promptBody = t.any,
	titleText = t.string,
	showingPreviewView = t.boolean,
	closePreviewView = t.callback,
	isMakeupPreview = t.optional(t.boolean),
	asset = t.optional(t.union(t.instanceOf("Model"), t.instanceIsA("AnimationClip"))),
	onNameUpdated = t.callback,
	canSubmit = t.callback,
	onSubmit = t.callback,
	enableInputDelayed = t.optional(t.boolean),
	isDelayedInput = t.optional(t.boolean),
	delayInputSeconds = t.optional(t.number),
	priceInRobux = t.optional(t.number),
	showTopScrim = t.optional(t.boolean),
	guid = t.any,
	scopes = t.any,
	errorMessage = t.optional(t.string),
	promptVisible = t.optional(t.boolean),
	closePrompt = t.callback,
	SetPromptVisibility = t.callback
})

function extended:init()
	self.swipeScrollingFrameRef = Roact.createRef()
	self.inputState = nil
	self.inputObject = nil
	self.connection = nil
	self.disposeUiScaleEffect = Signals.createEffect(function(p)
		self:setState({
			UiScale = Display.GetDisplayStore(p).getUIScale(p)
		})
	end)

	function self.storeInput(_, inputState, inputObject)
		self.inputState = inputState
		self.inputObject = inputObject

		return Enum.ContextActionResult.Sink
	end

	self:setState({
		showUnsavedDataWarning = false,
		isGamepad = isGamepadInput(UserInputService:GetLastInputType()) -- inferred equivalent call
	})

	function self.closePrompt()
		self.props.closePrompt()
		self.props.SetPromptVisibility(false)
	end

	function self.showUnsavedDataWarning()
		self:setState({ showUnsavedDataWarning = true })

		PublishAssetAnalytics.sendButtonClicked(
			PublishAssetAnalytics.Section.BuyCreationPage,
			PublishAssetAnalytics.Element.X
		)
	end

	function self.cancelClosePrompt()
		self:setState({ showUnsavedDataWarning = false })
	end

	function self.denyAndClose()
		ExperienceAuthService:ScopeCheckUIComplete(
			self.props.guid,
			self.props.scopes,
			Enum.ScopeCheckResult.ConsentDenied,
			{}
		)

		self.closePrompt()
	end

	function self.confirmAndUpload()
		if self.props.canSubmit() then
			self.props.onSubmit()
		end
	end
end

function extended:setUpGamepad()
	if UserInputService.GamepadEnabled then
		ContextActionService:UnbindCoreAction("ScrollPrompt")
		ContextActionService:BindCoreAction("ScrollPrompt", self.storeInput, false, Enum.KeyCode.Thumbstick2)
		self.connection = RunService.RenderStepped:Connect(function(dt)
			if self.inputState == Enum.UserInputState.Change and self.inputObject then
				local position = self.inputObject.Position
				local current = self.swipeScrollingFrameRef.current
				local v = current.CanvasPosition.Y + dt * -GamepadUtils.normalizeStickByDeadzone(position).Y * 1000

				if v <= current.AbsoluteSize.Y * udim.Scale + udim.Offset then
					current.CanvasPosition = Vector2.new(0, v)
				end
			end
		end)

		ContextActionService:UnbindCoreAction("ClosePrompt")
		ContextActionService:BindCoreAction("ClosePrompt", self.storeInput, false, Enum.KeyCode.ButtonB)
	end
end

function extended:cleanupGamepad()
	ContextActionService:UnbindCoreAction("ClosePrompt")
	ContextActionService:UnbindCoreAction("ScrollPrompt")

	if self.connection then
		self.connection:Disconnect()
	end
end

function extended:overrideMouseIconBehavior()
	local v

	if self.state.isGamepad then
		v = Enum.OverrideMouseIconBehavior.ForceHide
	else
		v = Enum.OverrideMouseIconBehavior.ForceShow
	end

	MouseIconOverrideService.push("BasePublishPromptOverrideKey", v)
end

function extended:removeMouseIconBehaviorOverride()
	MouseIconOverrideService.pop("BasePublishPromptOverrideKey")
end

function extended:didMount()
	self:setUpGamepad()

	self.props.SetPromptVisibility(true)

	self:overrideMouseIconBehavior()
end

function extended:didUpdate(p, p2)
	if p.promptVisible ~= self.props.promptVisible and self.props.promptVisible == false then
		self.closePrompt()
	end

	if self.state.isGamepad ~= p2.isGamepad then
		self:overrideMouseIconBehavior()
	end
end

function extended:renderMiddle(p)
	return withStyle(function(props)
		local font = props.Font
		local baseSize = font.BaseSize
		local theme = props.Theme

		local footer = font.Footer
		local color = theme.TextDefault.Color

		return Roact.createFragment({
			ScrollingFrame = Roact.createElement("ScrollingFrame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -50),
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				Selectable = false,
				[Roact.Ref] = self.swipeScrollingFrameRef
			}, {
				layout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, Constants.PromptSidePadding),
					PaddingRight = UDim.new(0, Constants.PromptSidePadding)
				}),
				NameInput = Roact.createElement(LabeledTextBox, {
					LayoutOrder = 1,
					labelText = self.props.nameLabel,
					topPadding = 24,
					defaultText = self.props.defaultName,
					onTextUpdated = self.props.onNameUpdated,
					textBoxHeight = 30
				}),
				PromptBody = Roact.createElement(
					"Frame",
					{
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						LayoutOrder = 2
					},
					self.props.promptBody
				)
			}),
			BottomGradient = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 5),
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, -50),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ZIndex = 2
			}, {
				gradient = Roact.createElement("UIGradient", {
					Rotation = 270,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, theme.BackgroundUIDefault.Color),
						ColorSequenceKeypoint.new(1, theme.BackgroundUIDefault.Color)
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, theme.BackgroundUIDefault.Transparency),
						NumberSequenceKeypoint.new(0.5, theme.BackgroundUIDefault.Transparency),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			}),
			DisclaimerContainer = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 50),
					Position = UDim2.new(0, 0, 1, -50)
				},
				{
					padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, Constants.PromptSidePadding),
						PaddingRight = UDim.new(0, Constants.PromptSidePadding)
					}),
					Disclaimer = Roact.createElement("TextLabel", {
						Size = UDim2.fromScale(1, 1),
						Text = p.disclaimer,
						FontFace = normalizeFontFace(props.Tokens.Typography.CaptionSmall.Font),
						TextSize = baseSize * footer.RelativeSize,
						TextColor3 = color,
						BackgroundTransparency = 1,
						TextWrapped = true
					})
				}
			)
		})
	end)
end

function extended:renderAlertLocalized(p)
	local guiInset, _ = GuiService:GetGuiInset()
	local udim2 = UDim2.new(0, 0, 0, -guiInset.Y)
	local udim3 = UDim2.new(1, 0, 1, guiInset.Y)
	local v = Constants2.TopBarHeight * self.state.UiScale

	return withStyle(function(p2)
		local theme = p2.Theme
		local text

		if self.props.priceInRobux and self.props.priceInRobux > 0 then
			text = string.format("%s %i", "", self.props.priceInRobux)
		else
			text = p.submit
		end

		local createFragment = Roact.createFragment
		local v2 = {
			LastInputTypeConnection = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.LastInputTypeChanged,
				callback = function(p3)
					self:setState({ isGamepad = isGamepadInput(p3) }) -- inferred equivalent call
				end
			}),
			BottomScrim = Roact.createElement(
				"Frame",
				{ Position = udim2, Size = udim3, ZIndex = -1, BackgroundTransparency = 1 },
				{
					Overlay = Roact.createElement(Overlay, { showGradient = false }),
					InputSink = Roact.createElement("TextButton", {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Text = "",
						Modal = true
					})
				}
			),
			PublishPrompt = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -v),
				Position = UDim2.fromOffset(0, v),
				Visible = not (self.state.showUnsavedDataWarning or self.props.showingPreviewView or self.props.showTopScrim)
			}, {
				FullPageModal = Roact.createElement(FullPageModal, {
					title = self.props.titleText,
					onCloseClicked = self.showUnsavedDataWarning,
					distanceFromTop = 4,
					marginSize = 0,
					screenSize = self.props.screenSize,
					buttonStackProps = {
						buttons = {
							{
								buttonType = ButtonType.PrimarySystem,
								props = {
									isDisabled = not self.props.canSubmit(),
									isDelayedInput = self.props.isDelayedInput,
									enableInputDelayed = self.props.enableInputDelayed,
									delayInputSeconds = self.props.delayInputSeconds,
									onActivated = self.confirmAndUpload,
									text = text,
									isLoading = not self.props.priceInRobux
								}
							}
						},
						disableRoactGamepadButtonSelection = true
					}
				}, { middleContent = self:renderMiddle(p) })
			}),
			LeaveCreationAlert = 0,
			ValidationErrorAlert = 0,
			PreviewFrame = 0,
			TopScrim = 0
		}
		local leaveCreationAlert

		if self.state.showUnsavedDataWarning then
			leaveCreationAlert = Roact.createElement(LeaveCreationAlert, {
				screenSize = self.props.screenSize,
				closePrompt = self.denyAndClose,
				cancelClosePrompt = self.cancelClosePrompt
			})
		end

		v2.LeaveCreationAlert = leaveCreationAlert
		local validationErrorAlert

		if self.props.errorMessage then
			validationErrorAlert = Roact.createElement(ValidationErrorModal, {
				screenSize = self.props.screenSize,
				closePrompt = self.closePrompt
			})
		end

		v2.ValidationErrorAlert = validationErrorAlert

		v2.PreviewFrame = self.props.showingPreviewView and Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = theme.BackgroundUIDefault.Transparency
		}, {
			PreviewViewport = Roact.createElement(PreviewViewport, {
				asset = self.props.asset,
				closePreviewView = self.props.closePreviewView,
				isMakeupPreview = self.props.isMakeupPreview
			})
		}) or nil

		v2.TopScrim = Roact.createElement("Frame", {
			Position = udim2,
			Size = udim3,
			ZIndex = 2,
			BackgroundTransparency = 1,
			Visible = self.props.showTopScrim
		}, {
			InputSink = Roact.createElement("TextButton", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = ""
			})
		})
		return createFragment(v2)
	end)
end

local function GetLocalizedStrings() -- 1 equivalent call inferred from this helper
	local localizedStrings = {}
	localizedStrings.submit = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Submit")
	localizedStrings.disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishCommon.Disclaimer")

	return localizedStrings
end

function extended:render()
	return self:renderAlertLocalized(GetLocalizedStrings()) -- inferred equivalent call
end

function extended:willUnmount()
	self:removeMouseIconBehaviorOverride()

	self:cleanupGamepad()

	if self.disposeUiScaleEffect then
		self.disposeUiScaleEffect()
	end

	self.props.SetPromptVisibility(false)
end

local function mapStateToProps(p)
	return {
		guid = p.promptRequest.promptInfo.guid,
		scopes = p.promptRequest.promptInfo.scopes,
		errorMessage = p.promptRequest.promptInfo.errorMessage,
		promptVisible = p.promptRequest.promptInfo.promptVisible
	}
end

local function mapDispatchToProps(callback)
	return {
		closePrompt = function()
			return callback(CloseOpenPrompt())
		end,
		SetPromptVisibility = function(p)
			return callback(SetPromptVisibility(p))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
