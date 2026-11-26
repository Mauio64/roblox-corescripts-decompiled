local CoreGui = game:GetService("CoreGui")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/ReactRoblox")

local function defaultShutdownGame()
	game:Shutdown()
end

local function defaultMount(p2, container)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(p2, container))

	return function()
		root:unmount()
	end
end

local v5 = {}

return function(data)
	local challengeId = data.challengeId

	if v5[challengeId] then
		return
	end

	v5[challengeId] = true

	local shutdownGame = data.shutdownGame or defaultShutdownGame
	local container = data.container or CoreGui
	local mount = data.mount or function(p2)
		return defaultMount(p2, container)
	end

	local function v6() end
	local function teardown()
		v5[challengeId] = nil
		v6()

		if data.shutdownOnTeardown then
			shutdownGame()
		end
	end

	local success, result = pcall(mount, data.render(teardown))

	if not success then
		v5[challengeId] = nil
		error(result)
	end

	v6 = result
end
