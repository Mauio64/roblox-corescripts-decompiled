local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local React = require(Parent.React)
local AppLinking = require(Parent.RoactServiceTags).AppLinking
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local UIBlox = require(Parent.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local authButtonClick = require(Parent.AuthAnalytics).Events.authButtonClick

local function FAEDirectLinkUpsell(t1: {[any]: any}) -- line: 30
	-- upvalues: useScreenSize (copy), useTokens (copy), useRoactService (copy), AppLinking (copy), useLocalization (copy), React (copy), authButtonClick (copy), PartialPageModal (copy), ButtonType (copy), Images (copy), FoundationText (copy)
	local webLink = t1.webLink
	local onCancel = t1.onCancel
	local sessionId = t1.sessionId
	local entryPointEventCtx = t1.entryPointEventCtx
	local v21 = useScreenSize()
	local v22 = useTokens()
	local v23 = useRoactService(AppLinking)
	local v24 = useLocalization({
		title = "Amp.FAEUpsell.Modal.ExternalLink.Title",
		bodyText = "Amp.FAEUpsell.Modal.ExternalLink.Text",
		startBtn = "Amp.FAEUpsell.Modal.ExternalLink.ButtonStart",
		cancelBtn = "Amp.FAEUpsell.Modal.ExternalLink.ButtonCancel"
	})
	local v25 = React.useCallback(function() -- line: 47
		-- upvalues: authButtonClick (copy), entryPointEventCtx (copy), sessionId (copy), v23 (copy), webLink (copy)
		authButtonClick(entryPointEventCtx, "startFaeNonNative", sessionId)
		v23:openURL(webLink)
	end, {
		v23,
		webLink,
		sessionId,
		entryPointEventCtx
	})
	local v26 = React.useCallback(function() -- line: 52
		-- upvalues: authButtonClick (copy), entryPointEventCtx (copy), sessionId (copy), onCancel (copy)
		authButtonClick(entryPointEventCtx, "cancelFaeNonNative", sessionId)
		onCancel()
	end, {
		onCancel,
		sessionId,
		entryPointEventCtx
	})

	return React.createElement(PartialPageModal, {
		title = v24.title,
		screenSize = v21,
		onCloseClicked = v26,
		buttonStackProps = {
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = v26,
						text = v24.cancelBtn
					}
				},
				{
					buttonType = ButtonType.PrimaryContextual,
					props = {
						icon = Images["icons/navigation/externallink_medium"],
						onActivated = v25,
						text = v24.startBtn
					}
				}
			}
		}
	}, {
		ViewFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			OuterPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v22.Padding.XXLarge),
				PaddingBottom = UDim.new(0, v22.Padding.XXLarge)
			}),
			BodyText = React.createElement(FoundationText, {
				tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
				LayoutOrder = 1,
				Text = v24.bodyText
			})
		})
	})
end

return FAEDirectLinkUpsell
