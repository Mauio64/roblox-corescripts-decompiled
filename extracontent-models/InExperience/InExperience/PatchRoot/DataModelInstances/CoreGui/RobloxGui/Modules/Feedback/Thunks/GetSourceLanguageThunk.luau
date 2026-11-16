local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch

local parent = script.Parent.Parent

local GetExperienceSourceLanguage = require(parent.Network.GetExperienceSourceLanguage)

local SetSourceLanguageName = require(parent.Actions.SetSourceLanguageName)

return function()
	return PerformFetch.Single("GetExperienceSourceLanguage", function(object)
		return GetExperienceSourceLanguage():andThen(function(p)
			object:dispatch(SetSourceLanguageName(p))
		end)
	end)
end
