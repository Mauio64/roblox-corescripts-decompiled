local Parent = script:FindFirstAncestor("AvatarExperiencePhotobooth").Parent
local React = require(Parent.React)
local PhotoboothContext = require(script.Parent.PhotoboothContext)

local function usePhotoboothContext() -- line: 12
	-- upvalues: React (copy), PhotoboothContext (copy)
	return (React.useContext(PhotoboothContext))
end

return usePhotoboothContext
