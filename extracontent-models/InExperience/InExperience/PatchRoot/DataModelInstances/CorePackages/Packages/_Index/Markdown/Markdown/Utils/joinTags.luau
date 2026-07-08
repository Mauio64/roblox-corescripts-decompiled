local Parent = script:FindFirstAncestor("Markdown").Parent
local forEachArgs = require(Parent.Dash).forEachArgs
local concat = table.concat

local function joinTags(...) -- line: 11
	-- upvalues: forEachArgs (copy), concat (copy)
	local t1 = {}

	forEachArgs(function(p1) -- line: 13
		-- upvalues: t1 (copy)
		if typeof(p1) == "string" then
			table.insert(t1, p1)

			return
		end

		if typeof(p1) == "table" then
			for v7, v8 in p1 do
				if v8 then
					table.insert(t1, v7)
				end
			end
		end
	end, ...)

	return concat(t1, " ")
end

return joinTags
