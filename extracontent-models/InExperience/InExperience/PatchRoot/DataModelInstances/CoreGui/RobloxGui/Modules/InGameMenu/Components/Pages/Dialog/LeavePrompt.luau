local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local GameIcon = require(parent.GameIcon)

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local ThemedTextLabel = require(parent.ThemedTextLabel)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local FocusHandler = require(parent.Connection.FocusHandler)
local ZonePortal = require(parent.ZonePortal)

local Direction = require(parent2.Enums.Direction)

local GetFFlagEnableVRFTUXExperience = require(RobloxGui.Modules.FTUX.Flags.GetFFlagEnableVRFTUXExperience)
local IsFTUXExperience = require(RobloxGui.Modules.FTUX.Utility.IsFTUXExperience)
local PlatformEnum = require(RobloxGui.Modules.FTUX.Enums.PlatformEnum)

local extended = Roact.PureComponent:extend("LeavePrompt")

extended.validateProps = t.strictInterface({
	titleText = t.string,
	bodyText = t.string,
	confirmText = t.string,
	cancelText = t.string,
	onConfirm = t.callback,
	onCancel = t.callback,
	canGamepadCaptureFocus = t.boolean,
	canKeyboardCaptureFocus = t.boolean
})

extended.defaultProps = { canGamepadCaptureFocus = false, canKeyboardCaptureFocus = false }

function extended:init()
	self.leaveButtonRef = Roact.createRef()
end

function extended.render(p)
	return withFoundationOrUIBloxStyle(function(p2)
		return {
			Theme = {
				BackgroundDefault = {
					Color = p2.Color.Surface.Surface_0.Color3,
					Transparency = p2.Color.Surface.Surface_0.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Header1 = {
					Font = p2.Typography.HeadingSmall.Font,
					RelativeSize = p2.Typography.HeadingSmall.FontSize
				},
				Body = {
					Font = p2.Typography.BodyLarge.Font,
					RelativeSize = p2.Typography.BodyLarge.FontSize
				}
			}
		}
	end, function(p2)
		local font = p2.Font

		local children = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 24),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			GameThumbnail = Roact.createElement(GameIcon, {
				gameId = game.GameId,
				iconSize = 100,
				layoutOrder = 1
			}),
			TitleText = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header1",
				themeKey = "TextEmphasis",
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, font.Header1.RelativeSize * font.BaseSize + 4),
				Text = p.props.titleText
			}),
			BodyText = 0,
			ButtonGroup = 0
		}

		local createElement = Roact.createElement
		local size

		if GetFFlagEnableVRFTUXExperience() and IsFTUXExperience(PlatformEnum.QuestVR) then
			size = UDim2.fromOffset(353, 4 * (font.Body.RelativeSize * font.BaseSize + 4))
		else
			size = UDim2.fromOffset(353, 2 * (font.Body.RelativeSize * font.BaseSize + 4))
		end

		children.BodyText = createElement(ThemedTextLabel, {
			fontKey = "Body",
			themeKey = "TextDefault",
			LayoutOrder = 3,
			Size = size,
			Text = p.props.bodyText,
			TextWrapped = true
		})

		children.ButtonGroup = Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.fromOffset(353, 84), LayoutOrder = 4 },
			{
				ConfirmButton = Roact.createElement(Button, {
					buttonType = ButtonType.PrimarySystem,
					layoutOrder = 4,
					position = UDim2.fromOffset(0, 0),
					size = UDim2.fromOffset(353, 36),
					onActivated = p.props.onConfirm,
					text = p.props.confirmText,
					buttonRef = p.leaveButtonRef
				}),
				CancelButton = Roact.createElement(Button, {
					buttonType = ButtonType.Secondary,
					layoutOrder = 5,
					position = UDim2.fromOffset(0, 48),
					size = UDim2.fromOffset(353, 36),
					onActivated = p.props.onCancel,
					text = p.props.cancelText
				})
			}
		)

		local v = {
			Content = Roact.createElement(
				"Frame",
				{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Selectable = false },
				children
			),
			FocusHandler = Roact.createElement(FocusHandler, {
				isFocused = p.props.canGamepadCaptureFocus,
				didFocus = function()
					GuiService.SelectedCoreObject = p.leaveButtonRef.current
				end
			}),
			ZonePortal = Roact.createElement(ZonePortal, {
				targetZone = 0,
				direction = Direction.Left
			}),
			KeyboardFocusHandler = Roact.createElement(FocusHandler, {
				isFocused = p.props.canKeyboardCaptureFocus,
				didFocus = function()
					ContextActionService:BindCoreAction("LeavePromptConfirm", function(_, p3)
						if p3 ~= Enum.UserInputState.End then
							return Enum.ContextActionResult.Pass
						end

						p.props.onConfirm()
						return Enum.ContextActionResult.Sink
					end, false, Enum.KeyCode.Return)
				end,
				didBlur = function()
					ContextActionService:UnbindCoreAction("LeavePromptConfirm")
				end
			}) or nil
		}

		return Roact.createElement("ImageButton", {
			Size = UDim2.fromScale(1, 1),
			AutoButtonColor = false,
			BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
			BackgroundTransparency = p2.Theme.BackgroundDefault.Transparency,
			Selectable = false
		}, v)
	end)
end

return extended
