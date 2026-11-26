local MarketplaceService = game:GetService("MarketplaceService")

local fFlagLuaAppEnableNativePurchaseFinishedV2Signals = require("@luauforge/bundled/hHD").FFlagLuaAppEnableNativePurchaseFinishedV2Signals
local module = require("@luauforge/bundled/hJR")

local function connectNativePurchaseEnded(callback, p2)
	local v5 = p2
		or {
			marketplaceService = MarketplaceService,
			hasLocalPlayerSignals = game:GetEngineFeature("NativePurchaseWithLocalPlayer")
		}

	local marketplaceService = v5.marketplaceService
	local connections = {}
	local thread = nil
	local flag = true

	local function disconnect()
		if not flag then
			return
		end

		flag = false

		for k, connection in connections do
			connection:Disconnect()
		end

		if thread ~= nil then
			task.cancel(thread)
		end
	end

	local function finish(p3)
		if flag then
			if flag then
				flag = false

				for k, connection in connections do
					connection:Disconnect()
				end

				if thread ~= nil then
					task.cancel(thread)
				end
			end

			callback(p3)
		end
	end

	local function onStoreReported()
		if flag then
			if flag then
				flag = false

				for k, connection in connections do
					connection:Disconnect()
				end

				if thread ~= nil then
					task.cancel(thread)
				end
			end

			callback("storeReported")
		end
	end

	table.insert(connections, marketplaceService.NativePurchaseFinished:Connect(onStoreReported))

	if v5.hasLocalPlayerSignals then
		table.insert(
			connections,
			marketplaceService.NativePurchaseFinishedWithLocalPlayer:Connect(onStoreReported)
		)
	end

	if fFlagLuaAppEnableNativePurchaseFinishedV2Signals then
		table.insert(connections, marketplaceService.NativePurchaseFinishedV2:Connect(onStoreReported))

		if v5.hasLocalPlayerSignals then
			table.insert(
				connections,
				marketplaceService.NativePurchaseFinishedWithLocalPlayerV2:Connect(onStoreReported)
			)
		end
	end

	thread = task.delay(module / 1000, function()
		thread = nil

		if flag then
			if flag then
				flag = false

				for k, connection in connections do
					connection:Disconnect()
				end

				if thread ~= nil then
					task.cancel(thread)
				end
			end

			callback("timeout")
		end
	end)

	return disconnect
end

return connectNativePurchaseEnded
