local MarketplaceService = game:GetService("MarketplaceService")

local fFlagLuaAppEnableNativePurchaseFinishedV2Signals = require("@luauforge/bundled/hHD").FFlagLuaAppEnableNativePurchaseFinishedV2Signals
require("@luauforge/bundled/hJQ")

local function connectNativePurchaseNotCompleted(callback, p2)
	local v5 = p2
		or {
			marketplaceService = MarketplaceService,
			hasLocalPlayerSignals = game:GetEngineFeature("NativePurchaseWithLocalPlayer")
		}

	local marketplaceService = v5.marketplaceService
	local connections = {}
	local flag = true

	local function disconnect()
		if not flag then
			return
		end

		flag = false

		for k, connection in connections do
			connection:Disconnect()
		end
	end

	local function onFinished(p3)
		if flag and p3 == false then
			if flag then
				flag = false

				for k, connection in connections do
					connection:Disconnect()
				end
			end

			callback()
		end
	end

	table.insert(connections, marketplaceService.NativePurchaseFinished:Connect(function(p3, p4, p5)
		if flag and p5 == false then
			if flag then
				flag = false

				for k, connection in connections do
					connection:Disconnect()
				end
			end

			callback()
		end
	end))

	if v5.hasLocalPlayerSignals then
		table.insert(
			connections,
			marketplaceService.NativePurchaseFinishedWithLocalPlayer:Connect(function(p3, p4)
				if flag and p4 == false then
					if flag then
						flag = false

						for k, connection in connections do
							connection:Disconnect()
						end
					end

					callback()
				end
			end)
		)
	end

	if fFlagLuaAppEnableNativePurchaseFinishedV2Signals then
		table.insert(connections, marketplaceService.NativePurchaseFinishedV2:Connect(function(p3, p4, p5)
			if flag and p5 == false then
				if flag then
					flag = false

					for k, connection in connections do
						connection:Disconnect()
					end
				end

				callback()
			end
		end))

		if v5.hasLocalPlayerSignals then
			table.insert(
				connections,
				marketplaceService.NativePurchaseFinishedWithLocalPlayerV2:Connect(function(p3, p4)
					if flag and p4 == false then
						if flag then
							flag = false

							for k, connection in connections do
								connection:Disconnect()
							end
						end

						callback()
					end
				end)
			)
		end
	end

	return disconnect
end

return connectNativePurchaseNotCompleted
