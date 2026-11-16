local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Empty = Foundation.Empty
local IconSize = Foundation.Enums.IconSize

local FFlagPlayerListLocalizeGameText = require(parent.Flags.FFlagPlayerListLocalizeGameText)
local useLegacyAndTransparencyAwarePanelStyle = require(parent.Hooks.useLegacyAndTransparencyAwarePanelStyle)

local function fn() end

local function ServiceUnavailableStateImpl(props)
	local v = useLegacyAndTransparencyAwarePanelStyle(props.useLegacyPanelStyling)
	local text, text2

	if FFlagPlayerListLocalizeGameText then
		local v2 = useLocalization({
			body = "InGame.PlayerList.LeaderboardUnavailable",
			retry = "InGame.PlayerList.Retry"
		})

		text = v2.body
		text2 = v2.retry
	else
		text = "Leaderboard unavailable. Please try again later."
		text2 = "Retry"
	end

	return React.createElement(
		View,
		{ tag = v.panelTag, LayoutOrder = props.layoutOrder, backgroundStyle = v.backgroundStyle },
		{
			Content = React.createElement(Empty, {
				icon = { name = "triangle-exclamation", size = IconSize.Large },
				text = text,
				button = {
					text = text2,
					onActivated = props.onRetry or fn
				}
			})
		}
	)
end

return React.memo(ServiceUnavailableStateImpl)
