local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Popover = Foundation.Popover
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local Localization = require(ExpChat.Localization)
local useIsChatBackgroundVisible = require(ExpChat.Stores.GetTransparencyStore.useIsChatBackgroundVisible)

local function DictationFTUX(p)
	local isOpen = useIsChatBackgroundVisible()
	local v = Foundation.Hooks.useTokens()

	local v2 = Localization.useLocalization({
		longPressHint = "CoreScripts.TextChat.ChatWindow.HandFreeTranscriptionFTUX"
	})

	local text = (not v2.longPressHint or v2.longPressHint == "") and "Hold to go hands free" or v2.longPressHint

	return React.createElement(Popover.Root, { isOpen = isOpen }, {
		Anchor = React.createElement(Popover.Anchor, { anchorRef = p.anchorRef }),
		Content = React.createElement(Popover.Content, {
			hasArrow = true,
			side = { position = PopoverSide.Top, offset = v.Size.Size_200 },
			align = PopoverAlign.Center,
			selectionGroup = false
		}, React.createElement(Foundation.View, {
			tag = "col gap-xsmall auto-xy padding-x-small padding-y-xsmall radius-small",
			backgroundStyle = v.Inverse.Surface.Surface_0,
			sizeConstraint = { MaxSize = Vector2.new(320, 1e999) },
			onActivated = p.onDismiss
		}, {
			Title = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-medium text-wrap content-inverse-default",
				Text = text
			})
		}))
	})
end

return React.memo(DictationFTUX)
