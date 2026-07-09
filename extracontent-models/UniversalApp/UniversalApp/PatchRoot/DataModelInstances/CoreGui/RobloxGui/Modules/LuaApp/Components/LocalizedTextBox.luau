local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local withLocalization = require(Modules.LuaApp.withLocalization)

if require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)() then
	return Roact.forwardRef(function(p1, p2) -- line: 10
		-- upvalues: withLocalization (copy), Roact (copy), Cryo (copy)
		return withLocalization({
			localizedText = p1.PlaceholderText
		})(function(p3) -- line: 13
			-- upvalues: Roact (copy), Cryo (copy), p1 (copy), p2 (copy)
			return Roact.createElement("TextBox", Cryo.Dictionary.join(p1, {
				PlaceholderText = p3.localizedText,
				[Roact.Ref] = p2
			}))
		end)
	end)
end

return RoactLocalization.connect({ "PlaceholderText" })("TextBox")
