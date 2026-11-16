local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Foundation")

local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")

local function createSduiTokensStore()
	local signal, v5 = Signals.createSignal(nil)

	return {
		getTokens = function(p2, p3)
			local tokens = signal(p2)

			if tokens == nil then
				SduiLogger.reportError(
					SduiErrors.SduiErrorType.GetNilTokens,
					{ message = "Getting tokens before they were set" },
					p3
				)
			end

			return tokens
		end,
		setTokens = v5
	}
end

local sduiTokensStore = nil

local function getSduiTokensStore()
	if sduiTokensStore == nil then
		local signal, v5 = Signals.createSignal(nil)

		sduiTokensStore = {
			getTokens = function(p2, p3)
				local tokens = signal(p2)

				if tokens == nil then
					SduiLogger.reportError(
						SduiErrors.SduiErrorType.GetNilTokens,
						{ message = "Getting tokens before they were set" },
						p3
					)
				end

				return tokens
			end,
			setTokens = v5
		}
	end

	return sduiTokensStore
end

return getSduiTokensStore
