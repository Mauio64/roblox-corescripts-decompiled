local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppLinking = require(Parent.RoactServiceTags).AppLinking
local CentralOverlay = require(Parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local extractAndStyleRichTextLinks = require(Parent.DiscoveryUtils).extractAndStyleRichTextLinks

local function PlayButtonUpsellDialog(t1: {[any]: any}) -- line: 37
	-- upvalues: useTokens (copy), useDispatch (copy), useRoactService (copy), AppLinking (copy), React (copy), extractAndStyleRichTextLinks (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy)
	local v18 = useTokens()
	local v19 = useDispatch()
	local v20 = useRoactService(AppLinking)
	local v21 = React.useMemo(function() -- line: 42
		-- upvalues: extractAndStyleRichTextLinks (copy), t1 (copy)
		local v23, v24 = extractAndStyleRichTextLinks(t1.bodyText)

		return {
			link = if not (#v23 > 0) then nil else v23[1],
			styledText = v24
		}
	end, { t1.bodyText })
	local v22 = React.useCallback(function() -- line: 52
		-- upvalues: v21 (copy), t1 (copy), v19 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v20 (copy), CloseCentralOverlay (copy)
		if not v21.link then
			return
		end

		t1.onCloseModal()
		v19(SetCentralOverlay(CentralOverlayType.LeaveRobloxAlert, {
			continueFunc = function() -- line: 61
				-- upvalues: v20 (copy), v21 (copy), v19 (copy), CloseCentralOverlay (copy)
				v20:openURL(v21.link)
				v19(CloseCentralOverlay())
			end
		}))
	end, {
		t1.onCloseModal,
		v21.link,
		v19,
		v20
	})

	return React.createElement(Dialog.Root, {
		hasBackdrop = false,
		size = DialogSize.Medium,
		onClose = t1.onCloseModal
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = t1.titleText
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			BodyText = React.createElement("TextButton", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				RichText = true,
				Size = UDim2.new(1, 0, 0, 0),
				Text = v21.styledText,
				TextSize = v18.Typography.BodyLarge.FontSize,
				Font = v18.Typography.BodyLarge.Font,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = v18.Color.Content.Emphasis.Color3,
				Active = v21.link ~= nil,
				Selectable = v21.link ~= nil,
				[React.Event.Activated] = if not v21.link then nil else v22
			})
		}),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = t1.cancelButtonText,
					variant = ButtonVariant.Standard,
					onActivated = t1.onCancelButtonClick
				},
				{
					text = t1.actionButtonText,
					variant = ButtonVariant.Emphasis,
					onActivated = t1.onActionButtonClick
				}
			}
		})
	})
end

return PlayButtonUpsellDialog
