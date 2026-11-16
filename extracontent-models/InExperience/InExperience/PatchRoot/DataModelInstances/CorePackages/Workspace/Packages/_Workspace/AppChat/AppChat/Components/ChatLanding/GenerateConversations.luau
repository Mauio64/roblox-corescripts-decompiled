local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)

return {
	init = function()
		local function generate(id)
			return {
				id = id,
				title = string.format("default dog chat no. %d", id),
				thumbnails = { "rbxassetid://2610133241" },
				presenceImage = "",
				messages = {
					keys = { "messageId" },
					values = {
						messageId = { content = "a message placeholder 🎷🐛" }
					}
				},
				shortRelativeTime = "now+" .. id,
				alias = "(alias)"
			}
		end

		local itemList = {}

		for i = 0, 200 do
			table.insert(itemList, generate(i))
		end

		return {
			getItemList = function()
				return itemList
			end,
			loadNext = function(list)
				return Cryo.List.join(list, { generate(list[#list].id + 1) })
			end,
			loadPrevious = function(list)
				return Cryo.List.join({ generate(list[1].id - 1) }, list)
			end
		}
	end
}
