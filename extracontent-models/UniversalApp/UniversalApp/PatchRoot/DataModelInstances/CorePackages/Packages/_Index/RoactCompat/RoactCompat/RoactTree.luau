local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local inspect = require(ParentParent.LuauPolyfill).util.inspect
local ReactRoblox = require(ParentParent.ReactRoblox)
local warnOnce = require(script.Parent.warnOnce)

return {
	mount = function(p1, p2, s1: string?) -- line: 31
		-- upvalues: ReactGlobals (copy), warnOnce (copy), inspect (copy), ReactRoblox (copy)
		if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
			warnOnce("mount", "Please use the createRoot API in ReactRoblox")
		end

		if p2 ~= nil and typeof(p2) ~= "Instance" then
			error(string.format("Cannot mount element (`%s`) into a parent that is not a Roblox Instance (got type `%s`) \n%s", not p1 and "<unknown>" or tostring(p1.type), typeof(p2), (function() -- line: 47
				-- upvalues: p2 (ref), inspect (copy)
				if p2 ~= nil then
					return inspect(p2)
				end

				return ""
			end)()))
		end

		local u11 = if not _G.__ROACT_17_COMPAT_LEGACY_ROOT__ then ReactRoblox.createRoot(Instance.new("Folder")) else ReactRoblox.createLegacyRoot(Instance.new("Folder"))

		if p2 == nil then
			local Folder = Instance.new("Folder")

			Folder.Name = "Target"
			p2 = Folder
		end

		if s1 == nil then
			s1 = not _G.__ROACT_17_COMPAT_LEGACY_ROOT__ and "ReactRoot" or "ReactLegacyRoot"
		end

		if ReactGlobals.__ROACT_17_INLINE_ACT__ then
			ReactRoblox.act(function() -- line: 82
				-- upvalues: u11 (ref), ReactRoblox (copy), s1 (ref), p1 (copy), p2 (ref)
				u11:render(ReactRoblox.createPortal({
					[s1] = p1
				}, p2))
			end)
		else
			u11:render(ReactRoblox.createPortal({
				[s1] = p1
			}, p2))
		end

		return {
			root = u11,
			parent = p2,
			key = s1
		}
	end,
	update = function(t1: {[any]: any}, p3) -- line: 98
		-- upvalues: ReactGlobals (copy), warnOnce (copy), ReactRoblox (copy)
		if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
			warnOnce("update", "Please use the createRoot API in ReactRoblox")
		end

		local key = t1.key
		local parent = t1.parent

		if ReactGlobals.__ROACT_17_INLINE_ACT__ then
			ReactRoblox.act(function() -- line: 108
				-- upvalues: t1 (copy), ReactRoblox (copy), key (copy), p3 (copy), parent (copy)
				t1.root:render(ReactRoblox.createPortal({
					[key] = p3
				}, parent))
			end)

			return t1
		end

		t1.root:render(ReactRoblox.createPortal({
			[key] = p3
		}, parent))

		return t1
	end,
	unmount = function(t2: {[any]: any}) -- line: 122
		-- upvalues: ReactGlobals (copy), warnOnce (copy), ReactRoblox (copy)
		if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
			warnOnce("unmount", "Please use the createRoot API in ReactRoblox")
		end

		if ReactGlobals.__ROACT_17_INLINE_ACT__ then
			ReactRoblox.act(function() -- line: 130
				-- upvalues: t2 (copy)
				t2.root:unmount()
			end)

			return
		end

		t2.root:unmount()
	end
}
