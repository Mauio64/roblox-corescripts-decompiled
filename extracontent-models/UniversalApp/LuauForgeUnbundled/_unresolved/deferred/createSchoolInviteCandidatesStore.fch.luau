local module = require("@luauforge/deferred/fbA")
local module2 = require("@luauforge/deferred/ekt")
local module3 = require("@luauforge/deferred/ekF")
require("@luauforge/deferred/ekz")
local createSessionScopedSignal = require("@luauforge/deferred/fci").createSessionScopedSignal
local createDataCache = module2.createDataCache
local createDataResolver = module2.createDataResolver

local module4 = require("@luauforge/deferred/fcj")
local module5 = require("@luauforge/deferred/fck")
require("@luauforge/deferred/ekr")
local module6 = require("@luauforge/deferred/ekq")

local function createSchoolInviteCandidatesStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal({})

	local function setSend(p2, p3)
		v5(function(p4)
			local join = module.Dictionary.join
			local v8 = if p3 then p3 else module.None
			return join(p4, { [p2] = v8 })
		end)
	end

	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			return module4()
		end,
		queueProcessDelaySec = 0
	})

	return {
		getInviteCandidates = function(p2)
			return dataResolver.getAndFetchItem(p2)
		end,
		getSends = sessionScopedSignal,
		sendInvite = function(p2)
			if sessionScopedSignal(false)[p2] ~= nil then
				return module3.resolve()
			end

			local v6 = { status = module6.InviteSendStatus.Sending }
			v5(function(p3)
				local join = module.Dictionary.join
				local v9 = if v6 then v6 else module.None
				return join(p3, { [p2] = v9 })
			end)

			return module5(p2):andThen(function()
				local v7 = p2
				local v8 = { status = module6.InviteSendStatus.Sent }
				v5(function(p3)
					local join = module.Dictionary.join
					local v11 = if v8 then v8 else module.None
					return join(p3, { [v7] = v11 })
				end)
			end):catch(function(p3)
				local v7 = p2
				local v8 = nil
				v5(function(p4)
					local join = module.Dictionary.join
					local v11 = if v8 then v8 else module.None
					return join(p4, { [v7] = v11 })
				end)

				return module3.reject(p3)
			end)
		end,
		clear = function()
			v5({})
			dataResolver.clear()
		end,
		dispose = function()
			v5({})
			dataResolver.dispose()
		end
	}
end

return createSchoolInviteCandidatesStore
