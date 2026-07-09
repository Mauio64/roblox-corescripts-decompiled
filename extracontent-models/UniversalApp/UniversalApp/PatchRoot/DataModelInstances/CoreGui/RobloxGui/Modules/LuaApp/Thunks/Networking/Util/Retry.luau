local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local RetryWithOverridableWait = require(script.Parent.RetryWithOverridableWait)

return function(p1) -- line: 6
	-- upvalues: Cryo (copy), RetryWithOverridableWait (copy)
	local v5 = Cryo.Dictionary.join(p1, {
		waitImpl = wait
	})

	return RetryWithOverridableWait(v5)
end
