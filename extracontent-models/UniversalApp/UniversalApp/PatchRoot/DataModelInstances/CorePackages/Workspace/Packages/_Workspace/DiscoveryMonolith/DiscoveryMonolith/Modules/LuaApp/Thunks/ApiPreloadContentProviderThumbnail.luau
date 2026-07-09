local ContentProvider = game:GetService("ContentProvider")
local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local mutedError = require(Parent.Loggers).mutedError
local Promise = require(Parent.Promise)
local getRbxthumbWithTypeSizeAndOptions = require(Parent.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions

return function(p1, p2, p3) -- line: 8
	-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), Promise (copy), ContentProvider (copy), mutedError (copy)
	return function(_) -- line: 9
		-- upvalues: p1 (copy), getRbxthumbWithTypeSizeAndOptions (copy), p2 (copy), p3 (copy), Promise (copy), ContentProvider (copy), mutedError (copy)
		local t1 = {}

		for _, v in ipairs(p1) do
			table.insert(t1, (getRbxthumbWithTypeSizeAndOptions(v, p2, p3)))
		end

		return Promise.new(function(resolve, _) -- line: 15
			-- upvalues: ContentProvider (copy), t1 (copy), mutedError (copy)
			task.spawn(function() -- line: 16
				-- upvalues: ContentProvider (copy), t1 (copy), mutedError (copy), resolve (copy)
				if not pcall(function() -- line: 17
					-- upvalues: ContentProvider (copy), t1 (copy)
					ContentProvider:PreloadAsync(t1)
				end) then
					mutedError("Could not preload content provider thumbnails")
				end

				resolve()
			end)
		end)
	end
end
