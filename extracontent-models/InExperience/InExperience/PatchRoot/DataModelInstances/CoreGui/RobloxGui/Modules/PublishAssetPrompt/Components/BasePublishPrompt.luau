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
local withStyle = UIBlox.Style.withStyle
local FullPageModal = UIBlox.App.Dialog.Modal.FullPageModal
local Overlay = UIBlox.App.Dialog.Overlay
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local GamepadUtils = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils
local MouseIconOverrideService = require(CorePackages.Workspace.Packages.CoreScriptsCommon).MouseIconOverrideService
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local InputType = require(CorePackages.Workspace.Packages.InputType)
local getInputGroup = require(CorePackages.Workspace.Packages.InputType).getInputGroup
local scriptParent = script.Parent
local LabeledTextBox = require(scriptParent.Common.LabeledTextBox)
local CloseOpenPrompt = require(script.Parent.Parent.Actions.CloseOpenPrompt)
local SetPromptVisibility = require(script.Parent.Parent.Actions.SetPromptVisibility)
local LeaveCreationAlert = require(script.Parent.LeaveCreationAlert)
local Constants = require(script.Parent.Parent.Constants)
local Constants2 = require(RobloxGui.Modules.TopBar.Constants)
local PreviewViewport = require(scriptParent.Common.PreviewViewport)
local ValidationErrorModal = require(scriptParent.ValidationErrorModal)
local PublishAssetAnalytics = require(CorePackages.Workspace.Packages.PurchasePrompt).PublishAssetAnalytics
local v35 = Roact.PureComponent:extend("BasePublishPrompt")
local uDim = UDim.new(1.5, 0)

local function isGamepadInput(p1) -- line: 69
	-- upvalues: getInputGroup (copy), InputType (copy)
	return getInputGroup(p1) == InputType.InputTypeConstants.Gamepad
end

v35.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	nameLabel = t.string,
	defaultName = t.string,
	promptBody = t.any,
	titleText = t.string,
	showingPreviewView = t.boolean,
	closePreviewView = t.callback,
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

function v35.init(p2) -- line: 107
	-- upvalues: Roact (copy), Signals (copy), Display (copy), UserInputService (copy), getInputGroup (copy), InputType (copy), PublishAssetAnalytics (copy), ExperienceAuthService (copy)
	p2.swipeScrollingFrameRef = Roact.createRef()
	p2.inputState = nil
	p2.inputObject = nil
	p2.connection = nil
	p2.disposeUiScaleEffect = Signals.createEffect(function(p3) -- line: 112
		-- upvalues: Display (copy), p2 (copy)
		local v68 = Display.GetDisplayStore(p3)

		p2:setState({
			UiScale = v68.getUIScale(p3)
		})
	end)

	function p2.storeInput(_, p5, p6) -- line: 119
		-- upvalues: p2 (copy)
		p2.inputState = p5
		p2.inputObject = p6

		return Enum.ContextActionResult.Sink
	end

	local t1 = {
		showUnsavedDataWarning = false
	}
	local LastInputType = UserInputService:GetLastInputType()

	t1.isGamepad = getInputGroup(LastInputType) == InputType.InputTypeConstants.Gamepad
	p2:setState(t1)

	function p2.closePrompt() -- line: 133
		-- upvalues: p2 (copy)
		p2.props.closePrompt()
		p2.props.SetPromptVisibility(false)
	end
	function p2.showUnsavedDataWarning() -- line: 138
		-- upvalues: p2 (copy), PublishAssetAnalytics (copy)
		p2:setState({
			showUnsavedDataWarning = true
		})
		PublishAssetAnalytics.sendButtonClicked(PublishAssetAnalytics.Section.BuyCreationPage, PublishAssetAnalytics.Element.X)
	end
	function p2.cancelClosePrompt() -- line: 146
		-- upvalues: p2 (copy)
		p2:setState({
			showUnsavedDataWarning = false
		})
	end
	function p2.denyAndClose() -- line: 152
		-- upvalues: ExperienceAuthService (copy), p2 (copy)
		ExperienceAuthService:ScopeCheckUIComplete(p2.props.guid, p2.props.scopes, Enum.ScopeCheckResult.ConsentDenied, {})
		p2.closePrompt()
	end
	function p2.confirmAndUpload() -- line: 163
		-- upvalues: p2 (copy)
		if p2.props.canSubmit() then
			p2.props.onSubmit()
		end
	end
end
function v35.setUpGamepad(p7) -- line: 170
	-- upvalues: UserInputService (copy), ContextActionService (copy), RunService (copy), GamepadUtils (copy), uDim (copy)
	if UserInputService.GamepadEnabled then
		ContextActionService:UnbindCoreAction("ScrollPrompt")
		ContextActionService:BindCoreAction("ScrollPrompt", p7.storeInput, false, Enum.KeyCode.Thumbstick2)
		p7.connection = RunService.RenderStepped:Connect(function(dt) -- line: 174
			-- upvalues: p7 (copy), GamepadUtils (copy), uDim (copy)
			if p7.inputState == Enum.UserInputState.Change and p7.inputObject then
				local inputObjectPosition = p7.inputObject.Position
				local current = p7.swipeScrollingFrameRef.current
				local v75 = current.CanvasPosition.Y + dt * -GamepadUtils.normalizeStickByDeadzone(inputObjectPosition).Y * 1000

				if v75 <= current.AbsoluteSize.Y * uDim.Scale + uDim.Offset then
					current.CanvasPosition = Vector2.new(0, v75)
				end
			end
		end)
		ContextActionService:UnbindCoreAction("ClosePrompt")
		ContextActionService:BindCoreAction("ClosePrompt", p7.storeInput, false, Enum.KeyCode.ButtonB)
	end
end
function v35.cleanupGamepad(p8) -- line: 194
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("ClosePrompt")
	ContextActionService:UnbindCoreAction("ScrollPrompt")

	if p8.connection then
		p8.connection:Disconnect()
	end
end
function v35.overrideMouseIconBehavior(p9) -- line: 202
	-- upvalues: MouseIconOverrideService (copy)
	local v48 = if not p9.state.isGamepad then Enum.OverrideMouseIconBehavior.ForceShow else Enum.OverrideMouseIconBehavior.ForceHide

	MouseIconOverrideService.push("BasePublishPromptOverrideKey", v48)
end
function v35.removeMouseIconBehaviorOverride(_) -- line: 210
	-- upvalues: MouseIconOverrideService (copy)
	MouseIconOverrideService.pop("BasePublishPromptOverrideKey")
end
function v35.didMount(p11) -- line: 214
	p11:setUpGamepad()
	p11.props.SetPromptVisibility(true)
	p11:overrideMouseIconBehavior()
end
function v35.didUpdate(p12, p13, p14) -- line: 223
	if p13.promptVisible ~= p12.props.promptVisible and p12.props.promptVisible == false then
		p12.closePrompt()
	end

	if p12.state.isGamepad ~= p14.isGamepad then
		p12:overrideMouseIconBehavior()
	end
end
function v35.renderMiddle(p15, p16) -- line: 237
	-- upvalues: withStyle (copy), Roact (copy), Constants (copy), LabeledTextBox (copy)
	return withStyle(function(p17) -- line: 238
		-- upvalues: Roact (copy), p15 (copy), Constants (copy), LabeledTextBox (copy), p16 (copy)
		local p17Font = p17.Font
		local BaseSize = p17Font.BaseSize
		local Theme = p17.Theme
		local Footer = p17Font.Footer
		local TextDefaultColor = Theme.TextDefault.Color

		return Roact.createFragment({
			ScrollingFrame = Roact.createElement("ScrollingFrame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -50),
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				Selectable = false,
				[Roact.Ref] = p15.swipeScrollingFrameRef
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
					topPadding = 24,
					textBoxHeight = 30,
					labelText = p15.props.nameLabel,
					defaultText = p15.props.defaultName,
					onTextUpdated = p15.props.onNameUpdated
				}),
				PromptBody = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, p15.props.promptBody)
			}),
			BottomGradient = Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ZIndex = 2,
				Size = UDim2.new(1, 0, 0, 5),
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, -50),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			}, {
				gradient = Roact.createElement("UIGradient", {
					Rotation = 270,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Theme.BackgroundUIDefault.Color),
						ColorSequenceKeypoint.new(1, Theme.BackgroundUIDefault.Color)
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, Theme.BackgroundUIDefault.Transparency),
						NumberSequenceKeypoint.new(0.5, Theme.BackgroundUIDefault.Transparency),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			}),
			DisclaimerContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 50),
				Position = UDim2.new(0, 0, 1, -50)
			}, {
				padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, Constants.PromptSidePadding),
					PaddingRight = UDim.new(0, Constants.PromptSidePadding)
				}),
				Disclaimer = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextWrapped = true,
					Size = UDim2.fromScale(1, 1),
					Text = p16.disclaimer,
					Font = Footer.Font,
					TextSize = BaseSize * Footer.RelativeSize,
					TextColor3 = TextDefaultColor
				})
			})
		})
	end)
end
function v35.renderAlertLocalized(p18, p19) -- line: 329
	-- upvalues: GuiService (copy), Constants2 (copy), withStyle (copy), Roact (copy), ExternalEventConnection (copy), UserInputService (copy), getInputGroup (copy), InputType (copy), Overlay (copy), FullPageModal (copy), ButtonType (copy), LeaveCreationAlert (copy), ValidationErrorModal (copy), PreviewViewport (copy)
	local v58, _ = GuiService:GetGuiInset()
	local uDim2 = UDim2.new(0, 0, 0, -v58.Y)
	local uDim2_2 = UDim2.new(1, 0, 1, v58.Y)
	local v62 = Constants2.TopBarHeight * p18.state.UiScale

	return withStyle(function(p20) -- line: 335
		-- upvalues: p18 (copy), p19 (copy), Roact (copy), ExternalEventConnection (copy), UserInputService (copy), getInputGroup (copy), InputType (copy), uDim2 (copy), uDim2_2 (copy), Overlay (copy), v62 (copy), FullPageModal (copy), ButtonType (copy), LeaveCreationAlert (copy), ValidationErrorModal (copy), PreviewViewport (copy)
		local Theme = p20.Theme
		local v84 = if not p18.props.priceInRobux or not (p18.props.priceInRobux > 0) then p19.submit else string.format("%s %i", "\238\128\130", p18.props.priceInRobux)

		return Roact.createFragment({
			LastInputTypeConnection = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.LastInputTypeChanged,
				callback = function(p21) -- line: 345
					-- upvalues: p18 (copy), getInputGroup (copy), InputType (copy)
					p18:setState({
						isGamepad = getInputGroup(p21) == InputType.InputTypeConstants.Gamepad
					})
				end
			}),
			BottomScrim = Roact.createElement("Frame", {
				ZIndex = -1,
				BackgroundTransparency = 1,
				Position = uDim2,
				Size = uDim2_2
			}, {
				Overlay = Roact.createElement(Overlay, {
					showGradient = false
				}),
				InputSink = Roact.createElement("TextButton", {
					BackgroundTransparency = 1,
					Text = "",
					Modal = true,
					Size = UDim2.fromScale(1, 1)
				})
			}),
			PublishPrompt = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -v62),
				Position = UDim2.fromOffset(0, v62),
				Visible = not p18.state.showUnsavedDataWarning and (not p18.props.showingPreviewView and not p18.props.showTopScrim)
			}, {
				FullPageModal = Roact.createElement(FullPageModal, {
					distanceFromTop = 4,
					marginSize = 0,
					title = p18.props.titleText,
					onCloseClicked = p18.showUnsavedDataWarning,
					screenSize = p18.props.screenSize,
					buttonStackProps = {
						disableRoactGamepadButtonSelection = true,
						buttons = {{
							buttonType = ButtonType.PrimarySystem,
							props = {
								isDisabled = not p18.props.canSubmit(),
								isDelayedInput = p18.props.isDelayedInput,
								enableInputDelayed = p18.props.enableInputDelayed,
								delayInputSeconds = p18.props.delayInputSeconds,
								onActivated = p18.confirmAndUpload,
								text = v84,
								isLoading = not p18.props.priceInRobux
							}
						}}
					}
				}, {
					middleContent = p18:renderMiddle(p19)
				})
			}),
			LeaveCreationAlert = if not p18.state.showUnsavedDataWarning then nil else Roact.createElement(LeaveCreationAlert, {
				screenSize = p18.props.screenSize,
				closePrompt = p18.denyAndClose,
				cancelClosePrompt = p18.cancelClosePrompt
			}),
			ValidationErrorAlert = if not p18.props.errorMessage then nil else Roact.createElement(ValidationErrorModal, {
				screenSize = p18.props.screenSize,
				closePrompt = p18.closePrompt
			}),
			PreviewFrame = p18.props.showingPreviewView and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Theme.BackgroundUIDefault.Color,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = Theme.BackgroundUIDefault.Transparency
			}, {
				PreviewViewport = Roact.createElement(PreviewViewport, {
					asset = p18.props.asset,
					closePreviewView = p18.props.closePreviewView
				})
			}) or nil,
			TopScrim = Roact.createElement("Frame", {
				ZIndex = 2,
				BackgroundTransparency = 1,
				Position = uDim2,
				Size = uDim2_2,
				Visible = p18.props.showTopScrim
			}, {
				InputSink = Roact.createElement("TextButton", {
					BackgroundTransparency = 1,
					Text = "",
					Size = UDim2.fromScale(1, 1)
				})
			})
		})
	end)
end

local function GetLocalizedStrings() -- line: 450
	-- upvalues: RobloxTranslator (copy)
	return {
		submit = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Submit"),
		disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishCommon.Disclaimer")
	}
end

function v35.render(p22) -- line: 458
	-- upvalues: RobloxTranslator (copy)
	return p22:renderAlertLocalized({
		submit = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Submit"),
		disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishCommon.Disclaimer")
	})
end
function v35.willUnmount(p23) -- line: 463
	p23:removeMouseIconBehaviorOverride()
	p23:cleanupGamepad()

	if p23.disposeUiScaleEffect then
		p23.disposeUiScaleEffect()
	end

	p23.props.SetPromptVisibility(false)
end

local function mapStateToProps(p24) -- line: 476
	return {
		guid = p24.promptRequest.promptInfo.guid,
		scopes = p24.promptRequest.promptInfo.scopes,
		errorMessage = p24.promptRequest.promptInfo.errorMessage,
		promptVisible = p24.promptRequest.promptInfo.promptVisible
	}
end
local function mapDispatchToProps(p25) -- line: 485
	-- upvalues: CloseOpenPrompt (copy), SetPromptVisibility (copy)
	return {
		closePrompt = function() -- line: 487
			-- upvalues: p25 (copy), CloseOpenPrompt (copy)
			return p25(CloseOpenPrompt())
		end,
		SetPromptVisibility = function(p26) -- line: 490
			-- upvalues: p25 (copy), SetPromptVisibility (copy)
			return p25(SetPromptVisibility(p26))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v35)
