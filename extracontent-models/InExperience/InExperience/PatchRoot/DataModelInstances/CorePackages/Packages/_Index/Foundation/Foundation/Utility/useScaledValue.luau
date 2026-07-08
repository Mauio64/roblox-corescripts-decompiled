local Foundation = script:FindFirstAncestor("Foundation")
local Logger = require(Foundation.Utility.Logger)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function useScaledValue(n1: number) -- line: 6
	-- upvalues: useTokens (copy), Logger (copy)
	local v6 = useTokens()
	local v7 = n1 * v6.Config.UI.Scale

	if v7 <= v6.Size.Size_3000 then
		Logger:warning("useScaledValue should be used for values larger than Size tokens. For smaller values, please align to a Size or derivative token.")
	end

	return v7
end

return useScaledValue
