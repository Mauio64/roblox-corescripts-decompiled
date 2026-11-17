local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local parent = GamePlayButton.Parent

local PlayButtonUpsellBody = require(GamePlayButton.PlayButtonUpsellBody)

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking

local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType

local DiscoveryUtils = require(parent.DiscoveryUtils)
local extractAndStyleRichTextLinks = DiscoveryUtils.extractAndStyleRichTextLinks

local FFlagEnablePlayButtonWizardVPCPrologue = require(GamePlayButton.Flags.FFlagEnablePlayButtonWizardVPCPrologue)

local function PlayButtonUpsellDialog(props)
	local v = useTokens()
	local v2 = useDispatch()
	local v3 = useRoactService(AppLinking)

	local v4 = React.useMemo(function()
		local v4, styledText = extractAndStyleRichTextLinks(props.bodyText)
		local link

		if #v4 > 0 then
			link = v4[1]
		end

		return { link = link, styledText = styledText }
	end, { props.bodyText })

	local v5 = React.useCallback(function()
		if not v4.link then
			return
		end

		props.onCloseModal()

		v2(SetCentralOverlay(CentralOverlayType.LeaveRobloxAlert, {
			continueFunc = function()
				v3:openURL(v4.link)
				v2(CloseCentralOverlay())
			end
		}))
	end, { props.onCloseModal, v4.link, v2, v3 })

	local createElement = React.createElement
	local root = Dialog.Root
	local v6 = { size = DialogSize.Medium, hasBackdrop = false, onClose = props.onCloseModal }
	local children = {
		Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = props.titleText }),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content
	local bodyText

	if FFlagEnablePlayButtonWizardVPCPrologue then
		bodyText = React.createElement(PlayButtonUpsellBody, {
			bodyText = props.bodyText,
			onCloseModal = props.onCloseModal
		})
	else
		local createElement3 = React.createElement
		local v7 = {
			["AutomaticSize"] = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			RichText = true,
			Size = UDim2.new(1, 0, 0, 0),
			Text = v4.styledText,
			TextSize = v.Typography.BodyLarge.FontSize,
			FontFace = normalizeFontFace(v.Typography.BodyLarge.Font),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = v.Color.Content.Emphasis.Color3,
			Active = v4.link ~= nil,
			Selectable = v4.link ~= nil
		}
		local activated = React.Event.Activated

		if not v4.link then
			v5 = nil
		end

		v7[activated] = v5
		bodyText = createElement3("TextButton", v7)
	end

	children.Content = createElement2(content, { LayoutOrder = 2 }, { BodyText = bodyText })

	children.Actions = React.createElement(Dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{
				text = props.cancelButtonText,
				variant = ButtonVariant.Standard,
				onActivated = props.onCancelButtonClick
			},
			{
				text = props.actionButtonText,
				variant = ButtonVariant.Emphasis,
				onActivated = props.onActionButtonClick
			}
		}
	})
	return createElement(root, v6, children)
end

return PlayButtonUpsellDialog
