local Parent = script:FindFirstAncestor("SocialExperienceJoin").Parent
local Cryo = require(Parent.Cryo)
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal
local v5 = Signals.createComputed(function(_) -- line: 27
	-- upvalues: createSignal (copy), Cryo (copy)
	local v7, v8 = createSignal({})
	local v9, v10 = createSignal(nil)

	local function setUserSettingsAction(p2) -- line: 39
		-- upvalues: v10 (copy)
		v10(p2)
	end

	return {
		getPlayabilityEntries = v7,
		getUserSettings = v9,
		setPlayabilityEntry = function(s1: string, p3) -- line: 31
			-- upvalues: v7 (copy), v8 (copy), Cryo (copy)
			if not s1 or s1 == "" then
				return
			end

			local v14 = v7(false)

			v8(Cryo.Dictionary.join(v14, {
				[s1] = p3
			}))
		end,
		setUserSettings = setUserSettingsAction,
		clearPlayabilityEntry = function(s2: string) -- line: 43
			-- upvalues: v7 (copy), v8 (copy), Cryo (copy)
			if not s2 or s2 == "" then
				return
			end

			local v17 = v7(false)

			if v17[s2] == nil then
				return
			end

			v8(Cryo.Dictionary.join(v17, {
				[s2] = Cryo.None
			}))
		end,
		clearCache = function(s3: string?) -- line: 54
			-- upvalues: v7 (copy), v8 (copy), Cryo (copy), v10 (copy)
			if s3 and s3 ~= "" then
				local v19 = v7(false)

				v8(Cryo.Dictionary.join(v19, {
					[s3] = Cryo.None
				}))
			else
				v8({})
			end

			v10(nil)
		end
	}
end)

return {
	get = function() -- line: 75
		-- upvalues: v5 (copy)
		return v5(false)
	end
}
