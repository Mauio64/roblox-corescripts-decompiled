local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Signals = require(CorePackages.Packages.Signals)
local SignalsExperimental = require(CorePackages.Packages.SignalsExperimental)
local createSessionScopedSignal = require("@luauforge/bundled/gOx").createSessionScopedSignal
local module = require("@luauforge/bundled/dNQ")
local getMessageFadeSequence = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsChat/FriendsChat/ConversationWindow/getMessageFadeSequence")
require("@luauforge/bundled/dMc")
local module3 = require("@luauforge/bundled/dCn")

local standardView = module.ColorPickerViewSettings.StandardView

local function createEmptyRangeIdToBodyPartsToSliderAndColor3Values()
	return {}
end

local function createBodyColorPickerSettingsStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(standardView)

	local sessionScopedSignal2, v6 = createSessionScopedSignal(1)

	local sessionScopedSignal3, v7 = createSessionScopedSignal(createEmptyRangeIdToBodyPartsToSliderAndColor3Values)

	local computed = Signals.createComputed(function(): nil
		return nil
	end)

	local v8 = {}
	return {
		getViewSetting = sessionScopedSignal,
		getSelectedBodyPartIndex = sessionScopedSignal2,
		getRangeIdToBodyPartsToSliderAndColor3Values = sessionScopedSignal3,
		getBodyPartsToSliderAndColor3ValuesForRange = function(p2)
			if p2 == nil then
				return computed
			end

			local v9 = v8[p2]

			if v9 == nil then
				v9 = Signals.createComputed(function(p3)
					return sessionScopedSignal3(p3)[p2]
				end)

				v8[p2] = v9
			end

			return v9
		end,
		setBodyColorViewSetting = function(p2)
			v5(p2)
		end,
		setSelectedBodyPartIndex = function(p2)
			if p2 < 0 or #module.BodyPartButtonData < p2 then
				module3("selectedBodyPartIndex is out of range")
			end

			v6(p2)
		end,
		setRangeIdToBodyPartsToSliderAndColor3Values = function(p2, p3, p4, p5)
			local clampBetween0And1, v9 = getMessageFadeSequence.clampBetween0And1(p4)

			if v9 then
				module3(`getColor3AtValueInRange: value {p4} should be between 0 and 1 inclusive`)
			end

			local v10 = sessionScopedSignal3(false)
			local v11 = v10[p2] or {}
			local joined = Cryo.Dictionary.join(v11, {
				[p3] = { color3 = p5, sliderValue = clampBetween0And1 }
			})

			v7(Cryo.Dictionary.join(v10, { [p2] = joined }))
		end,
		reset = function()
			SignalsExperimental.batch(function()
				v5(standardView)
				v6(1)
				v7({})
			end)
		end
	}
end

return createBodyColorPickerSettingsStore
