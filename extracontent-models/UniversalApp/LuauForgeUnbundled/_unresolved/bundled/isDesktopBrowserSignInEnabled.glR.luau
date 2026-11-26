local module = require("@luauforge/bundled/glS")

local UserInputService = game:GetService("UserInputService")

local function isDesktopBrowserSignInEnabled(p2)
	local v5 = p2 or UserInputService:GetPlatform()

	return module and (v5 == Enum.Platform.Windows or v5 == Enum.Platform.OSX)
end

return isDesktopBrowserSignInEnabled
