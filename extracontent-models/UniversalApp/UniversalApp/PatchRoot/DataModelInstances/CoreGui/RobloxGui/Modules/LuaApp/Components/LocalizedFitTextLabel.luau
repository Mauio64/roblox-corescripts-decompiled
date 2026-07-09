local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local withLocalization = require(Modules.LuaApp.withLocalization)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)

if require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)() then
	return function(p1) -- line: 11
		-- upvalues: withLocalization (copy), Roact (copy), FitTextLabel (copy), Cryo (copy)
		return withLocalization({
			localizedText = p1.Text
		})(function(p2) -- line: 14
			-- upvalues: Roact (copy), FitTextLabel (copy), Cryo (copy), p1 (copy)
			return Roact.createElement(FitTextLabel, Cryo.Dictionary.join(p1, {
				Text = p2.localizedText
			}))
		end)
	end
end

return RoactLocalization.connect({ "Text" })(FitTextLabel)
