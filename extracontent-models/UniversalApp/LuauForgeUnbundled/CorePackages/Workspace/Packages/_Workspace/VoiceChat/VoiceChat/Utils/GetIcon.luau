function LUAUFORGE_MODULE_GLOBALS_bnF_getIconSrc(p2, p3)
	return "rbxasset://textures/ui/VoiceChat/" .. (p3 and p3 .. "/" or "") .. p2 .. ".png"
end

return function(p2, p3, p4)
	if p2 ~= "Unmuted" then
		return LUAUFORGE_MODULE_GLOBALS_bnF_getIconSrc(p2, p3)
	end

	local v5 = math.floor(0.5 + 5 * (p4 or math.random())) * 20
	return p4 and LUAUFORGE_MODULE_GLOBALS_bnF_getIconSrc("Unmuted" .. tostring(v5), p3)
		or LUAUFORGE_MODULE_GLOBALS_bnF_getIconSrc("Blank", p3)
end
