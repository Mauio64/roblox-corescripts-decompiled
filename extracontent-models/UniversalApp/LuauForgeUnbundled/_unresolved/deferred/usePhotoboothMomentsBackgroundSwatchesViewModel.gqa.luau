local module = require("@luauforge/deferred/gpo")
local module2 = require("@luauforge/deferred/gpq")
local useSignalState = require("@luauforge/deferred/gpM").useSignalState

local module3 = require("@luauforge/deferred/gpG")
local module4 = require("@luauforge/deferred/gpN")
require("@luauforge/deferred/gpZ")

local useTokens = module2.Hooks.useTokens

local function resolveSwatchColor(p2, value)
	if typeof(value) == "Color3" then
		return value
	end

	return p2[string.match(value, "^(%a+)_")][value].Color3
end

local function usePhotoboothMomentsBackgroundSwatchesViewModel()
	local extended = useTokens().Color.Extended
	local v5 = module4(false)
	local v6 = useSignalState(v5.getActiveBackgroundId)

	return {
		swatches = module.useMemo(function()
			local result = {}

			for k, backgroundSwatch in module3.BackgroundSwatches do
				local v7 = { id = backgroundSwatch.assetId, color = 0, isSelected = 0 }
				local v8 = extended
				local v9 = backgroundSwatch.color

				if typeof(v9) ~= "Color3" then
					v9 = v8[string.match(v9, "^(%a+)_")][v9].Color3
				end

				v7.color = v9
				v7.isSelected = backgroundSwatch.assetId == v6
				table.insert(result, v7)
			end

			return result
		end, { extended, v6 }),
		onSwatchActivated = v5.setActiveBackground
	}
end

return usePhotoboothMomentsBackgroundSwatchesViewModel
