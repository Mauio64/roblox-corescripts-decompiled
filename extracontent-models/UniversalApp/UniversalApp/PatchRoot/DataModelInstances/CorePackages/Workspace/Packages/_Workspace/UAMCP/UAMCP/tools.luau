local t1 = {
	ready = require(script.ready),
	current_page = require(script.current_page),
	find_text = require(script.find_text),
	find_clickable = require(script.find_clickable),
	find_by_testid = require(script.find_by_testid),
	inspect = require(script.inspect),
	get_property = require(script.get_property),
	tree = require(script.tree),
	visible_at = require(script.visible_at),
	search = require(script.search),
	scroll_to = require(script.scroll_to),
	list_controls = require(script.list_controls),
	menu_items = require(script.menu_items)
}

t1.help = {
	description = "List all available tools and their parameters.",
	call = function(_) -- line: 19
		-- upvalues: t1 (copy)
		local t2 = {
			"UA MCP Tools",
			"============",
			""
		}
		local t3 = {}

		for k in pairs(t1) do
			t3[#t3 + 1] = k
		end

		table.sort(t3)

		for _, v in ipairs(t3) do
			local v8 = t1[v]

			table.insert(t2, ("• %s — %s"):format(v, v8.description))

			if v8.params then
				for _, v2 in ipairs(v8.params) do
					local v11 = not v2.required and "" or " (required)"

					table.insert(t2, ("    %s: %s%s"):format(v2.name, v2.desc, v11))
				end
			end

			table.insert(t2, "")
		end

		return table.concat(t2, "\n")
	end
}

return t1
