local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local isSplitPaneEducationalTourGuiObjectVisible = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/isSplitPaneEducationalTourGuiObjectVisible")

return function(instance)
	local state, setState = React.useState(nil)

	React.useLayoutEffect(function()
		if instance == nil then
			setState(nil)
			return
		end

		local function updateRect()
			if not isSplitPaneEducationalTourGuiObjectVisible(instance) then
				setState(nil)
				return
			end

			local absolutePosition = instance.AbsolutePosition
			local absoluteSize = instance.AbsoluteSize
			setState(Rect.new(
				absolutePosition.X,
				absolutePosition.Y,
				absolutePosition.X + absoluteSize.X,
				absolutePosition.Y + absoluteSize.Y
			))
		end

		updateRect()
		local connections = {
			instance:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateRect),
			instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateRect)
		}

		local guiObject = instance

		while guiObject ~= nil do
			if guiObject:IsA("GuiObject") then
				connections[#connections + 1] = guiObject:GetPropertyChangedSignal("Visible"):Connect(updateRect)
			end

			guiObject = guiObject.Parent
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { instance })

	return state
end
