local ParentParent = script.Parent.Parent
local PostType = require(ParentParent.Enums.PostType)

require(ParentParent.Types)

return function(t1: {[any]: any}) -- line: 11
	-- upvalues: PostType (copy)
	local n1 = 1
	local t2 = {}

	for _, v7 in t1 do
		table.insert(t2, {
			caption = "caption",
			creatorUserId = 1,
			experienceContext = {
				placeId = "456",
				experienceId = v7.experienceId or "123"
			},
			postId = v7.postId or "123",
			screenshotMetadata = {
				height = 101,
				width = 101,
				fullSizeUrl = ""
			},
			type = PostType.Screenshot,
			uploadedAtTimestamp = n1
		})
		n1 += 1
	end

	return t2
end
