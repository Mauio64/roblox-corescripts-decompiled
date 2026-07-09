local Parent = script:FindFirstAncestor("ExpChat").Parent
local List = require(Parent.llama).List
local v3 = require(Parent.ExpChatShared).Logger:new("ExpChat/" .. script.Name)
local sanitizeForRichText = require(script.Parent.sanitizeForRichText)
local FFlagEnableClientSummarySystemMessageOnLua = require(Parent.SharedFlags).FFlagEnableClientSummarySystemMessageOnLua

local function displaySystemMessage(p1, t1: {[any]: any}?, s1: string, p2, p3, s2: string?, p4: ((...any) -> ...any)?) -- line: 12
	-- upvalues: v3 (copy), List (copy), FFlagEnableClientSummarySystemMessageOnLua (copy), sanitizeForRichText (copy)
	v3:debug("Display system message: {}", s1)

	local result = nil

	if type(p1) == "string" then
		if p1 ~= "" then
			local ok

			ok, result = pcall(function() -- line: 27
				-- upvalues: p2 (copy), p1 (copy), t1 (copy)
				return p2:FormatByKey(p1, t1)
			end)

			if not ok then
				result = s2
			end
		end
	else
		result = table.concat(List.map(p1, function(p5) -- line: 38
			-- upvalues: p2 (copy), t1 (copy)
			return p2:FormatByKey(p5, t1)
		end), "\n")
	end

	if p3 and result then
		if FFlagEnableClientSummarySystemMessageOnLua then
			local v16 = sanitizeForRichText(result)

			if p4 then
				v16 = p4(v16)
			end

			p3:DisplaySystemMessage(v16, s1)

			return
		end

		p3:DisplaySystemMessage(sanitizeForRichText(result), s1)
	end
end

return displaySystemMessage
