local CoreGui = game:GetService("CoreGui")

local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local AccountUpgradeFlow = require(AccountUpgrade.AccountUpgradeFlow)

local v = {}
v[AccountUpgradeFlow.Pioneer] = {
	canDismiss = true,
	getView = function()
		local AccountUpgradePromptApp = require(script.Parent.AccountUpgradePromptApp)
		return AccountUpgradePromptApp
	end
}

local v2 = nil
local v3 = nil

local InExperienceController = {}

local function isCurrentHost(p, p2): boolean -- 2 equivalent calls inferred from this helper
	return v3 == p and v2 == p2
end

local function cleanupHost(object, instance)
	if not isCurrentHost(object, instance) then -- inferred equivalent call
		return
	end

	v3 = nil
	v2 = nil

	if object then
		pcall(function()
			object:unmount()
		end)
	end

	if instance then
		instance:Destroy()
	end
end

function InExperienceController.unmount()
	cleanupHost(v3, v2)
end

local function completeAfterCurrentEvent(root, inExperienceAccountUpgradePrompt, onComplete, p) -- 1 equivalent call inferred from this helper
	task.defer(function()
		if not isCurrentHost(root, inExperienceAccountUpgradePrompt) then -- inferred equivalent call
			return
		end

		cleanupHost(root, inExperienceAccountUpgradePrompt)

		if onComplete then
			onComplete(p)
		end
	end)
end

local function isMounted(): boolean -- 2 equivalent calls inferred from this helper
	return v3 ~= nil and v2 ~= nil and v2.Parent == CoreGui
end

local function unmountStaleHost() -- 1 equivalent call inferred from this helper
	if v3 ~= nil and not isMounted() then -- inferred equivalent call
		InExperienceController.unmount()
	end
end

function InExperienceController.mount(p): string
	unmountStaleHost() -- inferred equivalent call

	if isMounted() then -- inferred equivalent call
		return "already_mounted"
	end

	local v4 = v[p.flow]

	if v4 == nil then
		return "unsupported_flow"
	end

	local inExperienceAccountUpgradePrompt = Instance.new("ScreenGui")
	v2 = inExperienceAccountUpgradePrompt
	local v5 = nil

	local success, result = pcall(function()
		inExperienceAccountUpgradePrompt.Name = "InExperienceAccountUpgradePrompt"
		inExperienceAccountUpgradePrompt.AutoLocalize = false
		inExperienceAccountUpgradePrompt.DisplayOrder = 6
		inExperienceAccountUpgradePrompt.IgnoreGuiInset = true
		inExperienceAccountUpgradePrompt.ResetOnSpawn = false
		inExperienceAccountUpgradePrompt.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		inExperienceAccountUpgradePrompt.Parent = CoreGui

		local root = ReactRoblox.createRoot(inExperienceAccountUpgradePrompt)
		v5 = root
		v3 = root
		local flag = false
		local function fn(p2) -- 2 equivalent calls inferred from this helper
			if flag then
				return
			end

			flag = true
			completeAfterCurrentEvent(root, inExperienceAccountUpgradePrompt, p.onComplete, p2) -- inferred equivalent call
		end
		local function onComplete(p2)
			fn({ reason = "success", result = p2 }) -- inferred equivalent call
		end

		local v6

		if v4.canDismiss then
			local view = v4.getView()
			v6 = React.createElement(view, {
				flow = p.flow,
				onDismiss = function()
					fn({ reason = "user_closed" }) -- inferred equivalent call
				end,
				onComplete = onComplete
			})
		else
			local view = v4.getView()
			v6 = React.createElement(view, { flow = p.flow, onComplete = onComplete })
		end

		root:render(v6)
	end)

	if not success then
		cleanupHost(v5, inExperienceAccountUpgradePrompt)
		error(result, 0)
	end

	return "mounted"
end

return InExperienceController
