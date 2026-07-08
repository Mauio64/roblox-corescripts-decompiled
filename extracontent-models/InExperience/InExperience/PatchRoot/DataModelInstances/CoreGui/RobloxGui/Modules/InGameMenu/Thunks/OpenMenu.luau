local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent
local SetMenuOpen = require(ParentParent.Actions.SetMenuOpen)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)
local t1 = { Constants.ReportDialogKey }

return function(p1, p2) -- line: 14
	-- upvalues: Constants (copy), t1 (copy), GuiService (copy), SetMenuOpen (copy), SetCurrentPage (copy), SendAnalytics (copy)
	return function(p3) -- line: 15
		-- upvalues: p2 (ref), Constants (copy), t1 (copy), GuiService (copy), SetMenuOpen (copy), SetCurrentPage (copy), SendAnalytics (copy), p1 (copy)
		if not p2 then
			p2 = Constants.defaultPageKey
		end

		if not table.find(t1, p2) then
			if p2 ~= Constants.InitalPageKey then
				GuiService:SetMenuIsOpen(true, "InGameMenu")
			end

			p3:dispatch(SetMenuOpen(true))
			p3:dispatch(SetCurrentPage(p2))
		end

		SendAnalytics(Constants.AnalyticsMenuOpenName, Constants.AnalyticsMenuActionName, {
			source = p1
		})
	end
end
