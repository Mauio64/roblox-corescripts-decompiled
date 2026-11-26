local PlayButtonUpsellBody = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonUpsellBody")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Foundation")
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils").Hooks.RoactRodux.useDispatch

local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").AppLinking

local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/CentralOverlay")
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/RobloxAppEnums").CentralOverlayType

local extractAndStyleRichTextLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryUtils").extractAndStyleRichTextLinks

local FFlagEnablePlayButtonWizardVPCPrologue = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/Flags/FFlagEnablePlayButtonWizardVPCPrologue")

local function PlayButtonUpsellDialog(props)
	local v5 = useTokens()
	local v6 = useDispatch()
	local v7 = useRoactService(appLinking)

	local v8 = React.useMemo(function()
		local v9, v10 = extractAndStyleRichTextLinks(props.bodyText)

		local v12 = if #v9 > 0 then v9[1] else nil
		return { link = v12, styledText = v10 }
	end, { props.bodyText })

	local v9 = React.useCallback(function()
		if not v8.link then
			return
		end

		props.onCloseModal()

		v6(setCentralOverlay(centralOverlayType.LeaveRobloxAlert, {
			continueFunc = function()
				v7:openURL(v8.link)
				v6(closeCentralOverlay())
			end
		}))
	end, { props.onCloseModal, v8.link, v6, v7 })

	local createElement = React.createElement
	local root = dialog.Root
	local v10 = {
		size = dialogSize.Medium,
		hasBackdrop = false,
		onClose = props.onCloseModal
	}
	local children = {
		Title = React.createElement(dialog.Title, {
			LayoutOrder = 1,
			text = props.titleText
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content
	local v13

	if FFlagEnablePlayButtonWizardVPCPrologue then
		v13 = React.createElement(PlayButtonUpsellBody, {
			bodyText = props.bodyText,
			onCloseModal = props.onCloseModal
		})
	else
		local createElement3 = React.createElement
		local v15 = {
			["AutomaticSize"] = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			RichText = true,
			Size = UDim2.new(1, 0, 0, 0),
			Text = v8.styledText,
			TextSize = v5.Typography.BodyLarge.FontSize,
			FontFace = normalizeFontFace(v5.Typography.BodyLarge.Font),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = v5.Color.Content.Emphasis.Color3,
			Active = v8.link ~= nil,
			Selectable = v8.link ~= nil
		}
		local activated = React.Event.Activated

		if not v8.link then
			v9 = nil
		end

		v15[activated] = v9
		v13 = createElement3("TextButton", v15)
	end

	children.Content = createElement2(content, { LayoutOrder = 2 }, { BodyText = v13 })

	children.Actions = React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{
				text = props.cancelButtonText,
				variant = buttonVariant.Standard,
				onActivated = props.onCancelButtonClick
			},
			{
				text = props.actionButtonText,
				variant = buttonVariant.Emphasis,
				onActivated = props.onActionButtonClick
			}
		}
	})
	return createElement(root, v10, children)
end

return PlayButtonUpsellDialog
