local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local Signals = require(parent.Signals)
require(parent.Foundation)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)

local function createSduiTokensStore() -- 1 equivalent call inferred from this helper
	local signal, setTokens = Signals.createSignal(nil)

	return {
		getTokens = function(p, p2: string)
			local tokens = signal(p)

			if tokens == nil then
				SduiLogger.reportError(
					SduiErrors.SduiErrorType.GetNilTokens,
					{ message = "Getting tokens before they were set" },
					p2
				)
			end

			return tokens
		end,
		setTokens = setTokens
	}
end

local sduiTokensStore = nil

local function getSduiTokensStore()
	if sduiTokensStore == nil then
		sduiTokensStore = createSduiTokensStore() -- inferred equivalent call
	end

	return sduiTokensStore
end

return getSduiTokensStore
