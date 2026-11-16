local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization

local useStyle = UIBlox.Core.Style.useStyle
local buttonType = UIBlox.App.Button.Enum.ButtonType
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local styledTextLabel = UIBlox.App.Text.StyledTextLabel

local udim = UDim.new(0, 24)
local udim2 = UDim.new(0, 12)

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function EventNotificationsModal(p2)
	local v5 = useStyle()
	local v6 = useNavigation()
	local v7 = useSelector(selectScreenSize)

	local v8 = useLocalization({
		title = "Feature.VirtualEvents.EnableNotificationsModalTitle",
		body = "Feature.VirtualEvents.EnableNotificationsModalBody",
		notNow = "Feature.VirtualEvents.NotNowButton",
		getNotified = "Feature.VirtualEvents.GetNotifiedButton"
	})

	local v9 = React.useCallback(function()
		if p2.onClose then
			p2.onClose()
		end

		v6.goBack()
	end, { p2.onClose, v6 })

	local v10 = React.useCallback(function()
		if p2.onConfirm then
			p2.onConfirm()
		end

		v9()
	end, { p2.onConfirm, v9 })

	return React.createElement(partialPageModal, {
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		title = v8.title,
		screenSize = v7,
		buttonStackProps = {
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = v9, text = v8.notNow }
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = v10, text = v8.getNotified }
				}
			}
		},
		contentPadding = udim,
		onCloseClicked = v9
	}, {
		Wrapper = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = udim2
				}),
				Padding = React.createElement("UIPadding", {
					PaddingTop = udim2 + udim2,
					PaddingBottom = udim2
				}),
				Body = React.createElement(styledTextLabel, {
					text = v8.body,
					textXAlignment = Enum.TextXAlignment.Center,
					fontStyle = v5.Font.Body,
					colorStyle = v5.Theme.TextMuted,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					fluidSizing = false
				})
			}
		)
	})
end

return EventNotificationsModal
