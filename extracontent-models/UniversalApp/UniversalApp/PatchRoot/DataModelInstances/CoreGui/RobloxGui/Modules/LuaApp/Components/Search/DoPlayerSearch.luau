local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local CorePackages = game:GetService("CorePackages")
local GetFFlagLuaAppUseWithLocalization = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return function(p1, p2, p3, p4, p5, p6) -- line: 7
	-- upvalues: ArgCheck (copy), UrlBuilder (copy), GetFFlagLuaAppUseWithLocalization (copy)
	ArgCheck.isNotNil(p3, "keyword")

	local v12 = UrlBuilder.user.search({
		keyword = p3
	})

	p1.reportTouchSearchInsteadForPlayerNamed(p3)
	p4(v12, GetFFlagLuaAppUseWithLocalization() and p6 or p5:Format(p6), p2)
end
