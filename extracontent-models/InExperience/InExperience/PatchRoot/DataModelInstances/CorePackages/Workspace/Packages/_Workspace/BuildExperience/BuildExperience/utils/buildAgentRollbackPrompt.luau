local defineFastString = game:DefineFastString(
	"BuildAgentRollbackVersionPrompt",
	"<system_reminder>The user reverted the game to version {versionNumber}. Call restore_version."
)

local defineFastString2 = game:DefineFastString(
	"BuildAgentRollbackNotePrompt",
	" Add note title {title} and description {description}"
)

local function fill(value: string, p) -- 2 equivalent calls inferred from this helper
	return (value:gsub("{(%w+)}", function(p2)
		return (tostring(p[p2]))
	end))
end

local function buildAgentRollbackPrompt(versionNumber: number, title: string?, description: string?)
	local v = fill(defineFastString, { versionNumber = versionNumber }) -- inferred equivalent call
	local v2

	if title == nil or title == "" or description == nil or description == "" then
		v2 = ""
	else
		v2 = fill(defineFastString2, { title = title, description = description }) -- inferred equivalent call
	end

	return v .. v2 .. "</system_reminder>"
end

return buildAgentRollbackPrompt
