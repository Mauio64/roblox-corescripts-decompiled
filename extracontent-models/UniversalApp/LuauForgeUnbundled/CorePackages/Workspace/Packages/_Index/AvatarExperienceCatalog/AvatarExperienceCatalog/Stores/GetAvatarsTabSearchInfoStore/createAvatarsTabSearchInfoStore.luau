require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsExperimental")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsUtils").createSessionScopedSignal

local function createAvatarsTabSearchInfoStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(nil)

	local sessionScopedSignal2, v6 = createSessionScopedSignal(nil)

	local function setAvatarsTabSearchInfo(p2, p3)
		SignalsExperimental.batch(function()
			v5(p2)
			v6(p3)
		end)
	end

	local function reset()
		SignalsExperimental.batch(function()
			v5(nil)
			v6(nil)
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
