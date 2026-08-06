local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local ContentProvider = game:GetService("ContentProvider")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local useOpenWebView = require(BuildExperienceParent.WebViewUtils).useOpenWebView
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local function getPurchaseRobuxUrl() -- line: 16
	-- upvalues: ContentProvider (copy)
	local v10 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")

	return string.gsub(v10, "http:", "https:") .. "upgrades/robux?ctx=navpopover"
end
local function useOpenBuyRobuxWebView(p1: ((...any) -> ...any)?, t1: {[any]: any}?) -- line: 22
	-- upvalues: useOpenWebView (copy), React (copy), AppLifecycleObserverService (copy), ContentProvider (copy), LocalizationStrings (copy)
	local v13 = useOpenWebView()
	local v14 = React.useRef(false)
	local v15 = React.useCallback(function() -- line: 28
		-- upvalues: v14 (copy), p1 (copy)
		if not v14.current then
			return
		end

		v14.current = false

		if p1 then
			p1()
		end
	end, { p1 })

	React.useEffect(function() -- line: 38
		-- upvalues: p1 (copy), t1 (copy), AppLifecycleObserverService (copy), v15 (copy), v14 (copy)
		if p1 == nil then
			return function() -- line: 40
			end
		end

		local connection = (t1 or AppLifecycleObserverService).OnUnhide:Connect(v15)

		return function() -- line: 44
			-- upvalues: v14 (copy), connection (copy)
			v14.current = false
			connection:Disconnect()
		end
	end, {
		t1,
		v15,
		p1
	})

	return React.useCallback(function() -- line: 50
		-- upvalues: v14 (copy), p1 (copy), v13 (copy), ContentProvider (copy), LocalizationStrings (copy), v15 (copy)
		v14.current = p1 ~= nil

		local v17 = v13
		local v18 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")

		v17(string.gsub(v18, "http:", "https:") .. "upgrades/robux?ctx=navpopover", LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_SHEET_TITLE, if p1 == nil then nil else v15)
	end, {
		v15,
		p1,
		v13
	})
end

return useOpenBuyRobuxWebView
