local messages = {
	imageInReview = "The generated image is still under review.",
	imagePreparing = "The generated image is still being prepared.",
	imageTooLarge = "The generated image exceeds the 5 MB limit.",
	imageTimedOut = "The generated image could not be downloaded in time.",
	imageFailed = "The generated image could not be downloaded.",
	moderated = "Roblox moderation altered this product's text.",
	noUniverse = "No universe is associated with this session."
}

return {
	MESSAGES = messages,
	classify = function(value: string?)
		if value == nil then
			return nil
		end

		for k, v in messages do
			if string.find(value, v, 1, true) ~= nil then
				return k
			end
		end

		return nil
	end
}
