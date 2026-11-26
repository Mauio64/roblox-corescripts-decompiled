local v5 = {
	imageInReview = "The generated image is still under review.",
	imagePreparing = "The generated image is still being prepared.",
	imageTooLarge = "The generated image exceeds the 5 MB limit.",
	imageTimedOut = "The generated image could not be downloaded in time.",
	imageFailed = "The generated image could not be downloaded.",
	moderated = "Roblox moderation altered this product's text.",
	noUniverse = "No universe is associated with this session."
}

return {
	MESSAGES = v5,
	classify = function(value)
		if value == nil then
			return nil
		end

		for k, v6 in v5 do
			if string.find(value, v6, 1, true) ~= nil then
				return k
			end
		end

		return nil
	end
}
