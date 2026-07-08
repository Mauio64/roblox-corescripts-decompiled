local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent
local SetMenuOpen = require(ParentParent.Actions.SetMenuOpen)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)
local SetMenuIconTooltipOpen = require(ParentParent.Actions.SetMenuIconTooltipOpen)

return function(p1) -- line: 10
	-- upvalues: GuiService (copy), SetMenuOpen (copy), SetCurrentPage (copy), Constants (copy), SetMenuIconTooltipOpen (copy), SendAnalytics (copy)
	return function(p2) -- line: 11
		-- upvalues: GuiService (copy), SetMenuOpen (copy), SetCurrentPage (copy), Constants (copy), SetMenuIconTooltipOpen (copy), SendAnalytics (copy), p1 (copy)
		GuiService:SetMenuIsOpen(true, "InGameMenu")
		p2:dispatch(SetMenuOpen(true))
		p2:dispatch(SetCurrentPage(Constants.MainPagePageKey))

		if p2:getState().nativeClosePrompt.menuIconTooltipOpen then
			p2:dispatch(SetMenuIconTooltipOpen(false))
		end

		SendAnalytics(Constants.AnalyticsMenuOpenName, Constants.AnalyticsMenuActionName, {
			source = p1
		})
	end
end
