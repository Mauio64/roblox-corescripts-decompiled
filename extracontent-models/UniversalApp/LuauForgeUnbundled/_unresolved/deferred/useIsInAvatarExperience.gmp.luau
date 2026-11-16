local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/geP")

local function useIsInAvatarExperience(): boolean
	return React.useContext(module) == nil
end

return useIsInAvatarExperience
