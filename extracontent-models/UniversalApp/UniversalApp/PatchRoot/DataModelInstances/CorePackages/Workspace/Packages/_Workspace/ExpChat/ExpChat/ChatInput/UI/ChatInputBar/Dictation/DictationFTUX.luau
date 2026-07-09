local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Foundation = require(ExpChatParent.Foundation)
local Popover = Foundation.Popover
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local Localization = require(ExpChat.Localization)
local useIsChatBackgroundVisible = require(ExpChat.Stores.GetTransparencyStore.useIsChatBackgroundVisible)

local function DictationFTUX(t1: {[any]: any}) -- line: 26
	-- upvalues: useIsChatBackgroundVisible (copy), Foundation (copy), Localization (copy), React (copy), Popover (copy), PopoverSide (copy), PopoverAlign (copy)
	local v12 = useIsChatBackgroundVisible()
	local v13 = Foundation.Hooks.useTokens()
	local v14 = Localization.useLocalization({
		longPressHint = "CoreScripts.TextChat.ChatWindow.HandFreeTranscriptionFTUX"
	})
	local v15 = (not v14.longPressHint or v14.longPressHint == "") and "Hold to go hands free" or v14.longPressHint

	return React.createElement(Popover.Root, {
		isOpen = v12
	}, {
		Anchor = React.createElement(Popover.Anchor, {
			anchorRef = t1.anchorRef
		}),
		Content = React.createElement(Popover.Content, {
			hasArrow = true,
			selectionGroup = false,
			side = {
				position = PopoverSide.Top,
				offset = v13.Size.Size_200
			},
			align = PopoverAlign.Center
		}, React.createElement(Foundation.View, {
			tag = "col gap-xsmall auto-xy padding-x-small padding-y-xsmall radius-small",
			backgroundStyle = v13.Inverse.Surface.Surface_0,
			sizeConstraint = {
				MaxSize = Vector2.new(320, 1e999)
			},
			onActivated = t1.onDismiss
		}, {
			Title = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-medium text-wrap content-inverse-default",
				Text = v15
			})
		}))
	})
end

return React.memo(DictationFTUX)
