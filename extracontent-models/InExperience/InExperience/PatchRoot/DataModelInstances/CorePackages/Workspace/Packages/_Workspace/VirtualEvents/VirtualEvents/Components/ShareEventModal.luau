local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local Navigation = require(VirtualEvents.Parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils = require(VirtualEvents.Parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UrlBuilder = require(VirtualEvents.Parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local SelectableTextLabel = require(script.Parent.SelectableTextLabel)

local udim = UDim.new(0, 24)
local udim2 = UDim.new(0, 8)
local udim3 = UDim.new(0, 2)

local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

local function selectScreenSize(p)
	return p.ScreenSize
end

local function ShareEventModal(props)
	local v = useStyle()
	local screenSize = useSelector(selectScreenSize)
	local v2 = useNavigation()

	local text = React.useMemo(function()
		return urlBuilder.virtualevents.appsflyer({ eventId = props.virtualEventId })
	end, { props.virtualEventId })

	local v3 = useLocalization({
		title = "Feature.VirtualEvents.ShareModalTitle",
		body = "Feature.VirtualEvents.ShareModalBody",
		copyLink = "Feature.VirtualEvents.ShareModalLinkCopy",
		callToAction = "Feature.VirtualEvents.ShareModalCallToAction"
	})

	local onCloseClicked = React.useCallback(function()
		v2.goBack()

		if props.onClose then
			props.onClose()
		end
	end, { props, v2 })

	local onActivated = React.useCallback(function()
		if props.onCopy then
			props.onCopy(text)
		end
	end, { text, props.onCopy })

	return React.createElement(
		PartialPageModal,
		{
			title = v3.title,
			screenSize = screenSize,
			contentPadding = udim,
			onCloseClicked = onCloseClicked
		},
		{
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
						Padding = udim
					}),
					Padding = React.createElement("UIPadding", { PaddingTop = udim }),
					Body = React.createElement(StyledTextLabel, {
						layoutOrder = 1,
						text = v3.body,
						fontStyle = v.Font.Body,
						colorStyle = v.Theme.TextMuted,
						size = UDim2.new(1, 0, 0, 40),
						fluidSizing = false
					}),
					Deeplink = React.createElement(
						"Frame",
						{
							LayoutOrder = 2,
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1
						},
						{
							Layout = React.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Horizontal,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								Padding = udim
							}),
							Field = React.createElement("Frame", {
								LayoutOrder = 1,
								Size = UDim2.fromScale(0.8, 0) - UDim2.fromOffset(udim.Offset, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundColor3 = v.Theme.UIMuted.Color,
								BackgroundTransparency = 1
							}, {
								Corner = React.createElement("UICorner", { CornerRadius = udim3 }),
								Border = React.createElement("UIStroke", {
									Color = v.Theme.UIDefault.Color
								}),
								Padding = React.createElement("UIPadding", {
									PaddingTop = udim2,
									PaddingRight = udim2,
									PaddingBottom = udim2,
									PaddingLeft = udim2
								}),
								Label = React.createElement(SelectableTextLabel, {
									fontStyle = v.Font.Body,
									colorStyle = v.Theme.TextMuted,
									Size = UDim2.fromScale(1, 0),
									AutomaticSize = Enum.AutomaticSize.Y,
									Text = text
								})
							}),
							Action = React.createElement(Button, {
								buttonType = ButtonType.PrimarySystem,
								layoutOrder = 2,
								text = v3.copyLink,
								size = UDim2.new(0.2, 0, 0, 32),
								onActivated = onActivated
							})
						}
					)
				}
			)
		}
	)
end

return ShareEventModal
