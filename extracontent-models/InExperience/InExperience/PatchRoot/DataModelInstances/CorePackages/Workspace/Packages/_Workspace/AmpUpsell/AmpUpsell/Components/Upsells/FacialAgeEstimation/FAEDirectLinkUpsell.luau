local parent = script:FindFirstAncestor("AmpUpsell").Parent

local React = require(parent.React)

local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RobloxAppHooks2 = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks2.useScreenSize
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local UIBlox = require(parent.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images

local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local AuthAnalytics = require(parent.AuthAnalytics)
local authButtonClick = AuthAnalytics.Events.authButtonClick

local function FAEDirectLinkUpsell(props)
	local webLink = props.webLink
	local onCancel = props.onCancel
	local sessionId = props.sessionId
	local entryPointEventCtx = props.entryPointEventCtx

	local screenSize = useScreenSize()
	local v = useTokens()
	local v2 = useRoactService(AppLinking)

	local v3 = useLocalization({
		title = "Amp.FAEUpsell.Modal.ExternalLink.Title",
		bodyText = "Amp.FAEUpsell.Modal.ExternalLink.Text",
		startBtn = "Amp.FAEUpsell.Modal.ExternalLink.ButtonStart",
		cancelBtn = "Amp.FAEUpsell.Modal.ExternalLink.ButtonCancel"
	})

	local onActivated = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "startFaeNonNative", sessionId)
		v2:openURL(webLink)
	end, { v2, webLink, sessionId, entryPointEventCtx })

	local v4 = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "cancelFaeNonNative", sessionId)
		onCancel()
	end, { onCancel, sessionId, entryPointEventCtx })

	return React.createElement(PartialPageModal, {
		title = v3.title,
		screenSize = screenSize,
		onCloseClicked = v4,
		buttonStackProps = {
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = { onActivated = v4, text = v3.cancelBtn }
				},
				{
					buttonType = ButtonType.PrimaryContextual,
					props = {
						icon = Images["icons/navigation/externallink_medium"],
						onActivated = onActivated,
						text = v3.startBtn
					}
				}
			}
		}
	}, {
		ViewFrame = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0)
			},
			{
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				OuterPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v.Padding.XXLarge),
					PaddingBottom = UDim.new(0, v.Padding.XXLarge)
				}),
				BodyText = React.createElement(Text, {
					tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
					Text = v3.bodyText,
					LayoutOrder = 1
				})
			}
		)
	})
end

return FAEDirectLinkUpsell
