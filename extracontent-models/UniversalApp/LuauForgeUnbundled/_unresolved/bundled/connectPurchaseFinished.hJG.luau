local MarketplaceService = game:GetService("MarketplaceService")
local WebViewService = game:GetService("WebViewService")

local fFlagLuaAppEnableNativePurchaseFinishedV2Signals = require("@luauforge/bundled/hHD").FFlagLuaAppEnableNativePurchaseFinishedV2Signals

local function connectPurchaseFinished(onOnWindowClosed, p2)
	local v5 = p2
		or {
			marketplaceService = MarketplaceService,
			webViewService = WebViewService,
			hasLocalPlayerSignals = game:GetEngineFeature("NativePurchaseWithLocalPlayer")
		}

	local marketplaceService = v5.marketplaceService
	local connections = {}

	table.insert(connections, marketplaceService.NativePurchaseFinished:Connect(function(p3, p4, p5)
		if p5 then
			onOnWindowClosed()
		end
	end))

	if v5.hasLocalPlayerSignals then
		table.insert(
			connections,
			marketplaceService.NativePurchaseFinishedWithLocalPlayer:Connect(function(p3, p4)
				if p4 then
					onOnWindowClosed()
				end
			end)
		)
	end

	if fFlagLuaAppEnableNativePurchaseFinishedV2Signals then
		table.insert(connections, marketplaceService.NativePurchaseFinishedV2:Connect(function(p3, p4, p5)
			if p5 then
				onOnWindowClosed()
			end
		end))

		if v5.hasLocalPlayerSignals then
			table.insert(
				connections,
				marketplaceService.NativePurchaseFinishedWithLocalPlayerV2:Connect(function(p3, p4)
					if p4 then
						onOnWindowClosed()
					end
				end)
			)
		end
	end

	table.insert(connections, v5.webViewService.OnWindowClosed:Connect(onOnWindowClosed))

	return function()
		for k, connection in connections do
			connection:Disconnect()
		end
	end
end

return connectPurchaseFinished
