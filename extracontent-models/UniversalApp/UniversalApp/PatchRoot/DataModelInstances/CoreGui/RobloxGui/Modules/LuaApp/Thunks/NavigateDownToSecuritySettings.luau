local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)

return function(p1) -- line: 10
	-- upvalues: ArgCheck (copy), NavigateDown (copy), AppPage (copy), UrlBuilder (copy)
	ArgCheck.isTypeOrNil(p1, "function", "onClose")

	return NavigateDown({
		name = AppPage.SettingsSubPage,
		detail = UrlBuilder.static.settings.security(),
		extraProps = {
			titleKey = "Feature.AccountSettings.Heading.Tab.Security",
			onClose = p1
		}
	})
end
