local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local GameIcon = require(ParentParent.GameIcon)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ThemedTextLabel = require(ParentParent.ThemedTextLabel)
local withStyle = UIBlox.Core.Style.withStyle
local FocusHandler = require(ParentParent.Connection.FocusHandler)
local ZonePortal = require(ParentParent.ZonePortal)
local Direction = require(ParentParentParent.Enums.Direction)
local GetFFlagEnableVRFTUXExperience = require(RobloxGui.Modules.FTUX.Flags.GetFFlagEnableVRFTUXExperience)
local IsFTUXExperience = require(RobloxGui.Modules.FTUX.Utility.IsFTUXExperience)
local PlatformEnum = require(RobloxGui.Modules.FTUX.Enums.PlatformEnum)
local v22 = Roact.PureComponent:extend("LeavePrompt")

v22.validateProps = t.strictInterface({
	titleText = t.string,
	bodyText = t.string,
	confirmText = t.string,
	cancelText = t.string,
	onConfirm = t.callback,
	onCancel = t.callback,
	canGamepadCaptureFocus = t.boolean,
	canKeyboardCaptureFocus = t.boolean
})
v22.defaultProps = {
	canGamepadCaptureFocus = false,
	canKeyboardCaptureFocus = false
}

function v22.init(p1) -- line: 58
	-- upvalues: Roact (copy)
	p1.leaveButtonRef = Roact.createRef()
end
function v22.render(p2) -- line: 62
	-- upvalues: withStyle (copy), Roact (copy), GameIcon (copy), ThemedTextLabel (copy), GetFFlagEnableVRFTUXExperience (copy), IsFTUXExperience (copy), PlatformEnum (copy), Button (copy), ButtonType (copy), FocusHandler (copy), GuiService (copy), ZonePortal (copy), Direction (copy), ContextActionService (copy)
	return withStyle(function(p3) -- line: 63
		-- upvalues: Roact (copy), GameIcon (copy), ThemedTextLabel (copy), p2 (copy), GetFFlagEnableVRFTUXExperience (copy), IsFTUXExperience (copy), PlatformEnum (copy), Button (copy), ButtonType (copy), FocusHandler (copy), GuiService (copy), ZonePortal (copy), Direction (copy), ContextActionService (copy)
		local p3Font = p3.Font
		local t1 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 24),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			GameThumbnail = Roact.createElement(GameIcon, {
				iconSize = 100,
				layoutOrder = 1,
				gameId = game.GameId
			}),
			TitleText = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header1",
				themeKey = "TextEmphasis",
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, p3Font.Header1.RelativeSize * p3Font.BaseSize + 4),
				Text = p2.props.titleText
			}),
			BodyText = Roact.createElement(ThemedTextLabel, {
				fontKey = "Body",
				themeKey = "TextDefault",
				LayoutOrder = 3,
				TextWrapped = true,
				Size = if not GetFFlagEnableVRFTUXExperience() or not IsFTUXExperience(PlatformEnum.QuestVR) then UDim2.fromOffset(353, 2 * (p3Font.Body.RelativeSize * p3Font.BaseSize + 4)) else UDim2.fromOffset(353, 4 * (p3Font.Body.RelativeSize * p3Font.BaseSize + 4)),
				Text = p2.props.bodyText
			}),
			ButtonGroup = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.fromOffset(353, 84)
			}, {
				ConfirmButton = Roact.createElement(Button, {
					layoutOrder = 4,
					buttonType = ButtonType.PrimarySystem,
					position = UDim2.fromOffset(0, 0),
					size = UDim2.fromOffset(353, 36),
					onActivated = p2.props.onConfirm,
					text = p2.props.confirmText,
					buttonRef = p2.leaveButtonRef
				}),
				CancelButton = Roact.createElement(Button, {
					layoutOrder = 5,
					buttonType = ButtonType.Secondary,
					position = UDim2.fromOffset(0, 48),
					size = UDim2.fromOffset(353, 36),
					onActivated = p2.props.onCancel,
					text = p2.props.cancelText
				})
			})
		}
		local t2 = {
			Content = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Selectable = false,
				Size = UDim2.fromScale(1, 1)
			}, t1),
			FocusHandler = Roact.createElement(FocusHandler, {
				isFocused = p2.props.canGamepadCaptureFocus,
				didFocus = function() -- line: 130
					-- upvalues: GuiService (copy), p2 (copy)
					GuiService.SelectedCoreObject = p2.leaveButtonRef.current
				end
			}),
			ZonePortal = Roact.createElement(ZonePortal, {
				targetZone = 0,
				direction = Direction.Left
			}),
			KeyboardFocusHandler = Roact.createElement(FocusHandler, {
				isFocused = p2.props.canKeyboardCaptureFocus,
				didFocus = function() -- line: 141
					-- upvalues: ContextActionService (copy), p2 (copy)
					ContextActionService:BindCoreAction("LeavePromptConfirm", function(_, p5) -- line: 142
						-- upvalues: p2 (copy)
						if p5 == Enum.UserInputState.End then
							p2.props.onConfirm()

							return Enum.ContextActionResult.Sink
						end

						return Enum.ContextActionResult.Pass
					end, false, Enum.KeyCode.Return)
				end,
				didBlur = function() -- line: 151
					-- upvalues: ContextActionService (copy)
					ContextActionService:UnbindCoreAction("LeavePromptConfirm")
				end
			}) or nil
		}

		return Roact.createElement("ImageButton", {
			AutoButtonColor = false,
			Selectable = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
			BackgroundTransparency = p3.Theme.BackgroundDefault.Transparency
		}, t2)
	end)
end

return v22
