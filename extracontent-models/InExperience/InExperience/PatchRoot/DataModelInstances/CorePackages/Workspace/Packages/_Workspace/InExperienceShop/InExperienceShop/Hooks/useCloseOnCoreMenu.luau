local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)

local GuiService = game:GetService("GuiService")

local function useCloseOnCoreMenu(onMenuOpened)
	React.useEffect(function()
		local menuOpenedConnection = GuiService.MenuOpened:Connect(onMenuOpened)
		return function()
			menuOpenedConnection:Disconnect()
		end
	end, { onMenuOpened })
end

return useCloseOnCoreMenu
