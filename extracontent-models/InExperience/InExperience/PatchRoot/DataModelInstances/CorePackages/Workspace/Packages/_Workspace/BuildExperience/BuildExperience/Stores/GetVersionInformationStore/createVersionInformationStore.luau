local Parent = script:FindFirstAncestor("BuildExperience").Parent

require(Parent.Signals)

local createSessionScopedSignal = require(Parent.SignalsUtils).createSessionScopedSignal

local function createVersionInformationStore() -- line: 20
	-- upvalues: createSessionScopedSignal (copy)
	local v4, v5 = createSessionScopedSignal(function() -- line: 22
		return nil
	end)

	local function saveDraft(n1: number, s1: string, s2: string) -- line: 27
		-- upvalues: v5 (copy)
		v5({
			placeId = n1,
			title = s1,
			description = s2
		})
	end

	return {
		getDraft = v4,
		setDraft = saveDraft,
		clearDraft = function(n2: number) -- line: 35
			-- upvalues: v4 (copy), v5 (copy)
			local v11 = v4()

			if v11 ~= nil and n2 == v11.placeId then
				v5(nil)
			end
		end,
		reset = function() -- line: 42
			-- upvalues: v5 (copy)
			v5(nil)
		end
	}
end

return createVersionInformationStore
