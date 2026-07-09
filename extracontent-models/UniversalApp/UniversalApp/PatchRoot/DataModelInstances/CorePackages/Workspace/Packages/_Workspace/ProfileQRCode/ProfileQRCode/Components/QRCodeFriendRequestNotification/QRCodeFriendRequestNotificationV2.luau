local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local React = require(ProfileQRCodeParent.React)
local UIBlox = require(ProfileQRCodeParent.UIBlox)
local Foundation = require(ProfileQRCodeParent.Foundation)
local Localization = require(ProfileQRCodeParent.Localization)
local UserTile = require(ProfileQRCodeParent.UserTile).UserTile
local LayoutMode = require(ProfileQRCodeParent.UserTile).LayoutMode
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local TextKeys = require(ProfileQRCode.Common.TextKeys)
local useLocalization = Localization.Hooks.useLocalization
local useLocalUserInfo = require(ProfileQRCode.Utils.useLocalUserInfo)
local useCombinedUserName = require(ProfileQRCode.Utils.useCombinedUserName)
local useAnalytics = require(ProfileQRCode.Analytics.useAnalytics)
local EventNames = require(ProfileQRCode.Analytics.EventNames)
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 37
	-- upvalues: useTokens (copy), useLocalization (copy), TextKeys (copy), useStyle (copy), useLocalUserInfo (copy), useCombinedUserName (copy), useAnalytics (copy), React (copy), EventNames (copy), View (copy), UserTile (copy), LayoutMode (copy), Foundation (copy), StyledTextLabel (copy), Button (copy), ButtonVariant (copy), InputSize (copy), FillBehavior (copy)
	local v24 = useTokens()
	local v25 = useLocalization({
		accept = "CommonUI.Controls.Action.Accept",
		dismiss = "CommonUI.Messages.Action.Dismiss",
		notificationRequest = TextKeys.NotificationRequestText
	})
	local v26 = useStyle()
	local v27 = useLocalUserInfo(t1.userId)
	local v28 = useCombinedUserName(t1.userId)
	local v29 = if v28 == "" then not v27 and "" or (v27.displayName or (v27.username or "")) else v28 .. " @" .. v27.username
	local v30 = useAnalytics()
	local v31, v32 = React.useState(false)

	React.useEffect(function() -- line: 55
		-- upvalues: v32 (copy)
		v32(false)
	end, { t1.userId })
	React.useEffect(function() -- line: 59
		-- upvalues: v30 (copy), EventNames (copy), t1 (copy)
		v30.fireEvent(EventNames.QRPageFriendRequestBannerShown, {
			qrCodeBannerQueueSize = t1.notificationQueueSize
		})
	end, {
		t1.userId,
		v30.fireEvent,
		t1.notificationQueueSize
	})

	return React.createElement(View, {
		ZIndex = 2,
		tag = "col gap-medium size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium bg-surface-0",
		sizeConstraint = {
			MaxSize = Vector2.new(640, 1e999),
			MinSize = Vector2.new(0, 0)
		}
	}, {
		HeaderRow = React.createElement(View, {
			tag = "row align-y-top gap-medium size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			AvatarSlot = React.createElement(View, {
				tag = "no-flex auto-xy",
				LayoutOrder = 1
			}, {
				UserTile = React.createElement(UserTile, {
					userId = t1.userId,
					layoutMode = LayoutMode.compact,
					userPresenceType = Foundation.Enums.UserPresence.None,
					avatarSize = UDim2.new(0, v24.Size.Size_1000, 0, v24.Size.Size_1000)
				})
			}),
			ContentColumn = React.createElement(View, {
				tag = "col fill gap-xsmall auto-y",
				LayoutOrder = 2
			}, {
				Username = React.createElement(StyledTextLabel, {
					layoutOrder = 1,
					textWrapped = true,
					text = v29,
					fontStyle = v26.Font.Header2,
					colorStyle = v26.Theme.TextDefault,
					size = UDim2.new(1, 0, 0, v24.Size.Size_500),
					automaticSize = Enum.AutomaticSize.Y,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center
				}),
				Description = React.createElement(StyledTextLabel, {
					layoutOrder = 2,
					textWrapped = true,
					lineHeight = 1,
					text = v25.notificationRequest,
					fontStyle = v26.Font.Body,
					colorStyle = v26.Theme.TextDefault,
					size = UDim2.new(1, 0, 0, v24.Size.Size_700),
					automaticSize = Enum.AutomaticSize.Y,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center
				}),
				ButtonRow = React.createElement(View, {
					tag = "row gap-small size-full-0 auto-y padding-top-large",
					LayoutOrder = 3
				}, {
					AcceptSlot = React.createElement(View, {
						tag = "fill auto-xy",
						LayoutOrder = 1
					}, {
						AcceptButton = React.createElement(Button, {
							text = v25.accept,
							variant = ButtonVariant.Emphasis,
							size = InputSize.Small,
							fillBehavior = FillBehavior.Fill,
							isDisabled = v31,
							onActivated = function() -- line: 129
								-- upvalues: v32 (copy), t1 (copy)
								v32(true)
								t1.onAccept(t1.userId)
							end
						})
					}),
					DismissSlot = React.createElement(View, {
						tag = "fill auto-xy",
						LayoutOrder = 2
					}, {
						DismissButton = React.createElement(Button, {
							text = v25.dismiss,
							variant = ButtonVariant.Standard,
							size = InputSize.Small,
							fillBehavior = FillBehavior.Fill,
							onActivated = t1.onClose
						})
					})
				})
			})
		})
	})
end
