return function(p1, p2, p3) -- line: 1
	local storyRoots = p1.storyRoots
	local mapStory = p1.mapStory

	p2("SHOULD run all stories with no issue", function() -- line: 5
		-- upvalues: storyRoots (copy), p3 (copy), mapStory (copy)
		for _, v in ipairs(storyRoots) do
			for _, descendant in ipairs(v:GetDescendants()) do
				if descendant:IsA("ModuleScript") and descendant.Name:find(".story$") then
					p3("SHOULD mount: " .. descendant:GetFullName(), function(p4) -- line: 10
						-- upvalues: descendant (copy), mapStory (copy)
						local lib = require(descendant)
						local v12 = mapStory(function() -- line: 12
							-- upvalues: lib (copy)
							return lib
						end)()
						local _, v14 = p4.UnitTestHelpers.mountFrame(v12)

						v14()
					end)
				end
			end
		end
	end)
end
