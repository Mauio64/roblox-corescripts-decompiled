local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local useSelector = require(VirtualEvents.Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(VirtualEvents.Parent.Navigation).useNavigation
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local uDim = UDim.new(0, 24)
local uDim2 = UDim.new(0, 12)

local function selectScreenSize(p1) -- line: 17
	return p1.ScreenSize
end
local function EventNotificationsModal(t1: {[any]: any}) -- line: 26
	-- upvalues: useStyle (copy), useNavigation (copy), useSelector (copy), selectScreenSize (copy), useLocalization (copy), React (copy), PartialPageModal (copy), ButtonType (copy), uDim (copy), uDim2 (copy), StyledTextLabel (copy)
	local v17 = useStyle()
	local v18 = useNavigation()
	local v19 = useSelector(selectScreenSize)
	local v20 = useLocalization({
		title = "Feature.VirtualEvents.EnableNotificationsModalTitle",
		body = "Feature.VirtualEvents.EnableNotificationsModalBody",
		notNow = "Feature.VirtualEvents.NotNowButton",
		getNotified = "Feature.VirtualEvents.GetNotifiedButton"
	})
	local v21 = React.useCallback(function() -- line: 38
		-- upvalues: t1 (copy), v18 (copy)
		if t1.onClose then
			t1.onClose()
		end

		v18.goBack()
	end, {
		t1.onClose,
		v18
	})
	local v22 = React.useCallback(function() -- line: 46
		-- upvalues: t1 (copy), v21 (copy)
		if t1.onConfirm then
			t1.onConfirm()
		end

		v21()
	end, {
		t1.onConfirm,
		v21
	})

	return React.createElement(PartialPageModal, {
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		title = v20.title,
		screenSize = v19,
		buttonStackProps = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = v21,
						text = v20.notNow
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v22,
						text = v20.getNotified
					}
				}
			}
		},
		contentPadding = uDim,
		onCloseClicked = v21
	}, {
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = uDim2
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = uDim2 + uDim2,
				PaddingBottom = uDim2
			}),
			Body = React.createElement(StyledTextLabel, {
				fluidSizing = false,
				text = v20.body,
				textXAlignment = Enum.TextXAlignment.Center,
				fontStyle = v17.Font.Body,
				colorStyle = v17.Theme.TextMuted,
				size = UDim2.fromScale(1, 0),
				automaticSize = Enum.AutomaticSize.Y
			})
		})
	})
end

return EventNotificationsModal
