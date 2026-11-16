local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/ReactRoblox")

local v5 = {}
v5[require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeFlow").Pioneer] = {
	canDismiss = true,
	getView = function()
		return require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/InExperience/AccountUpgradePromptApp")
	end
}

local v6 = nil
local v7 = nil

local v8 = {}

local function isCurrentHost(p2, p3): boolean
	return v7 == p2 and v6 == p3
end

local function cleanupHost(object, instance)
	local v9 = v7 == object and v6 == instance

	if not v9 then
		return
	end

	v7 = nil
	v6 = nil

	if object then
		pcall(function()
			object:unmount()
		end)
	end

	if instance then
		instance:Destroy()
	end
end

function v8.unmount()
	cleanupHost(v7, v6)
end

local function completeAfterCurrentEvent(p2, p3, callback, p4)
	task.defer(function()
		local v9 = p3
		local v10 = v7 == p2 and v6 == v9

		if not v10 then
			return
		end

		cleanupHost(p2, p3)

		if callback then
			callback(p4)
		end
	end)
end

local function isMounted(): boolean
	return v7 ~= nil and v6 ~= nil and v6.Parent == CoreGui
end

local function unmountStaleHost()
	if v7 ~= nil then
		local v9 = not (v7 == nil or v6 == nil) and v6.Parent == CoreGui

		if not v9 then
			v8.unmount()
		end
	end
end

function v8.mount(p2): string
	if v7 ~= nil then
		local v9 = not (v7 == nil or v6 == nil) and v6.Parent == CoreGui

		if not v9 then
			v8.unmount()
		end
	end

	local v9 = not (v7 == nil or v6 == nil) and v6.Parent == CoreGui

	if v9 then
		return "already_mounted"
	end

	local v10 = v5[p2.flow]

	if v10 == nil then
		return "unsupported_flow"
	end

	local inExperienceAccountUpgradePrompt = Instance.new("ScreenGui")
	v6 = inExperienceAccountUpgradePrompt
	local v11 = nil

	local success, result = pcall(function()
		inExperienceAccountUpgradePrompt.Name = "InExperienceAccountUpgradePrompt"
		inExperienceAccountUpgradePrompt.AutoLocalize = false
		inExperienceAccountUpgradePrompt.DisplayOrder = 6
		inExperienceAccountUpgradePrompt.IgnoreGuiInset = true
		inExperienceAccountUpgradePrompt.ResetOnSpawn = false
		inExperienceAccountUpgradePrompt.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		inExperienceAccountUpgradePrompt.Parent = CoreGui

		local root = ReactRoblox.createRoot(inExperienceAccountUpgradePrompt)
		v11 = root
		v7 = root
		local flag = false

		local function onComplete(p3)
			local v12 = { reason = "success", result = p3 }

			if flag then
				return
			end

			flag = true
			local v13 = root
			local v14 = inExperienceAccountUpgradePrompt
			local onComplete2 = p2.onComplete
			task.defer(function()
				local v15 = v14
				local v16 = v7 == v13 and v6 == v15

				if not v16 then
					return
				end

				cleanupHost(v13, v14)

				if onComplete2 then
					onComplete2(v12)
				end
			end)
		end

		local v12

		if v10.canDismiss then
			local view = v10.getView()
			v12 = React.createElement(view, {
				flow = p2.flow,
				onDismiss = function()
					local v13 = { reason = "user_closed" }

					if flag then
						return
					end

					flag = true
					local v14 = root
					local v15 = inExperienceAccountUpgradePrompt
					local onComplete2 = p2.onComplete
					task.defer(function()
						local v16 = v15
						local v17 = v7 == v14 and v6 == v16

						if not v17 then
							return
						end

						cleanupHost(v14, v15)

						if onComplete2 then
							onComplete2(v13)
						end
					end)
				end,
				onComplete = onComplete
			})
		else
			local view = v10.getView()
			v12 = React.createElement(view, { flow = p2.flow, onComplete = onComplete })
		end

		root:render(v12)
	end)

	if not success then
		cleanupHost(v11, inExperienceAccountUpgradePrompt)
		error(result, 0)
	end

	return "mounted"
end

return v8
