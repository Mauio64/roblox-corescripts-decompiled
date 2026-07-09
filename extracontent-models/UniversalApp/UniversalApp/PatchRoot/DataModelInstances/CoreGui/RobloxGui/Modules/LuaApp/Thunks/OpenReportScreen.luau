local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)

local function openReportScreen(p1) -- line: 6
	-- upvalues: AppPage (copy), NavigateDown (copy)
	return function(p2) -- line: 7
		-- upvalues: AppPage (copy), p1 (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.ReportScreen,
			reportData = p1
		}

		p2:dispatch(NavigateDown(t1))
	end
end

return openReportScreen
