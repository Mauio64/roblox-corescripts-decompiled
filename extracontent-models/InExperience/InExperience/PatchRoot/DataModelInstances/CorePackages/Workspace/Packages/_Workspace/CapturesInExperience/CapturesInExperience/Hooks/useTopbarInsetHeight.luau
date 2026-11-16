local parent = script.Parent.Parent.Parent

local GuiService = game:GetService("GuiService")

local React = require(parent.React)

return function()
	local state, setState = React.useState(GuiService.TopbarInset.Height)

	React.useEffect(function()
		local topbarInsetChangedConnection = GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function()
			setState(GuiService.TopbarInset.Height)
		end)

		return function()
			topbarInsetChangedConnection:Disconnect()
		end
	end, {})

	return state
end
