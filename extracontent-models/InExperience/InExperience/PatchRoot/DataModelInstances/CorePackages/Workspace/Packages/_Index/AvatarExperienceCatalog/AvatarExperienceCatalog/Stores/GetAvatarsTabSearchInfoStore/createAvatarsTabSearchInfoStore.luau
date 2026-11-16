local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local function createAvatarsTabSearchInfoStore()
	local sessionScopedSignal, v = createSessionScopedSignal(nil)

	local sessionScopedSignal2, v2 = createSessionScopedSignal(nil)

	local function setAvatarsTabSearchInfo(p: string, p2: string)
		SignalsExperimental.batch(function()
			v(p)
			v2(p2)
		end)
	end

	local function reset()
		SignalsExperimental.batch(function()
			v(nil)
			v2(nil)
		end)
	end

	return {
		getSearchUuid = sessionScopedSignal,
		getKeyword = sessionScopedSignal2,
		setAvatarsTabSearchInfo = setAvatarsTabSearchInfo,
		reset = reset
	}
end

return createAvatarsTabSearchInfoStore
