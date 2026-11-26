local CorePackages = game:GetService("CorePackages")
require(CorePackages.Packages.React)

return function(callback)
	return function(p2)
		return function(p3)
			return callback(p2, p3)
		end
	end
end
