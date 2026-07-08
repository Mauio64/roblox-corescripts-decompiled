local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 17
	-- upvalues: t1 (copy)
	return (setmetatable({
		listeners = {}
	}, t1))
end
function t1.addListener(t2: {[any]: any}, s1: string, p1: ((...any) -> ...any)) -- line: 25
	if not t2.listeners[s1] then
		t2.listeners[s1] = {}
	end

	table.insert(t2.listeners[s1], p1)
end
function t1.removeAllListeners(p2) -- line: 32
	table.clear(p2.listeners)
end
function t1.emit(t3: {[any]: any}, s2: string, ...) -- line: 36
	local v10 = t3.listeners[s2]

	if not v10 then
		return
	end

	for _, v12 in (table.clone(v10)) do
		pcall(function(...) -- line: 44
			-- upvalues: v12 (copy)
			v12(...)

			return nil
		end, ...)
	end
end

return {
	jsonDecode = function(p3) -- line: 51
		-- upvalues: HttpService (copy)
		local ok, result = pcall(function() -- line: 52
			-- upvalues: HttpService (copy), p3 (copy)
			return HttpService:JSONDecode(p3)
		end)

		if ok and result then
			return result
		end

		return {}
	end,
	EventEmitter = t1,
	shorten = function(p4) -- line: 62
		return "..." .. string.sub(tostring(p4), -4)
	end,
	avoidEmitting = function(p5) -- line: 66
		local function prune(p6) -- line: 67
			if p6:HasTag("RbxDefaultVoiceEmitter") then
				task.defer(function() -- line: 70
					-- upvalues: p6 (copy)
					p6:Destroy()
				end)
			end
		end

		p5.DescendantAdded:Connect(prune)

		for _, descendant in p5:GetDescendants() do
			if descendant:HasTag("RbxDefaultVoiceEmitter") then
				task.defer(function() -- line: 70
					-- upvalues: descendant (copy)
					descendant:Destroy()
				end)
			end
		end
	end,
	destroyDefaultEmitter = function(p7) -- line: 81
		-- upvalues: Players (copy)
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			return
		end

		local Character = LocalPlayer.Character

		if not Character then
			return
		end

		if p7:IsDescendantOf(Character) then
			task.defer(function() -- line: 92
				-- upvalues: p7 (copy)
				p7:Destroy()
			end)
		end
	end,
	bind = function(p8, p9) -- line: 98
		return function(...) -- line: 99
			-- upvalues: p8 (copy), p9 (copy)
			return p8[p9](p8, ...)
		end
	end
}
