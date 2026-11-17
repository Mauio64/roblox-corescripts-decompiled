local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local TextButton = UIBlox.App.Button.TextButton

local extended = Roact.PureComponent:extend("ReportActionSelection")

local function fn() end

extended.defaultProps = {
	isMuted = true,
	isBlocked = true,
	onCancelActivated = fn,
	onConfirmActivated = fn,
	ZIndex = 1,
	uiScale = 1.3
}

extended.validateProps = t.strictInterface({
	mutedTitleText = t.string,
	blockedTitleText = t.string,
	mutedAndBlockedTitleText = t.string,
	mutedSubtitleText = t.string,
	blockedSubtitleText = t.string,
	mutedAndBlockedSubtitleText = t.string,
	cancelText = t.string,
	confirmText = t.string,
	isMuted = t.boolean,
	isBlocked = t.boolean,
	onCancelActivated = t.callback,
	onConfirmActivated = t.callback,
	ZIndex = t.optional(t.number),
	uiScale = t.optional(t.number)
})

function extended:init()
	function self.onCancelActivated()
		self.props.onCancelActivated()
	end

	function self.onConfirmActivated()
		self.props.onConfirmActivated()
	end

	local titleText = nil
	local subtitleText = nil

	if self.props.isMuted and self.props.isBlocked then
		titleText = self.props.mutedAndBlockedTitleText
		subtitleText = self.props.mutedAndBlockedSubtitleText
	elseif self.props.isMuted then
		titleText = self.props.mutedTitleText
		subtitleText = self.props.mutedSubtitleText
	elseif self.props.isBlocked then
		titleText = self.props.blockedTitleText
		subtitleText = self.props.blockedSubtitleText
	end

	self:setState({ titleText = titleText, subtitleText = subtitleText })
end

function extended.render(data)
	return withFoundationOrUIBloxStyle(function(tokens)
		return {
			Tokens = tokens,
			Theme = {
				SystemPrimaryContent = {
					Color = tokens.Color.ActionSubEmphasis.Foreground.Color3,
					Transparency = tokens.Color.ActionSubEmphasis.Foreground.Transparency
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
				Text = data.state.titleText,
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
				Text = data.state.subtitleText,
				TextColor3 = props.Theme.TextEmphasis.Color,
				TextTransparency = props.Theme.TextEmphasis.Transparency,
				TextSize = props.Font.CaptionHeader.RelativeSize * baseSize,
				FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
				TextWrapped = true,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2
			}),
			spacer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, 62),
				LayoutOrder = 3
			}),
			actions = Roact.createElement(
				"Frame",
				{
					Size = UDim2.fromOffset(584, 0),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = 4
				},
				{
					layout = Roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 70),
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					cancelContainer = Roact.createElement("Frame", {
						BackgroundColor3 = props.Theme.SystemPrimaryContent.Color,
						BackgroundTransparency = props.Theme.SystemPrimaryContent.Transparency,
						BorderSizePixel = 0,
						Size = UDim2.fromOffset(234, 44),
						LayoutOrder = 1
					}, {
						uiCorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
						cancelButton = Roact.createElement(TextButton, {
							size = UDim2.fromScale(1, 1),
							text = data.props.cancelText,
							onActivated = data.onCancelActivated
						})
					}),
					confirmContainer = Roact.createElement("Frame", {
						BackgroundColor3 = UIBlox.App.Style.Colors.Blue,
						BackgroundTransparency = 0,
						BorderSizePixel = 0,
						Size = UDim2.fromOffset(234, 44),
						LayoutOrder = 2
					}, {
						uiCorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
						confirmButton = Roact.createElement(TextButton, {
							size = UDim2.fromScale(1, 1),
							text = data.props.confirmText,
							onActivated = data.onConfirmActivated
						})
					})
				}
			)
		})
	end)
end

return extended
