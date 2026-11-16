local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent
local SetMenuOpen = require(parent.Actions.SetMenuOpen)
local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)
local SetCurrentPage = require(parent.Actions.SetCurrentPage)
local SetMenuIconTooltipOpen = require(parent.Actions.SetMenuIconTooltipOpen)

return function(source)
	return function(object)
		GuiService:SetMenuIsOpen(true, "InGameMenu")
		object:dispatch(SetMenuOpen(true))
		object:dispatch(SetCurrentPage(Constants.MainPagePageKey))

		if object:getState().nativeClosePrompt.menuIconTooltipOpen then
			object:dispatch(SetMenuIconTooltipOpen(false))
		end

		SendAnalytics(Constants.AnalyticsMenuOpenName, Constants.AnalyticsMenuActionName, {
			source = source
		})
	end
end
