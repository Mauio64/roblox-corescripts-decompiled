local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local TextButton = UIBlox.App.Button.TextButton
local CheckboxRow = require(script.Parent.CheckboxRow)
local v8 = Roact.PureComponent:extend("ReportActionSelection")

local function v9() -- line: 25
end

v8.defaultProps = {
	titleText = "Thanks for your report!",
	subtitleText = "We've received your report and will take action soon if needed. Your feedback helps keep our community safe.",
	instructionText = "Other steps you can take:",
	muteText = "Mute {DISPLAYNAME}(@username)",
	blockText = "Block {DISPLAYNAME}(@username)",
	doneText = "Done",
	showVoiceMuting = true,
	isVoiceMuted = false,
	isBlocked = false,
	ZIndex = 1,
	uiScale = 1.3,
	onMuteCheckboxActivated = v9,
	onBlockCheckboxActivated = v9,
	onDoneActivated = v9
}
v8.validateProps = t.interface({
	titleText = t.string,
	subtitleText = t.string,
	instructionText = t.string,
	muteText = t.string,
	blockText = t.string,
	doneText = t.string,
	showVoiceMuting = t.boolean,
	isVoiceMuted = t.optional(t.boolean),
	isBlocked = t.optional(t.boolean),
	onMuteCheckboxActivated = t.optional(t.callback),
	onBlockCheckboxActivated = t.optional(t.callback),
	onDoneActivated = t.callback,
	ZIndex = t.number
})

function v8.init(p1) -- line: 60
	function p1.onMuteCheckboxActivated(p2) -- line: 61
		-- upvalues: p1 (copy)
		p1:setState({
			isVoiceMuted = p2
		})
		p1.props.onMuteCheckboxActivated(p2)
	end
	function p1.onBlockCheckboxActivated(p3) -- line: 69
		-- upvalues: p1 (copy)
		p1:setState({
			isBlocked = p3
		})
		p1.props.onBlockCheckboxActivated(p3)
	end
	function p1.onDoneActivated() -- line: 77
		-- upvalues: p1 (copy)
		p1.props.onDoneActivated(p1.state.isBlocked, p1.state.isVoiceMuted)
	end

	p1:setState({
		isVoiceMuted = p1.props.isVoiceMuted,
		isBlocked = p1.props.isBlocked
	})
end
function v8.render(p4) -- line: 87
	-- upvalues: withFoundationOrUIBloxStyle (copy), Roact (copy), CheckboxRow (copy), TextButton (copy)
	return withFoundationOrUIBloxStyle(function(p5) -- line: 88
		return {
			Theme = {
				Divider = {
					Color = p5.Color.Stroke.Emphasis.Color3,
					Transparency = p5.Color.Stroke.Emphasis.Transparency
				},
				SystemPrimaryContent = {
					Color = p5.Color.ActionSubEmphasis.Foreground.Color3,
					Transparency = p5.Color.ActionSubEmphasis.Foreground.Transparency
				},
				TextDefault = {
					Color = p5.Color.Content.Default.Color3,
					Transparency = p5.Color.Content.Default.Transparency
				},
				TextEmphasis = {
					Color = p5.Color.Content.Emphasis.Color3,
					Transparency = p5.Color.Content.Emphasis.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				CaptionHeader = {
					Font = p5.Typography.CaptionLarge.Font,
					RelativeSize = p5.Typography.CaptionLarge.FontSize
				},
				Header1 = {
					Font = p5.Typography.HeadingSmall.Font,
					RelativeSize = p5.Typography.HeadingSmall.FontSize
				}
			}
		}
	end, function(p6) -- line: 120
		-- upvalues: Roact (copy), p4 (copy), CheckboxRow (copy), TextButton (copy)
		local BaseSize = p6.Font.BaseSize

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			ZIndex = p4.props.ZIndex
		}, {
			uiScale = Roact.createElement("UIScale", {
				Scale = p4.props.uiScale
			}),
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 22),
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			title = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Text = p4.props.titleText,
				TextColor3 = p6.Theme.TextEmphasis.Color,
				TextTransparency = p6.Theme.TextEmphasis.Transparency,
				TextSize = p6.Font.Header1.RelativeSize * BaseSize,
				Font = p6.Font.Header1.Font,
				AutomaticSize = Enum.AutomaticSize.XY
			}),
			subtitle = Roact.createElement("TextLabel", {
				TextWrapped = true,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.fromOffset(612, 0),
				Text = p4.props.subtitleText,
				TextColor3 = p6.Theme.TextEmphasis.Color,
				TextTransparency = p6.Theme.TextEmphasis.Transparency,
				TextSize = p6.Font.CaptionHeader.RelativeSize * BaseSize,
				Font = p6.Font.CaptionHeader.Font,
				AutomaticSize = Enum.AutomaticSize.Y
			}),
			actions = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.fromOffset(584, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Top,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 18),
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				instruction = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.fromScale(1, 0),
					Text = p4.props.instructionText,
					TextColor3 = p6.Theme.TextDefault.Color,
					TextTransparency = p6.Theme.TextDefault.Transparency,
					TextSize = p6.Font.CaptionHeader.RelativeSize * BaseSize,
					Font = p6.Font.CaptionHeader.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y
				}),
				muteCheckbox = p4.props.showVoiceMuting and Roact.createElement(CheckboxRow, {
					height = 28,
					image = "icons/controls/microphone",
					LayoutOrder = 2,
					descriptionText = p4.props.muteText,
					actionDisabled = p4.state.isBlocked,
					checkboxSelected = p4.state.isBlocked or p4.state.isVoiceMuted,
					onCheckboxActivated = p4.onMuteCheckboxActivated
				}),
				div = p4.props.showVoiceMuting and Roact.createElement("Frame", {
					BorderSizePixel = 0,
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = p6.Theme.Divider.Color,
					BackgroundTransparency = p6.Theme.Divider.Transparency
				}),
				blockCheckbox = Roact.createElement(CheckboxRow, {
					height = 28,
					image = "icons/actions/block",
					LayoutOrder = 4,
					descriptionText = p4.props.blockText,
					checkboxSelected = p4.state.isBlocked,
					onCheckboxActivated = p4.onBlockCheckboxActivated
				}),
				doneContainer = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					LayoutOrder = 5,
					BackgroundColor3 = p6.Theme.SystemPrimaryContent.Color,
					BackgroundTransparency = p6.Theme.SystemPrimaryContent.Transparency,
					Size = UDim2.new(1, 0, 0, 44)
				}, {
					uiCorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 4)
					}),
					doneButton = Roact.createElement(TextButton, {
						size = UDim2.fromScale(1, 1),
						text = p4.props.doneText,
						onActivated = p4.onDoneActivated
					})
				})
			})
		})
	end)
end

return v8
