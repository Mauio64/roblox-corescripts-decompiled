local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local useNavigation = require(VirtualEvents.Parent.Navigation).useNavigation
local useSelector = require(VirtualEvents.Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
local UrlBuilder = require(VirtualEvents.Parent.UrlBuilder).UrlBuilder
local SelectableTextLabel = require(script.Parent.SelectableTextLabel)
local uDim = UDim.new(0, 24)
local uDim2 = UDim.new(0, 8)
local uDim3 = UDim.new(0, 2)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

local function selectScreenSize(p1) -- line: 28
	return p1.ScreenSize
end
local function ShareEventModal(t1: {[any]: any}) -- line: 32
	-- upvalues: useStyle (copy), useSelector (copy), selectScreenSize (copy), useNavigation (copy), React (copy), UrlBuilder (copy), useLocalization (copy), PartialPageModal (copy), uDim (copy), StyledTextLabel (copy), uDim3 (copy), uDim2 (copy), SelectableTextLabel (copy), Button (copy), ButtonType (copy)
	local v21 = useStyle()
	local v22 = useSelector(selectScreenSize)
	local v23 = useNavigation()
	local v24 = React.useMemo(function() -- line: 37
		-- upvalues: UrlBuilder (copy), t1 (copy)
		return UrlBuilder.virtualevents.appsflyer({
			eventId = t1.virtualEventId
		})
	end, { t1.virtualEventId })
	local v25 = useLocalization({
		title = "Feature.VirtualEvents.ShareModalTitle",
		body = "Feature.VirtualEvents.ShareModalBody",
		copyLink = "Feature.VirtualEvents.ShareModalLinkCopy",
		callToAction = "Feature.VirtualEvents.ShareModalCallToAction"
	})
	local v26 = React.useCallback(function() -- line: 50
		-- upvalues: v23 (copy), t1 (copy)
		v23.goBack()

		if t1.onClose then
			t1.onClose()
		end
	end, {
		t1,
		v23
	})
	local v27 = React.useCallback(function() -- line: 58
		-- upvalues: t1 (copy), v24 (copy)
		if t1.onCopy then
			t1.onCopy(v24)
		end
	end, {
		v24,
		t1.onCopy
	})

	return React.createElement(PartialPageModal, {
		title = v25.title,
		screenSize = v22,
		contentPadding = uDim,
		onCloseClicked = v26
	}, {
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = uDim
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = uDim
			}),
			Body = React.createElement(StyledTextLabel, {
				layoutOrder = 1,
				fluidSizing = false,
				text = v25.body,
				fontStyle = v21.Font.Body,
				colorStyle = v21.Theme.TextMuted,
				size = UDim2.new(1, 0, 0, 40)
			}),
			Deeplink = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = uDim
				}),
				Field = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0.8, 0) - UDim2.fromOffset(uDim.Offset, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = v21.Theme.UIMuted.Color
				}, {
					Corner = React.createElement("UICorner", {
						CornerRadius = uDim3
					}),
					Border = React.createElement("UIStroke", {
						Color = v21.Theme.UIDefault.Color
					}),
					Padding = React.createElement("UIPadding", {
						PaddingTop = uDim2,
						PaddingRight = uDim2,
						PaddingBottom = uDim2,
						PaddingLeft = uDim2
					}),
					Label = React.createElement(SelectableTextLabel, {
						fontStyle = v21.Font.Body,
						colorStyle = v21.Theme.TextMuted,
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Text = v24
					})
				}),
				Action = React.createElement(Button, {
					layoutOrder = 2,
					buttonType = ButtonType.PrimarySystem,
					text = v25.copyLink,
					size = UDim2.new(0.2, 0, 0, 32),
					onActivated = v27
				})
			})
		})
	})
end

return ShareEventModal
