local parent = script:FindFirstAncestor("GenericChallenges").Parent

local CoreGui = game:GetService("CoreGui")

require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local function defaultShutdownGame()
	game:Shutdown()
end

local function defaultMount(p, container)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(p, container))

	return function()
		root:unmount()
	end
end

local v = {}

return function(data)
	local challengeId = data.challengeId

	if v[challengeId] then
		return
	end

	v[challengeId] = true

	local shutdownGame = data.shutdownGame or defaultShutdownGame
	local container = data.container or CoreGui
	local mount = data.mount or function(p)
		return defaultMount(p, container)
	end

	local function v2() end
	local function teardown()
		v[challengeId] = nil
		v2()

		if data.shutdownOnTeardown then
			shutdownGame()
		end
	end

	local success, result = pcall(mount, data.render(teardown))

	if not success then
		v[challengeId] = nil
		error(result)
	end

	v2 = result
end
