local module = require("@luauforge/deferred/enC")
local module2 = require("@luauforge/deferred/enD")

local module3 = require("@luauforge/deferred/enE")

local useSignalState = module2.useSignalState
local computed = module.createComputed(function(): nil
	return nil
end)

local function useExperienceName(p2)
	local v5 = if not (p2 == nil or p2 == 0) then tostring(p2) else nil
	local v6 = if v5 == nil then computed else module3(false).getAndFetchGameInfo(v5).data

	local v7 = useSignalState(v6)

	if v7 == nil then
		return nil
	end

	return v7.name
end

return useExperienceName
