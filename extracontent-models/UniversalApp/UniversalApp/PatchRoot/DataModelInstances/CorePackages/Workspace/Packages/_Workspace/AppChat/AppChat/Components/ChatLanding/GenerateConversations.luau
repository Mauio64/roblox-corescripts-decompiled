local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)

return {
	init = function() -- line: 11
		-- upvalues: Cryo (copy)
		local function generate(p1) -- line: 12
			return {
				presenceImage = "",
				alias = "(alias)",
				id = p1,
				title = string.format("default dog chat no. %d", p1),
				thumbnails = { "rbxassetid://2610133241" },
				messages = {
					keys = { "messageId" },
					values = {
						messageId = {
							content = "a message placeholder 🎷🐛"
						}
					}
				},
				shortRelativeTime = "now+" .. p1
			}
		end

		local t1 = {}

		for i = 0, 200 do
			table.insert(t1, (generate(i)))
		end

		return {
			getItemList = function() -- line: 38
				-- upvalues: t1 (copy)
				return t1
			end,
			loadNext = function(p2) -- line: 42
				-- upvalues: Cryo (copy), generate (copy)
				return Cryo.List.join(p2, { (generate(p2[#p2].id + 1)) })
			end,
			loadPrevious = function(p3) -- line: 46
				-- upvalues: Cryo (copy), generate (copy)
				return Cryo.List.join({ (generate(p3[1].id - 1)) }, p3)
			end
		}
	end
}
