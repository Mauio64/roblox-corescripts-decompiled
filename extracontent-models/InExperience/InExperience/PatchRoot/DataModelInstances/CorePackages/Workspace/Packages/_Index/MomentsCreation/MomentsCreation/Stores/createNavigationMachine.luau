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
local StickerOverlay = CreationFlowState.StickerOverlay
local t1 = {
	[Gallery] = {
		[Preview] = true
	},
	[Preview] = {
		[Gallery] = true,
		[Trimming] = true,
		[Music] = true,
		[TextOverlay] = true,
		[Description] = true,
		[StickerOverlay] = true
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
	},
	[StickerOverlay] = {
		[Preview] = true
	}
}

local function createNavigationMachine(p1) -- line: 58
	-- upvalues: createSignal (copy), Gallery (copy), t1 (copy)
	local v16, v17 = createSignal(p1 or Gallery)

	return {
		getStep = v16,
		canNavigate = function(p2) -- line: 61
			-- upvalues: v16 (copy), t1 (copy)
			local v19 = v16(false)

			if v19 == p2 then
				return true
			end

			local v20 = t1[v19]

			return v20 ~= nil and v20[p2] == true
		end,
		navigate = function(p3) -- line: 70
			-- upvalues: v16 (copy), t1 (copy), v17 (copy)
			local v22 = v16(false)
			local v23

			if v22 == p3 then
				v23 = true
			else
				local v24 = t1[v22]

				v23 = v24 ~= nil and v24[p3] == true
			end

			if not v23 then
				return false
			end

			v17(p3)

			return true
		end,
		reset = function(p4) -- line: 80
			-- upvalues: v17 (copy)
			v17(p4)
		end
	}
end

return createNavigationMachine
