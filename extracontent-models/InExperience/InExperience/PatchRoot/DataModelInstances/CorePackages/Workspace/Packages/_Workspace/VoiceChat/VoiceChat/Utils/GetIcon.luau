function getIconSrc(s1: string, s2: string) -- line: 4
	return "rbxasset://textures/ui/VoiceChat/" .. (s2 and s2 .. "/" or "") .. s1 .. ".png"
end

return function(s3: string, s4: string, n1: number?) -- line: 9
	if s3 == "Unmuted" then
		local v6 = math.floor(0.5 + 5 * (n1 or math.random())) * 20

		return n1 and getIconSrc("Unmuted" .. tostring(v6), s4) or getIconSrc("Blank", s4)
	end

	return getIconSrc(s3, s4)
end
