local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gYo")

local module2 = require("@luauforge/deferred/gYp")

local function EditEmotesPageContainer()
	local v5 = module()
	return React.createElement(module2, v5)
end

return (require("@luauforge/deferred/gmV")(EditEmotesPageContainer))
