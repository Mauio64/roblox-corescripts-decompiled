local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization

local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local emptyState = UIBlox.App.Indicator.EmptyState

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function EventNotFoundModal(p2)
	local v5 = useSelector(selectScreenSize)

	local v6 = useLocalization({ notFound = "Feature.VirtualEvents.EventNotFound" })

	return React.createElement(partialPageModal, {
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		screenSize = v5 - Vector2.new(40, 0),
		contentPadding = UDim.new(0, 24),
		onCloseClicked = p2.onClose
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
				EventNotFound = React.createElement(emptyState, { text = v6.notFound })
			}
		)
	})
end

return EventNotFoundModal
