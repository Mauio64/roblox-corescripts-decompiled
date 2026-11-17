local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local FreeTrialChipHostView = require(script.Parent.FreeTrialChipHostView)
local useFreeTrialChipHostViewModel = require(script.Parent.useFreeTrialChipHostViewModel)

local function FreeTrialChipHost(p)
	local v = useFreeTrialChipHostViewModel(p)

	if v == nil then
		return nil
	end

	return (React.createElement(FreeTrialChipHostView, v))
end

return FreeTrialChipHost
