local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local useSelector = require(VirtualEvents.Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local EmptyState = UIBlox.App.Indicator.EmptyState

local function selectScreenSize(p1) -- line: 11
	return p1.ScreenSize
end
local function EventNotFoundModal(t1: {[any]: any}) -- line: 19
	-- upvalues: useSelector (copy), selectScreenSize (copy), useLocalization (copy), React (copy), PartialPageModal (copy), EmptyState (copy)
	local v12 = useSelector(selectScreenSize)
	local v13 = useLocalization({
		notFound = "Feature.VirtualEvents.EventNotFound"
	})

	return React.createElement(PartialPageModal, {
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		screenSize = v12 - Vector2.new(40, 0),
		contentPadding = UDim.new(0, 24),
		onCloseClicked = t1.onClose
	}, {
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 80),
				PaddingBottom = UDim.new(0, 20)
			}),
			EventNotFound = React.createElement(EmptyState, {
				text = v13.notFound
			})
		})
	})
end

return EventNotFoundModal
