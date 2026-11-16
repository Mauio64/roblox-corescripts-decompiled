local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local IconButton = Foundation.IconButton
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization

local FFlagPlayerListLocalizeGameText = require(parent.Flags.FFlagPlayerListLocalizeGameText)

local function PanelHeader(props)
	local v = not FFlagPlayerListLocalizeGameText and "Leaderboard"
		or useLocalization({ leaderboard = "InGame.PlayerList.Leaderboard" }).leaderboard

	return React.createElement(
		View,
		{
			Size = UDim2.new(1, 0, 0, props.height),
			LayoutOrder = props.layoutOrder,
			tag = "row flex-x-between align-y-center auto-y padding-x-large"
		},
		{
			Title = React.createElement(Text, {
				Text = props.title or v,
				tag = "auto-xy text-label-medium content-emphasis",
				LayoutOrder = 1
			}),
			CloseButton = React.createElement(IconButton, {
				icon = { name = Foundation.Enums.IconName.X },
				size = Foundation.Enums.InputSize.XSmall,
				onActivated = props.onClose,
				isDisabled = props.isDisabled == true,
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(PanelHeader)
