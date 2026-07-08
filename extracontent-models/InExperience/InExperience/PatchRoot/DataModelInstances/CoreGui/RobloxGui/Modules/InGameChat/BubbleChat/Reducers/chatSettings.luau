local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.Cryo)

local Rodux = require(CorePackages.Packages.Rodux)
local UpdateChatSettings = require(script.Parent.Parent.Actions.UpdateChatSettings)
local ChatSettings = require(script.Parent.Parent.ChatSettings)

local function deepCopy(p1) -- line: 9
	-- upvalues: deepCopy (copy)
	if type(p1) ~= "table" then
		return p1
	end

	local t1 = {}

	for k, v in pairs(p1) do
		t1[k] = deepCopy(v)
	end

	return t1
end
local function mergeInto(p2, p3) -- line: 22
	-- upvalues: mergeInto (copy)
	for k, v in pairs(p3) do
		if type(v) ~= "table" then
			p2[k] = v
		elseif p2[k] then
			mergeInto(p2[k], v)
		end
	end
end

return (Rodux.createReducer(ChatSettings, {
	[UpdateChatSettings.name] = function(_, p5) -- line: 33
		-- upvalues: deepCopy (copy), ChatSettings (copy), mergeInto (copy)
		local v17 = deepCopy(ChatSettings)

		mergeInto(v17, p5.settings)

		local UserSpecificSettings = p5.settings.UserSpecificSettings

		if UserSpecificSettings then
			for k, v in pairs(UserSpecificSettings) do
				local v21 = deepCopy(ChatSettings)

				v21.UserSpecificSettings = nil
				mergeInto(v21, v)
				v17.UserSpecificSettings[k] = v21
			end
		end

		return v17
	end
}))
