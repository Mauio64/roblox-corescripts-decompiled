local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")

local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactServiceTags").AppLinking
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppHooks").useRoactService
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppHooks").useScreenSize
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local authButtonClick = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AuthAnalytics").Events.authButtonClick

local function FAEDirectLinkUpsell(props)
	local webLink = props.webLink
	local onCancel = props.onCancel
	local sessionId = props.sessionId
	local entryPointEventCtx = props.entryPointEventCtx

	local v5 = useScreenSize()
	local v6 = useTokens()
	local v7 = useRoactService(appLinking)

	local v8 = useLocalization({
		title = "Amp.FAEUpsell.Modal.ExternalLink.Title",
		bodyText = "Amp.FAEUpsell.Modal.ExternalLink.Text",
		startBtn = "Amp.FAEUpsell.Modal.ExternalLink.ButtonStart",
		cancelBtn = "Amp.FAEUpsell.Modal.ExternalLink.ButtonCancel"
	})

	local v9 = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "startFaeNonNative", sessionId)
		v7:openURL(webLink)
	end, { v7, webLink, sessionId, entryPointEventCtx })

	local v10 = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "cancelFaeNonNative", sessionId)
		onCancel()
	end, { onCancel, sessionId, entryPointEventCtx })

	return React.createElement(partialPageModal, {
		title = v8.title,
		screenSize = v5,
		onCloseClicked = v10,
		buttonStackProps = {
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = v10, text = v8.cancelBtn }
				},
				{
					buttonType = buttonType.PrimaryContextual,
					props = {
						icon = images["icons/navigation/externallink_medium"],
						onActivated = v9,
						text = v8.startBtn
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
					PaddingTop = UDim.new(0, v6.Padding.XXLarge),
					PaddingBottom = UDim.new(0, v6.Padding.XXLarge)
				}),
				BodyText = React.createElement(text, {
					tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
					Text = v8.bodyText,
					LayoutOrder = 1
				})
			}
		)
	})
end

return FAEDirectLinkUpsell
