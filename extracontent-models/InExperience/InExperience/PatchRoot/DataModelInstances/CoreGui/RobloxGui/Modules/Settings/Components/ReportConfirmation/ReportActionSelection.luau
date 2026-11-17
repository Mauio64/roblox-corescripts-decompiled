local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local TextButton = UIBlox.App.Button.TextButton

local CheckboxRow = require(script.Parent.CheckboxRow)

local extended = Roact.PureComponent:extend("ReportActionSelection")

local function fn() end

extended.defaultProps = {
	titleText = "Thanks for your report!",
	subtitleText = "We've received your report and will take action soon if needed. Your feedback helps keep our community safe.",
	instructionText = "Other steps you can take:",
	muteText = "Mute {DISPLAYNAME}(@username)",
	blockText = "Block {DISPLAYNAME}(@username)",
	doneText = "Done",
	showVoiceMuting = true,
	isVoiceMuted = false,
	isBlocked = false,
	onMuteCheckboxActivated = fn,
	onBlockCheckboxActivated = fn,
	onDoneActivated = fn,
	ZIndex = 1,
	uiScale = 1.3
}

extended.validateProps = t.interface({
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

function extended:init()
	function self.onMuteCheckboxActivated(isVoiceMuted)
		self:setState({ isVoiceMuted = isVoiceMuted })

		self.props.onMuteCheckboxActivated(isVoiceMuted)
	end

	function self.onBlockCheckboxActivated(isBlocked)
		self:setState({ isBlocked = isBlocked })

		self.props.onBlockCheckboxActivated(isBlocked)
	end

	function self.onDoneActivated()
		self.props.onDoneActivated(self.state.isBlocked, self.state.isVoiceMuted)
	end

	self:setState({ isVoiceMuted = self.props.isVoiceMuted, isBlocked = self.props.isBlocked })
end

function extended.render(data)
	return withFoundationOrUIBloxStyle(function(tokens)
		return {
			Tokens = tokens,
			Theme = {
				Divider = {
					Color = tokens.Color.Stroke.Emphasis.Color3,
					Transparency = tokens.Color.Stroke.Emphasis.Transparency
				},
				SystemPrimaryContent = {
					Color = tokens.Color.ActionSubEmphasis.Foreground.Color3,
					Transparency = tokens.Color.ActionSubEmphasis.Foreground.Transparency
				},
				TextDefault = {
					Color = tokens.Color.Content.Default.Color3,
					Transparency = tokens.Color.Content.Default.Transparency
				},
				TextEmphasis = {
					Color = tokens.Color.Content.Emphasis.Color3,
					Transparency = tokens.Color.Content.Emphasis.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				CaptionHeader = {
					Font = tokens.Typography.CaptionLarge.Font,
					RelativeSize = tokens.Typography.CaptionLarge.FontSize
				},
				Header1 = {
					Font = tokens.Typography.HeadingSmall.Font,
					RelativeSize = tokens.Typography.HeadingSmall.FontSize
				}
			}
		}
	end, function(props)
		local baseSize = props.Font.BaseSize

		return Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			ZIndex = data.props.ZIndex
		}, {
			uiScale = Roact.createElement("UIScale", { Scale = data.props.uiScale }),
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 22),
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			title = Roact.createElement("TextLabel", {
				Text = data.props.titleText,
				TextColor3 = props.Theme.TextEmphasis.Color,
				TextTransparency = props.Theme.TextEmphasis.Transparency,
				TextSize = props.Font.Header1.RelativeSize * baseSize,
				FontFace = normalizeFontFace(props.Tokens.Typography.HeadingSmall.Font),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 1
			}),
			subtitle = Roact.createElement("TextLabel", {
				Size = UDim2.fromOffset(612, 0),
				Text = data.props.subtitleText,
				TextColor3 = props.Theme.TextEmphasis.Color,
				TextTransparency = props.Theme.TextEmphasis.Transparency,
				TextSize = props.Font.CaptionHeader.RelativeSize * baseSize,
				FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
				TextWrapped = true,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2
			}),
			actions = Roact.createElement(
				"Frame",
				{
					Size = UDim2.fromOffset(584, 0),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = 3
				},
				{
					layout = Roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 18),
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					instruction = Roact.createElement("TextLabel", {
						Size = UDim2.fromScale(1, 0),
						Text = data.props.instructionText,
						TextColor3 = props.Theme.TextDefault.Color,
						TextTransparency = props.Theme.TextDefault.Transparency,
						TextSize = props.Font.CaptionHeader.RelativeSize * baseSize,
						FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = 1
					}),
					muteCheckbox = data.props.showVoiceMuting and Roact.createElement(CheckboxRow, {
						height = 28,
						image = "icons/controls/microphone",
						descriptionText = data.props.muteText,
						actionDisabled = data.state.isBlocked,
						checkboxSelected = data.state.isBlocked or data.state.isVoiceMuted,
						onCheckboxActivated = data.onMuteCheckboxActivated,
						LayoutOrder = 2
					}),
					div = data.props.showVoiceMuting and Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 1),
						BackgroundColor3 = props.Theme.Divider.Color,
						BackgroundTransparency = props.Theme.Divider.Transparency,
						BorderSizePixel = 0,
						LayoutOrder = 3
					}),
					blockCheckbox = Roact.createElement(CheckboxRow, {
						height = 28,
						image = "icons/actions/block",
						descriptionText = data.props.blockText,
						checkboxSelected = data.state.isBlocked,
						onCheckboxActivated = data.onBlockCheckboxActivated,
						LayoutOrder = 4
					}),
					doneContainer = Roact.createElement("Frame", {
						BackgroundColor3 = props.Theme.SystemPrimaryContent.Color,
						BackgroundTransparency = props.Theme.SystemPrimaryContent.Transparency,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 44),
						LayoutOrder = 5
					}, {
						uiCorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
						doneButton = Roact.createElement(TextButton, {
							size = UDim2.fromScale(1, 1),
							text = data.props.doneText,
							onActivated = data.onDoneActivated
						})
					})
				}
			)
		})
	end)
end

return extended
