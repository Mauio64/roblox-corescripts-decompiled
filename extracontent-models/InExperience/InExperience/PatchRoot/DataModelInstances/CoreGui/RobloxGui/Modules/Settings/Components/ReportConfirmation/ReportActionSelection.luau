local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
	return withFoundationOrUIBloxStyle(function(p)
		local tokens

		if FoundationFontFaceMigration then
			tokens = p
		end

		return {
			Tokens = tokens,
			Theme = {
				Divider = {
					Color = p.Color.Stroke.Emphasis.Color3,
					Transparency = p.Color.Stroke.Emphasis.Transparency
				},
				SystemPrimaryContent = {
					Color = p.Color.ActionSubEmphasis.Foreground.Color3,
					Transparency = p.Color.ActionSubEmphasis.Foreground.Transparency
				},
				TextDefault = {
					Color = p.Color.Content.Default.Color3,
					Transparency = p.Color.Content.Default.Transparency
				},
				TextEmphasis = {
					Color = p.Color.Content.Emphasis.Color3,
					Transparency = p.Color.Content.Emphasis.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				CaptionHeader = {
					Font = p.Typography.CaptionLarge.Font,
					RelativeSize = p.Typography.CaptionLarge.FontSize
				},
				Header1 = {
					Font = p.Typography.HeadingSmall.Font,
					RelativeSize = p.Typography.HeadingSmall.FontSize
				}
			}
		}
	end, function(props)
		local baseSize = props.Font.BaseSize

		local createElement = Roact.createElement
		local v = {
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			ZIndex = data.props.ZIndex
		}
		local children = {
			uiScale = Roact.createElement("UIScale", { Scale = data.props.uiScale }),
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 22),
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			title = 0,
			subtitle = 0,
			actions = 0
		}

		local createElement2 = Roact.createElement
		local v2 = {
			Text = data.props.titleText,
			TextColor3 = props.Theme.TextEmphasis.Color,
			TextTransparency = props.Theme.TextEmphasis.Transparency,
			TextSize = props.Font.Header1.RelativeSize * baseSize,
			Font = 0,
			FontFace = 0,
			BackgroundTransparency = 1,
			AutomaticSize = 0,
			LayoutOrder = 1
		}
		local font

		if not FoundationFontFaceMigration then
			font = props.Font.Header1.Font
		end

		v2.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.HeadingSmall.Font)
		end

		v2.FontFace = fontFace

		v2.AutomaticSize = Enum.AutomaticSize.XY
		children.title = createElement2("TextLabel", v2)

		local createElement3 = Roact.createElement
		local v3 = {
			Size = UDim2.fromOffset(612, 0),
			Text = data.props.subtitleText,
			TextColor3 = props.Theme.TextEmphasis.Color,
			TextTransparency = props.Theme.TextEmphasis.Transparency,
			TextSize = props.Font.CaptionHeader.RelativeSize * baseSize,
			Font = 0,
			FontFace = 0,
			TextWrapped = true,
			BackgroundTransparency = 1,
			AutomaticSize = 0,
			LayoutOrder = 2
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = props.Font.CaptionHeader.Font
		end

		v3.Font = font2
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font)
		end

		v3.FontFace = fontFace2

		v3.AutomaticSize = Enum.AutomaticSize.Y
		children.subtitle = createElement3("TextLabel", v3)

		local createElement4 = Roact.createElement
		local v4 = {
			Size = UDim2.fromOffset(584, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 3
		}

		local children2 = {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 18),
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			instruction = 0,
			muteCheckbox = 0,
			div = 0,
			blockCheckbox = 0,
			doneContainer = 0
		}

		local createElement5 = Roact.createElement
		local v5 = {
			Size = UDim2.fromScale(1, 0),
			Text = data.props.instructionText,
			TextColor3 = props.Theme.TextDefault.Color,
			TextTransparency = props.Theme.TextDefault.Transparency,
			TextSize = props.Font.CaptionHeader.RelativeSize * baseSize,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			BackgroundTransparency = 1,
			AutomaticSize = 0,
			LayoutOrder = 1
		}
		local font3

		if not FoundationFontFaceMigration then
			font3 = props.Font.CaptionHeader.Font
		end

		v5.Font = font3
		local fontFace3

		if FoundationFontFaceMigration then
			fontFace3 = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font)
		end

		v5.FontFace = fontFace3

		v5.TextXAlignment = Enum.TextXAlignment.Left

		v5.AutomaticSize = Enum.AutomaticSize.Y
		children2.instruction = createElement5("TextLabel", v5)

		children2.muteCheckbox = data.props.showVoiceMuting and Roact.createElement(CheckboxRow, {
			height = 28,
			image = "icons/controls/microphone",
			descriptionText = data.props.muteText,
			actionDisabled = data.state.isBlocked,
			checkboxSelected = data.state.isBlocked or data.state.isVoiceMuted,
			onCheckboxActivated = data.onMuteCheckboxActivated,
			LayoutOrder = 2
		})

		children2.div = data.props.showVoiceMuting and Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = props.Theme.Divider.Color,
			BackgroundTransparency = props.Theme.Divider.Transparency,
			BorderSizePixel = 0,
			LayoutOrder = 3
		})

		children2.blockCheckbox = Roact.createElement(CheckboxRow, {
			height = 28,
			image = "icons/actions/block",
			descriptionText = data.props.blockText,
			checkboxSelected = data.state.isBlocked,
			onCheckboxActivated = data.onBlockCheckboxActivated,
			LayoutOrder = 4
		})

		children2.doneContainer = Roact.createElement("Frame", {
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
		children.actions = createElement4("Frame", v4, children2)
		return createElement("Frame", v, children)
	end)
end

return extended
