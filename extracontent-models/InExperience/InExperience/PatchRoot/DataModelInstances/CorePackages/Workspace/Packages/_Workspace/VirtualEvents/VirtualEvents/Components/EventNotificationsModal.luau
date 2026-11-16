local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local RoactUtils = require(VirtualEvents.Parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Navigation = require(VirtualEvents.Parent.Navigation)
local useNavigation = Navigation.useNavigation
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useStyle = UIBlox.Core.Style.useStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local udim = UDim.new(0, 24)
local udim2 = UDim.new(0, 12)

local function selectScreenSize(p)
	return p.ScreenSize
end

local function EventNotificationsModal(p)
	local v = useStyle()
	local v2 = useNavigation()
	local screenSize = useSelector(selectScreenSize)

	local v3 = useLocalization({
		title = "Feature.VirtualEvents.EnableNotificationsModalTitle",
		body = "Feature.VirtualEvents.EnableNotificationsModalBody",
		notNow = "Feature.VirtualEvents.NotNowButton",
		getNotified = "Feature.VirtualEvents.GetNotifiedButton"
	})

	local v4 = React.useCallback(function()
		if p.onClose then
			p.onClose()
		end

		v2.goBack()
	end, { p.onClose, v2 })

	local onActivated = React.useCallback(function()
		if p.onConfirm then
			p.onConfirm()
		end

		v4()
	end, { p.onConfirm, v4 })

	return React.createElement(PartialPageModal, {
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		title = v3.title,
		screenSize = screenSize,
		buttonStackProps = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = { onActivated = v4, text = v3.notNow }
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = onActivated, text = v3.getNotified }
				}
			}
		},
		contentPadding = udim,
		onCloseClicked = v4
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
				Body = React.createElement(StyledTextLabel, {
					text = v3.body,
					textXAlignment = Enum.TextXAlignment.Center,
					fontStyle = v.Font.Body,
					colorStyle = v.Theme.TextMuted,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					fluidSizing = false
				})
			}
		)
	})
end

return EventNotificationsModal
