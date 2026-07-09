local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local withLocalization = require(Modules.LuaApp.withLocalization)

if require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)() then
	return function(p1) -- line: 10
		-- upvalues: withLocalization (copy), Roact (copy), Cryo (copy)
		return withLocalization({
			localizedText = p1.Text
		})(function(p2) -- line: 13
			-- upvalues: Roact (copy), Cryo (copy), p1 (copy)
			return Roact.createElement("TextLabel", Cryo.Dictionary.join(p1, {
				Text = p2.localizedText
			}))
		end)
	end
end

return RoactLocalization.connect({ "Text" })("TextLabel")
