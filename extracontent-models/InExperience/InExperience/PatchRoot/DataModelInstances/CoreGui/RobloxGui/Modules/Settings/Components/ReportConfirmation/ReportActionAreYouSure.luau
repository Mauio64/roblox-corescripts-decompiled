local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local TextButton = UIBlox.App.Button.TextButton
local v7 = Roact.PureComponent:extend("ReportActionSelection")

local function v8() -- line: 22
end

v7.defaultProps = {
	isMuted = true,
	isBlocked = true,
	ZIndex = 1,
	uiScale = 1.3,
	onCancelActivated = v8,
	onConfirmActivated = v8
}
v7.validateProps = t.strictInterface({
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

function v7.init(p1) -- line: 50
	function p1.onCancelActivated() -- line: 51
		-- upvalues: p1 (copy)
		p1.props.onCancelActivated()
	end
	function p1.onConfirmActivated() -- line: 55
		-- upvalues: p1 (copy)
		p1.props.onConfirmActivated()
	end

	local mutedAndBlockedTitleText = nil
	local mutedAndBlockedSubtitleText = nil

	if p1.props.isMuted and p1.props.isBlocked then
		mutedAndBlockedTitleText = p1.props.mutedAndBlockedTitleText
		mutedAndBlockedSubtitleText = p1.props.mutedAndBlockedSubtitleText
	elseif p1.props.isMuted then
		mutedAndBlockedTitleText = p1.props.mutedTitleText
		mutedAndBlockedSubtitleText = p1.props.mutedSubtitleText
	elseif p1.props.isBlocked then
		mutedAndBlockedTitleText = p1.props.blockedTitleText
		mutedAndBlockedSubtitleText = p1.props.blockedSubtitleText
	end

	p1:setState({
		titleText = mutedAndBlockedTitleText,
		subtitleText = mutedAndBlockedSubtitleText
	})
end
function v7.render(p2) -- line: 79
	-- upvalues: withFoundationOrUIBloxStyle (copy), Roact (copy), TextButton (copy), UIBlox (copy)
	return withFoundationOrUIBloxStyle(function(p3) -- line: 80
		return {
			Theme = {
				SystemPrimaryContent = {
					Color = p3.Color.ActionSubEmphasis.Foreground.Color3,
					Transparency = p3.Color.ActionSubEmphasis.Foreground.Transparency
				},
				TextEmphasis = {
					Color = p3.Color.Content.Emphasis.Color3,
					Transparency = p3.Color.Content.Emphasis.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				CaptionHeader = {
					Font = p3.Typography.CaptionLarge.Font,
					RelativeSize = p3.Typography.CaptionLarge.FontSize
				},
				Header1 = {
					Font = p3.Typography.HeadingSmall.Font,
					RelativeSize = p3.Typography.HeadingSmall.FontSize
				}
			}
		}
	end, function(p4) -- line: 104
		-- upvalues: Roact (copy), p2 (copy), TextButton (copy), UIBlox (copy)
		local BaseSize = p4.Font.BaseSize

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			ZIndex = p2.props.ZIndex
		}, {
			uiScale = Roact.createElement("UIScale", {
				Scale = p2.props.uiScale
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
				Text = p2.state.titleText,
				TextColor3 = p4.Theme.TextEmphasis.Color,
				TextTransparency = p4.Theme.TextEmphasis.Transparency,
				TextSize = p4.Font.Header1.RelativeSize * BaseSize,
				Font = p4.Font.Header1.Font,
				AutomaticSize = Enum.AutomaticSize.XY
			}),
			subtitle = Roact.createElement("TextLabel", {
				TextWrapped = true,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.fromOffset(612, 0),
				Text = p2.state.subtitleText,
				TextColor3 = p4.Theme.TextEmphasis.Color,
				TextTransparency = p4.Theme.TextEmphasis.Transparency,
				TextSize = p4.Font.CaptionHeader.RelativeSize * BaseSize,
				Font = p4.Font.CaptionHeader.Font,
				AutomaticSize = Enum.AutomaticSize.Y
			}),
			spacer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.fromOffset(0, 62)
			}),
			actions = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.fromOffset(584, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 70),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				cancelContainer = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					LayoutOrder = 1,
					BackgroundColor3 = p4.Theme.SystemPrimaryContent.Color,
					BackgroundTransparency = p4.Theme.SystemPrimaryContent.Transparency,
					Size = UDim2.fromOffset(234, 44)
				}, {
					uiCorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 4)
					}),
					cancelButton = Roact.createElement(TextButton, {
						size = UDim2.fromScale(1, 1),
						text = p2.props.cancelText,
						onActivated = p2.onCancelActivated
					})
				}),
				confirmContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					BackgroundColor3 = UIBlox.App.Style.Colors.Blue,
					Size = UDim2.fromOffset(234, 44)
				}, {
					uiCorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 4)
					}),
					confirmButton = Roact.createElement(TextButton, {
						size = UDim2.fromScale(1, 1),
						text = p2.props.confirmText,
						onActivated = p2.onConfirmActivated
					})
				})
			})
		})
	end)
end

return v7
