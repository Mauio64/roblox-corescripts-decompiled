local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/React")

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/RoactUtils").Hooks.RoactRodux.useDispatch
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/RobloxAppNavigation").NavigationCommands else nil

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")

local fFlagInlineRichTextUseWebViewService = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/SharedFlags").FFlagInlineRichTextUseWebViewService
local openWebView = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Utils/openWebView")

return function(p2)
	if fFlagInlineRichTextUseWebViewService then
		return React.useCallback(function(p3)
			openWebView(p3)
		end, {})
	end

	local v5 = useDispatch()
	return React.useCallback(function(p3)
		local v6 = { name = appPage.GenericWebPage, detail = p3 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			v5(navigateDown(v6))
		end
	end, { v5 })
end
