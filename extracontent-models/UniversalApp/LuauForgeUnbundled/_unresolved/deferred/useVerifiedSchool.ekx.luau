local module = require("@luauforge/deferred/eko")
local useSignalState = require("@luauforge/deferred/eky").useSignalState
local module2 = require("@luauforge/deferred/ekz")
local module3 = require("@luauforge/deferred/ekt")
local localUserIdStore = require("@luauforge/deferred/ekA").LocalUserIdStore

local module4 = require("@luauforge/deferred/ekB")
require("@luauforge/deferred/ekr")
local module5 = require("@luauforge/deferred/ekL")

local dataStatus = module3.DataStatus

local function useVerifiedSchool(p2)
	local v5 = useSignalState(localUserIdStore.getCurrentUserId)

	if v5 == "" or p2 == false then
		v5 = nil
	end

	local v6 = module4(false)

	local v7 = module.useMemo(function()
		if v5 == nil then
			return nil
		end

		return (v6.getVerifiedSchool(v5))
	end, { v5 })

	local v8 = module.useMemo(function()
		return module2.createComputed(function(p3)
			if v7 then
				return (v7.status(p3))
			end

			return dataStatus.NotReady
		end)
	end, { v7 })

	local v9 = module.useMemo(function()
		return module2.createComputed(function(p3)
			local v10 = if v7 then v7.data(p3) else nil

			if v10 then
				return v10.school
			end

			return nil
		end)
	end, { v7 })
	local v10

	if module5 then
		v10 = module.useMemo(function()
			return module2.createComputed(function(p3): boolean
				local v11 = if v7 then v7.data(p3) else nil

				if v11 then
					return v11.isLocked == true
				end

				return false
			end)
		end, { v7 })
	end

	local v11 = useSignalState(v8)
	local v12 = useSignalState(v9)

	local v13 = if module5 then useSignalState(v10) else false

	return { status = v11, school = v12, isLocked = v13 }
end

return useVerifiedSchool
