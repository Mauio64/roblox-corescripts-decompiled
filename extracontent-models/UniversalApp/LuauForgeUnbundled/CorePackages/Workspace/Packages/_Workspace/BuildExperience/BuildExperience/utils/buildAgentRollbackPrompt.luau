local defineFastString = game:DefineFastString(
	"BuildAgentRollbackVersionPrompt",
	"<system_reminder>The user reverted the game to version {versionNumber}. Call restore_version."
)

local defineFastString2 = game:DefineFastString(
	"BuildAgentRollbackNotePrompt",
	" Add note title {title} and description {description}"
)

local function fill(value, p2)
	return (value:gsub("{(%w+)}", function(p3)
		return (tostring(p2[p3]))
	end))
end

local function buildAgentRollbackPrompt(p2, p3, p4)
	local v5 = { versionNumber = p2 }
	local v6 = defineFastString:gsub("{(%w+)}", function(p5)
		return (tostring(v5[p5]))
	end)
	local v7

	if p3 == nil or p3 == "" or p4 == nil or p4 == "" then
		v7 = ""
	else
		local v8 = { title = p3, description = p4 }
		v7 = defineFastString2:gsub("{(%w+)}", function(p5)
			return (tostring(v8[p5]))
		end)
	end

	return v6 .. v7 .. "</system_reminder>"
end

return buildAgentRollbackPrompt
