local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UrlBuilder").UrlBuilder
local SelectableTextLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SelectableTextLabel")

local udim = UDim.new(0, 24)
local udim2 = UDim.new(0, 8)
local udim3 = UDim.new(0, 2)

local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function ShareEventModal(props)
	local v5 = useStyle()
	local v6 = useSelector(selectScreenSize)
	local v7 = useNavigation()

	local v8 = React.useMemo(function()
		return urlBuilder.virtualevents.appsflyer({ eventId = props.virtualEventId })
	end, { props.virtualEventId })

	local v9 = useLocalization({
		title = "Feature.VirtualEvents.ShareModalTitle",
		body = "Feature.VirtualEvents.ShareModalBody",
		copyLink = "Feature.VirtualEvents.ShareModalLinkCopy",
		callToAction = "Feature.VirtualEvents.ShareModalCallToAction"
	})

	local v10 = React.useCallback(function()
		v7.goBack()

		if props.onClose then
			props.onClose()
		end
	end, { props, v7 })

	local v11 = React.useCallback(function()
		if props.onCopy then
			props.onCopy(v8)
		end
	end, { v8, props.onCopy })

	return React.createElement(
		partialPageModal,
		{
			title = v9.title,
			screenSize = v6,
			contentPadding = udim,
			onCloseClicked = v10
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
					Body = React.createElement(styledTextLabel, {
						layoutOrder = 1,
						text = v9.body,
						fontStyle = v5.Font.Body,
						colorStyle = v5.Theme.TextMuted,
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
								BackgroundColor3 = v5.Theme.UIMuted.Color,
								BackgroundTransparency = 1
							}, {
								Corner = React.createElement("UICorner", {
									CornerRadius = udim3
								}),
								Border = React.createElement("UIStroke", {
									Color = v5.Theme.UIDefault.Color
								}),
								Padding = React.createElement("UIPadding", {
									PaddingTop = udim2,
									PaddingRight = udim2,
									PaddingBottom = udim2,
									PaddingLeft = udim2
								}),
								Label = React.createElement(SelectableTextLabel, {
									fontStyle = v5.Font.Body,
									colorStyle = v5.Theme.TextMuted,
									Size = UDim2.fromScale(1, 0),
									AutomaticSize = Enum.AutomaticSize.Y,
									Text = v8
								})
							}),
							Action = React.createElement(button, {
								buttonType = buttonType.PrimarySystem,
								layoutOrder = 2,
								text = v9.copyLink,
								size = UDim2.new(0.2, 0, 0, 32),
								onActivated = v11
							})
						}
					)
				}
			)
		}
	)
end

return ShareEventModal
