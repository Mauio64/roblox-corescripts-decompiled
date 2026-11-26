local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dzK")
local module2 = require("@luauforge/bundled/dzL")

local module3 = require("@luauforge/bundled/dzM")
local module4 = require("@luauforge/bundled/dzN")

local fFlagSignalsNavP3Final = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Final

return function(options, data)
	local v5 = options or {}

	if data.type == module.name then
		local v7 = if data.visible then data.text or nil else nil
		local v8 = if data.visible then data.link or nil else nil
		return {
			Text = v7,
			Link = v8,
			timestamp = data.timestamp or nil,
			updateRequested = false
		}
	end

	if data.type == module2.name then
		return Cryo.Dictionary.join(v5, { updateRequested = data.updateRequested })
	end

	if fFlagSignalsNavP3Final then
		return v5
	end

	for i, v7 in ipairs({ module3, module4 }) do
		if data.type == v7.name then
			return Cryo.Dictionary.join(v5, { updateRequested = true })
		end
	end

	return v5
end
