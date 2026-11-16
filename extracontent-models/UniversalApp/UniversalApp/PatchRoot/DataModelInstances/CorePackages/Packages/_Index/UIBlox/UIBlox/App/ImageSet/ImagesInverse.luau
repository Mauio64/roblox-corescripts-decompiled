local parent = script.Parent
local Images = require(parent.Images)

local ImagesInverse = {}

for k, image in Images do
	ImagesInverse[image] = k
end

return ImagesInverse
