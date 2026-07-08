local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent
local SetMenuOpen = require(ParentParent.Actions.SetMenuOpen)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)

return function(p1) -- line: 9
	-- upvalues: GuiService (copy), SetMenuOpen (copy), SetCurrentPage (copy), Constants (copy), SendAnalytics (copy)
	GuiService:SetMenuIsOpen(false, "InGameMenu")
	GuiService.SelectedCoreObject = nil
	p1:dispatch(SetMenuOpen(false))
	p1:dispatch(SetCurrentPage(Constants.InitalPageKey))
	SendAnalytics(Constants.AnalyticsMenuCloseName, Constants.AnalyticsMenuActionName, {})
end
