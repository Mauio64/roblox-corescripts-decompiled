function getIconSrc(p: string, p2: string)
	return "rbxasset://textures/ui/VoiceChat/" .. (p2 and p2 .. "/" or "") .. p .. ".png"
end

return function(p: string, p2: string, p3: number?)
	if p ~= "Unmuted" then
		return getIconSrc(p, p2)
	end

	local v = math.floor(0.5 + 5 * (p3 or math.random())) * 20
	return p3 and getIconSrc("Unmuted" .. tostring(v), p2) or getIconSrc("Blank", p2)
end
