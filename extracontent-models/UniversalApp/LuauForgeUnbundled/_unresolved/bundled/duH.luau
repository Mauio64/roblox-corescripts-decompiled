local ContentProvider = game:GetService("ContentProvider")

local mutedError = require("@luauforge/bundled/duw").mutedError
local module = require("@luauforge/bundled/dtg")
local getRbxthumbWithTypeSizeAndOptions = require("@game/CorePackages/Workspace/Packages/UserLib").Utils.getRbxthumbWithTypeSizeAndOptions

return function(list, p2, p3)
	return function(p4)
		local v5 = {}

		for i, item in ipairs(list) do
			table.insert(v5, (getRbxthumbWithTypeSizeAndOptions(item, p2, p3)))
		end

		return module.new(function(callback, p5)
			task.spawn(function()
				if not pcall(function()
					ContentProvider:PreloadAsync(v5)
				end) then
					mutedError("Could not preload content provider thumbnails")
				end

				callback()
			end)
		end)
	end
end
