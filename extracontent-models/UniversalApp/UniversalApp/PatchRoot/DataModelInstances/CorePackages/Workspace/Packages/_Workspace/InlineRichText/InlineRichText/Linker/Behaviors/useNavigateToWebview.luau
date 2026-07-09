local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local React = require(InlineRichTextParent.React)
local useDispatch = require(InlineRichTextParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateDown = require(InlineRichTextParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(InlineRichTextParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(InlineRichTextParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(InlineRichTextParent.RobloxAppEnums).AppPage

require(InlineRichText.Types)

local FFlagInlineRichTextUseWebViewService = require(InlineRichTextParent.SharedFlags).FFlagInlineRichTextUseWebViewService
local openWebView = require(InlineRichText.Utils.openWebView)

return function(_: nil) -- line: 20
	-- upvalues: FFlagInlineRichTextUseWebViewService (copy), React (copy), openWebView (copy), useDispatch (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
	if FFlagInlineRichTextUseWebViewService then
		return React.useCallback(function(s1: string) -- line: 22
			-- upvalues: openWebView (copy)
			openWebView(s1)
		end, {})
	end

	local v12 = useDispatch()

	return React.useCallback(function(s2: string) -- line: 27
		-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), v12 (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.GenericWebPage,
			detail = s2
		}

		if FFlagSignalsNavP3Dispatch then
			v7.down(v7.fromLegacyPage(t1))

			return
		end

		v12(NavigateDown(t1))
	end, { v12 })
end
