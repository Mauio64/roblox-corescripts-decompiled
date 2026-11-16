local v = game:DefineFastFlag("SocialCarouselBuildPresence2", false)

if v then
	local FFlagPresenceLocationType = require(script.Parent.FFlagPresenceLocationType)
	return FFlagPresenceLocationType and require(script.Parent.FFlagGameJoinCardContent)
end

return v
