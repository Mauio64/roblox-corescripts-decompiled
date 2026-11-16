local Foundation = script:FindFirstAncestor("Foundation")

local Logger = require(Foundation.Utility.Logger)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function useScaledValue(p: number)
	local v = useTokens()

	local v2 = p * v.Config.UI.Scale

	if v2 <= v.Size.Size_3000 then
		Logger:warning("useScaledValue should be used for values larger than Size tokens. For smaller values, please align to a Size or derivative token.")
	end

	return v2
end

return useScaledValue
