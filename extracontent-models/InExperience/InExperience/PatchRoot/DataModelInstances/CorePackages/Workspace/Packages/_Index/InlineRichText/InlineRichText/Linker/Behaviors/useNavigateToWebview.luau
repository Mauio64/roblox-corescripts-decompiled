local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent

local React = require(parent.React)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
require(InlineRichText.Types)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagInlineRichTextUseWebViewService = SharedFlags2.FFlagInlineRichTextUseWebViewService
local openWebView = require(InlineRichText.Utils.openWebView)

return function(_: nil)
	if FFlagInlineRichTextUseWebViewService then
		return React.useCallback(function(p: string)
			openWebView(p)
		end, {})
	end

	local v = useDispatch()
	return React.useCallback(function(detail: string)
		local v2 = { name = AppPage.GenericWebPage, detail = detail }

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v2))
		else
			v(NavigateDown(v2))
		end
	end, { v })
end
