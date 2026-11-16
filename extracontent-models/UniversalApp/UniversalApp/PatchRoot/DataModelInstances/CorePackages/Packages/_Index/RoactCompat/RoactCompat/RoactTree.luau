local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local inspect = LuauPolyfill.util.inspect
local ReactRoblox = require(parent.ReactRoblox)

local warnOnce = require(script.Parent.warnOnce)
local RoactTree = {}

function RoactTree.mount(p, instance, p2: string?)
	if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
		warnOnce("mount", "Please use the createRoot API in ReactRoblox")
	end

	if instance ~= nil and typeof(instance) ~= "Instance" then
		error(string.format(
			"Cannot mount element (`%s`) into a parent that is not a Roblox Instance (got type `%s`) \n%s",
			not p and "<unknown>" or tostring(p.type),
			typeof(instance),
			(function()
				if instance == nil then
					return ""
				end

				return inspect(instance)
			end)()
		))
	end

	local root

	if _G.__ROACT_17_COMPAT_LEGACY_ROOT__ then
		root = ReactRoblox.createLegacyRoot(Instance.new("Folder"))
	else
		root = ReactRoblox.createRoot(Instance.new("Folder"))
	end

	if instance == nil then
		local target = Instance.new("Folder")
		target.Name = "Target"
		instance = target
	end

	local v = p2 == nil and (_G.__ROACT_17_COMPAT_LEGACY_ROOT__ and "ReactLegacyRoot" or "ReactRoot") or p2

	if ReactGlobals.__ROACT_17_INLINE_ACT__ then
		ReactRoblox.act(function()
			root:render(ReactRoblox.createPortal({ [v] = p }, instance))
		end)
	else
		root:render(ReactRoblox.createPortal({ [v] = p }, instance))
	end

	return { root = root, parent = instance, key = v }
end

function RoactTree.update(data, p)
	if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
		warnOnce("update", "Please use the createRoot API in ReactRoblox")
	end

	local key = data.key
	local parent2 = data.parent

	if ReactGlobals.__ROACT_17_INLINE_ACT__ then
		ReactRoblox.act(function()
			data.root:render(ReactRoblox.createPortal({ [key] = p }, parent2))
		end)
		return data
	end

	data.root:render(ReactRoblox.createPortal({ [key] = p }, parent2))

	return data
end

function RoactTree:unmount()
	if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
		warnOnce("unmount", "Please use the createRoot API in ReactRoblox")
	end

	if ReactGlobals.__ROACT_17_INLINE_ACT__ then
		ReactRoblox.act(function()
			self.root:unmount()
		end)
	else
		self.root:unmount()
	end
end

return RoactTree
