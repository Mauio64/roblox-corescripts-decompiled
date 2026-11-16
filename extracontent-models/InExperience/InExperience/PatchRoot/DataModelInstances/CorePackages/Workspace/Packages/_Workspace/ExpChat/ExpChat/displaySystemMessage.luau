local parent = script:FindFirstAncestor("ExpChat").Parent
local llama = require(parent.llama)
local list = llama.List
local ExpChatShared = require(parent.ExpChatShared)
local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local sanitizeForRichText = require(script.Parent.sanitizeForRichText)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableClientSummarySystemMessageOnLua = SharedFlags.FFlagEnableClientSummarySystemMessageOnLua

local function displaySystemMessage(value, p, p2: string, object, object2, p3: string?, callback)
	v:debug("Display system message: {}", p2)
	local result = nil

	if type(value) == "string" then
		if value ~= "" then
			local success
			success, result = pcall(function()
				return object:FormatByKey(value, p)
			end)

			if not success then
				result = p3
			end
		end
	else
		result = table.concat(list.map(value, function(p4)
			return object:FormatByKey(p4, p)
		end), "\n")
	end

	if object2 and result then
		if FFlagEnableClientSummarySystemMessageOnLua then
			local v2 = sanitizeForRichText(result)

			if callback then
				v2 = callback(v2)
			end

			object2:DisplaySystemMessage(v2, p2)
		else
			object2:DisplaySystemMessage(sanitizeForRichText(result), p2)
		end
	end
end

return displaySystemMessage
