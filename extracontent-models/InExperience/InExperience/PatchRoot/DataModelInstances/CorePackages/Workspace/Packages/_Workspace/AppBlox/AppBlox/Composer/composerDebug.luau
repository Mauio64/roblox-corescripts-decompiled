local v = false
local ComposerDebug = {}

function ComposerDebug.setEnabled(flag: boolean)
	v = flag
end

function ComposerDebug.isEnabled()
	return v
end

function ComposerDebug.log(p: string, p2: string?)
	if not v then
		return
	end

	if p2 then
		print(`[Composer] {p} | {p2}`)
	else
		print(`[Composer] {p}`)
	end
end

return ComposerDebug
