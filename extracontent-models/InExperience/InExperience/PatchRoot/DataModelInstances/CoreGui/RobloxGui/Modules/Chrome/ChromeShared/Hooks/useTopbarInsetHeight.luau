local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local React = require(CorePackages.Packages.React)

return function() -- line: 6
	-- upvalues: React (copy), GuiService (copy)
	local v4, v5 = React.useState(GuiService.TopbarInset.Height)

	React.useEffect(function() -- line: 9
		-- upvalues: GuiService (copy), v5 (copy)
		local connection = GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function() -- line: 10
			-- upvalues: v5 (copy), GuiService (copy)
			v5(GuiService.TopbarInset.Height)
		end)

		return function() -- line: 14
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v4
end
