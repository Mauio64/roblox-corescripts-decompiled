local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dFr")
local module2 = require("@luauforge/bundled/hUM")
local module3 = require("@luauforge/bundled/fzU")

return module.createReducer({
	isGeneric = nil,
	promptType = nil,
	metadata = nil,
	lastUpdatedPromptTypeAt = nil,
	accountPinUnlockedUntil = nil
}, {
	[module2.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			accountPinUnlockedUntil = p3.accountPinUnlockedUntil or Cryo.None
		})
	end,
	[module3.name] = function(p2, data)
		local joined = Cryo.Dictionary.join(p2, {
			isGeneric = data.isGeneric or Cryo.None,
			promptType = data.promptType or Cryo.None,
			metadata = data.metadata or Cryo.None
		})

		if p2.promptType ~= data.promptType then
			joined = Cryo.Dictionary.join(joined, {
				lastUpdatedPromptTypeAt = data.lastUpdatedPromptTypeAt
			})
		end

		return joined
	end
})
