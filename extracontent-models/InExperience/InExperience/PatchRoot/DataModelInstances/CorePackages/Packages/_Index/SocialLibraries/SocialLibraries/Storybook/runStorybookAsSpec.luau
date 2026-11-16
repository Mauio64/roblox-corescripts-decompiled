return function(p, callback, callback2)
	local storyRoots = p.storyRoots
	local mapStory = p.mapStory

	callback("SHOULD run all stories with no issue", function()
		for _, folder in ipairs(storyRoots) do
			for _, moduleScript in ipairs(folder:GetDescendants()) do
				if not (moduleScript:IsA("ModuleScript") and moduleScript.Name:find(".story$")) then
					continue
				end

				local v = moduleScript
				callback2("SHOULD mount: " .. moduleScript:GetFullName(), function(p2)
					local module = require(v)
					local v2 = mapStory(function()
						return module
					end)()

					local _, v3 = p2.UnitTestHelpers.mountFrame(v2)

					v3()
				end)
			end
		end
	end)
end
