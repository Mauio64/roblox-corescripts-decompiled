return function(p1, p2, p3) -- line: 2
	local storyRoot = p1.storyRoot
	local v5 = p1.middleware or function(...) -- line: 4
		return ...
	end
	local ScreenGui = Instance.new("ScreenGui")

	p2("SHOULD run all stories with no issue", function() -- line: 10
		-- upvalues: storyRoot (copy), p3 (copy), v5 (copy), ScreenGui (copy)
		for _, descendant in ipairs(storyRoot:GetDescendants()) do
			if descendant:IsA("ModuleScript") and descendant.Name:find(".story$") then
				p3("SHOULD mount: " .. descendant:GetFullName(), function() -- line: 14
					-- upvalues: descendant (copy), v5 (copy), ScreenGui (copy)
					local lib = require(descendant)

					v5(lib, ScreenGui)()
				end)
			end
		end
	end)
end
