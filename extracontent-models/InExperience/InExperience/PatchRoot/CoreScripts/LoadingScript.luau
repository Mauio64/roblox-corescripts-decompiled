game:GetService("CoreGui"):WaitForChild("RobloxGui"):WaitForChild("Modules")

local CorePackages = game:GetService("CorePackages")
local PlaceId = game.PlaceId
local v3 = select("#", ...)

if PlaceId <= 0 and v3 > 0 then
	PlaceId = select(1, ...)
end

if game:DefineFastFlag("EnableExperienceGenericChallengeRenderingOnLoadingScript", false) then
	coroutine.wrap(function() -- line: 23
		-- upvalues: CorePackages (copy)
		require(CorePackages.Workspace.Packages.GenericChallenges).Middleware.InitExperienceChallengeInterceptor()
	end)()
end

local loadingScript = require(CorePackages.Workspace.Packages.ExperienceLoadingScript).loadingScript

coroutine.wrap(loadingScript)(PlaceId, 72)
