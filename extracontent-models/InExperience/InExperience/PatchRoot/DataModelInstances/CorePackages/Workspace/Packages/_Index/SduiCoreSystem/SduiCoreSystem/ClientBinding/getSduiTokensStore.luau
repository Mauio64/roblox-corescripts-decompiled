local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Signals = require(SduiCoreSystemParent.Signals)

require(SduiCoreSystemParent.Foundation)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)

local function createSduiTokensStore() -- line: 22
	-- upvalues: Signals (copy), SduiLogger (copy), SduiErrors (copy)
	local v9, v10 = Signals.createSignal(nil)

	return {
		getTokens = function(p1, s1: string) -- line: 25
			-- upvalues: v9 (copy), SduiLogger (copy), SduiErrors (copy)
			local v15 = v9(p1)

			if v15 == nil then
				SduiLogger.reportError(SduiErrors.SduiErrorType.GetNilTokens, {
					message = "Getting tokens before they were set"
				}, s1)
			end

			return v15
		end,
		setTokens = v10
	}
end

local t1 = nil

local function getSduiTokensStore() -- line: 43
	-- upvalues: t1 (ref), Signals (copy), SduiLogger (copy), SduiErrors (copy)
	if t1 == nil then
		local v11, v12 = Signals.createSignal(nil)

		t1 = {
			getTokens = function(p2, s2: string) -- line: 25
				-- upvalues: v11 (copy), SduiLogger (copy), SduiErrors (copy)
				local v18 = v11(p2)

				if v18 == nil then
					SduiLogger.reportError(SduiErrors.SduiErrorType.GetNilTokens, {
						message = "Getting tokens before they were set"
					}, s2)
				end

				return v18
			end,
			setTokens = v12
		}
	end

	return t1
end

return getSduiTokensStore
