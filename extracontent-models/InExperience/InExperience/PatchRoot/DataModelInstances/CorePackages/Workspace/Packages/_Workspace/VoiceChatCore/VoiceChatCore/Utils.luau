local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 18
	-- upvalues: t1 (copy)
	return (setmetatable({
		listeners = {}
	}, t1))
end
function t1.addListener(t2: {[any]: any}, s1: string, p1: ((...any) -> ...any)) -- line: 26
	if not t2.listeners[s1] then
		t2.listeners[s1] = {}
	end

	table.insert(t2.listeners[s1], p1)
end
function t1.removeListener(t3: {[any]: any}, s2: string, p2: ((...any) -> ...any)) -- line: 33
	local v10 = t3.listeners[s2]

	if not v10 then
		return
	end

	local v11 = table.find(v10, p2)

	if v11 then
		table.remove(v10, v11)

		if #v10 == 0 then
			t3.listeners[s2] = nil
		end
	end
end
function t1.removeAllListeners(p3) -- line: 48
	table.clear(p3.listeners)
end
function t1.emit(t4: {[any]: any}, s3: string, ...) -- line: 52
	local v15 = t4.listeners[s3]

	if not v15 then
		return
	end

	for _, v17 in (table.clone(v15)) do
		pcall(function(...) -- line: 60
			-- upvalues: v17 (copy)
			v17(...)

			return nil
		end, ...)
	end
end

return {
	jsonDecode = function(p4) -- line: 67
		-- upvalues: HttpService (copy)
		local ok, result = pcall(function() -- line: 68
			-- upvalues: HttpService (copy), p4 (copy)
			return HttpService:JSONDecode(p4)
		end)

		if ok and result then
			return result
		end

		return {}
	end,
	EventEmitter = t1,
	shorten = function(p5) -- line: 78
		return "..." .. string.sub(tostring(p5), -4)
	end,
	avoidEmitting = function(p6) -- line: 82
		local function prune(p7) -- line: 83
			if p7:HasTag("RbxDefaultVoiceEmitter") then
				task.defer(function() -- line: 86
					-- upvalues: p7 (copy)
					p7:Destroy()
				end)
			end
		end

		p6.DescendantAdded:Connect(prune)

		for _, descendant in p6:GetDescendants() do
			if descendant:HasTag("RbxDefaultVoiceEmitter") then
				task.defer(function() -- line: 86
					-- upvalues: descendant (copy)
					descendant:Destroy()
				end)
			end
		end
	end,
	destroyDefaultEmitter = function(p8) -- line: 97
		-- upvalues: Players (copy)
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			return
		end

		local Character = LocalPlayer.Character

		if not Character then
			return
		end

		if p8:IsDescendantOf(Character) then
			task.defer(function() -- line: 108
				-- upvalues: p8 (copy)
				p8:Destroy()
			end)
		end
	end,
	bind = function(p9, p10) -- line: 114
		return function(...) -- line: 115
			-- upvalues: p9 (copy), p10 (copy)
			return p9[p10](p9, ...)
		end
	end
}
