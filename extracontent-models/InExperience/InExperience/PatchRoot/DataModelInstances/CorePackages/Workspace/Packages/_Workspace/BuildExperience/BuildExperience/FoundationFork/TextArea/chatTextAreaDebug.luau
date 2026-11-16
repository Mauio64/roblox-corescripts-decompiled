local v = false
local ChatTextAreaDebug = {}

function ChatTextAreaDebug.setEnabled(flag: boolean)
	v = flag
end

function ChatTextAreaDebug.isEnabled()
	return v
end

function ChatTextAreaDebug.log(p: string, p2: string?)
	if not v then
		return
	end

	if p2 then
		print(`[ChatTextArea] {p} | {p2}`)
	else
		print(`[ChatTextArea] {p}`)
	end
end

return ChatTextAreaDebug
