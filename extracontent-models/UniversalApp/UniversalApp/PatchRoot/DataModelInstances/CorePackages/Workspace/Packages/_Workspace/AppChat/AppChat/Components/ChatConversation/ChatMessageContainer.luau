local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Roact = require(AppChatParent.Roact)
local AvatarCircle = require(AppChat.SocialLibraries).Components.AvatarCircle
local RoactFitComponents = require(AppChatParent.LuaSocialLibrariesDeps).RoactFitComponents
local withStyle = require(AppChatParent.UIBlox).Style.withStyle
local Logger = require(script.Parent.Logger)
local NoticeText = require(script.Parent.NoticeText)
local SystemMessage = require(script.Parent.SystemMessage)
local v10 = Roact.PureComponent:extend("ChatMessageContainer")

v10.defaultProps = {
	BackgroundColor3 = nil,
	BackgroundTransparency = nil,
	debugElement = nil,
	displayName = nil,
	failed = false,
	filteredForReceivers = false,
	isIncoming = false,
	isNewSender = false,
	parentWidth = 0,
	messageTypePaddingOffset = 0,
	moderated = false,
	messageMaxWidth = 0,
	senderUserId = nil,
	thumbnail = nil,
	viewProfileOnAvatarPressed = true,
	messageDefaultNoticeText = "PLACEHOLDER Not everyone in this chat can see your message.",
	messageModeratedNoticeText = "PLACEHOLDER Your message was moderated and not sent.",
	unknownUserText = "PLACEHOLDER unknown user",
	Font = Enum.Font.Gotham,
	openViewProfile = function() -- line: 41
		-- upvalues: Logger (copy)
		Logger:warning("openViewProfile was not passed to ChatMessage")
	end,
	renderMessage = function() -- line: 44
		-- upvalues: Logger (copy)
		Logger:warning("renderMessage was not passed to ChatMessage")
	end
}

function v10.init(p1) -- line: 56
	function p1.onAvatarActivated() -- line: 57
		-- upvalues: p1 (copy)
		if p1.props.viewProfileOnAvatarPressed then
			p1.props.openViewProfile(p1.props.senderUserId)
		end
	end
end
function v10.render(p2) -- line: 64
	-- upvalues: withStyle (copy), Roact (copy), RoactFitComponents (copy), SystemMessage (copy), AvatarCircle (copy), NoticeText (copy)
	return withStyle(function(p3) -- line: 65
		-- upvalues: p2 (copy), Roact (copy), RoactFitComponents (copy), SystemMessage (copy), AvatarCircle (copy), NoticeText (copy)
		local n1 = 0

		if not p2.props.showDateTime then
			n1 = (not p2.props.isNewSender and 2 or 10) + p2.props.messageTypePaddingOffset
		end

		local v15 = p2.props.displayName == "" and p2.props.unknownUserText or p2.props.displayName
		local v16 = p2.props.isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right
		local v17 = p2.props.moderated or p2.props.filteredForReceivers

		return Roact.createElement(RoactFitComponents.FitFrameVertical, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = v16,
			width = UDim.new(1, 0)
		}, {
			DateTime = p2.props.showDateTime and Roact.createElement(SystemMessage, {
				LayoutOrder = 1,
				maxWidth = 1000,
				Text = p2.props.sent:GetLongRelativeTime()
			}),
			MessageWithAvatar = Roact.createElement(RoactFitComponents.FitFrameVertical, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = v16,
				margin = {
					right = 0,
					bottom = 0,
					top = n1,
					left = not p2.props.thumbnail and 44 or 8
				},
				width = UDim.new(1, 0)
			}, {
				Avatar = p2.props.thumbnail and Roact.createElement("Frame", {
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(0, 36, 0, 36)
				}, {
					AvatarCircle = Roact.createElement(AvatarCircle, {
						circleColor3 = p2.props.BackgroundColor3 or p3.Theme.BackgroundDefault.Color,
						circleInteriorBackgroundColor3 = p2.props.BackgroundColor3 or p3.Theme.BackgroundDefault.Color,
						onActivated = p2.onAvatarActivated,
						thumbnails = { p2.props.thumbnail }
					})
				}) or nil,
				MessageWithDisplayName = Roact.createElement(RoactFitComponents.FitFrameVertical, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = v16,
					margin = {
						top = 0,
						right = 0,
						bottom = 0,
						left = not p2.props.isIncoming and 0 or 5
					},
					width = UDim.new(1, not p2.props.isIncoming and 0 or -44)
				}, {
					DisplayNameContainer = p2.props.displayName and Roact.createElement(RoactFitComponents.FitFrameVertical, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						margin = {
							top = 0,
							left = 6,
							right = 0,
							bottom = 0
						},
						width = UDim.new(0, p2.props.messageMaxWidth - 6)
					}, {
						DisplayName = Roact.createElement(RoactFitComponents.FitTextLabel, {
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Font = p3.Font.Footer.Font,
							maximumWidth = p2.props.messageMaxWidth - 6,
							Size = UDim2.new(1, 0, 1, 0),
							Text = v15,
							TextColor3 = p3.Theme.TextDefault.Color,
							TextSize = p3.Font.BaseSize * p3.Font.Footer.RelativeSize,
							TextTransparency = p3.Theme.TextDefault.Transparency,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							width = RoactFitComponents.FitTextLabel.Width.FitToText
						})
					}),
					MessageWithAlertIcon = Roact.createElement(RoactFitComponents.FitFrameVertical, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 2,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = v16,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 10),
						width = UDim.new(1, not p2.props.isIncoming and 0 or -44)
					}, {
						AlertIcon = (p2.props.failed or p2.props.moderated) and Roact.createElement("ImageLabel", {
							BackgroundTransparency = 1,
							Image = "rbxasset://textures/ui/LuaChat/icons/ic-alert.png",
							ImageColor3 = p3.Theme.Alert.Color,
							ImageTransparency = p3.Theme.Alert.Transparency,
							LayoutOrder = not p2.props.isIncoming and 1 or 2,
							Size = UDim2.new(0, 18, 0, 18)
						}),
						Message = p2.props.renderMessage({
							LayoutOrder = not p2.props.isIncoming and 2 or 1
						})
					})
				})
			}),
			Notice = v17 and Roact.createElement(NoticeText, {
				LayoutOrder = 3,
				Font = p2.props.Font,
				HorizontalAlignment = v16,
				Text = p2.props.moderated and p2.props.messageModeratedNoticeText or p2.props.messageDefaultNoticeText,
				TextColor3 = p2.props.moderated and p3.Theme.Alert.Color or p3.Theme.UIDefault.Color,
				TextTransparency = p2.props.moderated and p3.Theme.Alert.Transparency or p3.Theme.UIDefault.Transparency,
				TextXAlignment = p2.props.isIncoming and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right,
				margin = {
					top = 0,
					bottom = 0,
					left = not p2.props.isIncoming and 0 or 54,
					right = p2.props.isIncoming and 0 or 10
				},
				maxWidth = p2.props.parentWidth,
				width = UDim.new(1, not p2.props.isIncoming and 0 or -44)
			}),
			debug = p2.props.debugElement or nil
		})
	end)
end

return v10
