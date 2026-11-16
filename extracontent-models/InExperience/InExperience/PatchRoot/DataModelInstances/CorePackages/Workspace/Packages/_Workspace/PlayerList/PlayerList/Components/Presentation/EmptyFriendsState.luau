local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Text = Foundation.Text

local FFlagPlayerListLocalizeGameText = require(parent.Flags.FFlagPlayerListLocalizeGameText)
local useLegacyAndTransparencyAwarePanelStyle = require(parent.Hooks.useLegacyAndTransparencyAwarePanelStyle)

local function EmptyFriendsStateImpl(p)
	local v = useLegacyAndTransparencyAwarePanelStyle(p.useLegacyPanelStyling)

	local text = not FFlagPlayerListLocalizeGameText and "None of your friends have played this experience yet."
		or useLocalization({ friendsEmpty = "InGame.PlayerList.FriendsEmpty" }).friendsEmpty

	return React.createElement(
		View,
		{ tag = v.panelTag, LayoutOrder = p.layoutOrder, backgroundStyle = v.backgroundStyle },
		{
			Message = React.createElement(Text, {
				Text = text,
				tag = "size-full-0 auto-y text-body-small text-align-x-center content-default",
				TextWrapped = true
			})
		}
	)
end

return React.memo(EmptyFriendsStateImpl)
