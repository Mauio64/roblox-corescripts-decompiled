return function(p)
	return {
		["moderationDetail"] = p.fromString("usermoderation:v1/not-approved"),
		reactivate = p.fromString("usermoderation:v1/not-approved/reactivate"),
		reminder = p.fromString("usermoderation:v1/reminder"),
		dismissIntervention = p.fromString("usermoderation:v1/dismiss-intervention"),
		accessDetail = p.fromString("usermoderation:v2/not-approved")
	}
end
