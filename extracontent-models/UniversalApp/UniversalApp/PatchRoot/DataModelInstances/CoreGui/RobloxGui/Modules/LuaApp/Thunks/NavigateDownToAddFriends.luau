local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Modules = CoreGui.RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)

return function(p1) -- line: 12
	-- upvalues: t (copy), NavigateDown (copy), AppPage (copy), UrlBuilder (copy)
	assert(t.callback(p1) or t.none(p1))

	return NavigateDown({
		name = AppPage.GenericWebPage,
		detail = UrlBuilder.static.friends(),
		extraProps = {
			titleKey = "CommonUI.Features.Label.Friends",
			onClose = p1,
			searchParams = {
				searchType = "Players"
			}
		}
	})
end
