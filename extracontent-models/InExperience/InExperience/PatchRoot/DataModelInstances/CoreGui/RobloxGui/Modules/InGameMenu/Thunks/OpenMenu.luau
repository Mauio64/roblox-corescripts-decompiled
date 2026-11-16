local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent
local SetMenuOpen = require(parent.Actions.SetMenuOpen)
local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)
local SetCurrentPage = require(parent.Actions.SetCurrentPage)

local v = { Constants.ReportDialogKey }

return function(source, p)
	return function(object)
		if not p then
			p = Constants.defaultPageKey
		end

		if not table.find(v, p) then
			if p ~= Constants.InitalPageKey then
				GuiService:SetMenuIsOpen(true, "InGameMenu")
			end

			object:dispatch(SetMenuOpen(true))
			object:dispatch(SetCurrentPage(p))
		end

		SendAnalytics(Constants.AnalyticsMenuOpenName, Constants.AnalyticsMenuActionName, {
			source = source
		})
	end
end
