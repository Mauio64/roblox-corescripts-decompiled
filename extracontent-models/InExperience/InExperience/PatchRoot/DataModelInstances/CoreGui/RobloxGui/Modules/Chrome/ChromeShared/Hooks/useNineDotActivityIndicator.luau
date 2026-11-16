local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local Service = require(ChromeShared.Service)

return function(p: string, flag: boolean)
	React.useEffect(function()
		Service:setNineDotActivityIndicatorVisible(p, flag)

		return function()
			Service:setNineDotActivityIndicatorVisible(p, false)
		end
	end, { p, flag })
end
