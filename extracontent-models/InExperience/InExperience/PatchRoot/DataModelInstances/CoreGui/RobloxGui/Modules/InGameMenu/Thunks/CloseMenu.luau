local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent
local SetMenuOpen = require(parent.Actions.SetMenuOpen)
local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)
local SetCurrentPage = require(parent.Actions.SetCurrentPage)

return function(object)
	GuiService:SetMenuIsOpen(false, "InGameMenu")
	GuiService.SelectedCoreObject = nil
	object:dispatch(SetMenuOpen(false))
	object:dispatch(SetCurrentPage(Constants.InitalPageKey))
	SendAnalytics(Constants.AnalyticsMenuCloseName, Constants.AnalyticsMenuActionName, {})
end
