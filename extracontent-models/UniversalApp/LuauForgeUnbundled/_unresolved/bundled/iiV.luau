local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/iiW")

local getFFlagEnableUnifiedWebViews = require("@luauforge/bundled/iiX").GetFFlagEnableUnifiedWebViews

local module2 = require("@luauforge/bundled/iiY")

local function AdConsentHybridEventReceiver(p2): nil
	module.useEffect(function()
		local v5

		if getFFlagEnableUnifiedWebViews() then
			v5 = (p2.webViewService or game:GetService("WebViewService")).OnJavaScriptCall
		else
			v5 = (p2.browserService or game:GetService("BrowserService")).JavaScriptCallback
		end

		local connection = v5:Connect(function(json)
			local jsonDecode = HttpService:JSONDecode(json)

			if jsonDecode.moduleID == "AdConsent" and jsonDecode.functionName == "adConsentChanged" then
				local params = if typeof(jsonDecode.params) == "table" then jsonDecode.params else nil
				local v6 = if params and typeof(params.params) == "table" then params.params else nil

				module2(v6 or params)
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { p2.browserService, p2.webViewService })

	return nil
end

return module.memo(AdConsentHybridEventReceiver)
