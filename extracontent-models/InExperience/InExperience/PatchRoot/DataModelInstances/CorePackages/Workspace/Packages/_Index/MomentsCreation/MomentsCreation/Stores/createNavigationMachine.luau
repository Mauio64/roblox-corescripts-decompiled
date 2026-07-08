local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Signals = require(MomentsCreationParent.Signals)
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
local createSignal = Signals.createSignal
local Gallery = CreationFlowState.Gallery
local Preview = CreationFlowState.Preview
local Music = CreationFlowState.Music
local TextOverlay = CreationFlowState.TextOverlay
local Trimming = CreationFlowState.Trimming
local Description = CreationFlowState.Description
local t1 = {
	[Gallery] = {
		[Preview] = true
	},
	[Preview] = {
		[Gallery] = true,
		[Trimming] = true,
		[Music] = true,
		[TextOverlay] = true,
		[Description] = true
	},
	[Trimming] = {
		[Preview] = true
	},
	[Music] = {
		[Preview] = true
	},
	[TextOverlay] = {
		[Preview] = true
	},
	[Description] = {
		[Preview] = true
	}
}

local function createNavigationMachine(p1) -- line: 55
	-- upvalues: createSignal (copy), Gallery (copy), t1 (copy)
	local v15, v16 = createSignal(p1 or Gallery)

	return {
		getStep = v15,
		canNavigate = function(p2) -- line: 58
			-- upvalues: v15 (copy), t1 (copy)
			local v18 = v15(false)

			if v18 == p2 then
				return true
			end

			local v19 = t1[v18]

			return v19 ~= nil and v19[p2] == true
		end,
		navigate = function(p3) -- line: 67
			-- upvalues: v15 (copy), t1 (copy), v16 (copy)
			local v21 = v15(false)
			local v22

			if v21 == p3 then
				v22 = true
			else
				local v23 = t1[v21]

				v22 = v23 ~= nil and v23[p3] == true
			end

			if not v22 then
				return false
			end

			v16(p3)

			return true
		end,
		reset = function(p4) -- line: 77
			-- upvalues: v16 (copy)
			v16(p4)
		end
	}
end

return createNavigationMachine
