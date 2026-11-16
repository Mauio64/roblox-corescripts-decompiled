local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local RoactUtils = require(VirtualEvents.Parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local EmptyState = UIBlox.App.Indicator.EmptyState

local function selectScreenSize(p)
	return p.ScreenSize
end

local function EventNotFoundModal(p)
	local v = useSelector(selectScreenSize)

	local v2 = useLocalization({ notFound = "Feature.VirtualEvents.EventNotFound" })

	return React.createElement(PartialPageModal, {
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		screenSize = v - Vector2.new(40, 0),
		contentPadding = UDim.new(0, 24),
		onCloseClicked = p.onClose
	}, {
		Wrapper = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 80),
					PaddingBottom = UDim.new(0, 20)
				}),
				EventNotFound = React.createElement(EmptyState, { text = v2.notFound })
			}
		)
	})
end

return EventNotFoundModal
