local CorePackages = game:GetService("CorePackages")

local function SetFieldOfViewDeg(p1) -- line: 4
	return {
		fieldOfViewDeg = p1
	}
end

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, SetFieldOfViewDeg)
